## *
##  @file audio.h
##  @brief Global audio service.
##  @author hexkyz
##  @copyright libnx Authors
##

## / PcmFormat

type
  PcmFormat* = enum
    PcmFormatInvalid = 0, PcmFormatInt8 = 1, PcmFormatInt16 = 2, PcmFormatInt24 = 3,
    PcmFormatInt32 = 4, PcmFormatFloat = 5, PcmFormatAdpcm = 6


## / AudioDeviceName

type
  AudioDeviceName* {.bycopy.} = object
    name*: array[0x100, char]

