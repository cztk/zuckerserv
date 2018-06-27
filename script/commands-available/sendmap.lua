--[[
	An admin command for sending the map to a player
]]

local help = "sending the map to a player"
local usage = "<cn>|all"
local permission = 1
local enabled = true

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
