
# 2Take1Menu Lua API

Anything that interacts with the RAGE engine should be done from a script thread.

Script threads are created when you pass a callback to `menu.add_feature` or when you call `menu.create_thread`.

The feature script threads will run when the feature is activated. Threads created by `menu.create_thread` will be immediately scheduled for execution.

`autoexec.lua` will be executed when 2Take1Menu is injected.

## Menu

### Feature Types

| Name                   | Description                            |
|------------------------|----------------------------------------|
| `parent`               | Parent feature                         |
| `toggle`               | Toggle feature                         |
| `action`               | Action feature                         |
| `value_i`              | Toggle feature with integer value      |
| `value_f`              | Toggle feature with float value        |
| `slider`               | Toggle feature with slider             |
| `value_str`            | Toggle feature with string values      |
| `action_value_i`       | Action feature with integer value      |
| `action_value_f`       | Action feature with float value        |
| `action_slider`        | Action feature with slider             |
| `action_value_str`     | Action feature with string values      |
| `autoaction_value_i`   | Auto Action feature with integer value |
| `autoaction_value_f`   | Auto Action feature with float value   |
| `autoaction_slider `   | Auto Action feature with slider        |
| `autoaction_value_str` | Auto Action feature with string values |

### Handlers

```
#### eHandlerResponse	feature_script_handler(Feat feat, * data)
#### eHandlerResponse	player_feature_script_handle(Feat feat, Player player, * data)
#### eHandlerResponse	feature_d3d_renderer(Feat feat)
#### eHandlerResponse	player_feature_d3d_renderer(Feat feat, Player player)
```

If you want to return and continue execution on the next frame, you can return `HANDLER_CONTINUE`.

If you want to yield (from a script thread) you can call `system.wait(i)` or `system.yield(i)`.

Script handlers are executed in a script thread, and can use game functions.

Render handlers are executed in the d3d thread. You should only use d3d functions from these handlers.

### Structs

#### Feat

```
@property	boolean				on				read/write		feature on/off boolean
@property	Feat				parent			readonly
@property	Feat[]				children		readonly		Only for parents
@property	int					child_count		readonly		Only for parents
@property	integer				type			readonly
@property	integer				id				readonly		Ids will be recycled after the feature is deleted
@property	integer				value_i			read/write		DEPRECATED
@property	integer				min_i			read/write		DEPRECATED
@property	integer				max_i			read/write		DEPRECATED
@property	integer				mod_i			read/write		DEPRECATED
@property	boolean				threaded		read/write		DEPRECATED
@property	integer|float|nil	value*¹			read/write		feature value
@property	integer|float|nil	min*¹			read/write		feature minimum value
@property	integer|float|nil	max*¹			read/write		feature maximum value
@property	integer|float|nil	mod*¹			read/write		feature value modifier
@property	string				name			read/write
@property	function			renderer		read/write		d3d handler
@property	boolean				hidden			read/write		show/hide feature
@property	*					data			read/write		additional context passed to script handlers
@property	string[]			str_data		read/write		only available for value_str types

@method	Feat		toggle()
@method void 		set_str_data(string[] data)					only available for value_str types
@method string[]	get_str_data()								only available for value_str types
```
*¹ These properties are read/write for value_i, value_f and slider, but are readonly for value_str

#### PlayerFeat

```
@property	Feat[]		feats		readonly
@property	int			id			readonly
@property	int			parent_id	readonly
@property	boolean		threaded	read/write		deprecated
@property	function	renderer	read/write		Make sure you set the renderer with the PlayerFeat function, and not the Feat function. Otherwise the handler will not receive the player id in the second param.

@property	boolean				on*²			read/write
@property	integer|float|nil	value*¹*²		read/write		feature values
@property	integer|float|nil	min*¹*²			read/write		feature minimum values
@property	integer|float|nil	max*¹*²			read/write		feature maximum values
@property	integer|float|nil	mod*¹*²			read/write		feature value modifiers
@property	string[]			str_data		read/write		only available for value_str types

@method void 		set_str_data(string[] data)					only available for value_str types
@method string[]	get_str_data()								only available for value_str types
```
*¹ These properties are read/write for value_i, value_f and slider, but are readonly for value_str
*² These properties will expect a single value for setters, but return a table of values from the getters

#### v2

```
@property	float		x
@property	float		y

@constructor	v2()
@constructor	v2(float)
@constructor	v2(float, float)

@method	v2		__add(v2|v3|float)
@method	v2		__sub(v2|v3|float)
@method	v2		__mul(v2|v3|float)
@method	v2		__div(v2|v3|float)
@method	bool	__eq(v2)
@method	bool	__lt(v2)
@method	bool	__le(v2)
@method string	__tostring()
@method	float	magnitude(v2|nil)
```

#### v3

```
@property	float		x
@property	float		y
@property	float		z

@constructor	v3()
@constructor	v3(float)
@constructor	v3(float, float, float)

@method	v3		__add(v2|v3|float)
@method	v3		__sub(v2|v3|float)
@method	v3		__mul(v2|v3|float)
@method	v3		__div(v2|v3|float)
@method	bool	__eq(v3)
@method	bool	__lt(v3)
@method	bool	__le(v3)
@method string	__tostring()
@method	float	magnitude(v3|nil)
@method	void	transformRotToDir()
@method	void	radToDeg()
@method	void	degToRad()
```

!!! example
	```
	local player_id = player.player_id()
	local player_ped = player.get_player_ped(player_id)
	local pos = player.get_player_coords(player_id)
	local rot = entity.get_entity_rotation(player_ped)
	local dir = rot

	dir:transformRotToDir()
	dir = dir * 4
	pos = pos + dir
	```

#### Regex

```
@property	string		pattern

@constructor		Regex(string)

@method	RegexResult	search(string subject)
@method	string		__tostring()
```

#### RegexResult

```
@property	integer		count
@property	string[]	matches

@method	string		__tostring()
```

!!! example
	```
	local r = Regex("^(test123)")
	local s = "test123 abcd 345345"
	local m = r.search(r, s)

	if m.count > 0 then
		ui.notify_above_map(m.matches[1], "Lua regex", 140)
	end
	```

#### MenuKey

```
@property	uint32_t[]			keys			vector of virtual keys

@method		void				push_vk(uint32_t virtualKeyCode)
@method		bool				push_str(string key)
@method		void				pop()
@method		void				clear()
@method		bool				is_down()
@method		bool				is_down_stepped()
```

### Types

| Name    | Type    |
|---------|---------|
| Player  | integer |
| Entity  | integer |
| Ped     | integer |
| Vehicle | integer |
| Group   | integer |
| Hash    | integer |
| Ptfx    | integer |
| Any     | integer |
| Thread  | integer |

### Menu Functions

```
#### Feat			add_feature(string name, string type, integer parent, function script_handler)
#### bool			delete_feature(int id)
#### void			set_menu_can_navigate(bool toggle)
#### string			get_version()
#### PlayerFeat		add_player_feature(string name, string type, integer parent, function script_handler)
#### PlayerFeat		get_player_feature(uint32_t i)
#### bool			delete_player_feature(uint32_t id)
#### bool			is_threading_mode(int mode)
#### Thread			create_thread(function callback, * context)
#### bool			has_thread_finished(Thread id)
#### bool			delete_thread(Thread id)
#### void			notify(string message, string|nil title, uint32_t|nil seconds, uint32_t|nil color)
#### void			clear_all_notifications()
#### void			clear_visible_notifications()
#### bool			is_trusted_mode_enabled()
```

## Hooks

```
#### false|nil	script_event_hook(Player source, Player target, int[] params, int count)
#### false|nil	net_event_hook(Player source, Player target, int eventId)
```

If the callback returns `false` net or script event will be blocked. Anything else will let the script event pass.

### Hook Functions

```
#### int 		register_script_event_hook(function callback)
#### bool 		remove_script_event_hook(int id)
#### int 		register_net_event_hook(function callback)
#### bool 		remove_net_event_hook(int id)
```

