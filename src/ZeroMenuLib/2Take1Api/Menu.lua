menu = {}
menu.__index = menu


function menu:add_feature(name, type, parent, script_function)end
function menu:delete_feature(id)end
function menu:set_menu_can_navigate(toggle)end
function menu:get_version()end
function menu:add_player_feature(name, type, parent, script_function)end
function menu:get_player_feature(i)end
function menu:is_threading_mode(mode)end
function menu:create_thread(callback,context)end
function menu:has_thread_finished(Threadid)end
function menu:delete_thread(Threadid)end