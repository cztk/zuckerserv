--[[

  A player command to send a message to a player

]]
local permission = 0
local enabled = true
local help = "Send a private message to another player"
local usage ="<cn|name> <message>"
local aliases = {"pc", "pn", "pm", "pchat", "msg"}

local run = function(cn, tcn, ...)
  if not tcn then
    return false, usage
  end

  local text = table.concat({...}, " ")

  if not server.valid_cn(tcn) then
    tcn = server.name_to_cn_list_matches(cn,tcn)
    if not tcn then
      return
    end
  end

  server.player_msg(tcn, "priv_message", { name = server.player_displayname(cn), msg = text })
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}
