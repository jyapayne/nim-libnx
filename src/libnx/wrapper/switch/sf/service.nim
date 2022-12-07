## *
##  @file service.h
##  @brief Service wrapper object
##  @author fincs
##  @author SciresM
##  @copyright libnx Authors
##

import
  hipc, cmif, ../types, ../arm/tls, ../kernel/svc, ../result

## / Service object structure

type
  Service* {.bycopy.} = object
    session*: Handle
    ownHandle*: U32
    objectId*: U32
    pointerBufferSize*: U16


const
  SfBufferAttrIn* = bit(0)
  SfBufferAttrOut* = bit(1)
  SfBufferAttrHipcMapAlias* = bit(2)
  SfBufferAttrHipcPointer* = bit(3)
  SfBufferAttrFixedSize* = bit(4)
  SfBufferAttrHipcAutoSelect* = bit(5)
  SfBufferAttrHipcMapTransferAllowsNonSecure* = bit(6)
  SfBufferAttrHipcMapTransferAllowsNonDevice* = bit(7)

type
  SfBufferAttrs* {.bycopy.} = object
    attr0*: U32
    attr1*: U32
    attr2*: U32
    attr3*: U32
    attr4*: U32
    attr5*: U32
    attr6*: U32
    attr7*: U32

  SfBuffer* {.bycopy.} = object
    `ptr`*: pointer
    size*: csize_t

  SfOutHandleAttr* = enum
    SfOutHandleAttrNone = 0, SfOutHandleAttrHipcCopy = 1, SfOutHandleAttrHipcMove = 2
  SfOutHandleAttrs* {.bycopy.} = object
    attr0*: SfOutHandleAttr
    attr1*: SfOutHandleAttr
    attr2*: SfOutHandleAttr
    attr3*: SfOutHandleAttr
    attr4*: SfOutHandleAttr
    attr5*: SfOutHandleAttr
    attr6*: SfOutHandleAttr
    attr7*: SfOutHandleAttr

  SfDispatchParams* {.bycopy.} = object
    targetSession*: Handle
    context*: U32
    bufferAttrs*: SfBufferAttrs
    buffers*: array[8, SfBuffer]
    inSendPid*: bool
    inNumObjects*: U32
    inObjects*: array[8, ptr Service]
    inNumHandles*: U32
    inHandles*: array[8, Handle]
    outNumObjects*: U32
    outObjects*: ptr Service
    outHandleAttrs*: SfOutHandleAttrs
    outHandles*: ptr Handle



## *
##  @brief Returns whether a service has been initialized.
##  @param[in] s Service object.
##  @return true if initialized.
##

proc serviceIsActive*(s: ptr Service): bool {.inline, cdecl.} =
  return s.session != Invalid_Handle

## *
##  @brief Returns whether a service is overriden in the homebrew environment.
##  @param[in] s Service object.
##  @return true if overriden.
##

proc serviceIsOverride*(s: ptr Service): bool {.inline, cdecl.} =
  return serviceIsActive(s) and not s.ownHandle.bool and not s.objectId.bool

## *
##  @brief Returns whether a service is a domain.
##  @param[in] s Service object.
##  @return true if a domain.
##

proc serviceIsDomain*(s: ptr Service): bool {.inline, cdecl.} =
  return serviceIsActive(s) and s.ownHandle.bool and s.objectId.bool

## *
##  @brief Returns whether a service is a domain subservice.
##  @param[in] s Service object.
##  @return true if a domain subservice.
##

proc serviceIsDomainSubservice*(s: ptr Service): bool {.inline, cdecl.} =
  return serviceIsActive(s) and not s.ownHandle.bool and s.objectId.bool

## *
##  @brief For a domain/domain subservice, return the associated object ID.
##  @param[in] s Service object, necessarily a domain or domain subservice.
##  @return The object ID.
##

proc serviceGetObjectId*(s: ptr Service): U32 {.inline, cdecl.} =
  return s.objectId

## *
##  @brief Creates a service object from an IPC session handle.
##  @param[out] s Service object.
##  @param[in] h IPC session handle.
##

