rope = {}
rope.__index = rope

function rope:rope_load_textures()end
function rope:rope_unload_textures()end
function rope:rope_are_textures_loaded()end
function rope:add_rope(pos,rot,maxLen,ropeType,invalueitLength,minvalueLength,lengthChangeRate,onlyPPU,collisionOn,lockFromFront,timeMultiplier,breakable)end
function rope:does_rope_exist(rope)end
function rope:delete_rope(rope)end
function rope:attach_rope_to_entity(rope,e,offset,a3)end
function rope:attach_entities_to_rope(rope,ent1,ent2,pos_ent1,pos_ent2,len,a7,a8,boneName1,boneName2)end
function rope:detach_rope_from_entity(rope,entity)end
function rope:start_rope_unwinding_front(rope)end
function rope:start_rope_winding(rope)end
function rope:stop_rope_unwinding_front(rope)end
function rope:stop_rope_winding(rope)end
function rope:rope_force_length(rope,len)end
function rope:activate_physics(entity)end
