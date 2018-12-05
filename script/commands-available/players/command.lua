--[[
	A player command to list players and their country, frags, deaths and accuracy
]]

local permission = 0
local enabled = true

local help = function(cn, command)

    server.player_msg(cn, "list players and their country, frags, deaths and accuracy")
    server.player_msg(cn, "#" .. command .. " <cn>|\"<name>\"")

end

local run = function(cn)
    for p in server.gplayers() do
        local country = server.mmdatabase:lookup_ip(p:ip(), "country", "names", messages.languages["default"])
        local city = server.mmdatabase:lookup_ip(p:ip(), "city", "names", messages.languages["default"])
        if not country or #country < 1 then country = "Unknown" end
        if not city or #city < 1 then city = "Unknown" end
        server.player_msg(cn, "player_list", { name = p:displayname(), city = city, country = country, frags = p:frags(), deaths = p:deaths(), acc = p:accuracy() })
    end
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