proc serviceCreate*(s: ptr Service; h: Handle) {.inline, cdecl.} =
  s.session = h
  s.ownHandle = 1
  s.objectId = 0
  s.pointerBufferSize = 0
  discard cmifQueryPointerBufferSize(h, addr(s.pointerBufferSize))

## *
##  @brief Creates a non-domain subservice object from a parent service.
##  @param[out] s Service object.
##  @param[in] parent Parent service.
##  @param[in] h IPC session handle for this subservice.
##

proc serviceCreateNonDomainSubservice*(s: ptr Service; parent: ptr Service; h: Handle) {.
    inline, cdecl.} =
  if h != Invalid_Handle:
    s.session = h
    s.ownHandle = 1
    s.objectId = 0
    s.pointerBufferSize = parent.pointerBufferSize
  else:
    s[] = Service()

## *
##  @brief Creates a domain subservice object from a parent service.
##  @param[out] s Service object.
##  @param[in] parent Parent service, necessarily a domain or domain subservice.
##  @param[in] object_id Object ID for this subservice.
##

proc serviceCreateDomainSubservice*(s: ptr Service; parent: ptr Service; objectId: U32) {.
    inline, cdecl.} =
  if objectId != 0:
    s.session = parent.session
    s.ownHandle = 0
    s.objectId = objectId
    s.pointerBufferSize = parent.pointerBufferSize
  else:
    s[] = Service()

## *
##  @brief Hints the compiler that a service will always contain a domain object.
##  @param[in] _s Service object.
##

template serviceAssumeDomain*(s: untyped): void =
  while true:
    if not (s).objectId.bool:
      builtinUnreachable()
    if not 0:
      break

## *
##  @brief Closes a service.
##  @param[in] s Service object.
##

proc serviceClose*(s: ptr Service) {.inline, cdecl.} =
  {.emit: "#if defined(NX_SERVICE_ASSUME_NON_DOMAIN)".}
  {.emit: "    if (`s`->object_id)".}
  {.emit: "        __builtin_unreachable();".}
  {.emit: "#endif".}
  {.emit: "    if (`s`->own_handle || `s`->object_id) {".}
  {.emit: "        cmifMakeCloseRequest(armGetTls(), `s`->own_handle ? 0 : `s`->object_id);".}
  {.emit: "        svcSendSyncRequest(`s`->session);".}
  {.emit: "        if (`s`->own_handle)".}
  {.emit: "            svcCloseHandle(`s`->session);".}
  {.emit: "    }".}
  {.emit: "    *`s` = (Service){};".}

## *
##  @brief Clones a service.
##  @param[in] s Service object.
##  @param[out] out_s Output service object.
##

proc serviceClone*(s: ptr Service; outS: ptr Service): Result {.inline, cdecl.} =
  {.emit: "#if defined(NX_SERVICE_ASSUME_NON_DOMAIN)".}
  {.emit: "    if (`s`->object_id)".}
  {.emit: "        __builtin_unreachable();".}
  {.emit: "#endif".}
  {.emit: "    `outS`->session = 0;".}
  {.emit: "    `outS`->own_handle = 1;".}
  {.emit: "    `outS`->object_id = `s`->object_id;".}
  {.emit: "    `outS`->pointer_buffer_size = `s`->pointer_buffer_size;".}
  {.emit: "    `result` = cmifCloneCurrentObject(`s`->session, &`outS`->session);".}

## *
##  @brief Clones a service with a session manager tag.
##  @param[in] s Service object.
##  @param[in] tag Session manager tag (unused in current official server code)
##  @param[out] out_s Output service object.
##

proc serviceCloneEx*(s: ptr Service; tag: U32; outS: ptr Service): Result {.inline, cdecl.} =
  {.emit: "#if defined(NX_SERVICE_ASSUME_NON_DOMAIN)".}
  {.emit: "    if (`s`->object_id)".}
  {.emit: "        __builtin_unreachable();".}
  {.emit: "#endif".}
  {.emit: "    `outS`->session = 0;".}
  {.emit: "    `outS`->own_handle = 1;".}
  {.emit: "    `outS`->object_id = `s`->object_id;".}
  {.emit: "    `outS`->pointer_buffer_size = `s`->pointer_buffer_size;".}
  {.emit: "    `result` = cmifCloneCurrentObjectEx(`s`->session, `tag`, &`outS`->session);".}

