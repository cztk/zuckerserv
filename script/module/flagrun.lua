--[[
    Save flagrun time
    //piernov
]]

local using_mysql = (server.stats_use_mysql == 1)
local query_backend_name = server.stats_query_backend

local luasql = require("luasql_mysql")

local personal_flagruns = {{},{},{}}
local flagruns = {{},{}}
local queue = {}
local igamemode = ""

local mysql_schema = [[
CREATE TABLE IF NOT EXISTS  `flagruns` (
  `id`              bigint(1) UNSIGNED NOT NULL AUTO_INCREMENT,
  `serverid`        bigint(1) UNSIGNED NOT NULL,
  `mapname`         varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `playername`      varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `gamemode`        varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `time`            int(1) unsigned NOT NULL DEFAULT 0,
  `created`         datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified`        datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE(`serverid`,`mapname`,`gamemode`)
);
CREATE TABLE `personal_flagruns` (
  `id`              bigint(1) NOT NULL AUTO_INCREMENT,
  `serverid`        bigint(1) UNSIGNED NOT NULL,
  `mapname`         varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `gamemode`        varchar(16) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `playername`      varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `time`            int(1) UNSIGNED NOT NULL DEFAULT '0',
  `created`         datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified`        datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `playername` (`playername`,`mapname`,`gamemode`),
  KEY `time` (`playername`,`time`)
);
]]

local function escape_string(s)
	s = string.gsub(s, "\\", "\\\\")
	s = string.gsub(s, "%\"", "\\\"")
	s = string.gsub(s, "%'", "\\'")
	return s
end

local function execute_statement(statement)
    local cursor, errorinfo = connection:execute(statement)
    if not cursor then
        server.log_error(string.format("Buffering stats data because of a MySQL stats failure: %s", errorinfo))
        connection:close()
        connection = nil
    end
    return cursor
end

local function install_db(connection, settings)
    for statement in string.gmatch(mysql_schema, "CREATE TABLE[^;]+") do
        local cursor, err = execute_statement(statement)
        if not cursor then error(err) end
    end
end

local function mysql_open(settings)

    connection = luasql.mysql():connect(settings.database, settings.username, settings.password, settings.hostname, settings.port)

    if not connection then
        error(string.format("couldn't connect to MySQL server at %s:%s", settings.hostname, settings.port))
    end

    servername = settings.servername

    if settings.install then
        install_db(connection, settings)
    end

    open_settings = settings

    return true
end

local function insert_personal_flagrun(flagrun)
    local insert_flagrun_sql = [[INSERT INTO `personal_flagruns` (`serverid`, `mapname`, `playername`, `gamemode`, `time`)
            VALUES (%i, '%s', '%s', '%s', %i) ON DUPLICATE KEY UPDATE
            `time` = IF(`time` > VALUES(`time`), VALUES(`time`), `time`)
            ]]
    if not execute_statement(string.format(
            insert_flagrun_sql,
            tonumber(server.stats_serverid),
            escape_string(flagrun.mapname),
            escape_string(flagrun.playername),
            escape_string(flagrun.modename),
            tonumber(flagrun.time))) then return nil end

    if not personal_flagruns[flagrun.playername] then
        personal_flagruns[flagrun.playername] = {}
    end
    if not personal_flagruns[flagrun.playername][flagrun.modename] then
      personal_flagruns[flagrun.playername][flagrun.modename] = {}
    end
    if not personal_flagruns[flagrun.playername][flagrun.modename][flagrun.mapname] then
      personal_flagruns[flagrun.playername][flagrun.modename][flagrun.mapname] = {}
    end

    personal_flagruns[flagrun.playername][flagrun.modename][flagrun.mapname] = {flagrun.time, "today"}

    local cursor = execute_statement("SELECT last_insert_id()")
    if not cursor then return nil end
    return cursor:fetch()
end

local function insert_flagrun(flagrun)
    local insert_flagrun_sql = [[INSERT INTO `flagruns` (`serverid`, `mapname`, `playername`, `gamemode`, `time`)
            VALUES (%i, '%s', '%s', '%s', %i) ON DUPLICATE KEY UPDATE
            `playername` = IF(`time` > VALUES(`time`), VALUES(`playername`), `playername`),
            `time` = IF(`time` > VALUES(`time`), VALUES(`time`), `time`)
            ]]
    if not execute_statement(string.format(
            insert_flagrun_sql,
            tonumber(server.stats_serverid),
            escape_string(flagrun.mapname),
            escape_string(flagrun.playername),
            escape_string(flagrun.modename),
            tonumber(flagrun.time))) then return nil end

    if not flagruns[flagrun.modename] then
        flagruns[flagrun.modename] = {}
    end
    if not flagruns[flagrun.modename][flagrun.mapname] then
      flagruns[flagrun.modename][flagrun.mapname] = {}
    end

    flagruns[flagrun.modename][flagrun.mapname] = {flagrun.playername, flagrun.time, "today"}

    local cursor = execute_statement("SELECT last_insert_id()")
    if not cursor then return nil end
    return cursor:fetch()
end



local function mysql_commit_flagrun(flagrun)
    
    if not connection and not mysql_open(open_settings) then
       return false
    end
    
--    if not execute_statement("START TRANSACTION") then 
--        return false
--    end

    local flagrun_id = insert_flagrun(flagrun)
    local personal_flagrun_id = insert_personal_flagrun(flagrun)

    if nil == flagrun_id or nil == personal_flagrun_id then
        return false
    end

