--[[
	An admin command for hiding edit from a player to others
]]

local permission = 3
local enabled = true
local editmute = false

local editpacket_evt,mapchange_evt

local help = function(cn, command)

    server.player_msg(cn, "An admin command for hiding edit from a player to others")
    server.player_msg(cn, "#" .. command .. " 0|1 [<cn>]")

end

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
                help()
		return false
	end

	if target then
		if server.valid_cn(target) then
			server.player_vars(target).editmute = option
		else
                        help()
			return false
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
        help_function = help
}
