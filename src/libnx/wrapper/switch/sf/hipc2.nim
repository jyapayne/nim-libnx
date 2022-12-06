## *
##  @file hipc.h
##  @brief Horizon Inter-Process Communication protocol
##  @author fincs
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../result, ../arm/tls, ../kernel/svc

const
  HIPC_AUTO_RECV_STATIC* = uint8Max
  HIPC_RESPONSE_NO_PID* = uint32Max

type
  HipcMetadata* {.bycopy.} = object
    `type`*: U32
    numSendStatics*: U32
    numSendBuffers*: U32
    numRecvBuffers*: U32
    numExchBuffers*: U32
    numDataWords*: U32
    numRecvStatics*: U32       ##  also accepts HIPC_AUTO_RECV_STATIC
    sendPid*: U32
    numCopyHandles*: U32
    numMoveHandles*: U32

  HipcHeader* {.bycopy.} = object
    `type`* {.bitsize: 16.}: U32
    numSendStatics* {.bitsize: 4.}: U32
    numSendBuffers* {.bitsize: 4.}: U32
    numRecvBuffers* {.bitsize: 4.}: U32
    numExchBuffers* {.bitsize: 4.}: U32
    numDataWords* {.bitsize: 10.}: U32
    recvStaticMode* {.bitsize: 4.}: U32
    padding* {.bitsize: 6.}: U32
    recvListOffset* {.bitsize: 11.}: U32 ##  Unused.
    hasSpecialHeader* {.bitsize: 1.}: U32

  HipcSpecialHeader* {.bycopy.} = object
    sendPid* {.bitsize: 1.}: U32
    numCopyHandles* {.bitsize: 4.}: U32
    numMoveHandles* {.bitsize: 4.}: U32
    padding* {.bitsize: 23.}: U32

  HipcStaticDescriptor* {.bycopy.} = object
    index* {.bitsize: 6.}: U32
    addressHigh* {.bitsize: 6.}: U32
    addressMid* {.bitsize: 4.}: U32
    size* {.bitsize: 16.}: U32
    addressLow*: U32

  HipcBufferDescriptor* {.bycopy.} = object
    sizeLow*: U32
    addressLow*: U32
    mode* {.bitsize: 2.}: U32
    addressHigh* {.bitsize: 22.}: U32
    sizeHigh* {.bitsize: 4.}: U32
    addressMid* {.bitsize: 4.}: U32

  HipcRecvListEntry* {.bycopy.} = object
    addressLow*: U32
    addressHigh* {.bitsize: 16.}: U32
    size* {.bitsize: 16.}: U32

  HipcRequest* {.bycopy.} = object
    sendStatics*: ptr HipcStaticDescriptor
    sendBuffers*: ptr HipcBufferDescriptor
    recvBuffers*: ptr HipcBufferDescriptor
    exchBuffers*: ptr HipcBufferDescriptor
    dataWords*: ptr U32
    recvList*: ptr HipcRecvListEntry
    copyHandles*: ptr Handle
    moveHandles*: ptr Handle

  HipcParsedRequest* {.bycopy.} = object
    meta*: HipcMetadata
    data*: HipcRequest
    pid*: U64

  HipcResponse* {.bycopy.} = object
    pid*: U64
    numStatics*: U32
    numDataWords*: U32
    numCopyHandles*: U32
    numMoveHandles*: U32
    statics*: ptr HipcStaticDescriptor
    dataWords*: ptr U32
    copyHandles*: ptr Handle
    moveHandles*: ptr Handle

  HipcBufferMode* = enum
    HipcBufferModeNormal = 0, HipcBufferModeNonSecure = 1, HipcBufferModeInvalid = 2,
    HipcBufferModeNonDevice = 3


proc hipcMakeSendStatic*(buffer: pointer; size: csize_t; index: U8): HipcStaticDescriptor {.
    inline, cdecl, importc: "hipcMakeSendStatic".} =
  ## !!!Ignored construct:  return ( HipcStaticDescriptor ) { . index = index , . address_high = ( u32 ) ( ( uintptr_t ) buffer >> 36 ) , . address_mid = ( u32 ) ( ( uintptr_t ) buffer >> 32 ) , . size = ( u32 ) size , . address_low = ( u32 ) ( uintptr_t ) buffer , } ;
  ## Error: token expected: ; but got: {!!!

proc hipcMakeBuffer*(buffer: pointer; size: csize_t; mode: HipcBufferMode): HipcBufferDescriptor {.
    inline, cdecl, importc: "hipcMakeBuffer".} =
  ## !!!Ignored construct:  return ( HipcBufferDescriptor ) { . size_low = ( u32 ) size , . address_low = ( u32 ) ( uintptr_t ) buffer , . mode = mode , . address_high = ( u32 ) ( ( uintptr_t ) buffer >> 36 ) , . size_high = ( u32 ) ( size >> 32 ) , . address_mid = ( u32 ) ( ( uintptr_t ) buffer >> 32 ) , } ;
  ## Error: token expected: ; but got: {!!!

