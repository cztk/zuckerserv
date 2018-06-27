--[[

	A player command to set a leave-spectator-block

]]
local permission = 1
local enabled = true
local help = "A player command to set a player as spectator"
local usage = "<cn>|\"<name>\""
local aliases = {"fspec"}

local run = function(cn, tcn, time)
    if not tcn then
        return false, usage
    end

    if not server.valid_cn(tcn) then
        tcn = server.name_to_cn_list_matches(cn,tcn)
        if not tcn then
            return false, "Invalid CN"
        end
    end

    tcn = tonumber(tcn)

    if not server.force_spec then
        return false, "force_spec module is not loaded"
    end

    server.force_spec(tcn,time)
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}
