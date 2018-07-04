--[[

    	A player command to spec all players

]]

local usage =""
local help ="spec all players"
local enabled=true
local permission=1


local run = function()
    server.specall(true)
    server.msg("specall_command")
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
