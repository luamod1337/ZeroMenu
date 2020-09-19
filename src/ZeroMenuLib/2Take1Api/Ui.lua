ui = {}
ui.__index = ui

function ui:notify_above_map(message, title, color)end
function ui:get_entity_from_blip(blip)end
function ui:get_blip_from_entity(entity)end
function ui:add_blip_for_entity(entity)end
function ui:set_blip_sprite(blip, spriteId)end
function ui:set_blip_colour(blip, colour)end
function ui:hide_hud_component_this_frame(componentId)end
function ui:hide_hud_and_radar_this_frame()end
function ui:get_label_text(label)end
function ui:draw_rect(x, y, width, height, r, g, b, a)end
function ui:draw_line(pos1, pos2, r, g, b, a)end
function ui:draw_text(pszText, pos)end
function ui:set_text_scale(scale)end
function ui:set_text_color(r, g, b, a)end
function ui:set_text_font(font)end
function ui:set_text_wrap(start, till)end
function ui:set_text_outline(b)end
function ui:set_text_centre(b)end
function ui:set_new_waypoint(coord)end
function ui:get_waypoint_coord()end
function ui:is_hud_component_active(componentId)end
function ui:show_hud_component_this_frame(componentId)end
function ui:set_waypoint_off()end