local enabled = true
local permission = 1

local help = function()
end

local run = function(cn, command, arg, arg2, arg3)
--        if not commands.access(cn, admin_access) then return end
        if server.gamemode == "coop edit" or server.gamemode == "coop" then
                nm_messages.msg(cn, {cn}, maphack.label, "Disabled maphack module in red<coop edit> game mode", "orange", {"warn"})
                return
        end
        if command == nil then
                return false, "#maphack <CMD> [<ARG>]"
        else
               if arg == nil then
                        if command == "info" then
                                -- general states
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("red<==== GENERAL STATES =====>"), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.enabled = orange<%i>", maphack.enabled), "green", {"info" })
                                -- nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.check_interval = orange<%i>", maphack.check_interval), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.distance = orange<%i>", maphack.distance), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.above_dist = orange<%i>", maphack.above_dist), "green", {"info"})
                                -- recording
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("red<==== RECORDING STATES =====>"), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.recording = orange<%i>", maphack.recording), "green", {"info"})
                                -- nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.record_interval = orange<%i>", maphack.record_interval), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.testing = orange<%i>", maphack.testing), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.visualisation = orange<%i>", maphack.visualisation), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.undercover = orange<%i>", maphack.undercover), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.v(x, y, z)dist = (orange<%i>, orange<%i>, orange<%i>)", maphack.vxdist, maphack.vydist, maphack.vzdist), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.reverse = orange<%i>", maphack.reverse), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.carrots_max = orange<%i>", maphack.carrots_max), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.carrots_enttype = orange<%i>", maphack.carrots_enttype), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.carrots_entattr2 = orange<%i>", maphack.carrots_entattr2), "green", {"info"})
                                -- nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.load_carrots = orange<%i>", maphack.load_carrots), "green", {"info"})
                                -- current map states
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("red<==== CURRENT MAP INFO FOR %s =====>", server.map), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.profile_size = orange<%i>", maphack.profile_size), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.only_warnings = orange<%i>", maphack.only_warnings), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.silent = orange<%i>", maphack.silent), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.warnmalus = orange<%i>", maphack.warnmalus), "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("  maphack.banmalus = orange<%i>", maphack.banmalus), "green", {"info"})
                                local state = cheater.get_map_state(server.map, "maphack")
                                if state == 0 or state == 1 then
                                        nm_messages.msg(cn, {cn}, maphack.label, string.format("The recorded profile for this map is marked as red<new>. Mark it as only_warnings: orange<#maphack state only_warnings>"), "green", {"info"})
                                elseif state < cheater.map_states.recording.READY then
                                        nm_messages.msg(cn, {cn}, maphack.label, string.format("The recorded profile for this map is marked as yellow<only_warnings>. Mark it ready: orange<#maphack state ready>"), "green", {"info"})
                                else
                                        nm_messages.msg(cn, {cn}, maphack.label, string.format("The recorded profile for this map is marked as green<ready>."), "green", {"info"})
                                end
                        end
                        if command == "save" then
                            maphack.save_profile();
                        end
                        if command == "reset" then
                            maphack.clear_profile()
                                maphack.recording = 1
                                nm_messages.msg(cn, players.admins(), maphack.label, "Cleared maphack profile", "orange", {"warn"})
                                cheater.start_recording("maphack")
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.recording = " .. maphack.recording, "green", {"info"})
                        end
                        -- if command == "delete" then
                        --      if not commands.access(cn, masteradmin_access) then return end
                        --      maphack.delete_profile()
                        -- end
                        -- if command == "clear" then
                        --      if not commands.access(cn, masteradmin_access) then return end
                        --      maphack.clear_profile()
                        -- end
                        if command == "reset_malus" then
                                maphack.reset_malus()
                        end
                        if command == "reload" then
                                maphack.load_profile(true)
                        end
                        if command == "send_carrots" then
                                maphack.send_carrots()
                        end
                        if command == "clear_carrots" then
                                maphack.clear_carrots()
                        end
                        if command == "recording" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.recording = " .. maphack.recording, "green", {"info",  "irc", "log" })
                        end
                        if command == "testing" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.testing = " .. maphack.testing, "green", {"info"})
                        end
                        if command == "visualisation" or command == "visualization" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.visualisation = " .. maphack.visualisation, "green", {"info"})
                        end
                        if command == "enabled" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.enabled = " .. maphack.enabled, "green", {"info", "log" })
                        end
                        if command == "only_warnings" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.only_warnings = " .. maphack.only_warnings, "green", {"info"})
                        end
                        if command == "distance" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.distance = " .. maphack.distance, "green", {"info"})
                        end
                        if command == "interval" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.check_interval = " .. maphack.check_interval, "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.record_interval = " .. maphack.record_interval, "green", {"info"})
                        end
                        if command == "load_carrots" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.load_carrots = " .. maphack.load_carrots, "green", {"info"})
                        end
                        if command == "carrots_x" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.carrots_x = " .. maphack.carrots_x, "green", {"info"})
                        end
                        if command == "carrots_y" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.carrots_y = " .. maphack.carrots_y, "green", {"info"})
                        end
                        if command == "carrots_z" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.carrots_z = " .. maphack.carrots_z, "green", {"info"})
                        end
                        if command == "carrots_max" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.carrots_max = " .. maphack.carrots_max, "green", {"info"})
                        end
                        if command == "carrots_enttype" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.carrots_enttype = " .. maphack.carrots_enttype, "green", {"info"})
                        end
                        if command == "carrots_entattr2" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.carrots_entattr2 = " .. maphack.carrots_entattr2, "green", {"info"})
                        end
                        if command == "undercover" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.undercover = " .. maphack.undercover, "green", {"info",  "irc", "log" })
                        end
                        if command == "vxdist" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.vxdist = " .. maphack.vxdist, "green", {"info"})
                        end
                        if command == "vydist" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.vydist = " .. maphack.vydist, "green", {"info"})
                        end
                        if command == "vzdist" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.vzdist = " .. maphack.vzdist, "green", {"info"})
                        end
                        if command == "vdist" then
                                nm_messages.msg(cn, {cn}, maphack.label, string.format("maphack.v(x, y, z)dist = (%i, %i, %i)", maphack.vxdist, maphack.vydist, maphack.vzdist), "green", {"info"})
                        end
                        if command == "above_dist" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.above_dist = " .. maphack.above_dist, "green", {"info"})
                        end
                        if command == "reverse" then
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.reverse = " .. maphack.reverse, "green", {"info"})
                        end
                        if command == "points" then
                                if maphack.pointleader ~= nil then
                                        nm_messages.msg(cn, {cn}, maphack.label, string.format("The current point leader is name<%i> yellow<(%i positions)>", maphack.pointleader, maphack.points[maphack.pointleader]), "green", {"info"})
                                else
                                        nm_messages.msg(cn, {cn}, maphack.label, string.format("Currently no is the point leader"), "green", {"info"})
                                end
                                if maphack.points[cn] ~= nil then
                                        nm_messages.msg(cn, {cn}, maphack.label, string.format("You have recorded yellow<%i positions>", maphack.points[cn]), "green", {"info"})
                                else
                                        nm_messages.msg(cn, {cn}, maphack.label, "You have recorded yellow<no positions>", "green", {"info"})
                                end
                        end
                        if command == "state" then
                                local state = cheater.get_map_state(server.map, "maphack")
                                if state == 0 or state == 1 then
                                        nm_messages.msg(cn, {cn}, maphack.label, string.format("The recorded profile for this map is marked as red<new>. Mark it as only_warnings: orange<#maphack state only_warnings>"), "green", {"info","log"})
                                elseif state < cheater.map_states.recording.READY then
                                        nm_messages.msg(cn, {cn}, maphack.label, string.format("The recorded profile for this map is marked as yellow<only_warnings>. Mark it ready: orange<#maphack state ready>"), "green", {"info","log"})
                                else
                                        nm_messages.msg(cn, {cn}, maphack.label, string.format("The recorded profile for this map is marked as green<ready>."), "green", {"info","log"})
                                end
                        end
                else
                        if command == "recording" then
                                local recording_val = tonumber(arg)
                                if maphack.recording ~= recording_val then
                                        if maphack.recording == 0 then
                                                maphack.undercover = 0
                                                cheater.start_recording("maphack")
                                                nm_messages.msg(cn, players.all(), maphack.label, string.format("orange<Starting profiling %s on %s for maphack detection...>", server.gamemode, server.map), "green", {"info",  "irc", "log" })
                                        end
                                        if maphack.recording == 1 then
                                                nm_messages.msg(cn, players.all(), maphack.label, string.format("orange<Stopped profiling %s on %s for maphack detection...>", server.gamemode, server.map), "green", {"info",  "irc", "log" })
                                                cheater.stop_recording("maphack")
                                                maphack.clear_carrots()
                                                maphack.undercover = 1 -- automatically re-enable undercover
                                        end
                                else
                                        nm_messages.msg(cn, {cn}, maphack.label, "maphack.recording = " .. recording_val, "green", {"info", "log" })
                                end
                                maphack.recording = recording_val
                        end
                        if command == "testing" then
                                maphack.testing = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.testing = " .. maphack.testing, "green", {"info"})
                        end
                        if command == "visualisation" or command == "visualization" then
                                maphack.visualisation = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.visualisation = " .. maphack.visualisation, "green", {"info"})
                        end
                        if command == "enabled" then
                                maphack.enabled = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.enabled = " .. maphack.enabled, "green", {"info", "log" })
                        end
                        if command == "only_warnings" then
                                maphack.only_warnings = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.only_warnings = " .. maphack.only_warnings, "green", {"info"})
                        end
                        -- if command == "distance" then
                        --      maphack.distance = tonumber(arg)
                        --      nm_messages.msg(cn, {cn}, maphack.label, "maphack.distance = " .. maphack.distance, "green", {"info"})
                        -- end
                        if command == "load_carrots" then
                                maphack.load_carrots = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.load_carrots = " .. maphack.load_carrots, "green", {"info"})
                        end
                        if command == "carrots_x" then
                                maphack.carrots_x = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.carrots_x = " .. maphack.carrots_x, "green", {"info"})
                        end
                        if command == "carrots_y" then
                                maphack.carrots_y = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.carrots_y = " .. maphack.carrots_y, "green", {"info"})
                        end
                        if command == "carrots_z" then
                                maphack.carrots_z = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.carrots_z = " .. maphack.carrots_z, "green", {"info"})
                        end
                        if command == "carrots_max" then
                                maphack.carrots_max = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.carrots_max = " .. maphack.carrots_max, "green", {"info"})
                        end
                        if command == "carrots_enttype" then
                                maphack.carrots_enttype = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.carrots_enttype = " .. maphack.carrots_enttype, "green", {"info"})
                        end
                        if command == "carrots_entattr2" then
                                maphack.carrots_entattr2 = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.carrots_entattr2 = " .. maphack.carrots_entattr2, "green", {"info"})
                        end
                        if command == "vxdist" then
                                maphack.vxdist = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.vxdist = " .. maphack.vxdist, "green", {"info"})
                        end
                        if command == "vydist" then
                                maphack.vydist = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.vydist = " .. maphack.vydist, "green", {"info"})
                        end
                        if command == "vzdist" then
                                maphack.vzdist = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.vzdist = " .. maphack.vzdist, "green", {"info"})
                        end
                        if command == "vdist" then
                                if arg2 ~= nil and arg3 ~= nil then
                                        maphack.vxdist = tonumber(arg)
                                        maphack.vydist = tonumber(arg2)
                                        maphack.vzdist = tonumber(arg3)
                                        nm_messages.msg(cn, {cn}, maphack.label, "maphack.vxdist = " .. maphack.vxdist, "green", {"info"})
                                        nm_messages.msg(cn, {cn}, maphack.label, "maphack.vydist = " .. maphack.vydist, "green", {"info"})
                                        nm_messages.msg(cn, {cn}, maphack.label, "maphack.vzdist = " .. maphack.vzdist, "green", {"info"})
                                end
                        end
                        if command == "search" then
                                if arg == "normal" then
                                        maphack.vxdist = 2
                                        maphack.vydist = 2
                                        maphack.vzdist = 2
                                end
                                if arg == "floor" then
                                        maphack.vxdist = 10
                                        maphack.vydist = 10
                                        maphack.vzdist = 0
                                end
                                if arg == "x" then
                                        maphack.vxdist = 10
                                        maphack.vydist = 0
                                        maphack.vzdist = 3
                                end
                                if arg == "y" then
                                        maphack.vxdist = 0
                                        maphack.vydist = 10
                                        maphack.vzdist = 3
                                end
                                if arg == "z" then
                                        maphack.vxdist = 1
                                        maphack.vydist = 1
                                        maphack.vzdist = 5
                                end
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.vxdist = " .. maphack.vxdist, "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.vydist = " .. maphack.vydist, "green", {"info"})
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.vzdist = " .. maphack.vzdist, "green", {"info"})
                        end
                        if command == "above_dist" then
                                maphack.above_dist = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.above_dist = " .. maphack.above_dist, "green", {"info"})
                        end
                        if command == "reverse" then
                                maphack.reverse = tonumber(arg)
                                nm_messages.msg(cn, {cn}, maphack.label, "maphack.reverse = " .. maphack.reverse, "green", {"info"})
                        end
                        if command == "undercover" then
                                local new_value = tonumber(arg)
                                if new_value ~= nil then
                                        maphack.undercover = tonumber(arg)
                                        nm_messages.msg(cn, {cn}, maphack.label, "maphack.undercover = " .. maphack.undercover, "green", {"info", "log"})
                                end
                        end
                        if command == "state" then
                                if arg == "new" then
                                        cheater.set_map_state(server.map, "maphack", cheater.map_states.recording.NEW)
                                elseif arg == "only_warnings" then
                                        cheater.set_map_state(server.map, "maphack", cheater.map_states.recording.ONLY_WARNINGS)
                                elseif arg == "ready" then
                                        cheater.set_map_state(server.map, "maphack", cheater.map_states.recording.READY)
                                end
                                local state = cheater.get_map_state(server.map, "maphack")
                                if state == 0 or state == 1 then
                                        nm_messages.msg(-1, players.admins(), maphack.label, string.format("The recorded profile for this map is marked as red<new>. Mark it as only_warnings: orange<#maphack state only_warnings>"), "green", {"info","log"})
                                elseif state < cheater.map_states.recording.READY then
                                        nm_messages.msg(-1, players.admins(), maphack.label, string.format("The recorded profile for this map is marked as yellow<only_warnings>. Mark it ready: orange<#maphack state ready>"), "green", {"info","log"})
                                else
                                        nm_messages.msg(-1, players.admins(), maphack.label, string.format("The recorded profile for this map is marked as green<ready>."), "green", {"info","log"})
                                end
                        end
                        if command == "warnmalus" then
                                local malus = tonumber(arg)
                                if malus ~= nil then
                                        maphack.warnmalus = malus
                                        maphack.set_malus(maphack.warnmalus, maphack.banmalus)
                                        nm_messages.msg(cn, {cn}, maphack.label, string.format("maphack.warnmalus = %i", maphack.warnmalus), "green", {"info"})
                                end
                        end
                        if command == "banmalus" then
                                local malus = tonumber(arg)
                                if malus ~= nil then
                                        maphack.banmalus = malus
                                        maphack.set_malus(maphack.warnmalus, maphack.banmalus)
                                        nm_messages.msg(cn, {cn}, maphack.label, string.format("maphack.banmalus = %i", maphack.banmalus), "green", {"info"})
                                end
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

