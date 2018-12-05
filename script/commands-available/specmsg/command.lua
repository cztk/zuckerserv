--[[
        A player command to send a message to all spectators
]]

local enabled = true
local permission = 0

local help = function(cn, command)

    server.player_msg(cn, "send a message to all spectators")
    server.player_msg(cn, "#" .. command .. " <text>")

end

local run = function(cn, ...)

    local text = table.concat({...}, " ")
    
    if not text then
        help()
        return false
    end

    for client in server.gspectators() do
        client:msg("specmsg_command_message", {name = server.player_name(cn), cn = cn, msg = text})
    end
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
