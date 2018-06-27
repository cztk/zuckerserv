--[[
Nextmap script
*Show next map (from hopmod trunk)
*Show second map of mapbattle (LoveForEver for Suckerserv)
--]]

local permission = 0
local enabled = true
local help = "shows next map &&|| 2nd map of battle"
local usage =""
local aliases = {"next"}

local run = function(cn)

    if not map_rotation then
        server.player_msg(cn, "clients are controlling the map rotation")
    end
	
    local map1 = map_rotation.get_map_name(server.gamemode)
    local map2 = mapbattle.get_next_map(mapbattle.range, server.gamemode) or ""

    server.player_msg(cn, string.format(server.nextmap_message, map1, map2))
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}