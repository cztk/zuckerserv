local enabled = true
local permission = 0
local real_permission = 1

local help = function(cn, command)

    server.player_msg(cn, "<mode> [<weaponlist>]")
    server.player_msg(cn, green("#" .. command .. " -1 ") .. red("disable rugby"))
    server.player_msg(cn, green("#" .. command .. " 0 ") .. blue("no pass but no damage aswell, aka training mode"))
    server.player_msg(cn, green("#" .. command .. " 1 ") .. blue("enables rugby"))
    server.player_msg(cn, green("#" .. command .. " 1 ") .. blue("enables rugby and credits +1 flagscore to carriers"))
    server.player_msg(cn, green("#" .. command .. " 3 ") .. blue("enables rugby with extended list of weapons, see #guns for a cheat sheet"))
    server.player_msg(cn, green("#" .. command .. " 4 ") .. blue("same as 3 and credits +1 flagscore to carriers"))
    server.player_msg(cn, green("#" .. command .. " 4 04 ") .. blue("allows chainsaw(0) and rifle(4) passing"))
    server.player_msg(cn, red(">>> ") .. orange("press") .. white(" F11") .. orange(" to expand"))

end

local run = function(cn, status, wlist)

  if not status or real_permission > server.player_priv_code(cn) then
      local guns = ""
      for index,value in pairs(rugby_weapons) do
        if 1 == value then
          guns = guns .. " " .. weapons_types[index]
        end
      end

      if rugby_cmd_msgs[server.rugby_mode] then
        server.player_msg(cn, rugby_cmd_msgs[server.rugby_mode], { name = "Server", weapons = guns } )
      end
    return
  end

  local guns = ""

  if wlist then
    for index,value in pairs(rugby_weapons) do
         rugby_weapons[index] = 0
    end

    wlist:gsub(".", function(c)
      local i = tonumber(c)
      if rugby_weapons[i] then
        rugby_weapons[i] = 1
      end
    end
    )
  end

  for index,value in pairs(rugby_weapons) do
    if 1 == value then
        guns = guns .. " " .. weapons_types[index]
    end
  end

  if status <= "-1" then
      server.rugby_enabled = 0
      server.rugby_mode = -1
  end
  if status >= "0" then
      server.rugby_enabled = 1
      server.rugby_mode = 0
  end
  if status >= "1" then
      server.rugby_mode = status
  end

  if rugby_cmd_msgs[server.rugby_mode] then
    server.msg(rugby_cmd_msgs[server.rugby_mode], { name = server.player_displayname(cn), weapons = guns } )
  end

end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
