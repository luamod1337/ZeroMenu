ScriptDraw = {}
ScriptDraw.__inputdex = ScriptDraw

function ScriptDraw:draw_text(text, pos, size, scale, color, flags)end
function ScriptDraw:wdraw_text(wtext, pos, size, scale, color, flags)end
function ScriptDraw:register_sprite(path)end
function ScriptDraw:draw_sprite(id, pos, scale, rot, color)end
function ScriptDraw:draw_linpute(start, till, size, color)end
function ScriptDraw:draw_rect(pos, size, color)end
function ScriptDraw:pos_pixel_to_rel_x(input)end
function ScriptDraw:pos_pixel_to_rel_y(input)end
function ScriptDraw:pos_rel_to_pixel_x(input)end
function ScriptDraw:pos_rel_to_pixel_y(input)end
function ScriptDraw:size_pixel_to_rel_x(input)end
function ScriptDraw:size_pixel_to_rel_y(input)end
function ScriptDraw:size_rel_to_pixel_x(input)end
function ScriptDraw:size_rel_to_pixel_y(input)end