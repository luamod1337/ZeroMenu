player = {}
player.__index = player

function player:get_player_ped(player)end
function player:player_id()end
function player:set_player_model(hash)end
function player:get_player_group(player)end
function player:is_player_female(player)end
function player:is_player_friend(player)end
function player:is_player_playing(player)end
function player:is_player_free_aiming(player)end
function player:get_entity_player_is_aiming_at(player)end
function player:get_personal_vehicle()end
function player:set_player_visible_locally(player,toggle)end
function player:set_local_player_visible_locally(toggle)end
function player:set_player_as_modder(player,flags)end
function player:get_player_name(player)end
function player:get_player_scid(player)end
function player:is_player_pressing_horn(player)end
function player:get_player_ip(player)end
function player:is_player_modder(player,mask)end
function player:is_player_god(player)end
function player:get_player_wanted_level(player)end
function player:player_count()end
function player:is_player_in_any_vehicle(player)end
function player:get_player_coords(player)end
function player:get_player_heading(player)end
function player:get_player_health(player)end
function player:get_player_max_health(player)end
function player:get_player_armour(player)end
function player:get_player_from_ped(ped)end
function player:get_player_team(player)end
function player:get_player_vehicle(player)end
function player:is_player_vehicle_god(player)end
function player:is_player_host(player)end
function player:get_host()end
function player:is_player_spectating(player)end
function player:get_player_model(player)end
function player:send_player_sms(player,msg)end
function player:unset_player_as_modder(player,flags)end
function player:get_player_modder_flags(player)end
function player:get_modder_flag_text(flag)end
function player:get_modder_flag_ends()end
function player:add_modder_flag(text)end
function player:is_player_valid(player)end
function player:get_player_host_token(player)end
function player:get_player_host_priority(player)end
function player:set_player_targeting_mode(mode)end
function player:can_player_be_modder(player)end
function player:get_player_parachute_model(player)end
function player:set_player_parachute_model(player,model)end
--Modder Detection Flags:
--enum eModderDetectionFlags : unsigned long long
--{
--	MDF_MANUAL					= 1 << 0x00,
--	MDF_PLAYER_MODEL			= 1 << 0x01,
--	MDF_SCID_SPOOF				= 1 << 0x02,
--	MDF_INVALID_OBJECT_CRASH	= 1 << 0x03,
--	MDF_INVALID_PED_CRASH		= 1 << 0x04,
--	MDF_MODEL_CHANGE_CRASH		= 1 << 0x05,
--	MDF_PLAYER_MODEL_CHANGE		= 1 << 0x06,
--	MDF_RAC						= 1 << 0x07,
--	MDF_MONEY_DROP				= 1 << 0x08,
--	MDF_SEP						= 1 << 0x09,
--	MDF_ATTACH_OBJECT			= 1 << 0x0A,
--	MDF_ATTACH_PED				= 1 << 0x0B,
--	MDF_NET_ARRAY_CRASH			= 1 << 0x0C,
--	MDF_SYNC_CRASH				= 1 << 0x0D,
--	MDF_NET_EVENT_CRASH			= 1 << 0x0E,
--	MDF_HOST_TOKEN				= 1 << 0x0F,
--	MDF_SE_SPAM					= 1 << 0x10,
--	MDF_INVALID_VEHICLE			= 1 << 0x11,
--	MDF_FRAME_FLAGS				= 1 << 0x12,
--	MDF_ENDS					= 1 << 0x13,
--};
