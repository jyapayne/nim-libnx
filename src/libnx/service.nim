import
  libnx/results,
  libnx/wrapper/sm

from libnx/wrapper/types import Handle

type
  Service* = ref object
    serv: sm.Service

proc getSmService*(serv: Service): sm.Service =
  serv.serv

proc newService*(serv: sm.Service): Service =
  result = Service(serv: serv)

proc isOverride*(service: Service): bool =
  ## *
  ##  @brief Returns whether a service is overriden in the homebrew environment.
  ##  @param[in] s Service object.
  ##  @return true if overriden.
  ##
  serviceIsOverride(service.serv.addr)

proc isActive*(service: Service): bool =
  ## *
  ##  @brief Returns whether a service has been initialized.
  ##  @param[in] s Service object.
  ##  @return true if initialized.
  ##
  serviceIsActive(service.serv.addr)

proc isDomain*(service: Service): bool =
  ## *
  ##  @brief Returns whether a service is a domain.
  ##  @param[in] s Service object.
  ##  @return true if a domain.
  ##
  serviceIsDomain(service.serv.addr)

proc isDomainSubservice*(service: Service): bool =
  ## *
  ##  @brief Returns whether a service is a domain subservice.
  ##  @param[in] s Service object.
  ##  @return true if a domain subservice.
  ##
  serviceIsDomainSubservice(service.serv.addr)

proc objectId*(service: Service): uint32 =
  ## *
  ##  @brief For a domain/domain subservice, return the associated object ID.
  ##  @param[in] s Service object, necessarily a domain or domain subservice.
  ##  @return The object ID.
  ##
  serviceGetObjectId(service.serv.addr)

proc close*(service: Service; objectId: uint32): Result =
  ## *
  ##  @brief Closes a domain object by ID.
  ##  @param[in] s Service object, necessarily a domain or domain subservice.
  ##  @param object_id ID of the object to close.
  ##  @return Result code.
  ##
  serviceCloseObjectById(service.serv.addr, objectId).newResult


proc ipcDispatch*(service: Service): Result =
  ## *
  ##  @brief Dispatches an IPC request to a service.
  ##  @param[in] s Service object.
  ##  @return Result code.
  ##
  serviceIpcDispatch(service.serv.addr).newResult

proc createService*(handle: Handle): Service =
  ## *
  ##  @brief Creates a service object from an IPC session handle.
  ##  @param[out] s Service object.
  ##  @param[in] h IPC session handle.
  ##
  result = new(Service)
  serviceCreate(result.serv.addr, handle)

proc createDomainSubservice*(parent: Service; objectId: uint32): Service =
  ## *
  ##  @brief Creates a domain subservice object from a parent service.
  ##  @param[out] s Service object.
  ##  @param[in] parent Parent service, necessarily a domain or domain subservice.
  ##  @param[in] object_id Object ID for this subservice.
  ##
  result = new(Service)
  serviceCreateDomainSubservice(result.serv.addr, parent.serv.addr, objectId)

proc convertToDomain*(service: Service): Result =
  ## *
  ##  @brief Converts a regular service to a domain.
  ##  @param[in] s Service object.
  ##  @return Result code.
  ##
  serviceConvertToDomain(service.serv.addr).newResult

proc close*(service: Service) =
  ## *
  ##  @brief Closes a service.
  ##  @param[in] s Service object.
  ##
  serviceClose(service.serv.addr)