## Events

Event listeners should have 1 params, which is the event object
Event listeners are executed from script thread

### ExitEvent

```
@eventName	exit

@property	integer		code
```

### ChatEvent

```
@eventName	chat

@property	integer		player
@property	string		body
```

### PlayerJoinEvent

```
@eventName	player_join

@property	integer		player
```

### PlayerLeaveEvent

```
@eventName	player_leave

@property	integer		player
```

### ScriptEvent

```
@eventName	script

@property	integer			id
@property	int[]			params
```

### Event Functions

```
#### int 		add_event_listener(string eventName, function callback)
#### bool 		remove_event_listener(string eventName, int id)
```

## D3D

These functions should only be used from feature renderers, which can be set through the `renderer` property

!!! example
	```
	menu.add_feature("d3d renderer", "toggle", 0, nil).renderer	= d3d_draw
	```

Renderer callbacks are executed from the d3d thread

### D3D Functions

```
#### void		draw_text(string text, v2 pos, v2 size, float scale, int color, int flags)
#### int 		register_sprite(string path)
#### void		draw_sprite(int id, v2 pos, float scale, float rot, int color)
#### v2			get_sprite_origin(int id)
#### v2			get_sprite_size(int id)
#### void		draw_line(v2 start, v2 end, int size, int color)
#### void		draw_rect(v2 pos, v2 size, int color)
```	

## Input Box

### Response codes

```
0	SUCCESS
1	PENDING
2	FAILED
```

### Input types

```
0	ASCII
1	ALPHA
2	ALPHA_NUM
3	NUM
4	NUM_DOT
5	FLOAT
```

### Input Functions

```
#### int, string 		get(string title, string default, int len, int type)
```

## RAGE

### Player Functions

```
#### Ped				get_player_ped(Player player)
#### Player				player_id()
#### void				set_player_model(Hash hash)
#### Group				get_player_group(Player player)
#### bool				is_player_female(Player player)
#### bool				is_player_friend(Player player)
#### bool				is_player_playing(Player player)
#### bool				is_player_free_aiming(Player player)
#### Entity				get_entity_player_is_aiming_at(Player player)
#### Vehicle			get_personal_vehicle()
#### void				set_player_visible_locally(Player player, bool toggle)
#### void				set_local_player_visible_locally(bool toggle)
#### void				set_player_as_modder(Player player, int flags)
#### string				get_player_name(Player player)
#### int				get_player_scid(Player player)
#### bool				is_player_pressing_horn(Player player)
#### int	 			get_player_ip(Player player)
#### bool 				is_player_modder(Player player, int mask)
#### bool 				is_player_god(Player player)
#### int				get_player_wanted_level(Player player)
#### int				player_count()
#### bool				is_player_in_any_vehicle(Player player)
#### v3					get_player_coords(Player player)
#### float				get_player_heading(Player player)
#### float				get_player_health(Player player)
#### float				get_player_max_health(Player player)
#### float				get_player_armour(Player player)
#### int				get_player_from_ped(Ped ped)
#### int				get_player_team(Player player)
#### Vehicle			get_player_vehicle(Player player)
#### bool				is_player_vehicle_god(Player player)
#### bool				is_player_host(Player player)
#### Player				get_host()
#### bool				is_player_spectating(Player player)
#### Hash				get_player_model(Player player)
#### bool				send_player_sms(Player player, string msg)
#### bool 				unset_player_as_modder(Player player, int flags)
#### int				get_player_modder_flags(Player player)
#### string				get_modder_flag_text(int flag)
#### int				get_modder_flag_ends()
#### int				add_modder_flag(string text)
#### bool				is_player_valid(Player player)
#### int				get_player_host_token(Player player)
#### int				get_player_host_priority(Player player)
#### void				set_player_targeting_mode(int mode)
```

Modder Detection Flags:

```
enum eModderDetectionFlags : unsigned long long
{
	MDF_MANUAL					= 1 << 0x00,
	MDF_PLAYER_MODEL			= 1 << 0x01,
	MDF_SCID_SPOOF				= 1 << 0x02,
	MDF_INVALID_OBJECT_CRASH	= 1 << 0x03,
	MDF_INVALID_PED_CRASH		= 1 << 0x04,
	MDF_MODEL_CHANGE_CRASH		= 1 << 0x05,
	MDF_PLAYER_MODEL_CHANGE		= 1 << 0x06,
	MDF_RAC						= 1 << 0x07,
	MDF_MONEY_DROP				= 1 << 0x08,
	MDF_SEP						= 1 << 0x09,
	MDF_ATTACH_OBJECT			= 1 << 0x0A,
	MDF_ATTACH_PED				= 1 << 0x0B,
	MDF_NET_ARRAY_CRASH			= 1 << 0x0C,
	MDF_SYNC_CRASH				= 1 << 0x0D,
	MDF_NET_EVENT_CRASH			= 1 << 0x0E,
	MDF_HOST_TOKEN				= 1 << 0x0F,
	MDF_SE_SPAM					= 1 << 0x10,
	MDF_INVALID_VEHICLE			= 1 << 0x11,
	MDF_FRAME_FLAGS				= 1 << 0x12,

	MDF_ENDS					= 1 << 0x13,
};
```

### Ped Functions

