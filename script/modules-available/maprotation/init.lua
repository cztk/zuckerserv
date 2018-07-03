if server.use_server_map_rotation == 0 then
    return
end

dofile("script/modules-available/maprotation/supported_maps.lua")
dofile("script/modules-available/maprotation/core.lua")

local implementations = {
    standard = "script/modules-available/maprotation/implementation/standard.lua",
    random   = "script/modules-available/maprotation/implementation/random.lua",
    size     = "script/modules-available/maprotation/implementation/size.lua"
}

local implementation_script = implementations[server.map_rotation_type]

if not implementation_script then
    server.log_error("Unknown value set for map_rotation_type")
    return
end

map_rotation.set_implementation(dofile(implementation_script))
map_rotation.reload()

server.event_handler("started", function()
    server.reload_maprotation()

    server.log_status(messages[messages.languages.default].server_start_message)
end)

