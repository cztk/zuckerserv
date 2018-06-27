--[[
	An admin command to disable damages
]]

local usage = "0|1"
local nodamage = false
local help = "disable damages"

local permission = 1
local enabled = true
local aliases = {"nodmg"}

local damage_evt,mapchange_evt

local init= function()
	nodamage = false
	damage_evt = server.event_handler("damage", function()
		if nodamage then
			return -1
		end
	end)
	mapchange_evt = server.event_handler("mapchange", function() nodamage = false end)
end

local unload = function()
        damage_evt()
        mapchange_evt()
	nodamage = nil
end

local run = function(cn, option)
	if not option then
		return false, usage
	elseif tonumber(option) == 1 then
		nodamage = true
		server.player_msg(cn, server.nodamage_enabled_message)
	elseif tonumber(option) == 0 then
		nodamage = false
		server.player_msg(cn, server.nodamage_disabled_message)
	else
		return false, usage
	end
end

return {
        init = init,
        run = run,
        unload = unload,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}
