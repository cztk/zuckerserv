--[[

  
]]

local permission = 1
local enabled = true
local help = red("enable first with: ") .. blue("#spawnmode ") .. green("enable\n") .. blue("#spawnmode ") .. white("also takes: \n") .. green("health <number> ") .. green("\narmour <number>\narmourtype <number[0..2]>\nquadmillis <number>\ngunselect <gunNumber[0..9]>") .. blue(" -- first selected gun") .. green("\ngun <gunnumber[0..9]> <numberAmmo>") .. white(" ( see #guns )\n") .. green("clear\nload <templatename>\nsave <templatename>\nenable,disable")
local usage = "<option> [<value>] | gun <gunnum[0..9]> <ammo>\n"

local spawn_mode_state,spawn_mode_guns

local init = function()
  spawn_mode_state = {["health"] = 0, ["armour"] = 0, ["armourtype"] = 0, ["quadmillis"] = 0, ["gunselect"] = 0 }
  spawn_mode_guns  = {
    ["0"] = 0,
    ["1"] = 0,
    ["2"] = 0,
    ["3"] = 0,
    ["4"] = 0,
    ["5"] = 0,
    ["6"] = 0,
    ["7"] = 0,
    ["8"] = 0,
    ["9"] = 0,
    ["10"] = 0,
    ["11"] = 0
  }
end

local load_preset = function(name)
  state = find_script("script/commands-enabled/spawnmode/presets/" .. name .. ".state")
  guns = find_script("script/commands-enabled/spawnmode/presets/" .. name .. ".guns")
  if state and guns then
    spawn_mode_state,err1 = table.load( "script/commands-enabled/spawnmode/presets/" .. name .. ".state" )
    spawn_mode_guns,err2  = table.load( "script/commands-enabled/spawnmode/presets/" .. name .. ".guns" )
    server.set_spawn_state(spawn_mode_state["health"], spawn_mode_state["armour"],spawn_mode_state["armourtype"],spawn_mode_state["quadmillis"],spawn_mode_state["gunselect"])
    for k,v in pairs(spawn_mode_guns) do
      server.set_spawn_gun(k, v)
    end
    server.msg("loaded " .. name .. " spawnmode preset")
  else
    server.player_msg(cn, red("preset not found"))
  end
end

local save_preset = function(cn, name)
  state = find_script("script/commands-enabled/spawnmode/presets/" .. name .. ".state")
  guns = find_script("script/commands-enabled/spawnmode/presets/" .. name .. ".guns")
  if not state and not guns then
    table.save( spawn_mode_state, "script/commands-enabled/spawnmode/presets/" .. name .. ".state" )
    table.save( spawn_mode_guns, "script/commands-enabled/spawnmode/presets/" .. name .. ".guns" )
    server.player_msg(cn, green("preset saved"))
  else
    server.player_msg(cn, red("you can't overwrite existing presets"))
  end
end


local run = function(cn,cmd,val,gun)
  if false == enabled then
    return false, "command disabled"
  end
  if cmd == "enable" then
    server.spawn_mode = 1
    return
  end
  if cmd == "disable" then
    server.spawn_mode = 0
    return
  end
  if cmd == "load" then
    load_preset(val)
    return
  end
  if cmd == "save" then
    save_preset(cn,val)
    return
  end
  if cmd =="clear" then
    init()
  end
  if not gun then
    spawn_mode_state[cmd] = val
    server.set_spawn_state(spawn_mode_state["health"], spawn_mode_state["armour"],spawn_mode_state["armourtype"],spawn_mode_state["quadmillis"],spawn_mode_state["gunselect"])
  else
    spawn_mode_guns[val..""] = gun
    server.set_spawn_gun(val, gun)
  end
end

return {
        init = init,
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
