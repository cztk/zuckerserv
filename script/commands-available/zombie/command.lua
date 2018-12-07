local permission = 1
local enabled = true
local help = function()

end


local run = function(cn, command, arg)
        if command == "start" then
                nm_zombie.init()
        elseif command == "stop" then
                nm_zombie.destroy()
        elseif command == "create" then
                nm_zombie.create_zombie()
        elseif command == "upp" then
                nm_zombie.update_pos()
        elseif command == "upa" then
                nm_zombie.update_action()
        elseif command == "info" then
--[[
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.enabled = %i", nm_zombie.enabled), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.debug = %i", nm_zombie.debug), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.max_number_of_zombies = %i", nm_zombie.max_number_of_zombies), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.max_number_of_zombies = %i", nm_zombie.max_number_of_zombies), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.initial_number_of_zombies = %i", nm_zombie.initial_number_of_zombies), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.regenerate_rate = %i", nm_zombie.regenerate_rate), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.bite_regeneration = %i", nm_zombie.bite_regeneration), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.bite_dist = %i", nm_zombie.bite_dist), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.need_regeneration_min_health = %i", nm_zombie.need_regeneration_min_health), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.regenerated_min_health = %i", nm_zombie.regenerated_min_health), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.max_health = %i", nm_zombie.max_health), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.search_min_dist = %i", nm_zombie.search_min_dist), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.search_max_vlen = %.3f", nm_zombie.search_max_vlen), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.search_acceleration = %.3f", nm_zombie.search_acceleration), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.search_max_velocity_length_dividor = %i", nm_zombie.search_max_velocity_length_dividor), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.search_max_falling_vcubes = %i", nm_zombie.search_max_falling_vcubes), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.attack_acceleration = %.3f", nm_zombie.attack_acceleration), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.max_attack_iterations = %i", nm_zombie.max_attack_iterations), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.path_change = %i", nm_zombie.path_change), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.min_velocity = %.3f", nm_zombie.min_velocity), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.max_velocity = %.3f", nm_zombie.max_velocity), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.init_velocity = %i", nm_zombie.init_velocity), "green", {"info"})
                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.max_not_moved_iterations = %i", nm_zombie.max_not_moved_iterations), "green", {"info"})
--]]
        elseif command == "enabled" then
                nm_zombie.enabled = tonumber(arg)
                server.player_msg(green("nm_zombie.enabled = " .. nm_zombie.enabled))
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.enabled = %i", nm_zombie.enabled), "green", {"info"})
        elseif command == "debug" then
                nm_zombie.debug = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.debug = %i", nm_zombie.debug), "green", {"info"})
        elseif command == "max_number_of_zombies" then
                nm_zombie.max_number_of_zombies = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.max_number_of_zombies = %i", nm_zombie.max_number_of_zombies), "green", {"info"})
        elseif command == "initial_number_of_zombies" then
                nm_zombie.initial_number_of_zombies = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.initial_number_of_zombies = %i", nm_zombie.initial_number_of_zombies), "green", {"info"})
        elseif command == "regenerate_rate" then
                nm_zombie.regenerate_rate = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.regenerate_rate = %i", nm_zombie.regenerate_rate), "green", {"info"})
        elseif command == "bite_regeneration" then
                nm_zombie.bite_regeneration = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.bite_regeneration = %i", nm_zombie.bite_regeneration), "green", {"info"})
        elseif command == "bite_dist" then
                nm_zombie.bite_dist = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.bite_dist = %i", nm_zombie.bite_dist), "green", {"info"})
        elseif command == "need_regeneration_min_health" then
                nm_zombie.need_regeneration_min_health = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.need_regeneration_min_health = %i", nm_zombie.need_regeneration_min_health), "green", {"info"})
        elseif command == "regenerated_min_health" then
                nm_zombie.regenerated_min_health = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.regenerated_min_health = %i", nm_zombie.regenerated_min_health), "green", {"info"})
        elseif command == "max_health" then
                nm_zombie.max_health = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.max_health = %i", nm_zombie.max_health), "green", {"info"})
        elseif command == "search_min_dist" then
                nm_zombie.search_min_dist = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.search_min_dist = %i", nm_zombie.search_min_dist), "green", {"info"})
        elseif command == "search_max_vlen" then
                nm_zombie.search_max_vlen = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.search_max_vlen = %.3f", nm_zombie.search_max_vlen), "green", {"info"})
        elseif command == "search_acceleration" then
                nm_zombie.search_acceleration = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.search_acceleration = %.3f", nm_zombie.search_acceleration), "green", {"info"})
        elseif command == "search_max_velocity_length_dividor" then
                nm_zombie.search_max_velocity_length_dividor = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.search_max_velocity_length_dividor = %i", nm_zombie.search_max_velocity_length_dividor), "green", {"info"})
        elseif command == "search_max_falling_vcubes" then
                nm_zombie.search_max_falling_vcubes = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.search_max_falling_vcubes = %i", nm_zombie.search_max_falling_vcubes), "green", {"info"})
        elseif command == "attack_acceleration" then
                nm_zombie.attack_acceleration = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.attack_acceleration = %.3f", nm_zombie.attack_acceleration), "green", {"info"})
        elseif command == "max_attack_iterations" then
                nm_zombie.max_attack_iterations = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.max_attack_iterations = %i", nm_zombie.max_attack_iterations), "green", {"info"})
        elseif command == "path_change" then
                nm_zombie.path_change = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.path_change = %i", nm_zombie.path_change), "green", {"info"})
        elseif command == "min_velocity" then
                nm_zombie.min_velocity = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.min_velocity = %.3f", nm_zombie.min_velocity), "green", {"info"})
        elseif command == "max_velocity" then
                nm_zombie.max_velocity = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.max_velocity = %.3f", nm_zombie.max_velocity), "green", {"info"})
        elseif command == "init_velocity" then
                nm_zombie.init_velocity = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.init_velocity = %i", nm_zombie.init_velocity), "green", {"info"})
        elseif command == "max_not_moved_iterations" then
                nm_zombie.max_not_moved_iterations = tonumber(arg)
--                messages.msg(cn, {cn}, nm_zombie.label, string.format("nm_zombie.max_not_moved_iterations = %i", nm_zombie.max_not_moved_iterations), "green", {"info"})
        end
end


return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
