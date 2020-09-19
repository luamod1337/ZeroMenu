ai = {}
ai.__index = ai

function ai:task_goto_entity(e, target, duration, distance, speed)end
function ai:task_combat_ped(ped, target, a3, a4)end
function ai:task_go_to_coord_by_any_means(ped, coords, speed, p4, p5, walkStyle, a7)end
function ai:task_wander_standard(ped, unk0, unk1)end
function ai:task_vehicle_drive_wander(ped, vehicle, speed, driveStyle)end
function ai:task_start_scenario_in_place(ped, name, unkDelay, playEnterAnim)end
function ai:task_start_scenario_at_position(ped, name, coord, heading, duration, sittingScenario, teleport)end
function ai:task_stand_guard(ped, coord, heading, name)end
function ai:play_anim_on_running_scenario(ped, dict, name)end
function ai:does_scenario_group_exist(name)end
function ai:is_scenario_group_enabled(name)end
function ai:set_scenario_group_enabled(name, b)end
function ai:reset_scenario_groups_enabled()end
function ai:set_exclusive_scenario_group(name)end
function ai:reset_exclusive_scenario_group()end
function ai:is_scenario_type_enabled(name)end
function ai:set_scenario_type_enabled(name, b)end
function ai:reset_scenario_types_enabled()end
function ai:is_ped_active_in_scenario(ped)end
function ai:task_follow_to_offset_of_entity(ped, entity, offset, speed, timeout, stopRange, persistFollowing)end
function ai:task_vehicle_drive_to_coord_longrange(ped, vehicle, pos, speed, mode, stopRange)end
function ai:task_shoot_at_entity(entity, target, duration, firingPattern)end
function ai:task_vehicle_escort(ped, vehicle, targetVehicle, mode, speed, drivingStyle, minDistance, a8, noRoadsDistance)end
function ai:task_vehicle_follow(driver, vehicle, targetEntity, speed, drivingStyle, minDistance)end
function ai:task_vehicle_drive_to_coord(ped, vehicle, coord, speed, a5, vehicleModel, driveMode, stopRange, a9)end
function ai:task_vehicle_shoot_at_coord(ped, coord, a3)end
function ai:task_vehicle_shoot_at_ped(ped, target, a3)end
function ai:task_vehicle_aim_at_coord(ped, coord)end
function ai:task_vehicle_aim_at_ped(ped, target)end
function ai:task_stay_in_cover(ped)end
function ai:task_go_to_coord_while_aiming_at_coord(ped, gotoCoord, aimCoord, moveSpeed, a5, a6, a7, a8, flags, a10, firingPattern)end
function ai:task_go_to_coord_while_aiming_at_entity(ped, gotoCoord, target, moveSpeed, a5, a6, a7, a8, flags, a10, firingPattern)end
function ai:task_go_to_entity_while_aming_at_coord(ped, gotoEntity, aimCoord, a4, shoot, a6, a7, a8, a9, firingPattern)end
function ai:task_go_to_entity_while_aiming_at_entity(ped, gotoEntity, target, a4, shoot, a6, a7, a8, a9, firingPattern)end
function ai:task_open_vehicle_door(ped, vehicle, timeOut, doorIndex, speed)end
function ai:task_enter_vehicle(ped, vehicle, timeout, seat, speed, flag, p6)end
function ai:task_leave_vehicle(ped, vehicle, flag)end
function ai:task_sky_dive(ped, a2)end
function ai:task_parachute(ped, a2, a3)end
function ai:task_parachute_to_target(ped, coord)end
function ai:set_parachute_task_target(ped, coord)end
function ai:set_parachute_task_thrust(ped, thrust)end
function ai:task_rappel_from_heli(ped, a2)end
function ai:task_vehicle_chase(driver, target)end
function ai:set_task_vehicle_chase_behaviour_flag(ped, flag, set)end
function ai:set_task_vehicle_chase_ideal_persuit_distance(ped, dist)end
function ai:task_shoot_gun_at_coord(ped, coord, duration, firingPattern)end
function ai:task_aim_gun_at_coord(ped, coord, time, a4, a5)end
function ai:task_turn_ped_to_face_entity(ped, entity, duration)end
function ai:task_aim_gun_at_entity(ped, entity, duration, a4)end
function ai:is_task_active(ped, taskId)end