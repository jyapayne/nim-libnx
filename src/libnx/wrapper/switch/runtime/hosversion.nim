## *
##  @file hosversion.h
##  @brief Horizon OS (HOS) version detection utilities.
##  @author fincs
##  @copyright libnx Authors
##

import
  ../types


template makehosversion*(major, minor, micro: untyped): untyped =
  ## / Builds a HOS version value from its constituent components.
  (((U32)(major) shl 16) or ((U32)(minor) shl 8) or (U32)(micro))


template hosver_Major*(version: untyped): untyped =
  ## / Extracts the major number from a HOS version value.
  (((version) shr 16) and 0xFF)


template hosver_Minor*(version: untyped): untyped =
  ## / Extracts the minor number from a HOS version value.
  (((version) shr 8) and 0xFF)


template hosver_Micro*(version: untyped): untyped =
  ## / Extracts the micro number from a HOS version value.
  ((version) and 0xFF)

proc hosversionGet*(): U32 {.cdecl, importc: "hosversionGet".}
## / Returns the current HOS version that was previously set with \ref hosversionSet. If version initialization fails during startup (such as in the case set:sys is not available), this function returns zero.

proc hosversionSet*(version: U32) {.cdecl, importc: "hosversionSet".}
## / Sets or overrides the current HOS version. This function is normally called automatically by libnx on startup with the version info obtained with \ref setsysGetFirmwareVersion.

proc hosversionIsAtmosphere*(): bool {.cdecl, importc: "hosversionIsAtmosphere".}
## / Returns whether the current HOS version is augmented by running the Atmosphère custom firmware.

proc hosversionAtLeast*(major: U8; minor: U8; micro: U8): bool {.inline, cdecl.} =
  ## / Returns true if the current HOS version is equal to or above the specified major/minor/micro version.

  return hosversionGet() >= makehosversion(major, minor, micro)

proc hosversionBefore*(major: U8; minor: U8; micro: U8): bool {.inline, cdecl.} =
  ## / Returns true if the current HOS version is earlier than the specified major/minor/micro version.

  return not hosversionAtLeast(major, minor, micro)

proc hosversionBetween*(major1: U8; major2: U8): bool {.inline, cdecl.} =
  ## / Returns true if the current HOS version is between the two specified major versions, i.e. [major1, major2).

  var ver: U32 = hosversionGet()
  return ver >= makehosversion(major1, 0, 0) and ver < makehosversion(major2, 0, 0)
