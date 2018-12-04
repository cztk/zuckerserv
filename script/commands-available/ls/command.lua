
local help = "Lists current players."
local usage = ""
local aliases = {}
local enabled = true
local permission = 3

local init = function()
end

local run = function(ccn)
    for _, cn in ipairs(server.clients()) do
        server.player_msg(ccn, string.format("CN %s: IP: %s IPLong: %s Priv: %s NetIpmask: %s", cn, server.player_ip(cn), server.player_iplong(cn), server.player_priv_code(cn), net.ipmask(server.player_iplong(cn)) ))
    end
end

local unload= function()
end

return {
        init = init,
        run = run,
        unload = unload,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}
