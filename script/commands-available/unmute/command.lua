--[[

  A player command to unmute a player

]]
local permission = 1
local enabled = true
local help = "unmute a player"
local usage ="<cn>"

local init = function()
    if(true == enabled and not server.mute) then
        server.log(string.format("WARN: command #unmute is enabled but mute module not loaded!"))
        enabled = false
    end
end

local run = function(cn,tcn)
  if false == enabled then
    return false, "mute module not loaded"
  elseif not tcn then
    return false, "#unmute <cn>|\"<name>\""
  elseif not server.valid_cn(tcn) then
    tcn = server.name_to_cn_list_matches(cn,tcn)
    if not tcn then return end
  elseif not server.is_muted(tcn) then
    server.player_msg(cn, string.format(server.player_not_muted, server.player_displayname(tcn)))
    return
  end

  server.unmute(tcn)
end

return {
        init = init,
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
