scriptdraw = {}
scriptdraw.__index = scriptdraw

function scriptdraw:draw_text(text,pos,size,scale,color,flags,font)end
function scriptdraw:register_sprite(path)end
function scriptdraw:get_sprite_origin(id)end
function scriptdraw:get_sprite_size(id)end
function scriptdraw:get_text_size(text,scale,font)end
function scriptdraw:draw_sprite(id,pos,scale,rot,color)end
function scriptdraw:draw_line(start,endvalue,size,color)end
function scriptdraw:draw_rect(pos,size,color)end
function scriptdraw:pos_pixel_to_rel_x(invalue)end
function scriptdraw:pos_pixel_to_rel_y(invalue)end
function scriptdraw:pos_rel_to_pixel_x(invalue)end
function scriptdraw:pos_rel_to_pixel_y(invalue)end
function scriptdraw:size_pixel_to_rel_x(invalue)end
function scriptdraw:size_pixel_to_rel_y(invalue)end
function scriptdraw:size_rel_to_pixel_x(invalue)end
function scriptdraw:size_rel_to_pixel_y(invalue)end
--enum eDrawTextFlags
--{
--	TEXTFLAG_NONE			= 0,
--	TEXTFLAG_CENTER			= 1 << 0,
--	TEXTFLAG_SHADOW			= 1 << 1,
--	TEXTFLAG_VCENTER		= 1 << 2,
--	TEXTFLAG_BOTTOM			= 1 << 3,
--	TEXTFLAG_JUSTIFY_RIGHT = 1 << 4,
--};
