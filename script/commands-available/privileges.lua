--[[
	A player command to list players privileges
]]

local permission = 0
local enabled = true
local help ="list players privileges"
local usage =""
local aliases = {"privs"}

local run = function(cn)
    for p in server.gplayers() do
        if server.player_priv_code(p.cn) > server.PRIV_NONE then
            server.player_msg(cn, string.format(server.player_privileges_list_message, p:name(), p.cn, p:priv()))
        end
    end
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}
