-- rugby modes
-- 0 =
server.event_handler("damage", function(target, actor, damage, gun)
    if 1 == server.rugby_enabled and target ~= actor and server.player_team(actor) == server.player_team(target) then
        if(1 == server.has_flag(actor)) then
            if server.rugby_mode == 0 then
                server.msg("hmm did it pass?")
            end
            if server.rugby_mode >= 1 then
                server.passflag(actor, target)
            end
            return -1
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
        server.msg(string.format("%s owned the flag %s ms, passed %s times%s", value["name"], value["owntimems"], value["passcount"], didittext))
        server.player_add_flagcount(cn, 1)
    end
end)
