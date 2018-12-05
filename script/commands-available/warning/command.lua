--[[

  A player command to send a warning message
  player get banned when limit is reached

]]

local limit = server.warning_limit
local bantime = round(server.warning_bantime or 1800000 / 1000,0)

local permission = 1
local enabled = true
local aliases = {"warn"}

local help = function(cn, command)

    server.player_msg(cn, "send a warning message, player get banned when limit is reached")
    server.player_msg(cn, "#" .. command .. " <cn>|\"<name>\" <text>")

end

local init = function()
  limit = (server.warning_limit or 3)
  bantime = round(server.warning_bantime or 1800000 / 1000,0)
end

local run = function(cn, tcn, ...)
  if not tcn then
    help()
    return false
  end

  local text = table.concat({...}, " ")
  if not text then
    help()
    return false
  elseif text == "tk" then
    text = "Stop teamkilling. ONLY RED players are the enemies!"
  elseif not server.valid_cn(tcn) then
    tcn = server.name_to_cn_list_matches(cn,tcn)
    if not tcn then return end
  end
  local warn_count = (server.player_vars(tcn).warning_count or 1)
  if warn_count <= limit then
    for c in server.gclients() do
      local last = (warn_count == limit and limit > 1) and server.parse_message(cn, "last") or ""
      c:msg("warning_warn", { last = last, name = server.player_displayname(tcn), text = text })
    end

    server.player_vars(tcn).warning_count = warn_count + 1
  else
    server.kick(tcn,bantime,server.player_name(cn),"warning limit reached")
    server.player_vars(tcn).warning_count = nil
  end
end

return {
        init = init,
        run = run,
        permission = permission,
        enabled = enabled,
        aliases = aliases,
        help_function = help
}
