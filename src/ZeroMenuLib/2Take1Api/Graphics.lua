Graphics = {}
Graphics.__index = Graphics

function Graphics:get_screen_height()end
function Graphics:get_screen_width()end
function Graphics:request_named_ptfx_asset(asset)end
function Graphics:has_named_ptfx_asset_loaded(asset)end
function Graphics:set_next_ptfx_asset(asset)end
function Graphics:set_next_ptfx_asset_by_hash(hash)end
function Graphics:start_ptfx_looped_on_entity(name, e, offset, rot, scale)end
function Graphics:start_ptfx_non_looped_on_entity(name, e, offset, rot, scale)end
function Graphics:remove_ptfx_from_entity(Entity)end
function Graphics:does_looped_ptfx_exist(ptfx)end
function Graphics:start_particle_fx_looped_at_coord(name, pos, rot, scale, xAxis, yAxis, zAxis, a8)end
function Graphics:start_particle_fx_non_looped_at_coord(name, pos, rot, scale, xAxis, yAxis, zAxis)end
function Graphics:start_networked_particle_fx_non_looped_at_coord(name, pos, rot, scale, xAxis, yAxis, zAxis)end
function Graphics:remove_particle_fx(ptfx, a2)end
function Graphics:remove_particle_fx_in_range(pos, range)end
function Graphics:set_particle_fx_looped_offsets(ptfx, pos, rot)end
function Graphics:set_particle_fx_looped_evolution(ptfx, propertyName, amount, a4)end
function Graphics:set_particle_fx_looped_color(ptfx, r, b, g, a5)end
function Graphics:set_particle_fx_looped_alpha(ptfx, a)end
function Graphics:set_particle_fx_looped_scale(ptfx, scale)end
function Graphics:set_particle_fx_looped_far_clip_dist(ptfx, dist)end
function Graphics:enable_clown_blood_vfx(toggle)end
function Graphics:enable_alien_blood_vfx(toggle)end
function Graphics:animpostfx_play(effect, duration, looped)end
function Graphics:animpostfx_stop(effect)end
function Graphics:animpostfx_is_running(effect)end
function Graphics:animpostfx_stop_all()end
function Graphics:request_scaleform_movie(szName)end
function Graphics:begin_scaleform_movie_method(scaleform, szMethod)end
function Graphics:scaleform_movie_method_add_param_texture_name_string(val)end
function Graphics:scaleform_movie_method_add_param_int(val)end
function Graphics:scaleform_movie_method_add_param_float(val)end
function Graphics:scaleform_movie_method_add_param_bool(val)end
function Graphics:draw_scaleform_movie_fullscreen(scaleform, r, g, b, a, a6)end
function Graphics:draw_scaleform_movie(scaleform, x, y, w, h, r, g, b, a, a10)end
function Graphics:end_scaleform_movie_method()end
function Graphics:draw_marker(type, pos, dir, rot, scale, red, green, blue, alpha, bobUpAndDown, faceCam, a12, rotate, textureDict, textureName, drawOntEnts)end
function Graphics:create_checkpoint(type, thisPos, nextPos, radius, red, green, blue, alpha, reserved)end
function Graphics:set_checkpoint_icon_height(checkpoint, height)end
function Graphics:set_checkpoint_cylinder_height(checkpoint, nearHeight, farHeight, radius)end
function Graphics:set_checkpoint_rgba(checkpoint, r, g, b, a)end
function Graphics:set_checkpoint_icon_rgba(checkpoint, r, g, b, a)end
function Graphics:delete_checkpoint(checkpoint)end
function Graphics:has_scaleform_movie_loaded(scaleform)end
function Graphics:set_scaleform_movie_as_no_longer_needed(scaleform)end