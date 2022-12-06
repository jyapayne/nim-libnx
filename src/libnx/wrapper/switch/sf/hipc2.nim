## *
##  @file hipc.h
##  @brief Horizon Inter-Process Communication protocol
##  @author fincs
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../result, ../arm/tls

const
  HIPC_AUTO_RECV_STATIC* = uint8.high
  HIPC_RESPONSE_NO_PID* = uint32.high

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
    inline, cdecl.} =
  return HipcStaticDescriptor(
      index        : index,
      address_high : (U32)(cast[uintptr_t](buffer) shr 36),
      address_mid  : (U32)(cast[uintptr_t](buffer) shr 32),
      size         : (U32)size,
      address_low  : (U32)cast[uintptr_t](buffer)
  )

proc hipcMakeBuffer*(buffer: pointer; size: csize_t; mode: HipcBufferMode): HipcBufferDescriptor {.
    inline, cdecl.} =
  return HipcBufferDescriptor(
      size_low     : (U32)size,
      address_low  : (U32)cast[uintptr_t](buffer),
      mode         : mode.U32,
      address_high : (U32)(cast[uintptr_t](buffer) shr 36),
      size_high    : (U32)(size shr 32),
      address_mid  : (U32)(cast[uintptr_t](buffer) shr 32),
  )

proc hipcMakeRecvStatic*(buffer: pointer; size: csize_t): HipcRecvListEntry {.inline, cdecl.} =
  return HipcRecvListEntry(
      address_low  : (U32)(cast[uintptr_t](buffer)),
      address_high : (U32)(cast[uintptr_t](buffer) shr 32),
      size         : (U32)size,
  )

proc hipcGetStaticAddress*(desc: ptr HipcStaticDescriptor): pointer {.inline, cdecl.} =
  return cast[pointer]((desc.addressLow or
      (cast[uintptrT](desc.addressMid) shl 32) or
      (cast[uintptrT](desc.addressHigh) shl 36)))

proc hipcGetStaticSize*(desc: ptr HipcStaticDescriptor): csize_t {.inline, cdecl.} =
  return desc.size

proc hipcGetBufferAddress*(desc: ptr HipcBufferDescriptor): pointer {.inline, cdecl.} =
  return cast[pointer]((desc.addressLow or
      (cast[uintptrT](desc.addressMid) shl 32) or
      (cast[uintptrT](desc.addressHigh) shl 36)))

proc hipcGetBufferSize*(desc: ptr HipcBufferDescriptor): csize_t {.inline, cdecl.} =
  return desc.sizeLow or (cast[csize_t](desc.sizeHigh) shl 32)

proc hipcCalcRequestLayout*(meta: HipcMetadata; base: pointer): HipcRequest {.inline, cdecl.} =
  ##  Copy handles
  var base = base
  var copyHandles: ptr Handle = nil
  if meta.numCopyHandles.bool:
    copyHandles = cast[ptr Handle](base)
    base = copyHandles + meta.numCopyHandles
  var moveHandles: ptr Handle = nil
  if meta.numMoveHandles.bool:
    moveHandles = cast[ptr Handle](base)
    base = moveHandles + meta.numMoveHandles
  var sendStatics: ptr HipcStaticDescriptor = nil
  if meta.numSendStatics.bool:
    sendStatics = cast[ptr HipcStaticDescriptor](base)
    base = sendStatics + meta.numSendStatics
  var sendBuffers: ptr HipcBufferDescriptor = nil
  if meta.numSendBuffers.bool:
    sendBuffers = cast[ptr HipcBufferDescriptor](base)
    base = sendBuffers + meta.numSendBuffers
  var recvBuffers: ptr HipcBufferDescriptor = nil
  if meta.numRecvBuffers.bool:
    recvBuffers = cast[ptr HipcBufferDescriptor](base)
    base = recvBuffers + meta.numRecvBuffers
  var exchBuffers: ptr HipcBufferDescriptor = nil
  if meta.numExchBuffers.bool:
    exchBuffers = cast[ptr HipcBufferDescriptor](base)
    base = exchBuffers + meta.numExchBuffers
  var dataWords: ptr U32 = nil
  if meta.numDataWords.bool:
    dataWords = cast[ptr U32](base)
    base = dataWords + meta.numDataWords
  var recvList: ptr HipcRecvListEntry = nil
  if meta.numRecvStatics.bool:
    recvList = cast[ptr HipcRecvListEntry](base)
  return HipcRequest(
      send_statics: send_statics,
      send_buffers: send_buffers,
      recv_buffers: recv_buffers,
      exch_buffers: exch_buffers,
      data_words: data_words,
      recv_list: recv_list,
      copy_handles: copy_handles,
      move_handles: move_handles,
  )

