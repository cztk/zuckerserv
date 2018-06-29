-- rugby modes
--["regen capture"] ["capture"] ["effic ctf"] ["insta ctf"] ["ctf"] ["effic protect"] ["insta protect"] ["protect"] ["effic hold"] ["insta hold"] ["hold"] ["teamplay"] ["ffa"] ["effic team"] ["efficiency"] ["tac team"] ["tactics"] ["insta team"] ["instagib"] ["coop edit"]
server.event_handler("damage", function(target, actor, damage, gun)
    if 1 == server.rugby_enabled and target ~= actor and server.player_team(actor) == server.player_team(target) then
        if(1 == server.has_flag(actor)) then
            if server.rugby_mode == 0 then
                server.msg("hmm did it pass?")
                return -1
            end
            if server.rugby_mode >= 1 and server.rugby_mode ~= 3 and server.rugby_mode ~= 4  then
                server.passflag(actor, target,0)
            end
            if server.rugby_mode == 3 or server.rugby_mode == 4 then
              if(1 == rugby_weapons[gun]) then
                server.passflag(actor, target,0)
                return -1
              end
            end
            if server.rugby_mode >= 1 and ( server.rugby_mode ~= 3 and server.rugby_mode ~= 4 ) then
                return -1
            end
        end
    end
end)

server.event_handler("passflag", function(actor, target, dist)
    server.msg(string.format(red().."%s "..white().."passed the flag to %s with a distance of "..blue().."%s"..white().."ogro feet - "..green().."some random great job message.", server.player_name(actor), server.player_name(target), string.format("%.2f",dist/1000)))
end)

server.event_handler("creditflaghelpers", function(scoreclientnum, scoreteam, score, timetaken, helpers)
    for index,value in ipairs(helpers) do
        local didittext = "";
        local cn = value["cn"];
        if(value["stoleflagfirst"]) then
            didittext = " first holder"
        end
        didittext = string.format(blue().."%s"..white().." hold IT "..red().."%s"..white().."s, "..green().."%s"..white().." passes"..green().."%s"..orange().." Dist.: "..blue().."%s"..white().."of"..green(), value["name"], string.format("%.3f",value["owntimems"]/1000), value["passcount"], didittext, string.format("%.2f", value["distance"]/1000))
        if string.match(server.gamemode, "ctf") or string.match(server.gamemode, "hold") then
          if (server.rugby_mode == 2 or server.rugby_mode == 4) and scoreclientnum ~= value["cn"] then
            didittext = didittext .. " +1 Flagscore"
            server.player_add_flagcount(tonumber(value["cn"]), 1)
          end
        end
        server.msg(didittext);
    end
end)

-- TODO if more than 5 are allowed, list disallowed weapons +-
local rugby_notice = function(cn)
  if server.rugby_enabled == 1 then
    local guns = ""
    for index,value in pairs(rugby_weapons) do
      if 1 == value then
        guns = guns .. " " .. weapons_types[index]
      end
    end

    if rugby_cmd_msgs[server.rugby_mode] then
      server.msg(rugby_cmd_msgs[server.rugby_mode], { name = "Server", weapons = guns } )
    end
  end
end

server.interval(194300, rugby_notice)
