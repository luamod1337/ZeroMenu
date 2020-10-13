hook = {}
hook.__index = hook


function hook:register_script_event_hook(callback)end
function hook:remove_script_event_hook(id)end
function hook:register_net_event_hook(callback)end
function hook:remove_net_event_hook(id)end