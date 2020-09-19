Control = {}
Control.__index = Control

function Control:disable_control_action(inputGroup, control, disable)end
function Control:is_control_just_pressed(inputGroup, control)end
function Control:is_disabled_control_just_pressed(inputGroup, control)end
function Control:is_control_pressed(inputGroup, control)end
function Control:is_disabled_control_pressed(inputGroup, control)end