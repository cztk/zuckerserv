
local enabled = true
local permission = 3
local aliases = {"demo"}

local help = function(cn, command)

    server.player_msg(cn, "starts/stops recoding demo")
    server.player_msg(cn, "#" .. command .. " 1|0")

end

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
        help_function = help,
        aliases = aliases
}
