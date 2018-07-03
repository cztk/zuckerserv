--[[

  A player command to lower time when mapsucks ratio is reached
  By piernov <piernov@piernov.org>

  May 25 2013 (gear4): shortened one-line "if"'s, localised and shortened local statements, optimised (?) matches for "sucks" etc., 

]]

local help = "lower time when mapsucks ratio is reached"
local usage =""
local permission = 0
local enabled = true

local init = function()
    if(true == enabled and not server.mapsucks_vote) then
        server.log(string.format("WARN: command #mapsucks is enabled but mapsucks_vote module not loaded!"))
--        enabled = false
    end
end

local run = function(cn)
  if false == enabled then
    return false, "Mapsucks module not loaded"
  elseif server.player_status_code(cn) ~= server.SPECTATOR then
    server.mapsucks_vote(cn)
  else
    server.player_msg(cn, "mapbattle_cant_vote")
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
