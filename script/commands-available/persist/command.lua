--[[
        A player command to enable/ disable persistent teams at mapchange
]]

local permission = 1
local enabled = true

local help = function(cn, command)

    server.player_msg(cn, "enable/ disable persistent teams at mapchange")
    server.player_msg(cn, "#" .. command .. " 0|1")

end


local run = function(cn, option)
    if not option then
        help()
        return false
    elseif tonumber(option) == 1 then
        server.reassignteams = 0
        server.player_msg(cn, server.persist_disabled_message)
    elseif tonumber(option) == 0 then
        server.reassignteams = 1
        server.player_msg(cn, server.persist_enabled_message)
    else
        help()
        return false
    end
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