proc hipcMakeRequest*(base: pointer; meta: HipcMetadata): HipcRequest {.inline, cdecl.} =
  ##  Write message header
  var base = base
  var hasSpecialHeader: bool = meta.sendPid or meta.numCopyHandles or
      meta.numMoveHandles
  var hdr: ptr HipcHeader = cast[ptr HipcHeader](base)
  base = hdr + 1
  ## !!!Ignored construct:  * hdr = ( HipcHeader ) { . type = meta . type , . num_send_statics = meta . num_send_statics , . num_send_buffers = meta . num_send_buffers , . num_recv_buffers = meta . num_recv_buffers , . num_exch_buffers = meta . num_exch_buffers , . num_data_words = meta . num_data_words , . recv_static_mode = meta . num_recv_statics ? ( meta . num_recv_statics != HIPC_AUTO_RECV_STATIC ? 2u + meta . num_recv_statics : 2u ) : 0u , . padding = 0 , . recv_list_offset = 0 , . has_special_header = has_special_header , } ;
  ## Error: expected ';'!!!
  hdr[] = HipcHeader(
      type: meta.type,
      num_send_statics: meta.num_send_statics,
      num_send_buffers: meta.num_send_buffers,
      num_recv_buffers: meta.num_recv_buffers,
      num_exch_buffers: meta.num_exch_buffers,
      num_data_words: meta.num_data_words,
      recv_static_mode: if meta.num_recv_statics.bool:
        if meta.num_recv_statics != HIPC_AUTO_RECV_STATIC:
          2'U32 + meta.num_recv_statics.U32
        else: 2.U32
        else: 0.U32,
      padding: 0,
      recv_list_offset: 0,
      has_special_header: has_special_header.U32,
  )
  ##  Write special header
  if hasSpecialHeader:
    var sphdr: ptr HipcSpecialHeader = cast[ptr HipcSpecialHeader](base)
    base = sphdr + 1
    sphdr[] = HipcSpecialHeader(
        send_pid: meta.send_pid,
        num_copy_handles: meta.num_copy_handles,
        num_move_handles: meta.num_move_handles,
    )
    if meta.sendPid.bool:
      base = cast[ptr U8](base) + sizeof((U64))
  return hipcCalcRequestLayout(meta, base)

proc hipcParseRequest*(base: pointer): HipcParsedRequest {.inline, cdecl.} =
  ##  Parse message header
  var hdr: HipcHeader = HipcHeader()
  var base = base
  copyMem(addr(hdr), base, sizeof((hdr)))
  base = cast[ptr U8](base) + sizeof((hdr))
  var numRecvStatics: U32 = 0
  var pid: U64 = 0
  ##  Parse recv static mode
  if hdr.recvStaticMode.bool:
    if hdr.recvStaticMode == 2'u:
      numRecvStatics = Hipc_Auto_Recv_Static
    elif hdr.recvStaticMode > 2'u:
      numRecvStatics = hdr.recvStaticMode - 2.U32
  var sphdr: HipcSpecialHeader = HipcSpecialHeader()
  if hdr.hasSpecialHeader.bool:
    copyMem(addr(sphdr), base, sizeof((sphdr)))
    base = cast[ptr U8](base) + sizeof((sphdr))
    ##  Read PID descriptor
    if sphdr.sendPid.bool:
      pid = cast[ptr U64](base)[]
      base = cast[ptr U8](base) + sizeof((U64))
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
  return HipcParsedRequest(
      meta: meta,
      data: hipcCalcRequestLayout(meta, base),
      pid: pid,
  )

proc hipcParseResponse*(base: pointer): HipcResponse {.inline, cdecl.} =
  ##  Parse header
  var hdr: HipcHeader = HipcHeader()
  copyMem(addr(hdr), base, sizeof((hdr)))
  var base = base
  base = cast[ptr U8](base) + sizeof((hdr))
  ##  Initialize response
  var response: HipcResponse = HipcResponse()
  response.numStatics = hdr.numSendStatics
  response.numDataWords = hdr.numDataWords
  response.pid = Hipc_Response_No_Pid
  ##  Parse special header
  if hdr.hasSpecialHeader.bool:
    var sphdr: HipcSpecialHeader = HipcSpecialHeader()
    copyMem(addr(sphdr), base, sizeof((sphdr)))
    base = cast[ptr U8](base) + sizeof((sphdr))
    ##  Update response
    response.numCopyHandles = sphdr.numCopyHandles
    response.numMoveHandles = sphdr.numMoveHandles
    ##  Parse PID descriptor
    if sphdr.sendPid.bool:
      response.pid = cast[ptr U64](base)[]
      base = cast[ptr U8](base) + sizeof((U64))
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
