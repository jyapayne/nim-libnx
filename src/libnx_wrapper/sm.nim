import strutils
import ospaths
const headersm = currentSourcePath().splitPath().head & "/nx/include/switch/services/sm.h"
## *
##  @file sm.h
##  @brief Service manager (sm) IPC wrapper.
##  @author plutoo
##  @author yellows8
##  @copyright libnx Authors
## 

import
  libnx_wrapper/types, libnx_wrapper/svc, libnx_wrapper/ipc

## / Service type.

type
  ServiceType* {.size: sizeof(cint).} = enum
    ServiceType_Uninitialized, ## /< Uninitialized service.
    ServiceType_Normal,       ## /< Normal service.
    ServiceType_Domain,       ## /< Domain.
    ServiceType_DomainSubservice, ## /< Domain subservice;
    ServiceType_Override      ## /< Service overriden in the homebrew environment.


## / Service object structure.

type
  Service* {.importc: "Service", header: headersm, bycopy.} = object
    handle* {.importc: "handle".}: Handle
    object_id* {.importc: "object_id".}: uint32
    `type`* {.importc: "type".}: ServiceType


## *
##  @brief Returns whether a service is overriden in the homebrew environment.
##  @param[in] s Service object.
##  @return true if overriden.
## 

proc serviceIsOverride*(s: ptr Service): bool {.inline, cdecl,
    importc: "serviceIsOverride", header: headersm.}
## *
##  @brief Returns whether a service has been initialized.
##  @param[in] s Service object.
##  @return true if initialized.
## 

proc serviceIsActive*(s: ptr Service): bool {.inline, cdecl,
    importc: "serviceIsActive", header: headersm.}
## *
##  @brief Returns whether a service is a domain.
##  @param[in] s Service object.
##  @return true if a domain.
## 

proc serviceIsDomain*(s: ptr Service): bool {.inline, cdecl,
    importc: "serviceIsDomain", header: headersm.}
## *
##  @brief Returns whether a service is a domain subservice.
##  @param[in] s Service object.
##  @return true if a domain subservice.
## 

proc serviceIsDomainSubservice*(s: ptr Service): bool {.inline, cdecl,
    importc: "serviceIsDomainSubservice", header: headersm.}
## *
##  @brief For a domain/domain subservice, return the associated object ID.
##  @param[in] s Service object, necessarily a domain or domain subservice.
##  @return The object ID.
## 

proc serviceGetObjectId*(s: ptr Service): uint32 {.inline, cdecl,
    importc: "serviceGetObjectId", header: headersm.}
## *
##  @brief Closes a domain object by ID.
##  @param[in] s Service object, necessarily a domain or domain subservice.
##  @param object_id ID of the object to close.
##  @return Result code.
## 

proc serviceCloseObjectById*(s: ptr Service; object_id: uint32): Result {.inline, cdecl,
    importc: "serviceCloseObjectById", header: headersm.}
## *
##  @brief Dispatches an IPC request to a service.
##  @param[in] s Service object.
##  @return Result code.
## 

proc serviceIpcDispatch*(s: ptr Service): Result {.inline, cdecl,
    importc: "serviceIpcDispatch", header: headersm.}
## *
##  @brief Creates a service object from an IPC session handle.
##  @param[out] s Service object.
##  @param[in] h IPC session handle.
## 

proc serviceCreate*(s: ptr Service; h: Handle) {.inline, cdecl,
    importc: "serviceCreate", header: headersm.}
## *
##  @brief Creates a domain subservice object from a parent service.
##  @param[out] s Service object.
##  @param[in] parent Parent service, necessarily a domain or domain subservice.
##  @param[in] object_id Object ID for this subservice.
## 

proc serviceCreateDomainSubservice*(s: ptr Service; parent: ptr Service; object_id: uint32) {.
    inline, cdecl, importc: "serviceCreateDomainSubservice", header: headersm.}
## *
##  @brief Converts a regular service to a domain.
##  @param[in] s Service object.
##  @return Result code.
## 

proc serviceConvertToDomain*(s: ptr Service): Result {.inline, cdecl,
    importc: "serviceConvertToDomain", header: headersm.}
## *
##  @brief Closes a service.
##  @param[in] s Service object.
## 

proc serviceClose*(s: ptr Service) {.inline, cdecl, importc: "serviceClose",
                                 header: headersm.}
## *
##  @brief Initializes SM.
##  @return Result code.
##  @note This function is already called in the default application startup code (before main() is called).
## 

proc smInitialize*(): Result {.cdecl, importc: "smInitialize", header: headersm.}
## *
##  @brief Uninitializes SM.
##  @return Result code.
##  @note This function is already handled in the default application exit code (after main() returns).
## 

proc smExit*() {.cdecl, importc: "smExit", header: headersm.}
## *
##  @brief Requests a service from SM.
##  @param[out] service_out Service structure which will be filled in.
##  @param[in] name Name of the service to request.
##  @return Result code.
## 

proc smGetService*(service_out: ptr Service; name: cstring): Result {.cdecl,
    importc: "smGetService", header: headersm.}
## *
##  @brief Requests a service from SM, as an IPC session handle directly
##  @param[out] handle_out Variable containing IPC session handle.
##  @param[in] name Name of the service to request.
##  @return Result code.
## 

proc smGetServiceOriginal*(handle_out: ptr Handle; name: uint64): Result {.cdecl,
    importc: "smGetServiceOriginal", header: headersm.}
## *
##  @brief Retrieves an overriden service in the homebrew environment.
##  @param[in] name Name of the service to request (as 64-bit integer).
##  @return IPC session handle.
## 

proc smGetServiceOverride*(name: uint64): Handle {.cdecl,
    importc: "smGetServiceOverride", header: headersm.}
## *
##  @brief Creates and registers a new service within SM.
##  @param[out] handle_out Variable containing IPC port handle.
##  @param[in] name Name of the service.
##  @param[in] is_light "Is light"
##  @param[in] max_sessions Maximum number of concurrent sessions that the service will accept.
##  @return Result code.
## 

proc smRegisterService*(handle_out: ptr Handle; name: cstring; is_light: bool;
                       max_sessions: cint): Result {.cdecl,
    importc: "smRegisterService", header: headersm.}
## *
##  @brief Unregisters a previously registered service in SM.
##  @param[in] name Name of the service.
##  @return Result code.
## 

proc smUnregisterService*(name: cstring): Result {.cdecl,
    importc: "smUnregisterService", header: headersm.}
## *
##  @brief Check whether SM is initialized.
##  @return true if initialized.
## 

proc smHasInitialized*(): bool {.cdecl, importc: "smHasInitialized",
                              header: headersm.}
## *
##  @brief Encodes a service name as a 64-bit integer.
##  @param[in] name Name of the service.
##  @return Encoded name.
## 

proc smEncodeName*(name: cstring): uint64 {.cdecl, importc: "smEncodeName",
                                     header: headersm.}
## *
##  @brief Overrides a service with a custom IPC service handle.
##  @param[in] name Name of the service (as 64-bit integer).
##  @param[in] handle IPC session handle.
## 

proc smAddOverrideHandle*(name: uint64; handle: Handle) {.cdecl,
    importc: "smAddOverrideHandle", header: headersm.}