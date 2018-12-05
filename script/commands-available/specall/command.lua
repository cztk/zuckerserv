--[[

    	A player command to spec all players

]]

local enabled=true
local permission=1

local help = function(cn, command)

    server.player_msg(cn, "spec all players")

end

local run = function()
    server.specall(true)
    server.msg("specall_command")
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
