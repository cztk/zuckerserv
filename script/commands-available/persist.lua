--[[
        A player command to enable/ disable persistent teams at mapchange
]]

local usage = "0|1"
local help = "enable/ disable persistent teams at mapchange"
local permission = 1
local enabled = true


local run = function(cn, option)
    if not option then
        return false, usage
    elseif tonumber(option) == 1 then
        server.reassignteams = 0
        server.player_msg(cn, server.persist_disabled_message)
    elseif tonumber(option) == 0 then
        server.reassignteams = 1
        server.player_msg(cn, server.persist_enabled_message)
    else
        return false, usage
    end
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
