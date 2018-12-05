--[[
  A player command to raise player's privilege to master
]]

local trigger_event
local id_event

local permission = 1
local enabled = true
local aliases = {"setmaster"}

local help = function(cn, command)

    server.player_msg(cn, "raise player's privilege to master")
    server.player_msg(cn, "#" .. command .. "<cn>")

end

local init = function()
    trigger_event, id_event = server.create_event_signal("givemaster-command")
end

local unload = function()
    server.cancel_event_signal(id_event)
end

local run = function(cn, target)
  if not target then
    help()
    return false
  elseif not server.valid_cn(target) then
    return false, "CN is not valid"
  end

--  server.unsetpriv(cn)
  server.player_msg(target, "givemaster_message", { name = server.player_displayname(cn) })
  server.admin_log(string.format("GIVEMASTER: %s gave master to %s", server.player_displayname(cn), server.player_displayname(target)))
  if not (server.player_priv_code(target) >= server.PRIV_MASTER) then
    server.setmaster(target)
  end

  trigger_event(cn, target)
end

return {
        init = init,
        run = run,
        unload = unload,
        permission = permission,
        enabled = enabled,
        help_function = help,
        aliases = aliases
}

