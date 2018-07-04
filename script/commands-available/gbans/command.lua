local permission = 3
local enabled = true
local message = "Lists gbans"
local usage = ""

local run = function(cn)
    for ipmask, vars in pairs(server.ip_vars()) do
        if (vars.ban_expire or 0) > os.time() and (vars.is_gban or false) then
            server.player_msg(cn, string.format(
                "IP: %s Banlist: %s Reason: %s%s%s",
                ipmask,
                vars.ban_admin or "unknown",
                vars.ban_reason or "unknown",
                _if(vars.ban_expire - os.time() < 31536000, string.format(blue(" (expires in: %s)"), server.format_duration_str(vars.ban_expire - os.time())), ""),
                _if(vars.ignore_gban or false, red(" (deleted)"), "")
                        ))
        end
    end
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
