event = {}
event.__index = event

function event:add_event_listener(eventName,callback)end
function event:remove_event_listener(eventName,id)end
--## D3D
--These functions should only be used from feature renderers, which can be set through the `renderer` property
--!!! example
--	
--	menu.add_feature("d3d renderer", "toggle", 0, nil).renderer	= d3d_draw
--	
--Renderer callbacks are executed from the d3d thread
