Audio = {}
Audio.__index = Audio

function Audio:play_sound(soundId, audioName, audioRef, p4, p5, p6)end
function Audio:play_sound_frontend(soundId, audioName, audioRef, p4)end
function Audio:play_sound_from_entity(soundId, audioName, entity, audioRef)end
function Audio:play_sound_from_coord(soundId, audioName, pos, audioRef, a5, range, a7)end
function Audio:stop_sound(soundId)end