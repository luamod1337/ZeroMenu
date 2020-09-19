Hook = {}
Hook.__index = Hook


function Hook:register_script_event_hook(callback)end
function Hook:remove_script_event_hook(id)end
function Hook:register_net_event_hook(callback)end
function Hook:remove_net_event_hook(id)end