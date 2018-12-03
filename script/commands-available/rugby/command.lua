local help = "enabled rugby mode.\n modes:\n -1=off\n 0=no pass and no damage\n 1 = rugby with all weapons\n 2 = same as mode 1 but +1 flagscore.\n mode 3 and 4 are same as 1 and 2, but allow a list of allowed weapons\n#rugby 4 04 => allows chainsaw=0 and rifle=4 passing"
local usage = "<mode> [<weaponlist>]"
local enabled = true
local permission = 0
local real_permission = 1

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
        help_message = help,
        help_parameters = usage
}
