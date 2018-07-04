--[[
	An admin command for hiding edit from a player to others
]]

local permission = 3
local enabled = true
local help = "An admin command for hiding edit from a player to others #editmute 0|1 [<cn>]"
local usage = "0|1 [<cn>]"

local editmute = false

local editpacket_evt,mapchange_evt

local mapchange=function()
        editmute = nil
        for p in server.gplayers() do
                p:vars().editmute = nil
        end
end

local unload=function()
        mapchange()
        editpacket_evt()
        mapchange_evt()
end

local init=function()
	editpacket_evt = server.event_handler("editpacket", function(cn)
		if editmute or server.player_vars(cn).editmute then
			return -1
		end
	end)
	mapchange_evt = server.event_handler("mapchange", mapchange)
end

local run=function(cn, option, target)
	local option = tonumber(option)
	local target = tonumber(target)

	if option and (option == 0 or option == 1) then
		option = (option == 1)
	else
		return false, usage
	end

	if target then
		if server.valid_cn(target) then
			server.player_vars(target).editmute = option
		else
			return false, usage
		end
		local cn = target
	else
		editmute = option
	end

	if option then
		server.player_msg(cn, server.editmute_enabled_message)
	else
		server.player_msg(cn, server.editmute_disabled_message)
	end
end

return {
        init = init,
        run = run,
        unload = unload,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
