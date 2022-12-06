## *
##  @file hipc.h
##  @brief Horizon Inter-Process Communication protocol
##  @author fincs
##  @author SciresM
##  @copyright libnx Authors
##
import ../types
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
    inline, cdecl, importc: "hipcMakeSendStatic".} =
  return HipcStaticDescriptor(
      index: index,
      address_high: (U32)(cast[uintptr_t](buffer) shr 36),
      address_mid: (U32)(cast[uintptr_t](buffer) shr 32),
      size: (U32)size,
      address_low: cast[U32](buffer),
  )

proc hipcMakeBuffer*(buffer: pointer; size: csize_t; mode: HipcBufferMode): HipcBufferDescriptor {.
    inline, cdecl, importc: "hipcMakeBuffer".} =
  return HipcBufferDescriptor(
      size_low: (U32)size,
      address_low: (U32)cast[uintptr_t](buffer),
      mode: mode.U32,
      address_high: (U32)(cast[uintptr_t](buffer) shr 36),
      size_high: (U32)(size shr 32),
      address_mid: (U32)(cast[uintptr_t](buffer) shr 32),
  )

proc hipcMakeRecvStatic*(buffer: pointer; size: csize_t): HipcRecvListEntry {.inline,
    cdecl, importc: "hipcMakeRecvStatic".} =
  return HipcRecvListEntry(
      address_low: (U32)(cast[uintptr_t](buffer)),
      address_high: (U32)(cast[uintptr_t](buffer) shr 32),
      size: (U32)size,
  )

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
  var base = base
  ##  Copy handles
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


proc hipcMakeRequest*(base: pointer; meta: HipcMetadata): HipcRequest {.inline, cdecl,
    importc: "hipcMakeRequest".} =
  ##  Write message header
  var base = base
  var hasSpecialHeader = (meta.sendPid or meta.numCopyHandles or
      meta.numMoveHandles)
  var hdr: ptr HipcHeader = cast[ptr HipcHeader](base)
  base = hdr + 1
  hdr[] = HipcHeader(
      `type`: meta.`type`,
      num_send_statics: meta.num_send_statics,
      num_send_buffers: meta.num_send_buffers,
      num_recv_buffers: meta.num_recv_buffers,
      num_exch_buffers: meta.num_exch_buffers,
      num_data_words: meta.num_data_words,
      recv_static_mode: if meta.num_recv_statics.bool:
        if meta.num_recv_statics != HIPC_AUTO_RECV_STATIC: 2'u32 + meta.num_recv_statics
        else: 2'u32
        else: 0'u32,
      padding: 0,
      recv_list_offset: 0,
      has_special_header: has_special_header,
  )
  ##  Write special header
  if hasSpecialHeader.bool:
    var sphdr: ptr HipcSpecialHeader = cast[ptr HipcSpecialHeader](base)
    base = sphdr + 1
    sphdr[] = HipcSpecialHeader(
        send_pid         : meta.send_pid,
        num_copy_handles : meta.num_copy_handles,
        num_move_handles : meta.num_move_handles
    )
    if meta.sendPid.bool:
      base = cast[ptr U8](base) + sizeof((U64))
  return hipcCalcRequestLayout(meta, base)

#define hipcMakeRequestInline(_base,...) hipcMakeRequest((_base),(HipcMetadata){ __VA_ARGS__ })
proc hipcMakeRequestInline*(base: pointer, `type`: U32 = 0, numSendStatics: U32 = 0,
    numSendBuffers: U32 = 0, numRecvBuffers: U32 = 0, numExchBuffers: U32 = 0,
    numDataWords: U32 = 0, numRecvStatics: U32 = 0, sendPid: U32 = 0,
    numCopyHandles: U32 = 0, numMoveHandles: U32 = 0): HipcRequest {.inline, cdecl.} =
  var base = base
  hipcMakeRequest(base, HipcMetadata(
      `type`: `type`,
      numSendStatics: numSendStatics,
      numSendBuffers: numSendBuffers,
      numRecvBuffers: numRecvBuffers,
      numExchBuffers: numExchBuffers,
      numDataWords: numDataWords,
      numRecvStatics: numRecvStatics,       ##  also accepts HIPC_AUTO_RECV_STATIC
      sendPid: sendPid,
      numCopyHandles: numCopyHandles,
      numMoveHandles: numMoveHandles
    )
  )

