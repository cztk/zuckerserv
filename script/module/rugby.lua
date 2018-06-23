server.event_handler("damage", function(target, actor, damage, gun)
    if 1 == server.rugby_enabled and target ~= actor and server.player_team(actor) == server.player_team(target) then
        if(1 == server.has_flag(actor)) then
            if server.rugby_mode == 0 then
                server.msg("hmm did it pass?")
            end
            if server.rugby_mode == 1 then
                server.passflag(actor, target)
                server.msg(string.format("%s passed the flag to %s - some random great job message.", server.player_name(actor), server.player_name(target)))
            end
            return -1
        end
    end
end)

