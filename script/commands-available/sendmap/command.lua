--[[
	An admin command for sending the map to a player
]]

local permission = 1
local enabled = true

local help = function(cn, command)

    server.player_msg(cn, "sending the map to a player")
    server.player_msg(cn, "#" .. command .. " <cn>|all")

end

local run =function(actor, target)
	if target == "all" then
		for p in server.gclients() do
			if p.cn ~= actor then
				server.sendmap(actor, p.cn)
			end
		end
	elseif target and server.valid_cn(target) then
		server.sendmap(actor, target)
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
