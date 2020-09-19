D3D = {}
D3D.__index = D3D

function D3D:draw_text(text, pos, size, scale, color, flags)end
function D3D:register_sprite(path)end
function D3D:draw_sprite(id, pos, scale, rot, color)end
function D3D:get_sprite_origin(id)end
function D3D:get_sprite_size(id)end
function D3D:draw_line(start, till, size, color)end
function D3D:draw_rect(pos, size, color)end