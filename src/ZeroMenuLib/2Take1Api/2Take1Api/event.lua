event = {}
event.__index = event

function event:add_event_listener(eventName,callback)end
--:	Event listeners should have 1 params, which is the event object
--	Event listeners are executed from script thread
function event:remove_event_listener(eventName,id)end
--## D3D
--These functions should only be used from feature renderers, which can be set through the `renderer` property.
--Renderer callbacks are executed from the d3d thread and should not interact directly with RAGE functions.
--lua title="Example"
--local d3d_draw = function(feat)
--	local pos = v2()
--	
--	d3d.draw_rect(pos, v2(.2, .2), 0xFFFF0000)
--	d3d.draw_text("test123", pos, v2(), 1.0, 0xFF0000FF, 5)
--	
--	if feat.on then
--		return HANDLER_CONTINUE
--	end
--end
--menu.add_feature("d3d renderer", "toggle", 0, nil).renderer = d3d_draw
