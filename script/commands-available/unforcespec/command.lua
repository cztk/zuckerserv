--[[
	A player command to disable the leave-spectator-block
]]

local permission = 1
local enabled = true
local aliases = {"unfspec"}

local help = function(cn, command)

    server.player_msg(cn, "disable the leave-spectator-block")
    server.player_msg(cn, "#" .. command .. " <cn>|\"<name>\"")

end

local run = function(cn, tcn)
    if not tcn then
        help()
        return false
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
        help_function = help,
        aliases = aliases
}
