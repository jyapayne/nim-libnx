## *
##  @file tipc.h
##  @brief Tiny IPC protocol
##  @author fincs
##  @author SciresM
##  @copyright libnx Authors
##

import
  hipc, service, ../types, ../kernel/svc, ../result, ../arm/tls

type
  TipcCommandType* = enum
    TipcCommandTypeClose = 15


## / tipc Service object structure

type
  TipcService* {.bycopy.} = object
    session*: Handle

  TipcDispatchParams* {.bycopy.} = object
    bufferAttrs*: SfBufferAttrs
    buffers*: array[8, SfBuffer]
    inSendPid*: bool
    inNumHandles*: U32
    inHandles*: array[8, Handle]
    outNumObjects*: U32
    outObjects*: ptr TipcService
    outHandleAttrs*: SfOutHandleAttrs
    outHandles*: ptr Handle

  TipcRequestFormat* {.bycopy.} = object
    requestId*: U32
    dataSize*: U32
    numInBuffers*: U32
    numOutBuffers*: U32
    numInoutBuffers*: U32
    numHandles*: U32
    sendPid*: U32


proc tipcCreate*(s: ptr TipcService; h: Handle) {.inline, cdecl, importc: "tipcCreate".} =
  ## *
  ##  @brief Creates a tipc service object from an IPC session handle.
  ##  @param[out] s TIPC service object.
  ##  @param[in] h IPC session handle.
  ##
  s.session = h

proc tipcClose*(s: ptr TipcService) {.inline, cdecl, importc: "tipcClose".} =
  ## *
  ##  @brief Closes a tipc service.
  ##  @param[in] s TIPC service object.
  ##
  discard hipcMakeRequestInline(armGetTls(), `type` = TipcCommandType_Close.U32)
  discard svcSendSyncRequest(s.session)
  discard svcCloseHandle(s.session)
  s[] = TipcService()

proc tipcRequestInBuffer*(req: ptr HipcRequest; buffer: pointer; size: csize_t;
                         mode: HipcBufferMode) {.inline, cdecl,
    importc: "tipcRequestInBuffer".} =
  req.sendBuffers += 1
  req.sendBuffers[] = hipcMakeBuffer(buffer, size, mode)

proc tipcRequestOutBuffer*(req: ptr HipcRequest; buffer: pointer; size: csize_t;
                          mode: HipcBufferMode) {.inline, cdecl,
    importc: "tipcRequestOutBuffer".} =
  req.recvBuffers += 1
  req.recvBuffers[] = hipcMakeBuffer(buffer, size, mode)

proc tipcRequestInOutBuffer*(req: ptr HipcRequest; buffer: pointer; size: csize_t;
                            mode: HipcBufferMode) {.inline, cdecl,
    importc: "tipcRequestInOutBuffer".} =
  req.exchBuffers += 1
  req.exchBuffers[] = hipcMakeBuffer(buffer, size, mode)

proc tipcRequestHandle*(req: ptr HipcRequest; handle: Handle) {.inline, cdecl,
    importc: "tipcRequestHandle".} =
  req.copyHandles += 1
  req.copyHandles[] = handle

proc tipcRequestFormatProcessBuffer*(fmt: ptr TipcRequestFormat; attr: U32) {.inline,
    cdecl, importc: "_tipcRequestFormatProcessBuffer".} =
  if not attr.bool:
    return
  let isIn: bool = (attr and SfBufferAttrIn) != 0
  let isOut: bool = (attr and SfBufferAttrOut) != 0
  if (attr and SfBufferAttrHipcMapAlias).bool:
    if isIn and isOut:
      inc(fmt.numInoutBuffers)
    elif isIn:
      inc(fmt.numInBuffers)
    elif isOut:
      inc(fmt.numOutBuffers)

