--[[

    	A player command to unspec all players

]]

local permission = 1
local enabled = true

local help = function(cn, command)

    server.player_msg(cn, "unspec all players")

end

local run = function()
    server.unspecall(true)
    server.msg("unspecall_command")
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
