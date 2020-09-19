entity = {}
entity.__index = entity

function entity:get_entity_coords(entity)end
function entity:set_entity_coords_no_offset(entity, pos)end
function entity:get_entity_rotation(entity)end
function entity:set_entity_rotation(entity, rot)end
function entity:set_entity_heading(entity, heading)end
function entity:set_entity_velocity(entity, velocity)end
function entity:get_entity_velocity(entity)end
function entity:is_an_entity(entity)end
function entity:is_entity_a_ped(entity)end
function entity:is_entity_a_vehicle(entity)end
function entity:is_entity_an_object(entity)end
function entity:is_entity_dead(entity)end
function entity:is_entity_on_fire(entity)end
function entity:is_entity_visible(entity)end
function entity:is_entity_attached(entity)end
function entity:set_entity_visible(entity, toggle)end
function entity: get_entity_type(entity)end
function entity:set_entity_gravity(entity, gravity)end
function entity:apply_force_to_entity(ped, forceType, x, y, z, rx, ry, rz, isRel, highForce)end
function entity:get_entity_attached_to(entity)end
function entity:detach_entity(e)end
function entity:get_entity_model_hash(e)end
function entity: get_entity_heading(entity)end
function entity:attach_entity_to_entity(subject, target, boneIndex, offset, rot, softPinning, collision, isPed, vertexIndex, fixedRot)end
function entity:set_entity_as_mission_entity(entity, toggle, unk)end
function entity:set_entity_collision(entity, toggle, physics, unk0)end
function entity:is_entity_in_air(entity)end
function entity:set_entity_as_no_longer_needed(entity)end
function entity:set_entity_no_collsion_entity(entity, target, unk)end
function entity:freeze_entity(entity, toggle)end
function entity:get_entity_offset_from_coords(lentity, coords)end
function entity:get_entity_offset_from_entity(lentity, lentity2)end
function entity:set_entity_alpha(entity, alpha, skin)end
function entity:reset_entity_alpha(entity)end
function entity:delete_entity(e)end
function entity:set_entity_god_mode(entity, toggle)end
function entity:get_entity_god_mode(entity)end
function entity:is_entity_in_water(entity)end
function entity: get_entity_speed(entity)end
function entity:set_entity_lights(entity, toggle)end
function entity:set_entity_max_speed(entity, speed)end
function entity: get_entity_pitch(entity)end
function entity: get_entity_roll(e)end
function entity:get_entity_physics_rotation(e)end
function entity: get_entity_physics_heading(e)end
function entity: get_entity_physics_pitch(e)end
function entity: get_entity_physics_roll(e)end
function entity:does_entity_have_physics(entity)end
function entity:get_entity_rotation_velocity(entity)end
function entity: get_entity_submerged_level(entity)end
function entity:get_entity_population_type(entity)end
function entity:is_entity_static(entity)end
function entity:is_entity_in_zone(entity, zone)end
function entity:is_entity_upright(entity, angle)end
function entity:is_entity_upside_down(entity)end
function entity:has_entity_been_damaged_by_any_object(entity)end
function entity:has_entity_been_damaged_by_any_vehicle(entity)end
function entity:has_entity_been_damaged_by_any_ped(entity)end
function entity:has_entity_been_damaged_by_entity(e1, e2)end
function entity:does_entity_have_drawable(entity)end
function entity:has_entity_collided_with_anything(entity)end
function entity:get_entity_entity_has_collided_with(entity)end