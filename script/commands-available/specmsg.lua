--[[
        A player command to send a message to all spectators
]]

local help = "send a message to all spectators"
local usage = "<text>"
local enabled = true
local permission = 0

local run = function(cn, ...)

    local text = table.concat({...}, " ")
    
    if not text then
        return false, usage
    end

    for client in server.gspectators() do
        client:msg("specmsg_command_message", {name = server.player_name(cn), cn = cn, msg = text})
    end
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
