--[[

  A player command to mute a player
  
]]

local permission = 1
local enabled = true

local help = function(cn, command)

    server.player_msg(cn, "mute a player")
    server.player_msg(cn, "#" .. command .. " <cn>|\"<name>\" [reason] [time]")

end

local init = function()
    if(true == enabled and not server.mute) then
        server.log(string.format("WARN: command #mute is enabled but mute module not loaded!"))
        enabled = false
    end
end

local run = function(cn,tcn,reason,time)
  if false == enabled then
    return false, "mute module not loaded"
  elseif not tcn then
    help()
    return false
  elseif not server.valid_cn(tcn) then
    tcn = server.name_to_cn_list_matches(cn,tcn)
    if not tcn then return end
  elseif server.is_muted(tcn) then
    server.player_msg(cn, string.format(server.player_muted_already, server.player_displayname(tcn)))
    return
  end

  server.mute(tcn, time, reason or nil)
  server.player_msg(cn, string.format(server.player_mute_admin_message, server.player_displayname(tcn)))
end

return {
        init = init,
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
