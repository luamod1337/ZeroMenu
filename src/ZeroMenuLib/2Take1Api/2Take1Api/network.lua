network = {}
network.__index = network

function network:network_is_host()end
function network:has_control_of_entity(entity)end
function network:request_control_of_entity(entity)end
function network:is_session_started()end
function network:network_session_kick_player(player)end
function network:is_friend_online(name)end
function network:is_friend_in_multiplayer(name)end
function network:get_friend_scid(name)end
function network:get_friend_count()end
function network:get_max_friends()end
function network:network_hash_from_player(player)end
function network:get_friend_index_name(invaluedex)end
function network:is_friend_index_online(invaluedex)end
function network:is_scid_friend(scid)end
function network:get_entity_player_is_spectating(player)end
function network:get_player_player_is_spectating(player)end
function network:send_chat_message(msg,teamOnly)end
function network:force_remove_player(player)end