```
#### bool				is_ped_in_any_vehicle(Ped ped)
#### bool				set_group_formation(Ped group, int formation)
#### bool				set_ped_as_group_member(Ped ped, int groupId)
#### Group				get_ped_group(Ped ped)
#### int				get_group_size(int group)
#### float				get_ped_health(Ped ped)
#### bool				set_ped_health(Ped ped, float value)
#### bool				is_ped_ragdoll(Ped ped)
#### bool				is_ped_a_player(Ped ped)
#### Hash				get_current_ped_weapon(Ped ped)
#### bool				set_ped_into_vehicle(Ped ped, Vehicle vehicle, int seat)
#### int				get_ped_drawable_variation(Ped ped, int group)
#### int				get_ped_texture_variation(Ped ped, int group)
#### int				get_ped_prop_index(Ped ped, int group)
#### int				get_ped_prop_texture_index(Ped ped, int group)
#### bool				set_ped_component_variation(Ped ped, int component, int drawable, int texture, int pallette)
#### bool				set_ped_prop_index(Ped ped, int component, int drawable, int texture, int unk)
#### void				set_ped_can_switch_weapons(Ped ped, bool toggle)
#### bool				is_ped_shooting(Ped ped)
#### int				get_ped_bone_index(Ped ped, int bone)
#### bool, v3			get_ped_bone_coords(Ped ped, Hash boneId, v3 offset)
#### Hash				get_ped_relationship_group_hash(Ped ped)
#### void				set_ped_relationship_group_hash(Ped ped, Hash hash)
#### Vehicle			get_vehicle_ped_is_using(Ped ped)
#### void				clear_all_ped_props(Ped ped)
#### int				clear_ped_tasks_immediately(Ped ped)
#### void				clear_ped_blood_damage(Ped ped)
#### bool				is_ped_in_vehicle(Ped ped, Vehicle vehicle)
#### bool				is_ped_using_any_scenario(Ped ped)
#### bool				set_ped_to_ragdoll(Ped ped, int time1, int time2, int type)
#### bool				set_ped_can_ragdoll(Ped ped, bool toggle)
#### bool				can_ped_ragdoll(Ped ped)
#### bool, v3			get_ped_last_weapon_impact(Ped ped)
#### bool				set_ped_combat_ability(Ped ped, BYTE ability)
#### float				get_ped_max_health(Entity entity)
#### bool				set_ped_max_health(Entity entity, float health)
#### bool				resurrect_ped(Ped ped)
#### void				set_ped_combat_movement(Ped ped, int type)
#### void				set_ped_combat_range(Ped ped, int type)
#### void				set_ped_combat_attributes(Ped ped, int attr, bool toggle)
#### void				set_ped_accuracy(Ped ped, int accuracy)
#### Ped				create_ped(int type, Hash model, v3 pos, float heading, bool isNetworked, bool unk1)
#### int 				get_number_of_ped_drawable_variations(Ped ped, int comp)
#### int 				get_number_of_ped_texture_variations(Ped ped, int comp, int draw)
#### int 				get_number_of_ped_prop_drawable_variations(Ped ped, int groupId)
#### int 				get_number_of_ped_prop_texture_variations(Ped ped, int groupId, int drawId)
#### void				set_ped_random_component_variation(Ped ped)
#### void				set_ped_default_component_variation(Ped ped)
#### void				set_ped_movement_clipset(Ped ped, string szClipset)
#### void				reset_ped_movement_clipset(Ped ped, bool unk0)
#### Ped				clone_ped(Ped ped)
#### bool				set_ped_config_flag(Ped ped, int flag, uint8_t value)
#### bool				set_ped_ragdoll_blocking_flags(Ped ped, int flags)
#### bool				reset_ped_ragdoll_blocking_flags(Ped ped, int flags)
#### void				set_ped_density_multiplier_this_frame(float mult)
#### void				set_scenario_ped_density_multiplier_this_frame(float m1, float m2)
#### Ped[]				get_all_peds()
#### Group				create_group()
#### void				remove_group(Group group)
#### void				set_ped_as_group_leader(Ped ped, Group group)
#### void				remove_ped_from_group(Ped ped)
#### bool				is_ped_group_member(Ped ped, Group group)
#### bool				set_group_formation_spacing(Group group, float a2, float a3, float a4)
#### bool				reset_group_formation_default_spacing(Group group)
#### void				set_ped_never_leaves_group(Ped ped, bool toggle)
#### bool				does_group_exist(Group group)
#### bool				is_ped_in_group(Ped ped)
#### void				set_create_random_cops(bool t)
#### bool				can_create_random_cops()
#### bool				is_ped_swimming(Ped ped)
#### bool				is_ped_swimming_underwater(Ped ped)
#### void				clear_relationship_between_groups(Hash group1, Hash group2)
#### void				set_relationship_between_groups(int relation, Hash group1, Hash group2)
#### [...]|nil			get_ped_head_blend_data(Ped ped)
#### bool				set_ped_head_blend_data(Ped ped, int shape_first, int shape_second, int shape_third, int skin_first, int skin_second, int skin_third, float mix_shape, float mix_skin, float mix_third)
#### float|nil			get_ped_face_feature(Ped ped, uint32_t id)
#### bool				set_ped_face_feature(Ped ped, uint32_t id, float val)
#### int|nil			get_ped_hair_color(Ped ped)
#### int|nil			get_ped_hair_highlight_color(Ped ped)
#### int|nil			get_ped_eye_color(Ped ped)
#### bool				set_ped_hair_colors(Ped ped, int color, int highlight)
#### bool				set_ped_eye_color(Ped ped, int color)
#### bool				set_ped_head_overlay(Ped ped, uint32_t overlayID, int val, float opacity)
#### int|nil			get_ped_head_overlay_value(Ped ped, uint32_t overlayID)
#### float|nil			get_ped_head_overlay_opacity(Ped ped, uint32_t overlayID)
#### bool				set_ped_head_overlay_color(Ped ped, uint32_t overlayID, int colorType, int color, int highlight)
#### int|nil			get_ped_head_overlay_color_type(Ped ped, uint32_t overlayID)
#### int|nil			get_ped_head_overlay_color(Ped ped, uint32_t overlayID)
#### int|nil			get_ped_head_overlay_highlight_color(Ped ped, uint32_t overlayID)
```

### Vehicle Functions

