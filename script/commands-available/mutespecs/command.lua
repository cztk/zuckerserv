local permission = 1
local enabled = true
local help ="mute spectators"
local usage =""

local init = function()
    if(true == enabled and not server.mute_spectators) then
        server.log(string.format("WARN: command #mutespecs is enabled but mute_spectators module not loaded!"))
        enabled = false
    end
end


local run = function(cn)
    
    if false == enabled then
        return false, server.missing_mute_spectator_module_message
    end
    
    server.mute_spectators(true)
    server.player_msg(cn, server.all_spectator_muted_message)
end

return {
        init = init,
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
