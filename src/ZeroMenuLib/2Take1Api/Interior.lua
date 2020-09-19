Interior = {}
Interior.__index = Interior


function Interior:get_interior_from_entity(entity)end
function Interior:get_interior_at_coords_with_type(coords, interiorType)end
function Interior:enable_interior_prop(id, prop)end
function Interior:disable_interior_prop(id, prop)end
function Interior:refresh_interior(id)end