```
#### void				set_vehicle_tire_smoke_color(Vehicle vehicle, int r, int g, int b)
#### Ped				get_ped_in_vehicle_seat(Vehicle vehicle, int seat)
#### int				get_free_seat(Vehicle vehicle)
#### bool				is_vehicle_full(Vehicle vehicle)
#### void				set_vehicle_stolen(Vehicle vehicle, bool toggle)
#### bool				set_vehicle_color(Vehicle v, BYTE p, BYTE s, BYTE pearl, BYTE wheel)
#### string				get_mod_text_label(Vehicle veh, int modType, int modValue)
#### string				get_mod_slot_name(Vehicle veh, int modType)
#### int				get_num_vehicle_mods(Vehicle veh, int modType)
#### bool				set_vehicle_mod(Vehicle vehicle, int modType, int modIndex, bool customTires)
#### int				get_vehicle_mod(Vehicle vehicle, int modType)
#### bool				set_vehicle_mod_kit_type(Vehicle vehicle, int type)
#### void				set_vehicle_extra(Vehicle veh, int extra, bool toggle)
#### bool				does_extra_exist(Vehicle veh, int extra)
#### bool				is_vehicle_extra_turned_on(Vehicle veh, int extra)
#### void				toggle_vehicle_mod(Vehicle veh, int mod, bool toggle)
#### void				set_vehicle_bulletproof_tires(Vehicle veh, bool toggle)
#### bool				is_vehicle_a_convertible(Vehicle veh)
#### bool				get_convertible_roof_state(Vehicle veh)
#### void				set_convertible_roof(Vehicle veh, bool toggle)
#### void				set_vehicle_indicator_lights(Vehicle veh, int index, bool toggle)
#### void				set_vehicle_brake_lights(Vehicle veh, bool toggle)
#### void				set_vehicle_can_be_visibly_damaged(Vehicle veh, bool toggle)
#### void				set_vehicle_engine_on(Vehicle veh, bool toggle, bool instant, bool noAutoTurnOn)
#### void				set_vehicle_fixed(Vehicle veh)
#### void				set_vehicle_deformation_fixed(Vehicle veh)
#### void				set_vehicle_undriveable(Vehicle veh, bool toggle)
#### bool				set_vehicle_on_ground_properly(Vehicle veh)
#### void				set_vehicle_forward_speed(Vehicle veh, float speed)
#### void				set_vehicle_number_plate_text(Vehicle veh, string text)
#### void				set_vehicle_door_open(Vehicle veh, int doorIndex, bool loose, bool openInstantly)
#### void				set_vehicle_doors_shut(Vehicle veh, bool closeInstantly)
#### bool				is_toggle_mod_on(Vehicle veh, int index)
#### void				set_vehicle_wheel_type(Vehicle veh, int type)
#### void				set_vehicle_number_plate_index(Vehicle veh, int index)
#### void				set_vehicle_tires_can_burst(Vehicle veh, bool toggle)
#### void				set_vehicle_tire_burst(Vehicle veh, int index, bool onRim, float unk0)
#### int 				get_num_vehicle_mod(Vehicle veh, int modType)
#### bool				is_vehicle_engine_running(Vehicle veh)
#### void				set_vehicle_engine_health(Vehicle veh, float health)
#### bool				is_vehicle_damaged(Vehicle veh)
#### bool				is_vehicle_on_all_wheels(Vehicle veh)
#### Vehicle			create_vehicle(Hash model, v3 pos, float heading, bool networked, bool alwaysFalse)
#### bool				set_vehicle_doors_locked(Vehicle vehicle, int lockStatus)
#### bool				set_vehicle_neon_lights_color(Vehicle vehicle, int color)
#### int				get_vehicle_neon_lights_color(Vehicle vehicle)
#### bool				set_vehicle_neon_light_enabled(Vehicle vehicle, int index, bool toggle)
#### bool				is_vehicle_neon_light_enabled(Vehicle vehicle, int index, bool toggle)
#### void				set_vehicle_density_multipliers_this_frame(float mult)
#### void				set_random_vehicle_density_multiplier_this_frame(float mult)
#### void				set_parked_vehicle_density_multiplier_this_frame(float mult)
#### void				set_ambient_vehicle_range_multiplier_this_frame(float mult)
#### bool				is_vehicle_rocket_boost_active(Vehicle veh)
#### void				set_vehicle_rocket_boost_active(Vehicle veh, bool toggle)
#### void				set_vehicle_rocket_boost_percentage(Vehicle veh, float percentage)
#### void				set_vehicle_rocket_boost_refill_time(Vehicle veh, float refillTime)
#### void				control_landing_gear(Vehicle veh, int32_t state)
#### int32_t			get_landing_gear_state(Vehicle veh)
#### int32_t			get_vehicle_livery(Vehicle veh)
#### bool				set_vehicle_livery(Vehicle veh, int32_t index)
#### bool				is_vehicle_stopped(Vehicle veh)
#### int32_t			get_vehicle_number_of_passengers(Vehicle veh)
#### int32_t			get_vehicle_max_number_of_passengers(Vehicle veh)
#### int32_t			get_vehicle_model_number_of_seats(Hash modelHash)
#### int32_t			get_vehicle_livery_count(Vehicle veh)
#### int32_t			get_vehicle_roof_livery_count(Vehicle veh)
#### bool				is_vehicle_model(Vehicle veh, Hash model)
#### bool				is_vehicle_stuck_on_roof(Vehicle veh)
#### void				set_vehicle_doors_locked_for_player(Vehicle veh, Player player, bool toggle)
#### bool				get_vehicle_doors_locked_for_player(Vehicle veh, Player player)
#### void				set_vehicle_doors_locked_for_all_players(Vehicle veh, bool toggle)
#### void				set_vehicle_doors_locked_for_non_script_players(Vehicle veh, bool toggle)
#### void				set_vehicle_doors_locked_for_team(Vehicle veh, int32_t team, bool toggle)
#### void				explode_vehicle(Vehicle veh, bool isAudible, bool isInvisible)
#### void				set_vehicle_out_of_control(Vehicle veh, bool killDriver, bool explodeOnImpact)
#### void				set_vehicle_timed_explosion(Vehicle veh, Ped ped, bool toggle)
#### void				add_vehicle_phone_explosive_device(Vehicle veh)
#### bool				has_vehicle_phone_explosive_device()
#### void				detonate_vehicle_phone_explosive_device()
#### void				set_taxi_lights(Vehicle veh, bool state)
#### bool				is_taxi_light_on(Vehicle veh)
#### bool				set_vehicle_colors(Vehicle veh, int32_t primary, int32_t secondary)
#### bool				set_vehicle_extra_colors(Vehicle veh, int32_t pearl, int32_t wheel)
#### int32_t			get_vehicle_primary_color(Vehicle veh)
#### int32_t			get_vehicle_secondary_color(Vehicle veh)
#### int32_t			get_vehicle_pearlecent_color(Vehicle veh)
#### int32_t			get_vehicle_wheel_color(Vehicle veh)
#### bool				set_vehicle_fullbeam(Vehicle veh, bool toggle)
#### void				set_vehicle_custom_primary_colour(Vehicle veh, uint32_t color)
#### uint32_t			get_vehicle_custom_primary_colour(Vehicle veh)
#### void				clear_vehicle_custom_primary_colour(Vehicle veh)
#### bool				is_vehicle_primary_colour_custom(Vehicle veh)
#### void				set_vehicle_custom_secondary_colour(Vehicle veh, uint32_t color)
#### uint32_t			get_vehicle_custom_secondary_colour(Vehicle veh)
#### void				clear_vehicle_custom_secondary_colour(Vehicle veh)
#### bool				is_vehicle_secondary_colour_custom(Vehicle veh)
#### void				set_vehicle_custom_pearlescent_colour(Vehicle veh, uint32_t color)
#### uint32_t			get_vehicle_custom_pearlescent_colour(Vehicle veh)
#### void				set_vehicle_custom_wheel_colour(Vehicle veh, uint32_t color)
#### uint32_t			get_vehicle_custom_wheel_colour(Vehicle veh)
#### string				get_livery_name(Vehicle veh, int32_t livery)
#### void				set_vehicle_window_tint(Vehicle veh, int32_t t)
#### int32_t			get_vehicle_window_tint(Vehicle veh)
#### Hash[]				get_all_vehicle_model_hashes()
#### Vehicle[]			get_all_vehicles()
#### void				modify_vehicle_top_speed(Vehicle veh, float f)
#### void				set_vehicle_engine_torque_multiplier_this_frame(Vehicle veh, float f)
#### int32_t			get_vehicle_headlight_color(Vehicle v)
#### bool				set_vehicle_headlight_color(Vehicle v, int32_t color)
#### void				set_heli_blades_full_speed(Vehicle v)
#### void				set_heli_blades_speed(Vehicle v, float speed)
#### void				set_vehicle_parachute_active(Vehicle v, bool toggle)
#### bool				does_vehicle_have_parachute(Vehicle v)
#### bool				can_vehicle_parachute_be_activated(Vehicle v)
#### void				set_vehicle_can_be_locked_on(Vehicle veh, bool toggle, bool skipSomeCheck)
#### int|nil			get_vehicle_current_gear(Vehicle veh)
#### bool				set_vehicle_current_gear(Vehicle veh, int gear)
#### int|nil			get_vehicle_next_gear(Vehicle veh)
#### bool				set_vehicle_next_gear(Vehicle veh, int gear)
#### int|nil			get_vehicle_max_gear(Vehicle veh)
#### bool				set_vehicle_max_gear(Vehicle veh, int gear)
#### float|nil			get_vehicle_gear_ratio(Vehicle veh, int gear)
#### bool				set_vehicle_gear_ratio(Vehicle veh, int gear, float ratio)
#### float|nil			get_vehicle_rpm(Vehicle veh)
#### bool				get_vehicle_has_been_owned_by_player(Vehicle veh)
#### bool				set_vehicle_has_been_owned_by_player(Vehicle veh, bool owned)
#### float|nil			get_vehicle_steer_bias(Vehicle veh)
#### bool				set_vehicle_steer_bias(Vehicle veh, float v)
#### bool				get_vehicle_reduce_grip(Vehicle veh)
#### bool				set_vehicle_reduce_grip(Vehicle veh, bool t)
#### float				get_vehicle_estimated_max_speed(Vehicle veh)
#### int|nil			get_vehicle_wheel_count(Vehicle veh)
#### float|nil			get_vehicle_wheel_tire_radius(Vehicle veh, int idx)
#### float|nil			get_vehicle_wheel_rim_radius(Vehicle veh, int idx)
#### float|nil			get_vehicle_wheel_tire_width(Vehicle veh, int idx)
#### float|nil			get_vehicle_wheel_rotation_speed(Vehicle veh, int idx)
#### bool				set_vehicle_wheel_tire_radius(Vehicle veh, int idx, float v)
#### bool				set_vehicle_wheel_rim_radius(Vehicle veh, int idx, float v)
#### bool				set_vehicle_wheel_tire_width(Vehicle veh, int idx, float v)
#### bool				set_vehicle_wheel_rotation_speed(Vehicle veh, int idx, float v)
#### float|nil			get_vehicle_wheel_render_size(Vehicle veh)
#### bool				set_vehicle_wheel_render_size(Vehicle veh, float size)
#### float|nil			get_vehicle_wheel_render_width(Vehicle veh)
#### bool				set_vehicle_wheel_render_width(Vehicle veh, float width)
#### void				set_vehicle_tire_fixed(Vehicle veh, int idx)
#### float|nil			get_vehicle_wheel_power(Vehicle veh, int idx)
#### bool				set_vehicle_wheel_power(Vehicle veh, int idx, float v)
#### float|nil			get_vehicle_wheel_health(Vehicle veh, int idx)
#### bool				set_vehicle_wheel_health(Vehicle veh, int idx, float v)
#### float|nil			get_vehicle_wheel_brake_pressure(Vehicle veh, int idx)
#### bool				set_vehicle_wheel_brake_pressure(Vehicle veh, int idx, float v)
#### float|nil			get_vehicle_wheel_traction_vector_length(Vehicle veh, int idx)
#### bool				set_vehicle_wheel_traction_vector_length(Vehicle veh, int idx, float v)
#### float|nil			get_vehicle_wheel_x_offset(Vehicle veh, int idx)
#### bool				set_vehicle_wheel_x_offset(Vehicle veh, int idx, float v)
#### float|nil			get_vehicle_wheel_y_rotation(Vehicle veh, int idx)
#### bool				set_vehicle_wheel_y_rotation(Vehicle veh, int idx, float v)
#### int				get_vehicle_wheel_flags(Vehicle veh, int idx)
#### bool				set_vehicle_wheel_flags(Vehicle veh, int idx, int v)
#### bool				set_vehicle_wheel_is_powered(Vehicle veh, int idx, int v)
#### int|nil			get_vehicle_class(Vehicle veh)
#### string|nil			get_vehicle_class_name(Vehicle veh)
#### string|nil			get_vehicle_brand(Vehicle veh)
#### string|nil			get_vehicle_model(Vehicle veh)
#### string|nil			get_vehicle_brand_label(Vehicle veh)
#### string|nil			get_vehicle_model_label(Vehicle veh)
```

