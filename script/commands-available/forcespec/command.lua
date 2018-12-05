--[[

	A player command to set a leave-spectator-block

]]
local permission = 1
local enabled = true
local aliases = {"fspec"}

local help = function(cn, command)

    server.player_msg(cn, "A player command to set a player as spectator")
    server.player_msg(cn, "#" .. command .. " <cn>|\"<name>\"")

end

local run = function(cn, tcn, time)
    if not tcn then
        help()
        return false
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
        aliases = aliases,
        help_function = help
}