## *
##  @brief Converts a regular service to a domain.
##  @param[in] s Service object.
##  @return Result code.
##

proc serviceConvertToDomain*(s: ptr Service): Result {.inline, cdecl.} =
  if not s.ownHandle.bool:
    ##  For overridden services, create a clone first.
    var rc: Result = cmifCloneCurrentObjectEx(s.session, 0, addr(s.session))
    if r_Failed(rc):
      return rc
    s.ownHandle = 1
  return cmifConvertCurrentObjectToDomain(s.session, addr(s.objectId))

proc serviceRequestFormatProcessBuffer*(fmt: ptr CmifRequestFormat; attr: U32) {.
    inline, cdecl.} =
  if attr == 0:
    return

  let isIn: bool = (attr and SfBufferAttrIn) != 0
  let isOut: bool = (attr and SfBufferAttrOut) != 0
  if (attr and SfBufferAttrHipcAutoSelect).bool:
    if isIn:
      inc(fmt.numInAutoBuffers)
    if isOut:
      inc(fmt.numOutAutoBuffers)
  elif (attr and SfBufferAttrHipcPointer).bool:
    if isIn:
      inc(fmt.numInPointers)
    if isOut:
      if (attr and SfBufferAttrFixedSize).bool:
        inc(fmt.numOutFixedPointers)
      else:
        inc(fmt.numOutPointers)
  elif (attr and SfBufferAttrHipcMapAlias).bool:
    if isIn and isOut:
      inc(fmt.numInoutBuffers)
    elif isIn:
      inc(fmt.numInBuffers)
    elif isOut:
      inc(fmt.numOutBuffers)

proc serviceRequestProcessBuffer*(req: ptr CmifRequest; buf: ptr SfBuffer; attr: U32) {.
    inline, cdecl.} =
  if attr == 0:
    return
  let isIn: bool = (attr and SfBufferAttrIn).bool
  let isOut: bool = (attr and SfBufferAttrOut).bool
  if (attr and SfBufferAttrHipcAutoSelect).bool:
    var mode: HipcBufferMode = HipcBufferModeNormal
    if (attr and SfBufferAttrHipcMapTransferAllowsNonSecure).bool:
      mode = HipcBufferModeNonSecure
    if (attr and SfBufferAttrHipcMapTransferAllowsNonDevice).bool:
      mode = HipcBufferModeNonDevice
    if isIn:
      cmifRequestInAutoBuffer(req, buf.`ptr`, buf.size, mode)
    if isOut:
      cmifRequestOutAutoBuffer(req, cast[pointer](buf.`ptr`), buf.size, mode)
  elif (attr and SfBufferAttrHipcPointer).bool:
    if isIn:
      cmifRequestInPointer(req, buf.`ptr`, buf.size)
    if isOut:
      if (attr and SfBufferAttrFixedSize).bool:
        cmifRequestOutFixedPointer(req, cast[pointer](buf.`ptr`), buf.size)
      else:
        cmifRequestOutPointer(req, cast[pointer](buf.`ptr`), buf.size)
  elif (attr and SfBufferAttrHipcMapAlias).bool:
    var mode: HipcBufferMode = HipcBufferModeNormal
    if (attr and SfBufferAttrHipcMapTransferAllowsNonSecure).bool:
      mode = HipcBufferModeNonSecure
    if (attr and SfBufferAttrHipcMapTransferAllowsNonDevice).bool:
      mode = HipcBufferModeNonDevice
    if isIn and isOut:
      cmifRequestInOutBuffer(req, cast[pointer](buf.`ptr`), buf.size, mode)
    elif isIn:
      cmifRequestInBuffer(req, buf.`ptr`, buf.size, mode)
    elif isOut:
      cmifRequestOutBuffer(req, cast[pointer](buf.`ptr`), buf.size, mode)

