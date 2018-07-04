local MODULE_VARFILES_DIR = "./script/module/config"
local modules_avail_dir = "./script/modules-available"
local modules_enabled_dir = "./script/modules-enabled"

local signal_loaded = server.create_event_signal("module-loaded")
local signal_unloaded = server.create_event_signal("module-unloaded")

local all_signal_loaded = server.create_event_signal("all-module-loaded")
local all_signal_unloaded = server.create_event_signal("all-module-unloaded")


local started = false
local modules = {}
local loaded_modules = {}
local loaded_scripts = {}
local temporary_modules = {}

local function execute_module_script(filename, environment)
    
    local chunk, error_message = loadfile(filename)
    if not chunk then
        server.log_error(string.format("Error while executing '%s': %s", filename, error_message))
        return false, error_message
    end
    
    setfenv(chunk, environment)
    
    return (function(...) return unpack({...}) end)(pcall(chunk))
end

function server.unload(name)
    
    local control = loaded_modules[name]
    if not control then
        error(string.format("module '%s' not loaded", name))
    end
    
    if control.unload then
        control.unload()
    end
    
    control.cleanup_environment()
    
    loaded_modules[name] = nil
    loaded_scripts[control.filename] = nil
    
    collectgarbage()
    
    signal_unloaded(name, control.filename)
    server.log_status("Unloaded module " .. name)
end

local function unload_all_modules()
    for name in pairs(loaded_modules) do 
        local success, error_message = pcall(server.unload, name)
        if not success then
            if type(error_message) == "table" and type(error_message[1]) == "string" then
                error_message = error_message[1]
            end
            server.log_error(string.format("Error while unloading module '%s': %s", name, error_message))
        end
    end
    all_signal_unloaded()
end

local function create_module_environment()
    
    local environment = {server = {}}
    
    local event_handlers = {}
    local event_unload_handlers = {}
    local event_signals = {}
    local timers = {}
    
    environment.server.event_handler = function(name, handler)
        
        if name == "unload" or name == "shutdown" then
            event_unload_handlers[#event_unload_handlers + 1] = handler
            local connection_id = #event_unload_handlers
            return function()
                event_unload_handlers[connection_id] = nil
            end
        end
        
        local handlerId = server.event_handler(name, handler)
        event_handlers[#event_handlers + 1] = handlerId
        return handlerId
    end
    
    environment.server.create_event_signal = function(name)
        local trigger, signalId = server.create_event_signal(name)
        event_signals[#event_signals + 1] = signalId
        return trigger, signalId
    end
    
    local function add_timer(timer_function, countdown, handler)
        local handler_id = timer_function(countdown, handler)
        timers[#timers + 1] = handler_id
        return handler_id
    end
    
    environment.server.sleep = function(countdown, handler)
        return add_timer(server.sleep, countdown, handler)
    end
    
    environment.server.interval = function(countdown, handler)
        return add_timer(server.interval, countdown, handler)
    end
    
    local function cleanup()
        
        for _, unload_handler in pairs(event_unload_handlers) do
            unload_handler()
        end
        
        for _, handler_id in ipairs(event_handlers) do
            server.cancel_handler(handler_id)
        end
        
        for _, handler_id in ipairs(event_signals) do
            server.cancel_event_signal(handler_id)
        end
        
        for _, handler_id in ipairs(timers) do
            server.cancel_timer(handler_id)
        end
    end
    
    setmetatable(environment.server, {__index = _G.server, __newindex = _G.server})
    setmetatable(environment, {__index = _G, __newindex = _G})
    
    return environment, cleanup
end

local function load_module(name)
    
    local event_handlers = {}
    local event_signals = {}
    local timers = {}
    local event_unload_handlers = {}
    

    local globfname = find_script(modules_avail_dir .. "/" .. name .. "/globals.lua")
    if globfname then
      exec(modules_avail_dir .. "/" .. name .. "/globals.lua")
    end


    local filename = find_script(modules_avail_dir .. "/" .. name .. "/init.lua")
    if not filename then
        filename = find_script(name)
        if not filename then
            error(string.format("module '%s' not found. tried %s", name, filename))
        end
    end
    
    if loaded_scripts[filename] then
        server.log_status(name .. " module is already a loaded script")
        return
    end
    
    local environment, cleanup_environment = create_module_environment()
    
    local success, control = execute_module_script(filename, environment)
    
    if not success then
        server.log_status("error while loading module " .. name)
        cleanup_environment()
        server.log_error(control)
        return
    end
    
    control = control or {}
    control.name = name
    control.filename = filename
    control.environment = environment
    control.cleanup_environment = cleanup_environment
    
    loaded_scripts[filename] = true
    loaded_modules[name] = control
    
    signal_loaded(name, filename)
    
--    if server.uptime > 0 then
        server.log("Loaded module " .. name)
--    end
end

local function load_modules_enabled_dir()
  local filesystem = require "filesystem"
  for file_type, filename in filesystem.dir(modules_enabled_dir) do
    if filename ~= "." and filename ~= ".." then
      server.log_status("found modules-enabled/ " .. filename)
      server.module(filename)
    end
  end
end

local function load_modules_now()
    load_modules_enabled_dir()

    for _, name in ipairs(modules) do
        load_module(name)
    end
    all_signal_loaded()

    modules = {}
    started = true
end

function server.module(name)
    
    if started == true then
        load_module(name)
    else
        table.insert(modules, name)
    end
end

function server.load_temporary_module(name)
    
    server.module(name)
    
    if loaded_modules[name] then
        temporary_modules[#temporary_modules + 1] = name
    end
end

server.event_handler("mapchange", function()
    
    for _, name in ipairs(temporary_modules) do
        server.unload(name)
    end
    
    temporary_modules = {}
end)

server.event_handler("started", load_modules_now)
server.event_handler("shutdown", unload_all_modules)

-- Load module configuration variables
exec("./script/base/to_be_split_globals.lua")