### Entity Functions

```
#### v3					get_entity_coords(Entity entity)
#### bool				set_entity_coords_no_offset(Entity entity, pos)
#### v3					get_entity_rotation(Entity entity)
#### bool				set_entity_rotation(Entity entity, v3 rot)
#### bool				set_entity_heading(Entity entity, float heading)
#### bool				set_entity_velocity(Entity entity, v3 velocity)
#### v3					get_entity_velocity(Entity entity)
#### bool				is_an_entity(Entity entity)
#### bool				is_entity_a_ped(Entity entity)
#### bool				is_entity_a_vehicle(Entity entity)
#### bool				is_entity_an_object(Entity entity)
#### bool				is_entity_dead(Entity entity)
#### bool				is_entity_on_fire(Entity entity)
#### bool				is_entity_visible(Entity entity)
#### bool				is_entity_attached(Entity entity)
#### bool				set_entity_visible(Entity entity, bool toggle)
#### int				get_entity_type(Entity entity)
#### bool				set_entity_gravity(Entity entity, bool gravity)
#### void				apply_force_to_entity(Ped ped, int forceType, float x, float y, float z, float rx, float ry, float rz, bool isRel, bool highForce)
#### Entity				get_entity_attached_to(Entity entity)
#### bool				detach_entity(Entity e)
#### Hash				get_entity_model_hash(Entity e)
#### float				get_entity_heading(Entity entity)
#### bool				attach_entity_to_entity(Entity subject, Entity target, int boneIndex, v3 offset, v3 rot, bool softPinning, bool collision, bool isPed, int vertexIndex, bool fixedRot)
#### void				set_entity_as_mission_entity(Entity entity, bool toggle, bool unk)
#### bool				set_entity_collision(Entity entity, bool toggle, bool physics, bool unk0)
#### bool				is_entity_in_air(Entity entity)
#### bool				set_entity_as_no_longer_needed(Entity entity)
#### bool				set_entity_no_collsion_entity(Entity entity, Entity target, bool unk)
#### void				freeze_entity(Entity entity, bool toggle)
#### bool, v3			get_entity_offset_from_coords(Entity lEntity, v3 coords)
#### bool, v3			get_entity_offset_from_entity(Entity lEntity, Entity lEntity2)
#### void				set_entity_alpha(Entity entity, int alpha, bool skin)
#### void				reset_entity_alpha(Entity entity)
#### bool				delete_entity(Entity e)
#### void				set_entity_god_mode(Entity entity, bool toggle)
#### bool				get_entity_god_mode(Entity entity)
#### bool				is_entity_in_water(Entity entity)
#### float				get_entity_speed(Entity entity)
#### void				set_entity_lights(Entity entity, bool toggle)
#### void				set_entity_max_speed(Entity entity, float speed)
#### float				get_entity_pitch(Entity entity)
#### float				get_entity_roll(Entity e)
#### v3					get_entity_physics_rotation(Entity e)
#### float				get_entity_physics_heading(Entity e)
#### float				get_entity_physics_pitch(Entity e)
#### float				get_entity_physics_roll(Entity e)
#### bool				does_entity_have_physics(Entity entity)
#### v3					get_entity_rotation_velocity(Entity entity)
#### float				get_entity_submerged_level(Entity entity)
#### int32_t			get_entity_population_type(Entity entity)
#### bool				is_entity_static(Entity entity)
#### bool				is_entity_in_zone(Entity entity, string zone)
#### bool				is_entity_upright(Entity entity, float angle)
#### bool				is_entity_upside_down(Entity entity)
#### bool				has_entity_been_damaged_by_any_object(Entity entity)
#### bool				has_entity_been_damaged_by_any_vehicle(Entity entity)
#### bool				has_entity_been_damaged_by_any_ped(Entity entity)
#### bool				has_entity_been_damaged_by_entity(Entity e1, Entity e2)
#### bool				does_entity_have_drawable(Entity entity)
#### bool				has_entity_collided_with_anything(Entity entity)
#### Entity				get_entity_entity_has_collided_with(Entity entity)
#### int				get_entity_bone_index_by_name(Entity entity, string name)
```

### Object Functions

```
#### Object				create_object(Hash model, v3 pos, bool networked, bool dynamic)
#### Object				create_world_object(Hash model, v3 pos, bool networked, bool dynamic)
#### Object[]			get_all_objects()
#### Pickup[]			get_all_pickups()
```

### Weapon Functions

```
#### void				give_delayed_weapon_to_ped(Ped ped, Hash hash, int time, bool equipNow)
#### int 				get_weapon_tint_count(Hash weapon)
#### int 				get_ped_weapon_tint_index(Ped ped, Hash weapon)
#### void				set_ped_weapon_tint_index(Ped ped, Hash weapon, int index)
#### void				give_weapon_component_to_ped(Ped ped, Hash weapon, Hash component)
#### void				remove_all_ped_weapons(Ped ped)
#### void				remove_weapon_from_ped(Ped ped, Hash weapon)
#### bool,int			get_max_ammo(Ped ped, Hash weapon)
#### bool				set_ped_ammo(Ped ped, Hash weapon, int ammo)
#### void				remove_weapon_component_from_ped(Ped ped, Hash weapon, Hash component)
#### bool				has_ped_got_weapon_component(Ped ped, Hash weapon, Hash component)
#### Hash				get_ped_ammo_type_from_weapon(Ped ped, Hash weapon)
#### void				set_ped_ammo_by_type(Ped ped, Hash type, uint32_t amount)
#### bool				has_ped_got_weapon(Ped ped, Hash weapon)
#### Hash[]				get_all_weapon_hashes()
#### string				get_weapon_name(Hash weapon)
#### int				get_weapon_weapon_wheel_slot(Hash weapon)
#### Hash				get_weapon_model(Hash weapon)
#### Hash				get_weapon_audio_item(Hash weapon)
#### Hash				get_weapon_slot(Hash weapon)
#### int				get_weapon_ammo_type(Hash weapon)
#### Hash				get_weapon_weapon_group(Hash weapon)
#### Hash				get_weapon_weapon_type(Hash weapon)
#### Hash				get_weapon_pickup(Hash weapon)
```

### Streaming Functions

