menu = {}
menu.__index = menu

function menu:add_feature(name,type,parent,script_handler)end
function menu:delete_feature(id)end
function menu:set_menu_can_navigate(toggle)end
function menu:get_version()end
function menu:add_player_feature(name,type,parent,script_handler)end
function menu:get_player_feature(i)end
function menu:delete_player_feature(id)end
function menu:is_threading_mode(mode)end
function menu:create_thread(callback,context)end
function menu:has_thread_finished(id)end
function menu:delete_thread(id)end
function menu:notify(message,title,seconds,color)end
function menu:clear_all_notifications()end
function menu:clear_visible_notifications()end
function menu:is_trusted_mode_enabled()end
--## Hooks
function menu:script_event_hook(source,target,params,count)end
function menu:net_event_hook(source,target,eventId)end
--If the callback returns `false` net or script event will be blocked. Anything else will let the script event pass.
