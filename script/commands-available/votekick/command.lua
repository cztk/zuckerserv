--[[
  A player command to allow all players to vote to kick other players.
  Copyright (C) 2009 Thomas
]]

local permission = 0
local enabled = true
local votes = {"vk"}

local disconnect_evt,mapchange_evt


local help = function(cn, command)

    server.player_msg(cn, "allow all players to vote to kick other players")
    server.player_msg(cn, "#" .. command .. "<cn>|\"<name>\"")

end


local function check_kick(cn)
  local required_votes = round((server.playercount / 2), 0)
  if required_votes < server.votekick_min_votes_required then required_votes = server.votekick_min_votes_required end
  if votes[tostring(server.player_ip(cn))].votes >= required_votes then
    server.kick(cn, 3600, "server", "votekick by "..votes[tostring(server.player_ip(cn))].votes.." players")
    server.msg("votekick_passed", { name = server.player_displayname(cn) })
    votes[tostring(server.player_ip(cn))] = nil
  end
    return required_votes
end

local function check_player_on_disconnect(cn)
  local actor_id = tostring(cn)
  for p in server.gclients() do
    victim_id = tostring(p:ip())
    if votes[victim_id] then
      if votes[victim_id][actor_id] then
        votes[victim_id][actor_id] = nil
        votes[victim_id].votes = votes[victim_id].votes - 1
      end
      check_kick(p.cn)
    end
  end
end

local function init()
  votes = {}
  disconnect_evt = server.event_handler("disconnect", check_player_on_disconnect(cn))
  mapchange_evt = server.event_handler("mapchange", function() votes = {} end)
end

local function unload()
  votes = nil
  disconnect_evt()
  mapchange_evt()
end

local function run(cn,victim)
  if server.playercount < server.votekick_min_votes_required+1 then
    return false, "There aren't enough players here for votekick to work"
  elseif victim and not server.valid_cn(victim) then
    victim = server.name_to_cn_list_matches(cn,victim)
  elseif not victim then
    help()
    return false
  end
  
  local actor_id = tostring(cn)
  
  if victim == actor_id then
    return false, "You can't vote to kick yourself"
  elseif server.player_priv_code(victim) == server.PRIV_ADMIN then
    return false, "You can't vote to kick a server admin!"
  end
  
  victim_id = tostring(server.player_ip(victim))

  if not votes[victim_id] then
    votes[victim_id] = {}
    for p in server.gclients() do
      votes[victim_id][tostring(p.cn)] = "no"
    end
  elseif votes[victim_id][actor_id] == "yes" then
    return false, "You have already voted for this player to be kicked"
  elseif votes[victim_id][actor_id] ~= "no" then
    return false, "You connected after the votekick starts, so you can't vote"
  end

  votes[victim_id][actor_id] = "yes"
  
  if not votes[victim_id].votes then
    votes[victim_id].votes = 0
  end
  
  votes[victim_id].votes = votes[victim_id].votes + 1

  local required_votes = check_kick(victim)

  for p in server.gplayers() do
    if server.player_priv_code(victim) ~= server.PRIV_MASTER or not p.cn == victim then
      p:msg("votekick_vote", {actor = server.player_displayname(cn), victim = server.player_displayname(victim), nb = votes[victim_id].votes, total = required_votes} )
    end
  end
end

return {
        init = init,
        run = run,
        unload = unload,
        permission = permission,
        enabled = enabled,
        help_function = help
}