proc tipcRequestProcessBuffer*(req: ptr HipcRequest; buf: ptr SfBuffer; attr: U32) {.
    inline, cdecl, importc: "_tipcRequestProcessBuffer".} =
  if not attr.bool:
    return
  let isIn: bool = (attr and SfBufferAttrIn).bool
  let isOut: bool = (attr and SfBufferAttrOut).bool
  if (attr and SfBufferAttrHipcMapAlias).bool:
    var mode: HipcBufferMode = HipcBufferModeNormal
    if (attr and SfBufferAttrHipcMapTransferAllowsNonSecure).bool:
      mode = HipcBufferModeNonSecure
    if (attr and SfBufferAttrHipcMapTransferAllowsNonDevice).bool:
      mode = HipcBufferModeNonDevice
    if isIn and isOut:
      tipcRequestInOutBuffer(req, cast[pointer](buf.`ptr`), buf.size, mode)
    elif isIn:
      tipcRequestInBuffer(req, buf.`ptr`, buf.size, mode)
    elif isOut:
      tipcRequestOutBuffer(req, cast[pointer](buf.`ptr`), buf.size, mode)

proc tipcMakeRequest*(requestId: U32; dataSize: U32; sendPid: bool;
                     bufferAttrs: SfBufferAttrs; buffers: openArray[SfBuffer];
                     numHandles: U32; handles: openArray[Handle]): pointer {.inline, cdecl.} =
  var fmt: TipcRequestFormat = TipcRequestFormat()
  fmt.requestId = requestId + 16
  fmt.dataSize = dataSize
  fmt.numHandles = numHandles
  fmt.sendPid = sendPid.U32
  tipcRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr0)
  tipcRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr1)
  tipcRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr2)
  tipcRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr3)
  tipcRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr4)
  tipcRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr5)
  tipcRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr6)
  tipcRequestFormatProcessBuffer(addr(fmt), bufferAttrs.attr7)
  var req = hipcMakeRequestInline(armGetTls(),
      `type`           = fmt.request_id,
      num_send_statics = 0,
      num_send_buffers = fmt.num_in_buffers,
      num_recv_buffers = fmt.num_out_buffers,
      num_exch_buffers = fmt.num_inout_buffers,
      num_data_words   = ((data_size + 3).int / 4).U32,
      num_recv_statics = 0,
      send_pid         = fmt.send_pid,
      num_copy_handles = fmt.num_handles,
      num_move_handles = 0,
  );
  var i: U32 = 0
  while i < numHandles:
    tipcRequestHandle(addr(req), handles[i])
    inc(i)
  tipcRequestProcessBuffer(addr(req), addr(buffers[0]), bufferAttrs.attr0)
  tipcRequestProcessBuffer(addr(req), addr(buffers[1]), bufferAttrs.attr1)
  tipcRequestProcessBuffer(addr(req), addr(buffers[2]), bufferAttrs.attr2)
  tipcRequestProcessBuffer(addr(req), addr(buffers[3]), bufferAttrs.attr3)
  tipcRequestProcessBuffer(addr(req), addr(buffers[4]), bufferAttrs.attr4)
  tipcRequestProcessBuffer(addr(req), addr(buffers[5]), bufferAttrs.attr5)
  tipcRequestProcessBuffer(addr(req), addr(buffers[6]), bufferAttrs.attr6)
  tipcRequestProcessBuffer(addr(req), addr(buffers[7]), bufferAttrs.attr7)
  return req.dataWords

proc tipcResponseGetCopyHandle*(res: ptr HipcResponse): Handle {.inline, cdecl,
    importc: "tipcResponseGetCopyHandle".} =
  res.copyHandles += 1
  return res.copyHandles[]

proc tipcResponseGetMoveHandle*(res: ptr HipcResponse): Handle {.inline, cdecl,
    importc: "tipcResponseGetMoveHandle".} =
  res.moveHandles += 1
  return res.moveHandles[]

proc tipcResponseGetHandle*(res: ptr HipcResponse; ty: SfOutHandleAttr;
                           outHandle: ptr Handle) {.inline, cdecl.} =
  {.emit: "    switch (`ty`) {".}
  {.emit: "        default:".}
  {.emit: "        case SfOutHandleAttr_None:".}
  {.emit: "            break;".}
  {.emit: "        case SfOutHandleAttr_HipcCopy:".}
  {.emit: "            *`outHandle` = tipcResponseGetCopyHandle(`res`);".}
  {.emit: "            break;".}
  {.emit: "        case SfOutHandleAttr_HipcMove:".}
  {.emit: "            *`outHandle` = tipcResponseGetMoveHandle(`res`);".}
  {.emit: "            break;".}
  {.emit: "    }".}

