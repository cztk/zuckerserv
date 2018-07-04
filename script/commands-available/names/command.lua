--[[
  A player command to list all known names to player
  based on the stats.db and player_ip
]]

local permission = 3
local enabled = true
local help = "list all known names to player"
local usage ="<cn>|\"<name>\""
local aliases = {"alias"}

local init = function()
    if(true == enabled and not server.find_names_by_ip) then
        server.log(string.format("WARN: command #names is enabled but find_names_by_ip module not loaded!"))
        enabled = false
    end
end

local run = function(cn, target_cn)
  if not server.find_names_by_ip then
    return false, "Not available with this database"
  elseif not target_cn then
    return false, usage
  elseif not server.valid_cn(target_cn) then
    target_cn = server.name_to_cn_list_matches(cn,target_cn)
    if not target_cn then return end
  end

  local current_name = server.player_name(target_cn)
  local names = server.find_names_by_ip(server.player_ip(target_cn), current_name)
  local namelist = table.concat(names, ", ")
  if not namelist then
    namelist = "no aliases found"
  end

  server.player_msg(cn, "names_command_message", {curname = current_name, namelist = namelist })
end

return {
        init = init,
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}
