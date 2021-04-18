graphics = {}
graphics.__index = graphics

function graphics:get_screen_height()end
function graphics:get_screen_width()end
function graphics:request_named_ptfx_asset(asset)end
function graphics:has_named_ptfx_asset_loaded(asset)end
function graphics:set_next_ptfx_asset(asset)end
function graphics:set_next_ptfx_asset_by_hash(hash)end
function graphics:start_ptfx_looped_on_entity(name, e, offset, rot, scale)end
function graphics:start_ptfx_non_looped_on_entity(name, e, offset, rot, scale)end
function graphics:remove_ptfx_from_entity(Entity)end
function graphics:does_looped_ptfx_exist(ptfx)end
function graphics:start_particle_fx_looped_at_coord(name, pos, rot, scale, xAxis, yAxis, zAxis, a8)end
function graphics:start_particle_fx_non_looped_at_coord(name, pos, rot, scale, xAxis, yAxis, zAxis)end
function graphics:start_networked_particle_fx_non_looped_at_coord(name, pos, rot, scale, xAxis, yAxis, zAxis)end
function graphics:remove_particle_fx(ptfx, a2)end
function graphics:remove_particle_fx_in_range(pos, range)end
function graphics:set_particle_fx_looped_offsets(ptfx, pos, rot)end
function graphics:set_particle_fx_looped_evolution(ptfx, propertyName, amount, a4)end
function graphics:set_particle_fx_looped_color(ptfx, r, b, g, a5)end
function graphics:set_particle_fx_looped_alpha(ptfx, a)end
function graphics:set_particle_fx_looped_scale(ptfx, scale)end
function graphics:set_particle_fx_looped_far_clip_dist(ptfx, dist)end
function graphics:enable_clown_blood_vfx(toggle)end
function graphics:enable_alien_blood_vfx(toggle)end
function graphics:animpostfx_play(effect, duration, looped)end
function graphics:animpostfx_stop(effect)end
function graphics:animpostfx_is_running(effect)end
function graphics:animpostfx_stop_all()end
function graphics:request_scaleform_movie(szName)end
function graphics:begin_scaleform_movie_method(scaleform, szMethod)end
function graphics:scaleform_movie_method_add_param_texture_name_string(val)end
function graphics:scaleform_movie_method_add_param_int(val)end
function graphics:scaleform_movie_method_add_param_float(val)end
function graphics:scaleform_movie_method_add_param_bool(val)end
function graphics:draw_scaleform_movie_fullscreen(scaleform, r, g, b, a, a6)end
function graphics:draw_scaleform_movie(scaleform, x, y, w, h, r, g, b, a, a10)end
function graphics:end_scaleform_movie_method()end
function graphics:draw_marker(type, pos, dir, rot, scale, red, green, blue, alpha, bobUpAndDown, faceCam, a12, rotate, textureDict, textureName, drawOntEnts)end
function graphics:create_checkpoint(type, thisPos, nextPos, radius, red, green, blue, alpha, reserved)end
function graphics:set_checkpoint_icon_height(checkpoint, height)end
function graphics:set_checkpoint_cylinder_height(checkpoint, nearHeight, farHeight, radius)end
function graphics:set_checkpoint_rgba(checkpoint, r, g, b, a)end
function graphics:set_checkpoint_icon_rgba(checkpoint, r, g, b, a)end
function graphics:delete_checkpoint(checkpoint)end
function graphics:has_scaleform_movie_loaded(scaleform)end
function graphics:set_scaleform_movie_as_no_longer_needed(scaleform)end