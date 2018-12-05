--[[
	A player command to list players privileges
]]

local permission = 0
local enabled = true
local aliases = {"privs"}

local help = function(cn, command)

    server.player_msg(cn, "list players privileges")

end

local run = function(cn)
    for p in server.gplayers() do
        if server.player_priv_code(p.cn) > server.PRIV_NONE then
            server.player_msg(cn, "player_privileges_list", {name = p:name(), cn = p.cn,  priv =p:priv()})
        end
    end
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help,
        aliases = aliases
}
