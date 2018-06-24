import
  libnx/results,
  libnx/wrapper/sm

from libnx/wrapper/types import Handle

type
  Service* = ref object
    serv: sm.Service


proc newService*(serv: sm.Service): Service =
  result = Service(serv: serv)

## *
##  @brief Returns whether a service is overriden in the homebrew environment.
##  @param[in] s Service object.
##  @return true if overriden.
##
proc isOverride*(service: Service): bool =
  serviceIsOverride(service.serv.addr)

## *
##  @brief Returns whether a service has been initialized.
##  @param[in] s Service object.
##  @return true if initialized.
##
proc isActive*(service: Service): bool =
  serviceIsActive(service.serv.addr)

## *
##  @brief Returns whether a service is a domain.
##  @param[in] s Service object.
##  @return true if a domain.
##
proc isDomain*(service: Service): bool =
  serviceIsDomain(service.serv.addr)

## *
##  @brief Returns whether a service is a domain subservice.
##  @param[in] s Service object.
##  @return true if a domain subservice.
##
proc isDomainSubservice*(service: Service): bool =
  serviceIsDomainSubservice(service.serv.addr)

## *
##  @brief For a domain/domain subservice, return the associated object ID.
##  @param[in] s Service object, necessarily a domain or domain subservice.
##  @return The object ID.
##
proc objectId*(service: Service): uint32 =
  serviceGetObjectId(service.serv.addr)

## *
##  @brief Closes a domain object by ID.
##  @param[in] s Service object, necessarily a domain or domain subservice.
##  @param object_id ID of the object to close.
##  @return Result code.
##
proc close*(service: Service; objectId: uint32): Result =
  serviceCloseObjectById(service.serv.addr, objectId).newResult


## *
##  @brief Dispatches an IPC request to a service.
##  @param[in] s Service object.
##  @return Result code.
##
proc ipcDispatch*(service: Service): Result =
  serviceIpcDispatch(service.serv.addr).newResult

## *
##  @brief Creates a service object from an IPC session handle.
##  @param[out] s Service object.
##  @param[in] h IPC session handle.
##
proc createService*(handle: Handle): Service =
  result = new(Service)
  serviceCreate(result.serv.addr, handle)

## *
##  @brief Creates a domain subservice object from a parent service.
##  @param[out] s Service object.
##  @param[in] parent Parent service, necessarily a domain or domain subservice.
##  @param[in] object_id Object ID for this subservice.
##
proc createDomainSubservice*(parent: Service; objectId: uint32): Service =
  result = new(Service)
  serviceCreateDomainSubservice(result.serv.addr, parent.serv.addr, objectId)

## *
##  @brief Converts a regular service to a domain.
##  @param[in] s Service object.
##  @return Result code.
##
proc convertToDomain*(service: Service): Result =
  serviceConvertToDomain(service.serv.addr).newResult

## *
##  @brief Closes a service.
##  @param[in] s Service object.
##
proc close*(service: Service) =
  serviceClose(service.serv.addr)
