--[[
	A player command to set a permaban

	Copyright (C) 2009 Thomas

    TODO: Does that command still work??
    TODO: if it works, exclude other admins maybe?
]]

local permission = 3
local enabled = true
local help = "set a permaban on a player, maybe"
local usage = "<cn>|name"

local run = function(cn,cn_ban)

	if not cn_ban then
		return false, "#permaban <cn>|\"<name>\""
	end

	if not server.valid_cn(cn_ban) then

		cn_ban = server.name_to_cn_list_matches(cn,cn_ban)

		if not cn_ban then
			return
		end
	end

	local pb_file = io.open(server.banlist_file, "a+")

	pb_file:write("permban " .. server.player_ip(cn_ban) .. "\n")
	server.kick(cn_ban, -1, "server", red("permabanned"))
	admin_log(string.format("PERMBAN: Player %s addes a ban on IP: %s.", server.displayname(cn), server.player_ip(cn_ban)))

	pb_file:flush()
	pb_file:close()
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
