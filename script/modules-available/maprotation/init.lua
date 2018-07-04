if server.use_server_map_rotation == 0 then
    return
end

dofile("script/modules-enabled/maprotation/supported_maps.lua")
dofile("script/modules-enabled/maprotation/core.lua")

local implementations = {
    standard = "script/modules-enabled/maprotation/implementation/standard.lua",
    random   = "script/modules-enabled/maprotation/implementation/random.lua",
    size     = "script/modules-enabled/maprotation/implementation/size.lua"
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

