--[[
Force disconnecting someone from the server (without kicking or banning him)
By LoveForever (C) 2011
]]--

local permission = 1
local enabled = true
local help = "Force disconnecting someone from the server (without kicking or banning him)"
local usage = "<cn>"
local aliases = {"disc"}

local run = function(cn, tcn, ...)
  if not tcn then
    return false, "#disconnect <cn>"
  end
  
  if not server.valid_cn(tcn) then
    tcn = server.name_to_cn_list_matches(cn,tcn)
    if not tcn then return end
  end
  server.disconnect(tcn, 10, "disconnected by an admin")
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}
