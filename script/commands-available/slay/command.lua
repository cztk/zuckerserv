-- #slay <cn>|\"<name>\"|all

local permission = 3
local enabled = true
local aliases = {"kill"}

local help = function(cn, command)

    server.player_msg(cn, "kill a player by force")
    server.player_msg(cn, "#" .. command .. " <cn>|\"<name>\"|all")

end

local run = function(cn, target)

	if not target then
                help()
		return false
	end

	if target == "all" then
		for p in server.gplayers() do p:slay() end
        
		return
	elseif not server.valid_cn(target) then
		target = server.name_to_cn_list_matches(cn, target)

		if not target then
			return
		end
	else
                help()
		return false
	end

	server.player_slay(target)
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help,
        aliases = aliases
}
