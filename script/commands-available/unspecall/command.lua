--[[

    	A player command to unspec all players

]]

local permission = 1
local enabled = true
local help ="unspec all players"
local usage =""


local run = function()
    server.unspecall(true)
    server.msg("unspecall_command")
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
