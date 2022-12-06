## *
##  @file sm.h
##  @brief Service manager (sm) IPC wrapper.
##  @author plutoo
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../sf/tipc

## / Structure representing a service name (null terminated, remaining characters set to zero).

type
  SmServiceName* {.bycopy.} = object
    name*: array[8, char]

proc smServiceNameToU64*(name: SmServiceName): U64 {.inline, cdecl,
    importc: "smServiceNameToU64".} =
  ## / Converts a service name into a 64-bit integer.
  var ret: U64 = 0
  copyMem(addr(ret), addr(name), sizeof((U64)))
  return ret

proc smServiceNameFromU64*(name: U64): SmServiceName {.inline, cdecl,
    importc: "smServiceNameFromU64".} =
  ## / Converts a 64-bit integer into a service name.
  var ret: SmServiceName = SmServiceName()
  copyMem(addr(ret), addr(name), sizeof((SmServiceName)))
  return ret

proc smServiceNamesAreEqual*(a: SmServiceName; b: SmServiceName): bool {.inline, cdecl,
    importc: "smServiceNamesAreEqual".} =
  ## *
  ##  @brief Checks whether two service names are equal.
  ##  @param[in] a First name.
  ##  @param[in] b Second name.
  ##  @return Comparison result.
  ##
  return smServiceNameToU64(a) == smServiceNameToU64(b)

proc smEncodeName*(name: cstring): SmServiceName {.inline, cdecl,
    importc: "smEncodeName".} =
  ## *
  ##  @brief Encodes a service name string as a \ref SmServiceName structure.
  ##  @param[in] name Name of the service.
  ##  @return Encoded name.
  ##

  var nameEncoded: SmServiceName = SmServiceName()
  var len: cuint = len(name).cuint
  if len > 0:
    nameEncoded.name[0] = name[0]
  if len > 1:
    nameEncoded.name[1] = name[1]
  if len > 2:
    nameEncoded.name[2] = name[2]
  if len > 3:
    nameEncoded.name[3] = name[3]
  if len > 4:
    nameEncoded.name[4] = name[4]
  if len > 5:
    nameEncoded.name[5] = name[5]
  if len > 6:
    nameEncoded.name[6] = name[6]
  if len > 7:
    nameEncoded.name[7] = name[7]
  return nameEncoded

proc smInitialize*(): Result {.cdecl, importc: "smInitialize".}
## *
##  @brief Initializes SM.
##  @return Result code.
##  @note This function is already called in the default application startup code (before main() is called).
##

proc smExit*() {.cdecl, importc: "smExit".}
## *
##  @brief Uninitializes SM.
##  @return Result code.
##  @note This function is already handled in the default application exit code (after main() returns).
##

proc smGetServiceWrapper*(serviceOut: ptr Service; name: SmServiceName): Result {.
    cdecl, importc: "smGetServiceWrapper".}
## *
##  @brief Requests a service from SM, allowing overrides.
##  @param[out] service_out Service structure which will be filled in.
##  @param[in] name Name of the service to request.
##  @return Result code.
##

proc smGetServiceOriginal*(handleOut: ptr Handle; name: SmServiceName): Result {.cdecl,
    importc: "smGetServiceOriginal".}
## *
##  @brief Requests a service from SM, as an IPC session handle directly
##  @param[out] handle_out Variable containing IPC session handle.
##  @param[in] name Name of the service to request.
##  @return Result code.
##

proc smGetService*(serviceOut: ptr Service; name: cstring): Result {.inline, cdecl,
    importc: "smGetService".} =
  ## *
  ##  @brief Requests a service from SM.
  ##  @param[out] service_out Service structure which will be filled in.
  ##  @param[in] name Name of the service to request (as a string).
  ##  @return Result code.
  ##
  return smGetServiceWrapper(serviceOut, smEncodeName(name))

proc smGetServiceOverride*(name: SmServiceName): Handle {.cdecl,
    importc: "smGetServiceOverride".}
## *
##  @brief Retrieves an overriden service in the homebrew environment.
##  @param[in] name Name of the service to request.
##  @return IPC session handle.
##

proc smRegisterService*(handleOut: ptr Handle; name: SmServiceName; isLight: bool;
                       maxSessions: S32): Result {.cdecl,
    importc: "smRegisterService".}
## *
##  @brief Creates and registers a new service within SM.
##  @param[out] handle_out Variable containing IPC port handle.
##  @param[in] name Name of the service.
##  @param[in] is_light "Is light"
##  @param[in] max_sessions Maximum number of concurrent sessions that the service will accept.
##  @return Result code.
##

proc smRegisterServiceCmif*(handleOut: ptr Handle; name: SmServiceName; isLight: bool;
                           maxSessions: S32): Result {.cdecl,
    importc: "smRegisterServiceCmif".}
## / Same as \ref smRegisterService, but always using cmif serialization.

proc smRegisterServiceTipc*(handleOut: ptr Handle; name: SmServiceName; isLight: bool;
                           maxSessions: S32): Result {.cdecl,
    importc: "smRegisterServiceTipc".}
## / Same as \ref smRegisterService, but always using tipc serialization.

proc smUnregisterService*(name: SmServiceName): Result {.cdecl,
    importc: "smUnregisterService".}
## *
##  @brief Unregisters a previously registered service in SM.
##  @param[in] name Name of the service.
##  @return Result code.
##

proc smUnregisterServiceCmif*(name: SmServiceName): Result {.cdecl,
    importc: "smUnregisterServiceCmif".}
## / Same as \ref smUnregisterService, but always using cmif serialization.

proc smUnregisterServiceTipc*(name: SmServiceName): Result {.cdecl,
    importc: "smUnregisterServiceTipc".}
## / Same as \ref smUnregisterService, but always using tipc serialization.

proc smDetachClient*(): Result {.cdecl, importc: "smDetachClient".}
## *
##  @brief Detaches the current SM session.
##  @note After this function is called, the rest of the SM API cannot be used.
##  @note Only available on [11.0.0-11.0.1], or Atmosphère.
##

proc smDetachClientCmif*(): Result {.cdecl, importc: "smDetachClientCmif".}
## / Same as \ref smDetachClient, but always using cmif serialization.

proc smDetachClientTipc*(): Result {.cdecl, importc: "smDetachClientTipc".}
## / Same as \ref smDetachClient, but always using tipc serialization.

proc smGetServiceSession*(): ptr Service {.cdecl, importc: "smGetServiceSession".}
## *
##  @brief Gets the Service session used to communicate with SM.
##  @return Pointer to service session used to communicate with SM.
##

proc smGetServiceSessionTipc*(): ptr TipcService {.cdecl,
    importc: "smGetServiceSessionTipc".}
## *
##  @brief Gets the TipcService session used to communicate with SM.
##  @return Pointer to tipc service session used to communicate with SM.
##  @note Only available on [12.0.0+], or Atmosphère.
##

proc smAddOverrideHandle*(name: SmServiceName; handle: Handle) {.cdecl,
    importc: "smAddOverrideHandle".}
## *
##  @brief Overrides a service with a custom IPC service handle.
##  @param[in] name Name of the service.
##  @param[in] handle IPC session handle.
##

