
local help = "starts/stops recoding demo"
local usage = "1|0"
local enabled = true
local permission = 3
local aliases = {"demo"}

local run = function(cn,option)

	if not option or option == "1" or option == "start" then
		server.recorddemo("log/demo/" .. os.date("%y_%m_%d.%k_%M") .. "." .. server.gamemode .. "." .. server.map .. ".dmo")
		server.msg("recorddemo_start")
	else
		server.stopdemo()
	end

end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}
