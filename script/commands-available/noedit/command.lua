--[[
	An admin command for spectating player for a defined time when entering edit mode
        TODO: does not check if player "should" stay in spec
]]

local permission = 1
local enabled = true
local noedit = false
local SPEC_TIME = 5000

local help = function(cn, command)

    server.player_msg(cn, "specs player for a defined time when entering edit mode")
    server.player_msg(cn, "#" .. command .. " 0|1 [spec_time]")

end

local editmode_evt, mapchange_evt

local init=function()
	editmode_evt = server.event_handler("editmode", function(cn, val) 
		if noedit and val then
			local sid = server.player_sessionid(cn)
			server.force_spec(cn)
			server.sleep(SPEC_TIME, function()
				if sid == server.player_sessionid(cn) then
					server.unforce_spec(cn)
					server.player_respawn(cn)
				end
			end)
		end
	end)
	mapchange_evt = server.event_handler("mapchange", function() noedit = false end)
end

local unload = function()
        editmode_evt()
        mapchange_evt()
	noedit = nil
end

local run = function(cn, option)
	option = tonumber(option)

	if option and (option == 0 or option == 1) then
		noedit = (option == 1)
	else
                help()
		return false
	end

	if noedit then
		server.player_msg(cn, server.noedit_enabled_message)
	else
		server.player_msg(cn, server.noedit_disabled_message)
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
