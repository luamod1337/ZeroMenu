vehicle = {}
vehicle.__index = vehicle

function vehicle:set_vehicle_tire_smoke_color(vehicle, r, g, b)end
function vehicle:get_ped_in_vehicle_seat(vehicle, seat)end
function vehicle:get_free_seat(vehicle)end
function vehicle:is_vehicle_full(vehicle)end
function vehicle:set_vehicle_stolen(vehicle, toggle)end
function vehicle:set_vehicle_color(v, p, s, pearl, wheel)end
function vehicle:get_mod_text_label(veh, modType, modValue)end
function vehicle:get_mod_slot_name(veh, modType)end
function vehicle:get_num_vehicle_mods(veh, modType)end
function vehicle:set_vehicle_mod(vehicle, modType, modIndex, customTires)end
function vehicle:get_vehicle_mod(vehicle, modType)end
function vehicle:set_vehicle_mod_kit_type(vehicle, type)end
function vehicle:set_vehicle_extra(veh, extra, toggle)end
function vehicle:does_extra_exist(veh, extra)end
function vehicle:is_vehicle_extra_turned_on(veh, extra)end
function vehicle:toggle_vehicle_mod(veh, mod, toggle)end
function vehicle:set_vehicle_bulletproof_tires(veh, toggle)end
function vehicle:is_vehicle_a_convertible(veh)end
function vehicle:get_convertible_roof_state(veh)end
function vehicle:set_convertible_roof(veh, toggle)end
function vehicle:set_vehicle_indicator_lights(veh, index, toggle)end
function vehicle:set_vehicle_brake_lights(veh, toggle)end
function vehicle:set_vehicle_can_be_visibly_damaged(veh, toggle)end
function vehicle:set_vehicle_engine_on(veh, toggle, instant, noAutoTurnOn)end
function vehicle:set_vehicle_fixed(veh)end
function vehicle:set_vehicle_deformation_fixed(veh)end
function vehicle:set_vehicle_undriveable(veh, toggle)end
function vehicle:set_vehicle_on_ground_properly(veh)end
function vehicle:set_vehicle_forward_speed(veh, speed)end
function vehicle:set_vehicle_number_plate_text(veh, text)end
function vehicle:set_vehicle_door_open(veh, doorIndex, loose, openInstantly)end
function vehicle:set_vehicle_doors_shut(veh, closeInstantly)end
function vehicle:is_toggle_mod_on(veh, index)end
function vehicle:set_vehicle_wheel_type(veh, type)end
function vehicle:set_vehicle_number_plate_index(veh, index)end
function vehicle:set_vehicle_tires_can_burst(veh, toggle)end
function vehicle:set_vehicle_tire_burst(veh, index, onRim, unk0)end
function vehicle:get_num_vehicle_mod(veh, modType)end
function vehicle:is_vehicle_engine_running(veh)end
function vehicle:set_vehicle_engine_health(veh, health)end
function vehicle:is_vehicle_damaged(veh)end
function vehicle:is_vehicle_on_all_wheels(veh)end
function vehicle:create_vehicle(model, pos, heading, networked, unk2)end
function vehicle:set_vehicle_doors_locked(vehicle, lockStatus)end
function vehicle:set_vehicle_neon_lights_color(vehicle, color)end
function vehicle:get_vehicle_neon_lights_color(vehicle)end
function vehicle:set_vehicle_neon_light_enabled(vehicle, index, toggle)end
function vehicle:is_vehicle_neon_light_enabled(vehicle, index, toggle)end
function vehicle:set_vehicle_density_multipliers_this_frame(mult)end
function vehicle:set_random_vehicle_density_multiplier_this_frame(mult)end
function vehicle:set_parked_vehicle_density_multiplier_this_frame(mult)end
function vehicle:set_ambient_vehicle_range_multiplier_this_frame(mult)end
function vehicle:is_vehicle_rocket_boost_active(veh)end
function vehicle:set_vehicle_rocket_boost_active(veh, toggle)end
function vehicle:set_vehicle_rocket_boost_percentage(veh, percentage)end
function vehicle:set_vehicle_rocket_boost_refill_time(veh, refillTime)end
function vehicle:control_landing_gear(veh, state)end
function vehicle:get_landing_gear_state(veh)end
function vehicle:get_vehicle_livery(veh)end
function vehicle:set_vehicle_livery(veh, index)end
function vehicle:is_vehicle_stopped(veh)end
function vehicle:get_vehicle_number_of_passengers(veh)end
function vehicle:get_vehicle_max_number_of_passengers(veh)end
function vehicle:get_vehicle_model_number_of_seats(modelHash)end
function vehicle:get_vehicle_livery_count(veh)end
function vehicle:get_vehicle_roof_livery_count(veh)end
function vehicle:is_vehicle_model(veh, model)end
function vehicle:is_vehicle_stuck_on_roof(veh)end
function vehicle:set_vehicle_doors_locked_for_player(veh, player, toggle)end
function vehicle:get_vehicle_doors_locked_for_player(veh, player)end
function vehicle:set_vehicle_doors_locked_for_all_players(veh, toggle)end
function vehicle:set_vehicle_doors_locked_for_non_script_players(veh, toggle)end
function vehicle:set_vehicle_doors_locked_for_team(veh, team, toggle)end
function vehicle:explode_vehicle(veh, isAudible, isInvisible)end
function vehicle:set_vehicle_out_of_control(veh, killDriver, explodeOnImpact)end
function vehicle:set_vehicle_timed_explosion(veh, ped, toggle)end
function vehicle:add_vehicle_phone_explosive_device(veh)end
function vehicle:has_vehicle_phone_explosive_device()end
function vehicle:detonate_vehicle_phone_explosive_device()end
function vehicle:set_taxi_lights(veh, state)end
function vehicle:is_taxi_light_on(veh)end
function vehicle:set_vehicle_colors(veh, primary, secondary)end
function vehicle:set_vehicle_extra_colors(veh, pearl, wheel)end
function vehicle:get_vehicle_primary_color(veh)end
function vehicle:get_vehicle_secondary_color(veh)end
function vehicle:get_vehicle_pearlecent_color(veh)end
function vehicle:get_vehicle_wheel_color(veh)end
function vehicle:set_vehicle_fullbeam(veh, toggle)end
function vehicle:set_vehicle_custom_primary_colour(veh, ucolor)end
function vehicle:get_vehicle_custom_primary_colour(veh)end
function vehicle:clear_vehicle_custom_primary_colour(veh)end
function vehicle:is_vehicle_primary_colour_custom(veh)end
function vehicle:set_vehicle_custom_secondary_colour(veh, ucolor)end
function vehicle:get_vehicle_custom_secondary_colour(veh)end
function vehicle:clear_vehicle_custom_secondary_colour(veh)end
function vehicle:is_vehicle_secondary_colour_custom(veh)end
function vehicle:set_vehicle_custom_pearlescent_colour(veh, ucolor)end
function vehicle:get_vehicle_custom_pearlescent_colour(veh)end
function vehicle:set_vehicle_custom_wheel_colour(veh, ucolor)end
function vehicle:get_vehicle_custom_wheel_colour(veh)end
function vehicle:get_livery_name(veh, livery)end
function vehicle:set_vehicle_window_tint(veh, t)end
function vehicle:get_vehicle_window_tint(veh)end
function vehicle:get_all_vehicle_model_hashes()end
function vehicle:get_all_vehicles()end
function vehicle:modify_vehicle_top_speed(veh, f)end
function vehicle:set_vehicle_engine_torque_multiplier_this_frame(veh, f)end
function vehicle:get_vehicle_headlight_color(Vehicle)end
function vehicle:set_vehicle_headlight_color(vehicle, color)end
function vehicle:set_heli_blades_full_speed(vehicle)end
function vehicle:set_heli_blades_speed(Vehicle, speed)end
function vehicle:set_vehicle_parachute_active(Vehicle, toggle)end
function vehicle:does_vehicle_have_parachute(Vehicle)end
function vehicle:can_vehicle_parachute_be_activated(Vehicle)end