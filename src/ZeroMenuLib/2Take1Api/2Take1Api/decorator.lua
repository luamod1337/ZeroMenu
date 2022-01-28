decorator = {}
decorator.__index = decorator

function decorator:decor_register(name,type)end
function decorator:decor_exists_on(e,decor)end
function decorator:decor_remove(e,decor)end
function decorator:decor_get_int(entity,name)end
function decorator:decor_set_int(entity,name,value)end
function decorator:decor_get_float(entity,name)end
function decorator:decor_set_float(entity,name,value)end
function decorator:decor_get_bool(entity,name)end
function decorator:decor_set_bool(entity,name,value)end
function decorator:decor_set_time(entity,name,value)end
