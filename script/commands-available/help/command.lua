--[[
	A player command to list commands and show help
]]

local permission = 0
--server.priv_NONE
local enabled = true

local help = function(cn, command_name)

    server.player_msg(cn, server.help_description .. " " .. server.help_parameters);

end

local run = function(cn, command_name)
  local privilege = server.player_priv_code(cn)

  if command_name then
    local command = player_commands[command_name]

    if not command then
      return false, server.help_unknown_command_message
    elseif not is_player_command_enabled(command_name) then
      return false, server.help_command_disabled_message
    elseif privilege < command.permission then
      return false, server.help_access_denied_message
    elseif not command.help_function then
      return false, server.help_no_description_message % { command_name = command_name }
    end
    
    server.player_msg(cn, "help_command", { command_name = command_name })
    if command.help_function and type(command.help_function) == "function" then
        command.help_function(cn, command_name)
    end

    return
  end

  local commands_per_privilege = {}
  for name, command in pairs(player_commands) do
    if is_player_command_enabled(name) then
      if not commands_per_privilege[command.permission + 1] then
        commands_per_privilege[command.permission + 1] = { name }
      else
        table.insert(commands_per_privilege[command.permission + 1], name)
      end
    end
  end

  local privilege_colours = {}
  privilege_colours[server.PRIV_NONE] = "%{blue}"
  privilege_colours[server.PRIV_MASTER] = "%{green}"
  privilege_colours[server.PRIV_ADMIN] = "%{orange}"

  local list_of_command_names = {}
  for permission, commands in pairs(commands_per_privilege) do
    permission = permission - 1
    if privilege >= permission then
      table.insert(list_of_command_names, privilege_colours[permission] .. table.concat(commands, ", "))
    end
  end

  server.player_msg(cn, "help")

  for i,v in ipairs(list_of_command_names) do
    server.player_msg(cn, v)
  end
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help,
}
