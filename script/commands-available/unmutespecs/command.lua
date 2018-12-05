

local permission = 1
local enabled = true

local help = function(cn, command)

    server.player_msg(cn, "unmute spectators")

end

local init = function()
    if(true == enabled and not server.mute_spectators) then
        server.log(string.format("WARN: command #unmutespecs is enabled but mute_spectators module not loaded!"))
        enabled = false
    end
end


local run = function(cn)
    
    if false == enabled then
        return false, server.missing_mute_spectator_module_message
    end
    
    server.mute_spectators()
    server.player_msg(cn, server.all_spectator_unmuted_message)
end

return {
        init = init,
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
