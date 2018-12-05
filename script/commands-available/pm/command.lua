--[[

  A player command to send a message to a player

]]
local permission = 0
local enabled = true
local aliases = {"pc", "pn", "pm", "pchat", "msg"}

local help = function(cn, command)

    server.player_msg(cn, "Send a private message to another player")
    server.player_msg(cn, "#" .. command .. " <cn|name> <message>")

end

local run = function(cn, tcn, ...)
  if not tcn then
    help()
    return false
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
        help_function = help,
        aliases = aliases
}
