stats = {}
stats.__index = stats

function stats:stat_get_int(hash,unk0)end
function stats:stat_get_float(hash,unk0)end
function stats:stat_get_bool(hash,unk0)end
function stats:stat_set_int(hash,value,save)end
function stats:stat_set_float(hash,value,save)end
function stats:stat_set_bool(hash,value,save)end
function stats:stat_get_i64(hash)end
function stats:stat_set_i64(hash,v,flags)end
function stats:stat_get_u64(hash)end
function stats:stat_set_u64(hash,v,flags)end
function stats:stat_get_masked_int(hash,mask,a3,a4)end
function stats:stat_set_masked_int(hash,val,mask,a4,save)end
function stats:stat_get_masked_bool(hash,mask,a3)end
function stats:stat_set_masked_bool(hash,val,mask,a4,save)end
function stats:stat_get_bool_hash_and_mask(stat,invaluedex,character)end
function stats:stat_get_int_hash_and_mask(stat,invaluedex,character)end
