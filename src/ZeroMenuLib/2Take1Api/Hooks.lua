Hooks = {}
Hooks.__index = Hooks


function Hooks:script_event_hook(source, target, paramsArray, count)end
function Hooks:net_event_hook(source, target, eventId)end