```
#### bool				request_model(Hash hash)
#### bool				has_model_loaded(Hash hash)
#### bool				set_model_as_no_longer_needed(Hash hash)
#### bool				is_model_in_cdimage(Hash hash)
#### bool				is_model_valid(Hash hash)
#### bool				is_model_a_plane(Hash hash)
#### bool				is_model_a_vehicle(Hash hash)
#### bool				is_model_a_heli(Hash hash)
#### void				request_ipl(string szName)
#### void				remove_ipl(string szName)
#### void				request_anim_set(string szName)
#### bool				has_anim_set_loaded(string szName)
#### void				request_anim_dict(string szName)
#### bool				has_anim_dict_loaded(string szName)
#### bool				is_model_a_bike(Hash ulHash)
#### bool				is_model_a_car(Hash ulHash)
#### bool				is_model_a_bicycle(Hash ulHash)
#### bool				is_model_a_quad(Hash ulHash)
#### bool				is_model_a_boat(Hash ulHash)
#### bool				is_model_a_train(Hash ulHash)
#### bool				is_model_an_object(Hash ulHash)
#### bool				is_model_a_world_object(Hash ulHash)
#### bool				is_model_a_ped(Hash ulHash)
#### void				remove_anim_dict(string szName)
#### void				remove_anim_set(string szName)
```
### UI Functions

```
#### void				notify_above_map(string message, string title, int color)
#### Entity				get_entity_from_blip(Blip blip)
#### Blip				get_blip_from_entity(Entity entity)
#### Blip				add_blip_for_entity(Entity entity)
#### bool				set_blip_sprite(Blip blip, int spriteId)
#### bool				set_blip_colour(Blip blip, int colour)
#### void				hide_hud_component_this_frame(int componentId)
#### void				hide_hud_and_radar_this_frame()
#### string				get_label_text(string label)
#### void				draw_rect(float x, float y, float width, float height, int r, int g, int b, int a)
#### void				draw_line(v3 pos1, v3 pos2, int r, int g, int b, int a)
#### void				draw_text(string pszText, v2 pos)
#### void				set_text_scale(float scale)
#### void				set_text_color(int r, int g, int b, int a)
#### void				set_text_font(int font)
#### void				set_text_wrap(float start, float end)
#### void				set_text_outline(bool b)
#### void				set_text_centre(bool b)
#### void				set_text_right_justify(bool b)
#### void				set_text_justification(int j)
#### void				set_new_waypoint(v2 coord)
#### v2					get_waypoint_coord()
#### bool				is_hud_component_active(int32_t componentId)
#### void				show_hud_component_this_frame(int32_t componentId)
#### void				set_waypoint_off()
#### bool				set_blip_as_mission_creator_blip(Blip blip, bool toggle)
#### bool				is_mission_creator_blip(Blip blip)
#### Blip				add_blip_for_radius(v3 pos, float radius)
#### Blip				add_blip_for_pickup(Pickup pickup)
#### Blip				add_blip_for_coord(v3 pos)
#### void				set_blip_coord(Blip blip, v3 coord)
#### v3					get_blip_coord(Blip blip)
#### bool				remove_blip(Blip blip)
#### void				set_blip_route(Blip blip, bool toggle)
#### void				set_blip_route_color(Blip blip, int32_t color)
#### int				get_current_notification()
#### void				remove_notification(int id)
#### bool, v3|nil		get_objective_coord()
```

### ScriptDraw Functions

```
#### void				draw_text(string text, v2 pos, v2 size, float scale, uint32_t color, uint32_t flags, int|nil font)
#### uint32_t			register_sprite(string path)
#### v2					get_sprite_origin(uint32_t id)
#### v2					get_sprite_size(uint32_t id)
#### v2					get_text_size(string text, float|nil scale, int|nil font)
#### void				draw_sprite(uint32_t id, v2 pos, float scale, float rot, uint32_t color)
#### void				draw_line(v2 start, v2 end, uint32_t size, uint32_t color)
#### void				draw_rect(v2 pos, v2 size, uint32_t color)
#### float				pos_pixel_to_rel_x(float in)
#### float				pos_pixel_to_rel_y(float in)
#### float				pos_rel_to_pixel_x(float in)
#### float				pos_rel_to_pixel_y(float in)
#### float				size_pixel_to_rel_x(float in)
#### float				size_pixel_to_rel_y(float in)
#### float				size_rel_to_pixel_x(float in)
#### float				size_rel_to_pixel_y(float in)
```

```
enum eDrawTextFlags
{
	TEXTFLAG_NONE			= 0,
	TEXTFLAG_CENTER			= 1 << 0,
	TEXTFLAG_SHADOW			= 1 << 1,
	TEXTFLAG_VCENTER		= 1 << 2,
	TEXTFLAG_BOTTOM			= 1 << 3,
	TEXTFLAG_JUSTIFY_RIGHT = 1 << 4,
};
```

### Cam Functions

```
#### v3					get_gameplay_cam_rot()
#### v3					get_gameplay_cam_pos()
#### float				get_gameplay_cam_relative_pitch()
#### float				get_gameplay_cam_relative_yaw()
```

### Gameplay Functions

```
#### Hash				get_hash_key(string in)
#### void				display_onscreen_keyboard(string title, string default_text, int maxLength)
#### bool				update_onscreen_keyboard()
#### string				get_onscreen_keyboard_result()
#### bool				is_onscreen_keyboard_active()
#### void				set_override_weather(int weatherIndex)
#### void				clear_override_weather()
#### void				set_blackout(bool toggle)
#### void				set_mobile_radio(bool toggle)
#### int				get_game_state()
#### bool				is_game_state(int)
#### void				clear_area_of_objects(v3 coord, float radius, int flags)
#### void				clear_area_of_vehicles(v3 coord, float radius, bool a3, bool a4, bool a5, bool a6, bool a7)
#### void				clear_area_of_peds(v3 coord, float radius, bool a3)
#### void				clear_area_of_cops(v3 coord, float radius, bool a3)
#### void				set_cloud_hat_opacity(float opacity)
#### float				get_cloud_hat_opacity()
#### void				preload_cloud_hat(string szName)
#### void				clear_cloud_hat()
#### void				load_cloud_hat(string szName, float transitionTime)
#### void				unload_cloud_hat(string szName, float a2)
#### bool, float		get_ground_z(v3 pos)
#### uint64_t			get_frame_count()
#### float				get_frame_time()
#### bool				shoot_single_bullet_between_coords(v3 start, v3 end, int32_t damage, Hash weapon, Ped owner, bool audible, bool invisible, float speed)
```

### Fire Functions

```
#### bool				add_explosion(v3 pos, int type, bool isAudible, bool isInvis, float fCamShake, Ped owner)
#### Ped				start_entity_fire(Ped ped)
#### void				stop_entity_fire(Ped ped)
```

### Network Functions

```
#### bool				network_is_host()
#### bool				has_control_of_entity(Entity entity)
#### bool				request_control_of_entity(Entity entity)
#### bool				is_session_started()
#### void				network_session_kick_player(Player player)
#### bool				is_friend_online(string name)
#### bool				is_friend_in_multiplayer(string name)
#### uint32_t			get_friend_scid(string name)
#### uint32_t			get_friend_count()
#### uint32_t			get_max_friends()
#### Hash				network_hash_from_player(Player player)
#### string|nil			get_friend_index_name(uint32_t index)
#### bool				is_friend_index_online(uint32_t index)
#### bool				is_scid_friend(uint32_t scid)
#### Entity|nil			get_entity_player_is_spectating(Player player)
#### Player|nil			get_player_player_is_spectating(Player player)
#### bool				send_chat_message(string msg, bool teamOnly)
```

### Cutscene Functions

```
#### void				stop_cutscene_immediately()
#### void				remove_cutscene()
#### bool				is_cutscene_active()
#### bool				is_cutscene_playing()
```

### Control Functions

```
#### bool				disable_control_action(int inputGroup, int control, bool disable)
#### bool				is_control_just_pressed(int inputGroup, int control)
#### bool				is_disabled_control_just_pressed(int inputGroup, int control)
#### bool				is_control_pressed(int inputGroup, int control)
#### bool				is_disabled_control_pressed(int inputGroup, int control)
#### float				get_control_normal(int inputGroup, int control)
#### bool				set_control_normal(int inputGroup, int control, float value)
```

### Graphics Functions

