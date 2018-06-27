--[[
	A player command to disable the leave-spectator-block
]]

local usage = "<cn>|\"<name>\""
local help = "disable the leave-spectator-block"
local permission = 1
local enabled = true
local aliases = {"unfspec"}

local run = function(cn, tcn)
    if not tcn then
        return false, usage
    end

    if not server.valid_cn(tcn) then
        tcn = server.name_to_cn_list_matches(cn,tcn)
        if not tcn then
            return
        end
    end

    tcn = tonumber(tcn)

    server.player_vars(tcn).modmap = false		-- when cd/modmap.lua was active

    if not server.unforce_spec then
        server.unspec(tcn)
    end

    server.unforce_spec(tcn)
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}
