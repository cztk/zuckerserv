local usage = "#rugby -1=off | 0=migration mode | 1 = on"

return function(cn, status)

  if not status then
    server.player_msg(cn, "rugby_enabled is " .. server.rugby_enabled .. ", rugby_mode is " .. server.rugby_mode .. " " .. usage)
    return
  end

  if status == "-1" then
      server.rugby_enabled = 0
      server.rugby_mode = -1
      server.msg(string.format(blue(" %s ") .. red("disabled rugby mode!"), server.player_displayname(cn) ))
  end
  if status == "0" then
      server.rugby_enabled = 1
      server.rugby_mode = 0
      server.msg(string.format(blue(" %s ") .. red("enabled rugby - migration/training/withdrawal/weaning mode!"), server.player_displayname(cn) ))
  end
  if status == "1" then
      server.rugby_enabled = 1
      server.rugby_mode = 1
      server.msg(string.format(blue(" %s ") .. red("enabled rugby mode!"), server.player_displayname(cn) ))
  end

end

