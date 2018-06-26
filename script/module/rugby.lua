-- rugby modes

server.event_handler("damage", function(target, actor, damage, gun)
    if 1 == server.rugby_enabled and target ~= actor and server.player_team(actor) == server.player_team(target) then
        if(1 == server.has_flag(actor)) then
            if server.rugby_mode == 0 then
                server.msg("hmm did it pass?")
                return -1
            end
            if server.rugby_mode >= 1 and server.rugby_mode ~= 3 and server.rugby_mode ~= 4  then
                server.passflag(actor, target)
            end
            if server.rugby_mode == 3 or server.rugby_mode == 4 then
              if(1 == rugby_weapons[gun]) then
                server.passflag(actor, target)
                return -1
              end
            end
            if server.rugby_mode >= 1 and ( server.rugby_mode ~= 3 and server.rugby_mode ~= 4 ) then
                return -1
            end
        end
    end
end)

server.event_handler("passflag", function(actor, target)
    server.msg(string.format("%s passed the flag to %s - some random great job message.", server.player_name(actor), server.player_name(target)))
end)

server.event_handler("creditflaghelpers", function(scoreclientnum, scoreteam, score, timetaken, helpers)
    for index,value in ipairs(helpers) do
        local didittext = "";
        local cn = value["cn"];
        if(value["stoleflagfirst"]) then
            didittext = " and stole the flag #1"
        end
        didittext = string.format("%s(%s) owned the flag %s ms, passed %s times%s", value["name"], value["cn"], value["owntimems"], value["passcount"], didittext)
        if (server.rugby_mode == 2 or server.rugby_mode == 4) and scoreclientnum ~= value["cn"] then
            didittext = didittext .. " +1 Flagscore"
            server.player_add_flagcount(tonumber(value["cn"]), 1)
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

server.interval(354300, rugby_notice)
