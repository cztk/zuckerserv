--[[

	A player command to raise player's privilege to admin

]]

local trigger_event
local id_event

local permission = 3
local enabled = true
local aliases = {"setadmin"}
local help = "A player command to raise player's privilege to admin"
local usage ="<cn>"

local init = function()
    trigger_event, id_event = server.create_event_signal("giveadmin-command")
end

local unload = function()
    server.cancel_event_signal(id_event)
end

local run = function(cn, target)
    if not target then
        return false, usage
    end

    if not server.valid_cn(target) then
        return false, "CN is not valid"
    end

    -- server.unsetmaster()
    server.player_msg(target, "giveadmin", {name = server.player_displayname(cn) })
    server.admin_log(string.format("GIVEADMIN: %s gave admin to %s", server.player_displayname(cn), server.player_displayname(target)))
    server.setadmin(target)

    trigger_event(cn, target)
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
