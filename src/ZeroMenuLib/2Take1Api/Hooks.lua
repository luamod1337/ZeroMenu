hooks = {}
hooks.__index = hooks


function hooks:script_event_hook(source, target, paramsArray, count)end
function hooks:net_event_hook(source, target, eventId)end