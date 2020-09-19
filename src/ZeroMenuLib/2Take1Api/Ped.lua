ped = {}
ped.__index = ped

function ped:is_ped_in_any_vehicle(ped)end
function ped:set_group_formation(group, formation)end
function ped:set_ped_as_group_member(ped, groupId)end
function ped:get_ped_group(ped)end
function ped:get_group_size(group)end
function ped:get_ped_health(ped)end
function ped:set_ped_health(ped, value)end
function ped:is_ped_ragdoll(ped)end
function ped:is_ped_a_player(ped)end
function ped:get_current_ped_weapon(ped)end
function ped:set_ped_into_vehicle(ped, vehicle, seat)end
function ped:get_ped_drawable_variation(ped, group)end
function ped:get_ped_texture_variation(ped, group)end
function ped:get_ped_prop_index(ped, group)end
function ped:get_ped_prop_texture_index(ped, group)end
function ped:set_ped_component_variation(ped, component, drawable, texture, pallette)end
function ped:set_ped_prop_index(ped, component, drawable, texture, unk)end
function ped:set_ped_can_switch_weapons( ped,  toggle)end
function ped:is_ped_shooting( ped)end
function ped:get_ped_bone_index( ped,  bone)end
function ped:get_ped_bone_coords( ped,  boneId,  offset)end
function ped:get_ped_relationship_group_hash( ped)end
function ped:set_ped_relationship_group_hash( ped,  hash)end
function ped:get_vehicle_ped_is_using( ped)end
function ped:clear_all_ped_props( ped)end
function ped:clear_ped_tasks_immediately( ped)end
function ped:clear_ped_blood_damage(ped)end
function ped:is_ped_in_vehicle(ped, vehicle)end
function ped:is_ped_using_any_scenario(ped)end
function ped:set_ped_to_ragdoll(ped, time1, time2, type)end
function ped:set_ped_can_ragdoll(ped,  toggle)end
function ped:can_ped_ragdoll(ped)end
function ped:get_ped_last_weapon_impact(ped)end
function ped:set_ped_combat_ability(ped, ability)end
function ped:get_ped_max_health(entity)end
function ped:set_ped_max_health(entity, health)end
function ped:resurrect_ped(ped)end
function ped:set_ped_combat_movement(ped, type)end
function ped:set_ped_combat_range(ped, type)end
function ped:set_ped_combat_attributes(ped, attr, toggle)end
function ped:set_ped_accuracy(ped, accuracy)end
function ped:create_ped(type, model, pos, heading, isNetworked, unk1)end
function ped:get_number_of_ped_drawable_variations(ped, comp)end
function ped:get_number_of_ped_texture_variations(ped, comp,  draw)end
function ped:get_number_of_ped_prop_drawable_variations( ped,  groupId)end
function ped:get_number_of_ped_prop_texture_variations( ped, groupId,  drawId)end
function ped:set_ped_random_component_variation( ped)end
function ped:set_ped_default_component_variation( ped)end
function ped:set_ped_movement_clipset( ped,  szClipset)end
function ped:reset_ped_movement_clipset( ped,  unk0)end
function ped:clone_ped( ped)end
function ped:set_ped_config_flag(ped, flag, value)end
function ped:set_ped_ragdoll_blocking_flags(ped, flags)end
function ped:reset_ped_ragdoll_blocking_flags(ped, flags)end
function ped:set_ped_density_multiplier_this_frame(mult)end
function ped:set_scenario_ped_density_multiplier_this_frame(m1, m2)end
function ped:get_all_peds()end
function ped:create_group()end
function ped:remove_group(group)end
function ped:set_ped_as_group_leader(ped, group)end
function ped:remove_ped_from_group(ped)end
function ped:is_ped_group_member(ped, group)end
function ped:set_group_formation_spacing(group, a2, a3, a4)end
function ped:reset_group_formation_default_spacing(group)end
function ped:set_ped_never_leaves_group(ped, toggle)end
function ped:does_group_exist(group)end
function ped:is_ped_in_group(ped)end
function ped:set_create_random_cops(boolean)end
function ped:can_create_random_cops()end
function ped:is_ped_swimming(ped)end
function ped:is_ped_swimming_underwater(ped)end
function ped:clear_relationship_between_groups(group1, group2)end
function ped:set_relationship_between_groups(relation, group1, group2)end