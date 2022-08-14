gameplay = {}
gameplay.__index = gameplay

function gameplay:get_hash_key(invalue)end
function gameplay:display_onscreen_keyboard(title,default_text,maxLength)end
function gameplay:update_onscreen_keyboard()end
function gameplay:get_onscreen_keyboard_result()end
function gameplay:is_onscreen_keyboard_active()end
function gameplay:set_override_weather(weatherIndex)end
function gameplay:clear_override_weather()end
function gameplay:set_blackout(toggle)end
function gameplay:set_mobile_radio(toggle)end
function gameplay:get_game_state()end
function gameplay:is_game_state(invaluet)end
function gameplay:clear_area_of_objects(coord,radius,flags)end
function gameplay:clear_area_of_vehicles(coord,radius,a3,a4,a5,a6,a7)end
function gameplay:clear_area_of_peds(coord,radius,a3)end
function gameplay:clear_area_of_cops(coord,radius,a3)end
function gameplay:set_cloud_hat_opacity(opacity)end
function gameplay:get_cloud_hat_opacity()end
function gameplay:preload_cloud_hat(szName)end
function gameplay:clear_cloud_hat()end
function gameplay:load_cloud_hat(szName,transitionTime)end
function gameplay:unload_cloud_hat(szName,a2)end
function gameplay:get_ground_z(pos)end
function gameplay:get_frame_count()end
function gameplay:get_frame_time()end
function gameplay:shoot_single_bullet_between_coords(start,endvalue,damage,weapon,owner,audible,invaluevisible,speed)end
function gameplay:find_spawn_point_in_direction(pos,fwd,dist)end