proc serviceMakeRequest*(s: ptr Service; requestId: U32; context: U32; dataSize: U32;
                        sendPid: bool; bufferAttrs: SfBufferAttrs;
                        buffers: openArray[SfBuffer]; numObjects: U32;
                        objects: openArray[ptr Service]; numHandles: U32; handles: openArray[Handle]): pointer {.
    inline, cdecl.} =
  when defined(nx_Service_Assume_Non_Domain):
    if s.objectId:
      builtinUnreachable()
  var fmt: CmifRequestFormat
  fmt.objectId = s.objectId
  fmt.requestId = requestId
  fmt.context = context
  fmt.dataSize = dataSize
  fmt.serverPointerSize = s.pointerBufferSize
  fmt.numObjects = numObjects
  fmt.numHandles = numHandles
  fmt.sendPid = sendPid.U32
  serviceRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr0)
  serviceRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr1)
  serviceRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr2)
  serviceRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr3)
  serviceRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr4)
  serviceRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr5)
  serviceRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr6)
  serviceRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr7)
  var req: CmifRequest = cmifMakeRequest(armGetTls(), fmt)
  if s.objectId.bool:
    var i: U32 = 0
    while i < numObjects:
      cmifRequestObject(addr(req), objects[i].objectId)
      inc(i)
  var i: U32 = 0
  while i < numHandles:
    cmifRequestHandle(addr(req), handles[i])
    inc(i)
  serviceRequestProcessBuffer(addr(req), addr(buffers[0]), bufferAttrs.attr0)
  serviceRequestProcessBuffer(addr(req), addr(buffers[1]), bufferAttrs.attr1)
  serviceRequestProcessBuffer(addr(req), addr(buffers[2]), bufferAttrs.attr2)
  serviceRequestProcessBuffer(addr(req), addr(buffers[3]), bufferAttrs.attr3)
  serviceRequestProcessBuffer(addr(req), addr(buffers[4]), bufferAttrs.attr4)
  serviceRequestProcessBuffer(addr(req), addr(buffers[5]), bufferAttrs.attr5)
  serviceRequestProcessBuffer(addr(req), addr(buffers[6]), bufferAttrs.attr6)
  serviceRequestProcessBuffer(addr(req), addr(buffers[7]), bufferAttrs.attr7)
  return req.data

proc serviceResponseGetHandle*(res: ptr CmifResponse; ty: SfOutHandleAttr;
                              `out`: ptr Handle) {.inline, cdecl.} =
  {.emit: "    switch (`ty`) {".}
  {.emit: "        default:".}
  {.emit: "        case SfOutHandleAttr_None:".}
  {.emit: "            break;".}
  {.emit: "        case SfOutHandleAttr_HipcCopy:".}
  {.emit: "            *`out` = cmifResponseGetCopyHandle(`res`);".}
  {.emit: "            break;".}
  {.emit: "        case SfOutHandleAttr_HipcMove:".}
  {.emit: "            *`out` = cmifResponseGetMoveHandle(`res`);".}
  {.emit: "            break;".}
  {.emit: "    }".}