## !!!Ignored construct:  # ( _base , ... ) hipcMakeRequest ( ( _base ) , ( HipcMetadata ) { __VA_ARGS__ } ) [NewLine] static inline HipcParsedRequest hipcParseRequest ( void * base ) {  Parse message header HipcHeader hdr = { } ; __builtin_memcpy ( & hdr , base , sizeof ( hdr ) ) ; base = ( u8 * ) base + sizeof ( hdr ) ; u32 num_recv_statics = 0 ; u64 pid = 0 ;  Parse recv static mode if ( hdr . recv_static_mode ) { if ( hdr . recv_static_mode == 2u ) num_recv_statics = HIPC_AUTO_RECV_STATIC ; else if ( hdr . recv_static_mode > 2u ) num_recv_statics = hdr . recv_static_mode - 2u ; }  Parse special header HipcSpecialHeader sphdr = { } ; if ( hdr . has_special_header ) { __builtin_memcpy ( & sphdr , base , sizeof ( sphdr ) ) ; base = ( u8 * ) base + sizeof ( sphdr ) ;  Read PID descriptor if ( sphdr . send_pid ) { pid = * ( u64 * ) base ; base = ( u8 * ) base + sizeof ( u64 ) ; } } const HipcMetadata meta = { . type = hdr . type , . num_send_statics = hdr . num_send_statics , . num_send_buffers = hdr . num_send_buffers , . num_recv_buffers = hdr . num_recv_buffers , . num_exch_buffers = hdr . num_exch_buffers , . num_data_words = hdr . num_data_words , . num_recv_statics = num_recv_statics , . send_pid = sphdr . send_pid , . num_copy_handles = sphdr . num_copy_handles , . num_move_handles = sphdr . num_move_handles , } ; return ( HipcParsedRequest ) { . meta = meta , . data = hipcCalcRequestLayout ( meta , base ) , . pid = pid , } ; } static inline HipcResponse hipcParseResponse ( void * base ) {  Parse header HipcHeader hdr = { } ; __builtin_memcpy ( & hdr , base , sizeof ( hdr ) ) ; base = ( u8 * ) base + sizeof ( hdr ) ;  Initialize response HipcResponse response = { } ; response . num_statics = hdr . num_send_statics ; response . num_data_words = hdr . num_data_words ; response . pid = HIPC_RESPONSE_NO_PID ;  Parse special header if ( hdr . has_special_header ) { HipcSpecialHeader sphdr = { } ; __builtin_memcpy ( & sphdr , base , sizeof ( sphdr ) ) ; base = ( u8 * ) base + sizeof ( sphdr ) ;  Update response response . num_copy_handles = sphdr . num_copy_handles ; response . num_move_handles = sphdr . num_move_handles ;  Parse PID descriptor if ( sphdr . send_pid ) { response . pid = * ( u64 * ) base ; base = ( u8 * ) base + sizeof ( u64 ) ; } }  Copy handles response . copy_handles = ( Handle * ) base ; base = response . copy_handles + response . num_copy_handles ;  Move handles response . move_handles = ( Handle * ) base ; base = response . move_handles + response . num_move_handles ;  Send statics response . statics = ( HipcStaticDescriptor * ) base ; base = response . statics + response . num_statics ;  Data words response . data_words = ( u32 * ) base ; return response ; }
## Error: identifier expected, but got: (!!!

proc hipcParseRequest*(base: pointer): HipcParsedRequest {.inline, cdecl.} =
  ##  Parse message header
  # {.emit: "    // Parse message header".}
  # {.emit: "    HipcHeader hdr = {};".}
  # {.emit: "    __builtin_memcpy(&hdr, `base`, sizeof(hdr));".}
  # {.emit: "    `base` = (u8*)`base` + sizeof(hdr);".}
  # {.emit: "    u32 num_recv_statics = 0;".}
  # {.emit: "    u64 pid = 0;".}
  # {.emit: "    // Parse recv static mode".}
  # {.emit: "    if (hdr.recv_static_mode) {".}
  # {.emit: "        if (hdr.recv_static_mode == 2u)".}
  # {.emit: "            num_recv_statics = HIPC_AUTO_RECV_STATIC;".}
  # {.emit: "        else if (hdr.recv_static_mode > 2u)".}
  # {.emit: "            num_recv_statics = hdr.recv_static_mode - 2u;".}
  # {.emit: "    }".}
  # {.emit: "    // Parse special header".}
  # {.emit: "    HipcSpecialHeader sphdr = {};".}
  # {.emit: "    if (hdr.has_special_header) {".}
  # {.emit: "        __builtin_memcpy(&sphdr, `base`, sizeof(sphdr));".}
  # {.emit: "        `base` = (u8*)`base` + sizeof(sphdr);".}
  # {.emit: "        if (sphdr.send_pid) {".}
  # {.emit: "            pid = *(u64*)`base`;".}
  # {.emit: "            `base` = (u8*)`base` + sizeof(u64);".}
  # {.emit: "        }".}
  # {.emit: "    }".}
  # {.emit: "    const HipcMetadata meta = {".}
  # {.emit: "        .type             = hdr.type,".}
  # {.emit: "        .num_send_statics = hdr.num_send_statics,".}
  # {.emit: "        .num_send_buffers = hdr.num_send_buffers,".}
  # {.emit: "        .num_recv_buffers = hdr.num_recv_buffers,".}
  # {.emit: "        .num_exch_buffers = hdr.num_exch_buffers,".}
  # {.emit: "        .num_data_words   = hdr.num_data_words,".}
  # {.emit: "        .num_recv_statics = num_recv_statics,".}
  # {.emit: "        .send_pid         = sphdr.send_pid,".}
  # {.emit: "        .num_copy_handles = sphdr.num_copy_handles,".}
  # {.emit: "        .num_move_handles = sphdr.num_move_handles,".}
  # {.emit: "    };".}
  # {.emit: "    `result` = (HipcParsedRequest){".}
  # {.emit: "        .meta = meta,".}
  # {.emit: "        .data = hipcCalcRequestLayout(meta, `base`),".}
  # {.emit: "        .pid  = pid,".}
  # {.emit: "    };".}
  var base = base
  var hdr: HipcHeader = HipcHeader()
  copyMem(addr(hdr), base, sizeof((hdr)))
  base = cast[ptr U8](base) + sizeof((hdr))
  var numRecvStatics: U32 = 0
  var pid: U64 = 0
  ##  Parse recv static mode
  if hdr.recvStaticMode.bool:
    if hdr.recvStaticMode == 2'u:
      numRecvStatics = Hipc_Auto_Recv_Static
    elif hdr.recvStaticMode > 2'u:
      numRecvStatics = hdr.recvStaticMode - 2'u32
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
    pid: pid
  )

proc hipcParseResponse*(base: pointer): HipcResponse {.inline, cdecl.} =
  ##  Parse header
  var base = base
  var hdr: HipcHeader = HipcHeader()
  copyMem(addr(hdr), base, sizeof((hdr)))
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

