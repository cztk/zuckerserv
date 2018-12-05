--[[

	A player command to raise privilege to admin

        May 25 2013 (gear4): removed junk

]]

local trigger_event
local id_event

local aliases = {}
local enabled = true
local permission = 0

local help = function(cn, command)

    server.player_msg(cn, "raise privilege to admin.")
    server.player_msg(cn, "#" .. command)

end

local init = function()
    trigger_event, id_event = server.create_event_signal("admin-command")
end

local run = function(cn)
  local domains = table_unique(server.admin_domains)

  if not domains then
    server.log_error("admin command: no domains set")
    return
  end

  local sid = server.player_sessionid(cn)
  for _, domain in pairs(domains) do
    auth.send_request(cn, domain, function(cn, user_id, domain, status)
      if sid == server.player_sessionid(cn) and status == auth.request_status.SUCCESS then
        server.setadmin(cn)

        server.msg("claimadmin", { name = server.player_displayname(cn), uid = user_id })
        server.log(string.format("%s playing as %s(%i) used auth to claim admin.", user_id, server.player_name(cn), cn))
        server.admin_log(string.format("%s playing as %s(%i) used auth to claim admin.", user_id, server.player_name(cn), cn))

        trigger_event(cn, user_id)
      end
    end)
  end
end

local unload= function()
    server.cancel_event_signal(id_event)
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