proc hipcMakeRecvStatic*(buffer: pointer; size: csize_t): HipcRecvListEntry {.inline,
    cdecl, importc: "hipcMakeRecvStatic".} =
  ## !!!Ignored construct:  return ( HipcRecvListEntry ) { . address_low = ( u32 ) ( ( uintptr_t ) buffer ) , . address_high = ( u32 ) ( ( uintptr_t ) buffer >> 32 ) , . size = ( u32 ) size , } ;
  ## Error: token expected: ; but got: {!!!

proc hipcGetStaticAddress*(desc: ptr HipcStaticDescriptor): pointer {.inline, cdecl,
    importc: "hipcGetStaticAddress".} =
  return cast[pointer]((desc.addressLow or
      (cast[uintptrT](desc.addressMid) shl 32) or
      (cast[uintptrT](desc.addressHigh) shl 36)))

proc hipcGetStaticSize*(desc: ptr HipcStaticDescriptor): csize_t {.inline, cdecl,
    importc: "hipcGetStaticSize".} =
  return desc.size

proc hipcGetBufferAddress*(desc: ptr HipcBufferDescriptor): pointer {.inline, cdecl,
    importc: "hipcGetBufferAddress".} =
  return cast[pointer]((desc.addressLow or
      (cast[uintptrT](desc.addressMid) shl 32) or
      (cast[uintptrT](desc.addressHigh) shl 36)))

proc hipcGetBufferSize*(desc: ptr HipcBufferDescriptor): csize_t {.inline, cdecl,
    importc: "hipcGetBufferSize".} =
  return desc.sizeLow or (cast[csize_t](desc.sizeHigh) shl 32)

proc hipcCalcRequestLayout*(meta: HipcMetadata; base: pointer): HipcRequest {.inline,
    cdecl, importc: "hipcCalcRequestLayout".} =
  ##  Copy handles
  var copyHandles: ptr Handle = nil
  if meta.numCopyHandles:
    copyHandles = cast[ptr Handle](base)
    base = copyHandles + meta.numCopyHandles
  var moveHandles: ptr Handle = nil
  if meta.numMoveHandles:
    moveHandles = cast[ptr Handle](base)
    base = moveHandles + meta.numMoveHandles
  var sendStatics: ptr HipcStaticDescriptor = nil
  if meta.numSendStatics:
    sendStatics = cast[ptr HipcStaticDescriptor](base)
    base = sendStatics + meta.numSendStatics
  var sendBuffers: ptr HipcBufferDescriptor = nil
  if meta.numSendBuffers:
    sendBuffers = cast[ptr HipcBufferDescriptor](base)
    base = sendBuffers + meta.numSendBuffers
  var recvBuffers: ptr HipcBufferDescriptor = nil
  if meta.numRecvBuffers:
    recvBuffers = cast[ptr HipcBufferDescriptor](base)
    base = recvBuffers + meta.numRecvBuffers
  var exchBuffers: ptr HipcBufferDescriptor = nil
  if meta.numExchBuffers:
    exchBuffers = cast[ptr HipcBufferDescriptor](base)
    base = exchBuffers + meta.numExchBuffers
  var dataWords: ptr U32 = nil
  if meta.numDataWords:
    dataWords = cast[ptr U32](base)
    base = dataWords + meta.numDataWords
  var recvList: ptr HipcRecvListEntry = nil
  if meta.numRecvStatics:
    recvList = cast[ptr HipcRecvListEntry](base)
  ## !!!Ignored construct:  return ( HipcRequest ) { . send_statics = send_statics , . send_buffers = send_buffers , . recv_buffers = recv_buffers , . exch_buffers = exch_buffers , . data_words = data_words , . recv_list = recv_list , . copy_handles = copy_handles , . move_handles = move_handles , } ;
  ## Error: token expected: ; but got: {!!!

