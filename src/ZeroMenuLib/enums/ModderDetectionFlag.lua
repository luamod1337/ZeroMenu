eModderDetectionFlags = {
  MDF_MANUAL          =         bit.blshift(1, 0x00),
  MDF_PLAYER_MODEL      =       bit.blshift(1, 0x01),
  MDF_SCID_0          =         bit.blshift(1, 0x02),
  MDF_SCID_SPOOF        =       bit.blshift(1, 0x03),
  MDF_INVALID_OBJECT_CRASH  =   bit.blshift(1, 0x04),
  MDF_INVALID_PED_CRASH   =     bit.blshift(1, 0x05),
  MDF_CLONE_SPAWN       =       bit.blshift(1, 0x06),
  MDF_MODEL_CHANGE_CRASH    =   bit.blshift(1, 0x07),
  MDF_PLAYER_MODEL_CHANGE   =   bit.blshift(1, 0x08),
  MDF_RAC           =           bit.blshift(1, 0x09),
  MDF_MONEY_DROP        =       bit.blshift(1, 0x0A),
  MDF_SEP           =           bit.blshift(1, 0x0B),
  MDF_ATTACH_OBJECT     =       bit.blshift(1, 0x0C),
  MDF_ATTACH_PED        =       bit.blshift(1, 0x0D),
  MDF_ENDS          =           bit.blshift(1, 0x0E)
}