Menu = {}
Menu.__index = Menu


function Menu:add_feature(name, type, parent, script_function)end
function Menu:delete_feature(id)end
function Menu:set_menu_can_navigate(toggle)end
function Menu:get_version()end
function Menu:add_player_feature(name, type, parent, script_function)end
function Menu:get_player_feature(i)end
function Menu:is_threading_mode(mode)end
function Menu:create_thread(callback,context)end
function Menu:has_thread_finished(Threadid)end
function Menu:delete_thread(Threadid)end