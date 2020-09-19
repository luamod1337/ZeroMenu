Weapon = {}
Weapon.__index = Weapon


function Weapon:give_delayed_weapon_to_ped(ped, hash, time, equipNow)end
function Weapon:get_weapon_tint_count(weapon)end
function Weapon:get_ped_weapon_tint_index(ped, weapon)end
function Weapon:set_ped_weapon_tint_index(ped, weapon, index)end
function Weapon:give_weapon_component_to_ped(ped, weapon, component)end
function Weapon:remove_all_ped_weapons(ped)end
function Weapon:remove_weapon_from_ped(ped, weapon)end
function Weapon:get_max_ammo(ped, weapon)end
function Weapon:set_ped_ammo(ped, weapon, ammo)end
function Weapon:remove_weapon_component_from_ped(ped, weapon, component)end
function Weapon:has_ped_got_weapon_component(ped, weapon, component)end
function Weapon:get_ped_ammo_type_from_weapon(ped, weapon)end
function Weapon:set_ped_ammo_by_type(ped, type, amount)end
function Weapon:has_ped_got_weapon(ped, weapon)end
function Weapon:get_all_weapon_hashes()end
function Weapon:get_weapon_name(weapon)end
function Weapon:get_weapon_weapon_wheel_slot(weapon)end
function Weapon:get_weapon_model(weapon)end
function Weapon:get_weapon_audio_item(weapon)end
function Weapon:get_weapon_slot(weapon)end
function Weapon:get_weapon_ammo_type(weapon)end
function Weapon:get_weapon_weapon_group(weapon)end
function Weapon:get_weapon_weapon_type(weapon)end
function Weapon:get_weapon_pickup(weapon)end