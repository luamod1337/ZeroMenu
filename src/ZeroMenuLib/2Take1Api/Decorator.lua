Decorator = {}
Decorator.__index = Decorator

function Decorator:decor_register(name, type)end
function Decorator:decor_exists_on(e, decor)end
function Decorator:decor_remove(e, decor)end
function Decorator:decor_get_int(entity, name)end
function Decorator:decor_set_int(entity, name, value)end