proc hipcMakeRequest*(base: pointer; meta: HipcMetadata): HipcRequest {.inline, cdecl,
    importc: "hipcMakeRequest".} =
  ##  Write message header
  var hasSpecialHeader: bool = meta.sendPid or meta.numCopyHandles or
      meta.numMoveHandles
  var hdr: ptr HipcHeader = cast[ptr HipcHeader](base)
  base = hdr + 1
  ## !!!Ignored construct:  * hdr = ( HipcHeader ) { . type = meta . type , . num_send_statics = meta . num_send_statics , . num_send_buffers = meta . num_send_buffers , . num_recv_buffers = meta . num_recv_buffers , . num_exch_buffers = meta . num_exch_buffers , . num_data_words = meta . num_data_words , . recv_static_mode = meta . num_recv_statics ? ( meta . num_recv_statics != HIPC_AUTO_RECV_STATIC ? 2u + meta . num_recv_statics : 2u ) : 0u , . padding = 0 , . recv_list_offset = 0 , . has_special_header = has_special_header , } ;
  ## Error: expected ';'!!!
  ##  Write special header
  if hasSpecialHeader:
    var sphdr: ptr HipcSpecialHeader = cast[ptr HipcSpecialHeader](base)
    base = sphdr + 1
    ## !!!Ignored construct:  * sphdr = ( HipcSpecialHeader ) { . send_pid = meta . send_pid , . num_copy_handles = meta . num_copy_handles , . num_move_handles = meta . num_move_handles , } ;
    ## Error: expected ';'!!!
    if meta.sendPid:
      base = cast[ptr U8](base) + sizeof((u64))
  return hipcCalcRequestLayout(meta, base)

proc hipcParseRequest*(base: pointer): HipcParsedRequest {.inline, cdecl,
    importc: "hipcParseRequest".} =
  ##  Parse message header
  var hdr: HipcHeader = HipcHeader()
  builtinMemcpy(addr(hdr), base, sizeof((hdr)))
  base = cast[ptr U8](base) + sizeof((hdr))
  var numRecvStatics: U32 = 0
  var pid: U64 = 0
  ##  Parse recv static mode
  if hdr.recvStaticMode:
    if hdr.recvStaticMode == 2'u:
      numRecvStatics = hipc_Auto_Recv_Static
    elif hdr.recvStaticMode > 2'u:
      numRecvStatics = hdr.recvStaticMode - 2'u
  var sphdr: HipcSpecialHeader = HipcSpecialHeader()
  if hdr.hasSpecialHeader:
    builtinMemcpy(addr(sphdr), base, sizeof((sphdr)))
    base = cast[ptr U8](base) + sizeof((sphdr))
    ##  Read PID descriptor
    if sphdr.sendPid:
      pid = cast[ptr U64](base)[]
      base = cast[ptr U8](base) + sizeof((u64))
  let meta: HipcMetadata = HipcMetadata(`type`: hdr.`type`,
                                    numSendStatics: hdr.numSendStatics,
                                    numSendBuffers: hdr.numSendBuffers,
                                    numRecvBuffers: hdr.numRecvBuffers,
                                    numExchBuffers: hdr.numExchBuffers,
                                    numDataWords: hdr.numDataWords,
                                    numRecvStatics: numRecvStatics,
                                    sendPid: sphdr.sendPid,
                                    numCopyHandles: sphdr.numCopyHandles,
                                    numMoveHandles: sphdr.numMoveHandles)
  ## !!!Ignored construct:  return ( HipcParsedRequest ) { . meta = meta , . data = hipcCalcRequestLayout ( meta , base ) , . pid = pid , } ;
  ## Error: token expected: ; but got: {!!!

proc hipcParseResponse*(base: pointer): HipcResponse {.inline, cdecl,
    importc: "hipcParseResponse".} =
  ##  Parse header
  var hdr: HipcHeader = HipcHeader()
  builtinMemcpy(addr(hdr), base, sizeof((hdr)))
  base = cast[ptr U8](base) + sizeof((hdr))
  ##  Initialize response
  var response: HipcResponse = HipcResponse()
  response.numStatics = hdr.numSendStatics
  response.numDataWords = hdr.numDataWords
  response.pid = hipc_Response_No_Pid
  ##  Parse special header
  if hdr.hasSpecialHeader:
    var sphdr: HipcSpecialHeader = HipcSpecialHeader()
    builtinMemcpy(addr(sphdr), base, sizeof((sphdr)))
    base = cast[ptr U8](base) + sizeof((sphdr))
    ##  Update response
    response.numCopyHandles = sphdr.numCopyHandles
    response.numMoveHandles = sphdr.numMoveHandles
    ##  Parse PID descriptor
    if sphdr.sendPid:
      response.pid = cast[ptr U64](base)[]
      base = cast[ptr U8](base) + sizeof((u64))
  response.copyHandles = cast[ptr Handle](base)
  base = response.copyHandles + response.numCopyHandles
  ##  Move handles
  response.moveHandles = cast[ptr Handle](base)
  base = response.moveHandles + response.numMoveHandles
  ##  Send statics
  response.statics = cast[ptr HipcStaticDescriptor](base)
  base = response.statics + response.numStatics
  ##  Data words
  response.dataWords = cast[ptr U32](base)
  return response
