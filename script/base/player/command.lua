player_commands = {}

--[[
    The table structure for a player command:
    {
        init = function,
        run = function,
        unload = function,
        permission = number,
        enabled = boolean,
        help_function = function
        aliases = array
    }
]]

local function merge_player_command(name, command)
    
    assert(type(name) == "string")
    assert(type(command) == "table")
    
    local existing_command = player_commands[name] or {}
    
    if existing_command.enabled then
        if command.enabled == false and existing_command.unload then
            existing_command.unload()
        end
    else
        if command.enabled and existing_command.init then
            existing_command.init()
        elseif command.enabled and command.init then
            command.init()
        end
    end
    
    for key, value in pairs(command) do
       existing_command[key] = value 
    end
    
    player_commands[name] = existing_command
    if command.aliases then
        for _, alias in ipairs(command.aliases) do
            player_commands[alias] = existing_command
        end
    end
end

local function load_player_command_script(filename, name)
    
    local command = {}
    command.permission = server.PRIV_NONE
    
    local chunk, error_message = loadfile(filename)
    
    if not chunk then
        server.log_error(string.format("Error in player command script '%s': %s", filename, error_message))
        return
    end
    
    local chunk_return, help_function, aliases = chunk()
    local chunk_return_type = type(chunk_return)
    
    if chunk_return_type == "function" then
    
        command.run = chunk_return
        
        command.help_function = help_function
        command.aliases = aliases
        command.permission = permission
        command.enabled = enabled
        
    elseif chunk_return_type == "table" then
    
        command.init = chunk_return.init
        command.run = chunk_return.run
        command.unload = chunk_return.unload
        command.enabled = chunk_return.enabled        
        command.help_function = chunk_return.help_function
        command.aliases = chunk_return.aliases
        command.permission = chunk_return.permission
        
    else
        server.log_error(string.format("Expected player command script '%s' to return a function or table value", filename))
        return
    end

    command.permission = cmd_perm_overwrites[name] or command.permission
    
    if command.init then
        command.init(name)
    end
    server.log(string.format("Loaded command '%s' with priv: %s", name, command.permission))
    
    merge_player_command(name, command)
end

local function load_player_command_script_directories()
  local dir_filename = "script/commands-enabled"

  local filesystem = require "filesystem"

  for file_type, filename in filesystem.dir(dir_filename) do
   if filename ~= "." and filename ~= ".." then
    local cmdfname = find_script(dir_filename .. "/" ..filename .. "/command.lua")
    if cmdfname then
      local command_name = filename
      filename = dir_filename .. "/" .. filename .. "/command.lua"
      load_player_command_script(filename, command_name)
    end
   end
  end
end
--load_player_command_script_directories()

local function is_command_prefix(text)
    local first_char = string.sub(text, 1, 1)
    return first_char == "#" or first_char == "!" or first_char == "@"
end

local function send_command_error(cn, error_message)
  
    local output_message = server.command_error_message
    local err = error_message or " unknown error"
    
    server.player_msg(cn, {"command_error_message", err})
end

local function exec_command(cn, text, force)
    if not force and not is_command_prefix(text) then
        return
    end
    
    if is_command_prefix(text) then
        text = string.sub(text, 2)
    end

    local arguments = {}
    local quotecount = 0
    for token in string.gmatch(text, '[^"]+') do
           if quotecount % 2 == 0 then
               for word in string.gmatch(token, '[^%s]+') do
                   table.insert(arguments, word)
               end
           else
               table.insert(arguments, token)
           end
           quotecount = quotecount + 1
    end

    
    if not arguments then
        server.player_msg(cn, "command_syntax_error", {err = error_message})
        return -1
    end
    
    local command_name = arguments[1]
    
    local command = player_commands[command_name]
    
    if not command then
        server.player_msg(cn, "command_not_found_message")
        return -1
    end
    
    arguments[1] = cn
    
    if not (command.enabled == true) or not command.run then
        server.player_msg(cn, "command_disabled")
        return -1
    end
    
    local privilege = server.player_priv_code(cn)
    
    if privilege < command.permission then
        server.player_msg(cn, "command_permission_denied")
        return -1
    end
    
    local pcall_status, success, error_message = pcall(command.run, unpack(arguments))
    
    if pcall_status == false then
        local message = success  -- success value is the error message returned by pcall
        server.log_error(string.format("The #%s player command failed with error: %s", command_name, message[1]))
        server.player_msg(cn, "command_internal_error")
    end
    
    if success == false then
        send_command_error(cn, error_message)
    end
    
    return -1
end

server.event_handler("text", function(cn, text)
    return exec_command(cn, text, false)
end)

server.event_handler("servcmd", function(cn, text)
    exec_command(cn, text, true)
end)

function player_command_function(name, func, permission)
    merge_player_command(name, {run = func, permission = permission or 0})
end



local function merge_command_list(command_list, options)
    for _, command_name in pairs(command_list) do
        merge_player_command(command_name, options)
    end
end

function server.enable_commands(command_list)
    merge_command_list(command_list, {enabled = true})
end

function server.disable_commands(command_list)
    merge_command_list(command_list, {enabled = false})
end

function server.admin_commands(command_list)
    merge_command_list(command_list, {permission = server.PRIV_ADMIN})
end

function server.master_commands(command_list)
    merge_command_list(command_list, {permission = server.PRIV_MASTER})
end

function is_player_command_enabled(command_name)
    local command = player_commands[command_name]
    return command and command.enabled and command.run
end

server.event_handler("all-module-loaded", function()
  load_player_command_script_directories()
end)

server.event_handler("started", function()
    
    function log_unknown_player_commands()
        for name, command in pairs(player_commands) do
            if not command.run then
                server.log_error(string.format("No function loaded for player command '%s'", name))
            end
        end
    end
    
    log_unknown_player_commands()
end)