--    if not execute_statement("COMMIT") then
--        return false
--    end

-- seriously transactions for situations where one server should edit one entity at a time
-- combined with serverid field ... it causes more issues like locked tables than it may
-- prevent ....
    
    return true
end

local function commit_flagrun(flagrun)
    
    local function queue_current_flagrun()
        queue[#queue+1] = flagrun
    end
    
    while #queue > 0 do
        if mysql_commit_flagrun(queue[1]) then
            table.remove(queue, 1)
        else
            queue_current_flagrun()
            return
        end
    end
    
    if not mysql_commit_flagrun(flagrun) then
        queue_current_flagrun()
    end
end

local function load_flagruns(map,mode,show)

    if not flagruns[mode] then
      flagruns[mode] = {}
    end
    if not flagruns[mode][map] then
      flagruns[mode][map] = {}
    end

    local load_flagruns_query = execute_statement(string.format("SELECT `playername`, `time`, `created`, `modified` FROM `flagruns` WHERE `serverid` = %i AND `mapname` = '%s' AND `gamemode`='%s'", tonumber(server.stats_serverid),map,mode))
    row = load_flagruns_query:fetch ({}, "a")
    if row then
      if row.time then
        local date = row.modified or row.created
        flagruns[mode][map] = {row.playername, tonumber(row.time),date}
        if 1 == show then
          server.msg(string.format("%s ran on %s in %ss ( %s ) %s", row.playername, map , string.format("%.3f",tonumber(row.time)/1000), mode, date))
        end
      end
    end
end

local function load_personal_flagruns(map,mode,pname,cn,show)

    if not personal_flagruns[pname] then
      personal_flagruns[pname] = {}
    end
    if not personal_flagruns[pname][mode] then
      personal_flagruns[pname][mode] = {}
    end
    if not personal_flagruns[pname][mode][map] then
      personal_flagruns[pname][mode][map] = {}
    end

    local load_pflagruns_query = execute_statement(string.format("SELECT `time`,`created`, `modified` FROM `personal_flagruns` WHERE `playername` = '%s' AND `mapname` = '%s' AND `gamemode`='%s' ORDER BY `time` LIMIT 1", escape_string(pname),map,mode))
    row = load_pflagruns_query:fetch ({}, "a")
    if row then
      if row.time then
        local date = row.modified or row.created
        personal_flagruns[pname][mode][map] = {tonumber(row.time),date}
        if 1 == show then
          server.player_msg(cn, string.format("You ran on %s in %ss ( %s ) %s", map , string.format("%.3f",tonumber(row.time)/1000), mode, date))
        end
      end 
    end
end


if using_mysql then
    local ret = catch_error(mysql_open, {
        hostname    = server.stats_mysql_hostname,
        port        = server.stats_mysql_port,
        username    = server.stats_mysql_username,
        password    = server.stats_mysql_password,
        database    = server.stats_mysql_database,
        install     = server.stats_mysql_install == "true",
        servername  = server.stats_servername
    })
end

local scoreflag = server.event_handler("scoreflag", function(cn, team, score, timetrial, used_rugby)
    local docommit = 0
    local a,b,c = "no best time",0,"now"

    if gamemodeinfo.ctf and timetrial > 0 then
        if not flagruns[igamemode] then
            load_flagruns(map, igamemode,0)
        end
        local playerauthname = server.player_name(cn)
        local mapname = server.map
        if(1 == server.stats_overwrite_name_with_authname and 1 == server.stats_use_auth and server.player_vars(cn).stats_auth_name) then
            playerauthname = server.player_vars(cn).stats_auth_name
        end
        
        if playerauthname and not used_rugby then
          load_personal_flagruns(mapname,igamemode,playerauthname,cn,1)

          if not personal_flagruns[playerauthname][igamemode][mapname][1] then
              docommit = 1
          else
            if timetrial < personal_flagruns[playerauthname][igamemode][mapname][1] then
              docommit = 1
            end
          end

          if not flagruns[igamemode][mapname][2] or  timetrial < flagruns[igamemode][mapname][2] then
            docommit = 1
          end

          if 1 == docommit then
            commit_flagrun({ mapname = mapname, playername = playerauthname, time = timetrial, modename = igamemode})
            load_personal_flagruns(mapname,igamemode,playerauthname,cn,0)
            load_flagruns(mapname, igamemode,0)
          end
        end
        if flagruns[igamemode] and flagruns[igamemode][mapname] and flagruns[igamemode][mapname][2] then
          if flagruns[igamemode][mapname][2] > timetrial then
            a = playerauthname
            b = timetrial
            c = "just now"
          end
          a = flagruns[igamemode][mapname][1]
          b = flagruns[igamemode][mapname][2]
          c = flagruns[igamemode][mapname][3]
        end

        server.msg("flagrun", {name = playerauthname, time = string.format("%.3f",timetrial/1000), bestname = a, besttime = string.format("%.3f",b/1000), created = c .. "" })
    end
end)

local mapchange = server.event_handler("mapchange", function(map)
    flagruns = {{},{}}
    personal_flagruns = {{},{},{}}
    igamemode = server.gamemode
    if gamemodeinfo.ctf then
        flagruns[igamemode] = {}
        load_flagruns(map, igamemode,1)
    end
end)

local started = server.event_handler("started", function()
    flagruns = {{},{}}
    personal_flagruns = {{},{},{}}
    igamemode = server.gamemode
end)