proc serviceParseResponse*(s: ptr Service; outSize: U32; outData: ptr pointer;
                          numOutObjects: U32; outObjects: ptr Service;
                          outHandleAttrs: SfOutHandleAttrs; outHandles: ptr Handle): Result {.
    inline, cdecl.} =
  {.emit: "#if defined(NX_SERVICE_ASSUME_NON_DOMAIN)".}
  {.emit: "    if (`s`->object_id)".}
  {.emit: "        __builtin_unreachable();".}
  {.emit: "#endif".}
  {.emit: "    CmifResponse res = {};".}
  {.emit: "    bool is_domain = `s`->object_id != 0;".}
  {.emit: "    Result rc = cmifParseResponse(&res, armGetTls(), is_domain, `outSize`);".}
  {.emit: "    if (R_FAILED(rc))".}
  {.emit: "        return rc;".}
  {.emit: "    if (`outSize`)".}
  {.emit: "        *`outData` = res.data;".}
  {.emit: "    for (u32 i = 0; i < `numOutObjects`; i ++) {".}
  {.emit: "        if (is_domain)".}
  {.emit: "            serviceCreateDomainSubservice(&`outObjects`[i], `s`, cmifResponseGetObject(&res));".}
  {.emit: "        else // Output objects are marshalled as move handles at the beginning of the list.".}
  {.emit: "            serviceCreateNonDomainSubservice(&`outObjects`[i], `s`, cmifResponseGetMoveHandle(&res));".}
  {.emit: "    }".}
  {.emit: "    _serviceResponseGetHandle(&res, `outHandleAttrs`.attr0, &`outHandles`[0]);".}
  {.emit: "    _serviceResponseGetHandle(&res, `outHandleAttrs`.attr1, &`outHandles`[1]);".}
  {.emit: "    _serviceResponseGetHandle(&res, `outHandleAttrs`.attr2, &`outHandles`[2]);".}
  {.emit: "    _serviceResponseGetHandle(&res, `outHandleAttrs`.attr3, &`outHandles`[3]);".}
  {.emit: "    _serviceResponseGetHandle(&res, `outHandleAttrs`.attr4, &`outHandles`[4]);".}
  {.emit: "    _serviceResponseGetHandle(&res, `outHandleAttrs`.attr5, &`outHandles`[5]);".}
  {.emit: "    _serviceResponseGetHandle(&res, `outHandleAttrs`.attr6, &`outHandles`[6]);".}
  {.emit: "    _serviceResponseGetHandle(&res, `outHandleAttrs`.attr7, &`outHandles`[7]);".}
  {.emit: "    `result` = 0;".}

proc serviceDispatchImpl*(s: ptr Service; requestId: U32; inData: pointer;
                         inDataSize: U32; outData: pointer; outDataSize: U32;
                         disp: SfDispatchParams): Result {.inline, cdecl.} =
  ##  Make a copy of the service struct, so that the compiler can assume that it won't be modified by function calls.
  var srv: Service
  var `in`: pointer = serviceMakeRequest(addr(srv), requestId, disp.context,
                                     inDataSize, disp.inSendPid, disp.bufferAttrs,
                                     disp.buffers, disp.inNumObjects,
                                     disp.inObjects, disp.inNumHandles,
                                     disp.inHandles)
  if inDataSize.bool:
    copyMem(`in`, inData, inDataSize)

  var rc: Result = svcSendSyncRequest(if disp.targetSession == Invalid_Handle: s.session else: disp.targetSession)

  if r_Succeeded(rc):
    var `out`: pointer = nil
    rc = serviceParseResponse(addr(srv), outDataSize, addr(`out`),
                            disp.outNumObjects, disp.outObjects,
                            disp.outHandleAttrs, disp.outHandles)
    if r_Succeeded(rc) and outData != nil and outDataSize.bool:
      copyMem(outData, `out`, outDataSize)
  return rc

## !!!Ignored construct:  # ( _s , _rid , ... ) serviceDispatchImpl ( ( _s ) , ( _rid ) , NULL , 0 , NULL , 0 , ( SfDispatchParams ) { __VA_ARGS__ } ) [NewLine] # ( _s , _rid , _in , ... ) serviceDispatchImpl ( ( _s ) , ( _rid ) , & ( _in ) , sizeof ( _in ) , NULL , 0 , ( SfDispatchParams ) { __VA_ARGS__ } ) [NewLine] # ( _s , _rid , _out , ... ) serviceDispatchImpl ( ( _s ) , ( _rid ) , NULL , 0 , & ( _out ) , sizeof ( _out ) , ( SfDispatchParams ) { __VA_ARGS__ } ) [NewLine] # ( _s , _rid , _in , _out , ... ) serviceDispatchImpl ( ( _s ) , ( _rid ) , & ( _in ) , sizeof ( _in ) , & ( _out ) , sizeof ( _out ) , ( SfDispatchParams ) { __VA_ARGS__ } ) [NewLine]
## Error: identifier expected, but got: (!!!
