local enabled = true
local permission = 3

local help = function(cn, command)

    server.player_msg(cn, green("#entity <info|type|pos|attrs|print|raw|raw_player|free|send_mapmodels>"))

end

local run
run = function (cn, command, arg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        if command == nil then
                help()
                return false
        else
                if arg == nil then
                        if command == "info" then
--                                messages.msg(cn, {cn}, "ENTITIES", string.format("number of slots = %i", #entities.slots), "green", {"info"})
                        end
                        if command == "register" then
                                local slot = entities.register()
--                                messages.msg(cn, {cn}, "ENTITIES", string.format("Registered slot %i", slot), "green", {"info"})
                        end
                else
                        if command == "type" then
                                local slot = tonumber(arg)
                                local type = entities.get_type(slot)
                                if arg2 ~= nil then
                                        entities.set_type(slot, tonumber(arg2))
                                        type = entities.get_type(slot)
                                end
--                                messages.msg(cn, {cn}, "ENTITIES", string.format("slot: %i -- type: %i", slot, type), "green", {"info"})
                        elseif command == "pos" then
                                local slot = tonumber(arg)
                                local pos = entities.get_pos(slot)
                                if arg2 ~= nil and arg3 ~= nil and arg4 ~= nil then
                                        entities.set_pos(slot, tonumber(arg2), tonumber(arg3), tonumber(arg4))
                                        pos = entities.get_pos(slot)
                                end
--                                messages.msg(cn, {cn}, "ENTITIES", string.format("slot: %i -- x: %i y: %i z: %i", slot, pos[1], pos[2], pos[3]), "green", {"info"})
                        elseif command == "attrs" then
                                local slot = tonumber(arg)
                                local attrs = entities.get_attrs(slot)
                                if arg2 ~= nil and arg3 ~= nil and arg4 ~= nil and arg5 ~= nil and arg6 ~= nil then
                                        entities.set_attrs(slot, tonumber(arg2), tonumber(arg3), tonumber(arg4), tonumber(arg5), tonumber(arg6))
                                        attrs = entities.get_attrs(slot)
                                end
--                                messages.msg(cn, {cn}, "ENTITIES", string.format("slot: %i -- attr1: %i attr2: %i attr3: %i attr4: %i attr5: %i", slot, attrs[1], attrs[2], attrs[3], attrs[4], attrs[5]), "green", {"info"})
                        elseif command == "print" then
                                local slot = tonumber(arg)
                                local type = entities.get_type(slot)
                                local pos = entities.get_pos(slot)
                                local attrs = entities.get_attrs(slot)
--                                messages.msg(cn, {cn}, "ENTITIES", string.format("slot: %i -- type: %i -- x: %i y: %i z: %i -- attr1: %i attr2: %i attr3: %i attr4: %i attr5: %i", slot, type, pos[1], pos[2], pos[3], attrs[1], attrs[2], attrs[3], attrs[4], attrs[5]), "green", {"info"})
                        elseif command == "raw" then
                                local slot = tonumber(arg)
                                entities.send_raw(slot, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
                        elseif command == "raw_player" then
                                local slot = tonumber(arg)
                                local cn = tonumber(arg2)
                                entities.player_send_raw(slot, cn, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)
                        elseif command == "free" then
                                local slot = tonumber(arg)
                                entities.free(slot)
                        elseif command == "send_by_type" then
                                entities.send_by_type(entities.types[arg])
                        elseif command == "send_mapmodels" then
                                local cn = tonumber(arg)
                                entities.player_send_by_type(cn, entities.types['mapmodel'])
                        end
                end
        end
end


return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
