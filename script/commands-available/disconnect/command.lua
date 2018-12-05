--[[
Force disconnecting someone from the server (without kicking or banning him)
By LoveForever (C) 2011
]]--

local permission = 1
local enabled = true
local aliases = {"disc"}

local help = function(cn, command)

    server.player_msg(cn, "Force disconnecting someone from the server (without kicking or banning him)")
    server.player_msg(cn, "#" .. command .. "<cn>")

end

local run = function(cn, tcn, ...)
  if not tcn then
    return false, "#disconnect <cn>"
  end
  
  if not server.valid_cn(tcn) then
    tcn = server.name_to_cn_list_matches(cn,tcn)
    if not tcn then return end
  end
  server.disconnect(tcn, 10, "disconnected")
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help,
        aliases = aliases
}