proc tipcParseResponse*(outSize: U32; outData: ptr pointer; numOutObjects: U32;
                       outObjects: ptr TipcService;
                       outHandleAttrs: SfOutHandleAttrs; outHandles: ptr Handle): Result {.
    inline, cdecl, importc: "tipcParseResponse".} =
  var res: HipcResponse = hipcParseResponse(armGetTls())
  res.dataWords += 1
  var rc: Result = res.dataWords[]
  if r_Failed(rc):
    return rc
  if outSize.bool:
    outData[] = res.dataWords
  var i: U32 = 0
  while i < numOutObjects:
    tipcCreate(addr(outObjects[i]), tipcResponseGetMoveHandle(addr(res)))
    inc(i)
  tipcResponseGetHandle(addr(res), outHandleAttrs.attr0, addr(outHandles[0]))
  tipcResponseGetHandle(addr(res), outHandleAttrs.attr1, addr(outHandles[1]))
  tipcResponseGetHandle(addr(res), outHandleAttrs.attr2, addr(outHandles[2]))
  tipcResponseGetHandle(addr(res), outHandleAttrs.attr3, addr(outHandles[3]))
  tipcResponseGetHandle(addr(res), outHandleAttrs.attr4, addr(outHandles[4]))
  tipcResponseGetHandle(addr(res), outHandleAttrs.attr5, addr(outHandles[5]))
  tipcResponseGetHandle(addr(res), outHandleAttrs.attr6, addr(outHandles[6]))
  tipcResponseGetHandle(addr(res), outHandleAttrs.attr7, addr(outHandles[7]))
  return 0

proc tipcDispatchImpl*(s: ptr TipcService; requestId: U32; inData: pointer;
                      inDataSize: U32; outData: pointer; outDataSize: U32;
                      disp: TipcDispatchParams): Result {.inline, cdecl,
    importc: "tipcDispatchImpl".} =
  var `in`: pointer = tipcMakeRequest(requestId, inDataSize, disp.inSendPid,
                                  disp.bufferAttrs, disp.buffers,
                                  disp.inNumHandles, disp.inHandles)
  if inDataSize.bool:
    copyMem(`in`, inData, inDataSize)
  var rc: Result = svcSendSyncRequest(s.session)
  if r_Succeeded(rc):
    var `out`: pointer = nil
    rc = tipcParseResponse(outDataSize, addr(`out`), disp.outNumObjects,
                         disp.outObjects, disp.outHandleAttrs, disp.outHandles)
    if r_Succeeded(rc) and outData != nil and outDataSize.bool:
      copyMem(outData, `out`, outDataSize)
  return rc

## !!!Ignored construct:  # ( _s , _rid , ... ) tipcDispatchImpl ( ( _s ) , ( _rid ) , NULL , 0 , NULL , 0 , ( TipcDispatchParams ) { __VA_ARGS__ } ) [NewLine] # ( _s , _rid , _in , ... ) tipcDispatchImpl ( ( _s ) , ( _rid ) , & ( _in ) , sizeof ( _in ) , NULL , 0 , ( TipcDispatchParams ) { __VA_ARGS__ } ) [NewLine] # ( _s , _rid , _out , ... ) tipcDispatchImpl ( ( _s ) , ( _rid ) , NULL , 0 , & ( _out ) , sizeof ( _out ) , ( TipcDispatchParams ) { __VA_ARGS__ } ) [NewLine] # ( _s , _rid , _in , _out , ... ) tipcDispatchImpl ( ( _s ) , ( _rid ) , & ( _in ) , sizeof ( _in ) , & ( _out ) , sizeof ( _out ) , ( TipcDispatchParams ) { __VA_ARGS__ } ) [NewLine]
## Error: identifier expected, but got: (!!!
