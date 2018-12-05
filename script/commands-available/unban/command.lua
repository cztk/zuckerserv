--[[
	A player command to unban a banned player
]]

local enabled = true
local permission = 1

local help = function(cn, command)

    server.player_msg(cn, "unban a banned player")
    server.player_msg(cn, "#" .. command .. " <ip>")

end

local run = function(cn, ip)
    if not ip then
        help()
        return false
    end
    local res = check_ip(ip)
    if #res == 1 then
        return false, string.format("Invalid IP (%s)", res[1])
    end
    if server.ip_vars(ip).ban_time then
        server.unban(ip)
        server.msg("unban_message", { name = server.player_displayname(cn), ip = ip })
        admin_log(string.format("UNBAN: %s unbaned IP: %s", server.player_displayname(cn), ip))
    else
        server.player_msg(cn, "no_matching_ban", { ip = ip })
    end
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}