```
#### int				get_screen_height()
#### int				get_screen_width()
#### void				request_named_ptfx_asset(string asset)
#### bool				has_named_ptfx_asset_loaded(string asset)
#### void				remove_named_ptfx_asset(string name)
#### void				set_next_ptfx_asset(string asset)
#### void				set_next_ptfx_asset_by_hash(Hash hash)
#### Ptfx				start_ptfx_looped_on_entity(string name, Entity e, v3 offset, v3 rot, float scale)
#### bool				start_ptfx_non_looped_on_entity(string name, Entity e, v3 offset, v3 rot, float scale)
#### Ptfx				start_networked_ptfx_looped_on_entity(string name, Entity e, v3 offset, v3 rot, float scale)
#### bool				start_networked_ptfx_non_looped_on_entity(string name, Entity e, v3 offset, v3 rot, float scale)
#### void				remove_ptfx_from_entity(Entity)
#### bool				does_looped_ptfx_exist(Ptfx ptfx)
#### Ptfx				start_ptfx_looped_at_coord(string name, v3 pos, v3 rot, float scale, bool xAxis, bool yAxis, bool zAxis)
#### bool				start_ptfx_non_looped_at_coord(string name, v3 pos, v3 rot, float scale, bool xAxis, bool yAxis, bool zAxis)
#### bool				start_networked_ptfx_non_looped_at_coord(string name, v3 pos, v3 rot, float scale, bool xAxis, bool yAxis, bool zAxis)
#### Ptfx				start_networked_ptfx_looped_at_coord(string name, v3 pos, v3 rot, float scale, bool xAxis, bool yAxis, bool zAxis)
#### void				remove_particle_fx(Ptfx ptfx, bool a2)
#### void				remove_ptfx_in_range(v3 pos, float range)
#### void				set_ptfx_looped_offsets(Ptfx ptfx, v3 pos, v3 rot)
#### void				set_ptfx_looped_evolution(Ptfx ptfx, string propertyName, float amount, bool a4)
#### void				set_ptfx_looped_color(Ptfx ptfx, float r, float b, float g, bool a5)
#### void				set_ptfx_looped_alpha(Ptfx ptfx, float a)
#### void				set_ptfx_looped_scale(Ptfx ptfx, float scale)
#### void				set_ptfx_looped_far_clip_dist(Ptfx ptfx, float dist)
#### void				enable_clown_blood_vfx(bool toggle)
#### void				enable_alien_blood_vfx(bool toggle)
#### void				animpostfx_play(Hash effect, int32_t duration, bool looped)
#### void				animpostfx_stop(Hash effect)
#### bool				animpostfx_is_running(Hash effect)
#### void				animpostfx_stop_all()
#### Any				request_scaleform_movie(string szName)
#### bool				begin_scaleform_movie_method(Any scaleform, string szMethod)
#### void				scaleform_movie_method_add_param_texture_name_string(string val)
#### void				scaleform_movie_method_add_param_int(int32_t val)
#### void				scaleform_movie_method_add_param_float(float val)
#### void				scaleform_movie_method_add_param_bool(bool val)
#### void				draw_scaleform_movie_fullscreen(Any scaleform, int r, int g, int b, int a, int a6)
#### void				draw_scaleform_movie(Any scaleform, float x, float y, float w, float h, int r, int g, int b, int a, int a10)
#### void				end_scaleform_movie_method()
#### void				draw_marker(Any type, v3 pos, v3 dir, v3 rot, v3 scale, int red, int green, int blue, int alpha, bool bobUpAndDown, bool faceCam, int a12, bool rotate, string|nil textureDict, string|nil textureName, bool drawOntEnts)
#### Any				create_checkpoint(Any type, v3 thisPos, v3 nextPos, float radius, int red, int green, int blue, int alpha, int reserved)
#### void				set_checkpoint_icon_height(Any checkpoint, float height)
#### void				set_checkpoint_cylinder_height(Any checkpoint, float nearHeight, float farHeight, float radius)
#### void				set_checkpoint_rgba(Any checkpoint, int r, int g, int b, int a)
#### void				set_checkpoint_icon_rgba(Any checkpoint, int r, int g, int b, int a)
#### void				delete_checkpoint(Any checkpoint)
#### bool				has_scaleform_movie_loaded(Any scaleform)
#### void				set_scaleform_movie_as_no_longer_needed(Any scaleform)
```

### Time Functions

```
#### void				set_clock_time(int hour, int minute, int second)
#### int				get_clock_hours()
#### int				get_clock_minutes()
#### int				get_clock_seconds()
```

### AI Functions

```
#### void				task_goto_entity(Entity e, Entity target, int duration, float distance, float speed)
#### bool				task_combat_ped(Ped ped, Ped target, int a3, int a4)
#### Any				task_go_to_coord_by_any_means(Ped ped, v3 coords, float speed, Any p4, bool p5, int walkStyle, float a7)
#### bool				task_wander_standard(Ped ped, float unk0, bool unk1)
#### void				task_vehicle_drive_wander(Ped ped, Vehicle vehicle, float speed, int driveStyle)
#### void				task_start_scenario_in_place(Ped ped, string name, int unkDelay, bool playEnterAnim)
#### void				task_start_scenario_at_position(Ped ped, string name, v3 coord, float heading, int duration, bool sittingScenario, bool teleport)
#### void				task_stand_guard(Ped ped, v3 coord, float heading, string name)
#### void				play_anim_on_running_scenario(Ped ped, string dict, string name)
#### bool				does_scenario_group_exist(string name)
#### bool				is_scenario_group_enabled(string name)
#### bool				set_scenario_group_enabled(string name, bool b)
#### void				reset_scenario_groups_enabled()
#### bool				set_exclusive_scenario_group(string name)
#### bool				reset_exclusive_scenario_group()
#### bool				is_scenario_type_enabled(string name)
#### bool				set_scenario_type_enabled(string name, bool b)
#### void				reset_scenario_types_enabled()
#### bool				is_ped_active_in_scenario(Ped ped)
#### void				task_follow_to_offset_of_entity(Ped ped, Entity entity, v3 offset, float speed, int timeout, float stopRange, bool persistFollowing)
#### void				task_vehicle_drive_to_coord_longrange(Ped ped, Vehicle vehicle, v3 pos, float speed, int mode, float stopRange)
#### void				task_shoot_at_entity(Entity entity, Entity target, int duration, Hash firingPattern)
#### void				task_vehicle_escort(Ped ped, Vehicle vehicle, Vehicle targetVehicle, int mode, float speed, int drivingStyle, float minDistance, int a8, float noRoadsDistance)
#### void				task_vehicle_follow(Ped driver, Vehicle vehicle, Entity targetEntity, float speed, int drivingStyle, int minDistance)
#### void				task_vehicle_drive_to_coord(Ped ped, Vehicle vehicle, v3 coord, float speed, int a5, Hash vehicleModel, int driveMode, float stopRange, float a9)
#### void				task_vehicle_shoot_at_coord(Ped ped, v3 coord, float a3)
#### void				task_vehicle_shoot_at_ped(Ped ped, Ped target, float a3)
#### void				task_vehicle_aim_at_coord(Ped ped, v3 coord)
#### void				task_vehicle_aim_at_ped(Ped ped, Ped target)
#### void				task_stay_in_cover(Ped ped)
#### void				task_go_to_coord_while_aiming_at_coord(Ped ped, v3 gotoCoord, v3 aimCoord, float moveSpeed, bool a5, float a6, float a7, bool a8, Any flags, bool a10, Hash firingPattern)
#### void				task_go_to_coord_while_aiming_at_entity(Ped ped, v3 gotoCoord, Entity target, float moveSpeed, bool a5, float a6, float a7, bool a8, Any flags, bool a10, Hash firingPattern)
#### void				task_go_to_entity_while_aming_at_coord(Ped ped, Entity gotoEntity, v3 aimCoord, float a4, bool shoot, float a6, float a7, bool a8, bool a9, Hash firingPattern)
#### void				task_go_to_entity_while_aiming_at_entity(Ped ped, Entity gotoEntity, Entity target, float a4, bool shoot, float a6, float a7, bool a8, bool a9, Hash firingPattern)
#### void				task_open_vehicle_door(Ped ped, Vehicle vehicle, int timeOut, int doorIndex, float speed)
#### void				task_enter_vehicle(Ped ped, Vehicle vehicle, int timeout, int seat, float speed, uint32_t flag, Any p6)
#### void				task_leave_vehicle(Ped ped, Vehicle vehicle, uint32_t flag)
#### void				task_sky_dive(Ped ped, bool a2)
#### void				task_parachute(Ped ped, bool a2, bool a3)
#### void				task_parachute_to_target(Ped ped, v3 coord)
#### void				set_parachute_task_target(Ped ped, v3 coord)
#### void				set_parachute_task_thrust(Ped ped, float thrust)
#### void				task_rappel_from_heli(Ped ped, float a2)
#### void				task_vehicle_chase(Ped driver, Entity target)
#### void				set_task_vehicle_chase_behaviour_flag(Ped ped, int flag, bool set)
#### void				set_task_vehicle_chase_ideal_persuit_distance(Ped ped, float dist)
#### void				task_shoot_gun_at_coord(Ped ped, v3 coord, int duration, Hash firingPattern)
#### void				task_aim_gun_at_coord(Ped ped, v3 coord, int time, bool a4, bool a5)
#### void				task_turn_ped_to_face_entity(Ped ped, Entity entity, int duration)
#### void				task_aim_gun_at_entity(Ped ped, Entity entity, int duration, bool a4)
#### bool				is_task_active(Ped ped, Any taskId)
#### bool				task_play_anim(Ped ped, string dict, string anim, float speed, float speedMult, int duration, int flag, float playbackRate, bool lockX, bool lockY, bool lockZ)
#### void				stop_anim_task(Ped ped, const char* dict, const char* anim, float a4)
```

