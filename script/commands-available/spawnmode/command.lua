--[[

  
]]

local permission = 1
local enabled = true
local help ="<option> can be health,armour,armourtype,quadmillis,gunselect,enable,disable. <gunnum> number 0-9"
local usage = "<option> <value> | gun <gunnum> <numammo>"

local spawn_mode_state,spawn_mode_guns

local init = function()
  spawn_mode_state = {["health"] = 0, ["armour"] = 0, ["armourtype"] = 0, ["quadmillis"] = 0, ["gunselect"] = 0 }
  spawn_mode_guns  = {
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0,
    [6] = 0,
    [7] = 0,
    [8] = 0,
    [9] = 0,
    [10] = 0,
    [11] = 0
  }
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
  if not gun then
    spawn_mode_state[cmd] = val
    server.set_spawn_state(spawn_mode_state["health"], spawn_mode_state["armour"],spawn_mode_state["armourtype"],spawn_mode_state["quadmillis"],spawn_mode_state["gunselect"])
  else
    spawn_mode_guns[val] = gun
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
