-- #slay <cn>|\"<name>\"|all

local help = "kill a player by force"
local usage = "<cn>|\"<name>\"|all"
local permission = 3
local enabled = true
local aliases = {"kill"}

local run = function(cn, target)

	if not target then
		return false, usage
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
		return false, usage
	end

	server.player_slay(target)
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}