<https://pastebin.com/2gFqJ3Px>


### Decorator Functions

```
#### void				decor_register(string name, int type)
#### bool				decor_exists_on(Entity e, string decor)
#### bool				decor_remove(Entity e, string decor)
#### int				decor_get_int(Entity entity, string name)
#### bool				decor_set_int(Entity entity, string name, int value)
#### float				decor_get_float(Entity entity, string name)
#### bool				decor_set_float(Entity entity, string name, float value)
#### bool				decor_get_bool(Entity entity, string name)
#### bool				decor_set_bool(Entity entity, string name, bool value)
#### bool				decor_set_time(Entity entity, string name, int value)
```

### Interior Functions

```
#### Any				get_interior_from_entity(Entity entity)
#### Any				get_interior_at_coords_with_type(const v3 coords, string interiorType)
#### void				enable_interior_prop(Any id, string prop)
#### void				disable_interior_prop(Any id, string prop)
#### void				refresh_interior(Any id)
```

### Water Functions

```
#### float				get_waves_intensity()
#### void				set_waves_intensity(float intensity)
#### void				reset_waves_intensity()
```

### Stats Functions

```
#### int32_t|nil		stat_get_int(Hash hash, int unk0)
#### float|nil			stat_get_float(Hash hash, int unk0)
#### bool|nil			stat_get_bool(Hash hash, int unk0)
#### bool				stat_set_int(Hash hash, int32_t value, bool save)
#### bool				stat_set_float(Hash hash, float value, bool save)
#### bool				stat_set_bool(Hash hash, bool value, bool save)
#### int64_t			stat_get_i64(Hash hash)
#### bool				stat_set_i64(Hash hash, int64_t v, uint32_t|nil flags)
#### uint64_t			stat_get_u64(Hash hash)
#### bool				stat_set_u64(Hash hash, uint64_t v, uint32_t|nil flags)
#### int32_t|nil		stat_get_masked_int(Hash hash, int mask, int a3, int|nil a4)
#### bool				stat_set_masked_int(Hash hash, int32_t val, int mask, int a4, bool save)
#### bool|nil			stat_get_masked_bool(Hash hash, int mask, int|nil a3)
#### bool				stat_set_masked_bool(Hash hash, bool val, int mask, int a4, bool save)
#### hash, int			stat_get_bool_hash_and_mask(string stat, int index, int character)
#### hash, int			stat_get_int_hash_and_mask(string stat, int index, int character)
```

### Script Functions

```
#### void 				trigger_script_event(int eventId, Player player, int[] params)
#### Player 			get_host_of_this_script()
#### float|nil			get_global_f(uint32_t i)
#### int|nil			get_global_i(uint32_t i)
#### bool				set_global_f(uint32_t i, float v)
#### bool				set_global_i(uint32_t i, int v)
#### float|nil			get_local_f(Hash script, uint32_t i)
#### int|nil			get_local_i(Hash script, uint32_t i)
#### bool				set_local_f(Hash script, uint32_t i, float v)
#### bool				set_local_i(Hash script, uint32_t i, int v)
```

### Audio Functions

```
#### void				play_sound(int soundId, string audioName, string audioRef, bool p4, Any p5, bool p6)
#### void				play_sound_frontend(int soundId, string audioName, string audioRef, bool p4)
#### void				play_sound_from_entity(int soundId, string audioName, Entity entity, string audioRef)
#### void				play_sound_from_coord(int soundId, string audioName, v3 pos, string audioRef, bool a5, int range, bool a7)
#### void				stop_sound(int soundId)
```

### Worldprobe Functions

```
#### bool hit, v3 hitPos, v3 hitSurf, Hash hitMat, Entity hitEnt 	raycast(v3 start, v3 end, int intersect, Entity ignore)
```

```
enum eRayIntersect : unsigned
{
	RAYINT_MAP			= 1 << 0,
	RAYINT_VEH			= 1 << 1,
	RAYINT_PED			= 1 << 2,
	RAYINT_PED2			= 1 << 3,
	RAYINT_OBJECT		= 1 << 4,
	RAYINT_UNK0			= 1 << 5,
	RAYINT_UNK1			= 1 << 6,
	RAYINT_UNK2			= 1 << 7,
	RAYINT_VEGETATION	= 1 << 8,
};
```

### Rope Functions

```
#### void				rope_load_textures()
#### void				rope_unload_textures()
#### bool				rope_are_textures_loaded()
#### int				add_rope(v3 pos, v3 rot, float maxLen, int ropeType, float initLength, float minLength, float lengthChangeRate, bool onlyPPU, bool collisionOn, bool lockFromFront, float timeMultiplier, bool breakable)
#### bool				does_rope_exist(int rope)
#### bool				delete_rope(int rope)
#### void				attach_rope_to_entity(int rope, Entity e, v3 offset, bool a3)
#### void				attach_entities_to_rope(int rope, Entity ent1, Entity ent2, v3 pos_ent1, v3 pos_ent2, float len, int a7, int a8, string|nil boneName1, string|nil boneName2)
#### void				detach_rope_from_entity(int rope, Entity entity)
#### void				start_rope_unwinding_front(int rope)
#### void				start_rope_winding(int rope)
#### void				stop_rope_unwinding_front(int rope)
#### void				stop_rope_winding(int rope)
#### void				rope_force_length(int rope, float len)
#### void				activate_physics(Entity entity)
```

### System Functions

```
#### void				wait(int ms)
#### void				yield(int ms)
```

### Utils Functions

```
#### int				str_to_vk(string keyName)
#### string[]			get_all_files_in_directory(string path, string extension)
#### string[]			get_all_sub_directories_in_directory(string path)
#### bool				file_exists(string path)
#### bool				dir_exists(string path)
#### bool 				make_dir(string path)
#### string 			get_appdata_path(string dir, string file)
#### string				from_clipboard()
#### void				to_clipboard(string str)
#### int				time()
#### int				time_ms()
#### uint64_t[]			str_to_vecu64(string str)
#### string				vecu64_to_str(uint64_t[] vec)
```
