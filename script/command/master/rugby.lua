local usage = "#rugby -1=off | 0=migration mode | 1 = on | 2 = +1 flagscore for helper | 3 numlist = limit passing weapons, numlist = 04 for chainsaw+rifle | 4 = as 3 but +1 flagscore for helper "

return function(cn, status, wlist)

  if not status then
    server.player_msg(cn, "rugby_enabled is " .. server.rugby_enabled .. ", rugby_mode is " .. server.rugby_mode .. " " .. usage)
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

