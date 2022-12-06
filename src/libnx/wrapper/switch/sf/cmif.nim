## *
##  @file cmif.h
##  @brief Common Message Interface Framework protocol
##  @author fincs
##  @author SciresM
##  @copyright libnx Authors
##

import
  hipc, ../types, ../result, ../arm/tls, ../kernel/svc

const
  CMIF_IN_HEADER_MAGIC* = 0x49434653
  CMIF_OUT_HEADER_MAGIC* = 0x4F434653

type
  CmifCommandType* = enum
    CmifCommandTypeInvalid = 0, CmifCommandTypeLegacyRequest = 1,
    CmifCommandTypeClose = 2, CmifCommandTypeLegacyControl = 3,
    CmifCommandTypeRequest = 4, CmifCommandTypeControl = 5,
    CmifCommandTypeRequestWithContext = 6, CmifCommandTypeControlWithContext = 7
  CmifDomainRequestType* = enum
    CmifDomainRequestTypeInvalid = 0, CmifDomainRequestTypeSendMessage = 1,
    CmifDomainRequestTypeClose = 2
  CmifInHeader* {.bycopy.} = object
    magic*: U32
    version*: U32
    commandId*: U32
    token*: U32

  CmifOutHeader* {.bycopy.} = object
    magic*: U32
    version*: U32
    result*: Result
    token*: U32

  CmifDomainInHeader* {.bycopy.} = object
    `type`*: U8
    numInObjects*: U8
    dataSize*: U16
    objectId*: U32
    padding*: U32
    token*: U32

  CmifDomainOutHeader* {.bycopy.} = object
    numOutObjects*: U32
    padding*: array[3, U32]

  CmifRequestFormat* {.bycopy.} = object
    objectId*: U32
    requestId*: U32
    context*: U32
    dataSize*: U32
    serverPointerSize*: U32
    numInAutoBuffers*: U32
    numOutAutoBuffers*: U32
    numInBuffers*: U32
    numOutBuffers*: U32
    numInoutBuffers*: U32
    numInPointers*: U32
    numOutPointers*: U32
    numOutFixedPointers*: U32
    numObjects*: U32
    numHandles*: U32
    sendPid*: U32

  CmifRequest* {.bycopy.} = object
    hipc*: HipcRequest
    data*: pointer
    outPointerSizes*: ptr U16
    objects*: ptr U32
    serverPointerSize*: U32
    curInPtrId*: U32

  CmifResponse* {.bycopy.} = object
    data*: pointer
    objects*: ptr U32
    copyHandles*: ptr Handle
    moveHandles*: ptr Handle


proc cmifGetAlignedDataStart*(dataWords: ptr U32; base: pointer): pointer {.inline,
    cdecl.} =
  {.emit: "    intptr_t data_start = ((u8*)`dataWords` - (u8*)`base` + 15) &~ 15;".}
  {.emit: "    `result` = (u8*)base + data_start;".}

proc cmifMakeRequest*(base: pointer; fmt: CmifRequestFormat): CmifRequest {.inline,
    cdecl.} =
  {.emit: "    u32 actual_size = 16;".}
  {.emit: "    if (`fmt`.object_id)".}
  {.emit: "        actual_size += sizeof(CmifDomainInHeader) + `fmt`.num_objects*sizeof(u32);".}
  {.emit: "    actual_size += sizeof(CmifInHeader) + `fmt`.data_size;".}
  {.emit: "    actual_size = (actual_size + 1) &~ 1; // hword-align".}
  {.emit: "    u32 out_pointer_size_table_offset = actual_size;".}
  {.emit: "    u32 out_pointer_size_table_size = `fmt`.num_out_auto_buffers + `fmt`.num_out_pointers;".}
  {.emit: "    actual_size += sizeof(u16)*out_pointer_size_table_size;".}
  {.emit: "    u32 num_data_words = (actual_size + 3) / 4;".}
  {.emit: "    CmifRequest req = {};".}
  {.emit: "    req.hipc = hipcMakeRequestInline(`base`,".}
  {.emit: "        .type             = `fmt`.context ? CmifCommandType_RequestWithContext : CmifCommandType_Request,".}
  {.emit: "        .num_send_statics = `fmt`.num_in_auto_buffers  + `fmt`.num_in_pointers,".}
  {.emit: "        .num_send_buffers = `fmt`.num_in_auto_buffers  + `fmt`.num_in_buffers,".}
  {.emit: "        .num_recv_buffers = `fmt`.num_out_auto_buffers + `fmt`.num_out_buffers,".}
  {.emit: "        .num_exch_buffers = `fmt`.num_inout_buffers,".}
  {.emit: "        .num_data_words   = num_data_words,".}
  {.emit: "        .num_recv_statics = out_pointer_size_table_size + `fmt`.num_out_fixed_pointers,".}
  {.emit: "        .send_pid         = `fmt`.send_pid,".}
  {.emit: "        .num_copy_handles = `fmt`.num_handles,".}
  {.emit: "        .num_move_handles = 0,".}
  {.emit: "    );".}
  {.emit: "    CmifInHeader* hdr = NULL;".}
  {.emit: "    void* start = cmifGetAlignedDataStart(req.hipc.data_words, `base`);".}
  {.emit: "    if (`fmt`.object_id) {".}
  {.emit: "        CmifDomainInHeader* domain_hdr = (CmifDomainInHeader*)start;".}
  {.emit: "        u32 payload_size = sizeof(CmifInHeader) + `fmt`.data_size;".}
  {.emit: "        *domain_hdr = (CmifDomainInHeader){".}
  {.emit: "            .type           = CmifDomainRequestType_SendMessage,".}
  {.emit: "            .num_in_objects = (u8)`fmt`.num_objects,".}
  {.emit: "            .data_size      = (u16)payload_size,".}
  {.emit: "            .object_id      = `fmt`.object_id,".}
  {.emit: "            .padding        = 0,".}
  {.emit: "            .token          = `fmt`.context,".}
  {.emit: "        };".}
  {.emit: "        hdr = (CmifInHeader*)(domain_hdr+1);".}
  {.emit: "        req.objects = (u32*)((u8*)hdr + payload_size);".}
  {.emit: "    } else".}
  {.emit: "        hdr = (CmifInHeader*)start;".}
  {.emit: "    *hdr = (CmifInHeader){".}
  {.emit: "        .magic      = CMIF_IN_HEADER_MAGIC,".}
  {.emit: "        .version    = `fmt`.context ? 1U : 0U,".}
  {.emit: "        .command_id = `fmt`.request_id,".}
  {.emit: "        .token      = `fmt`.object_id ? 0U : `fmt`.context,".}
  {.emit: "    };".}
  {.emit: "    req.data = hdr+1;".}
  {.emit: "    req.out_pointer_sizes = (u16*)(void*)((u8*)(void*)req.hipc.data_words + out_pointer_size_table_offset);".}
  {.emit: "    req.server_pointer_size = `fmt`.server_pointer_size;".}
  {.emit: "    `result` =  req;".}

proc cmifMakeControlRequest*(base: pointer; requestId: U32; size: U32): pointer {.
    inline, cdecl.} =
  var base = base
  var actualSize: U32 = 16 + sizeof((CmifInHeader)) + size
  var hipc = hipcMakeRequestInline(base,
        `type` = CmifCommandType_Control.U32,
        num_data_words = ((actual_size + 3).int / 4).U32
  )
  var hdr: ptr CmifInHeader = cast[ptr CmifInHeader](cmifGetAlignedDataStart(
      hipc.dataWords, base))
  hdr.magic = CMIF_IN_HEADER_MAGIC
  hdr.version = 0
  hdr.commandId = requestId
  hdr.token = 0
  return hdr + 1

proc cmifMakeCloseRequest*(base: pointer; objectId: U32) {.inline, cdecl,
    importc: "cmifMakeCloseRequest".} =
  var base = base
  if objectId.bool:
    var hipc = hipcMakeRequestInline(base,
          `type` = CmifCommandTypeRequest.U32,
          num_data_words = ((16 + sizeof(CmifDomainInHeader))/4).U32
    )
    var domainHdr: ptr CmifDomainInHeader = cast[ptr CmifDomainInHeader](cmifGetAlignedDataStart(
        hipc.dataWords, base))
    domainHdr.`type` = CmifDomainRequestTypeClose.U8
    domainHdr.objectId = objectId
  else:
    discard hipcMakeRequestInline(base,
        `type` = CmifCommandType_Close.U32
    );

proc cmifRequestInBuffer*(req: ptr CmifRequest; buffer: pointer; size: csize_t;
                         mode: HipcBufferMode) {.inline, cdecl,
    importc: "cmifRequestInBuffer".} =
  req.hipc.sendBuffers += 1
  req.hipc.sendBuffers[] = hipcMakeBuffer(buffer, size, mode)

proc cmifRequestOutBuffer*(req: ptr CmifRequest; buffer: pointer; size: csize_t;
                          mode: HipcBufferMode) {.inline, cdecl,
    importc: "cmifRequestOutBuffer".} =
  req.hipc.recvBuffers += 1
  req.hipc.recvBuffers[] = hipcMakeBuffer(buffer, size, mode)

proc cmifRequestInOutBuffer*(req: ptr CmifRequest; buffer: pointer; size: csize_t;
                            mode: HipcBufferMode) {.inline, cdecl,
    importc: "cmifRequestInOutBuffer".} =
  req.hipc.exchBuffers += 1
  req.hipc.exchBuffers[] = hipcMakeBuffer(buffer, size, mode)

proc cmifRequestInPointer*(req: ptr CmifRequest; buffer: pointer; size: csize_t) {.
    inline, cdecl, importc: "cmifRequestInPointer".} =
  req.hipc.sendStatics += 1
  req.hipc.sendStatics[] = hipcMakeSendStatic(buffer, size, req.curInPtrId.U8)
  req.curInPtrId += 1
  dec(req.serverPointerSize, size)

proc cmifRequestOutFixedPointer*(req: ptr CmifRequest; buffer: pointer; size: csize_t) {.
    inline, cdecl, importc: "cmifRequestOutFixedPointer".} =
  req.hipc.recvList += 1
  req.hipc.recvList[] = hipcMakeRecvStatic(buffer, size)
  dec(req.serverPointerSize, size)

proc cmifRequestOutPointer*(req: ptr CmifRequest; buffer: pointer; size: csize_t) {.
    inline, cdecl.} =
  cmifRequestOutFixedPointer(req, buffer, size)
  req.outPointerSizes += 1
  req.outPointerSizes[] = size.U16

proc cmifRequestInAutoBuffer*(req: ptr CmifRequest; buffer: pointer; size: csize_t;
                             mode: HipcBufferMode) {.inline, cdecl,
    importc: "cmifRequestInAutoBuffer".} =
  if req.serverPointerSize.bool and size <= req.serverPointerSize:
    cmifRequestInPointer(req, buffer, size)
    cmifRequestInBuffer(req, nil, 0, mode)
  else:
    cmifRequestInPointer(req, nil, 0)
    cmifRequestInBuffer(req, buffer, size, mode)

proc cmifRequestOutAutoBuffer*(req: ptr CmifRequest; buffer: pointer; size: csize_t;
                              mode: HipcBufferMode) {.inline, cdecl,
    importc: "cmifRequestOutAutoBuffer".} =
  if req.serverPointerSize.bool and size <= req.serverPointerSize:
    cmifRequestOutPointer(req, buffer, size)
    cmifRequestOutBuffer(req, nil, 0, mode)
  else:
    cmifRequestOutPointer(req, nil, 0)
    cmifRequestOutBuffer(req, buffer, size, mode)

proc cmifRequestObject*(req: ptr CmifRequest; objectId: U32) {.inline, cdecl,
    importc: "cmifRequestObject".} =
  req.objects += 1
  req.objects[] = objectId

proc cmifRequestHandle*(req: ptr CmifRequest; handle: Handle) {.inline, cdecl,
    importc: "cmifRequestHandle".} =
  req.hipc.copyHandles += 1
  req.hipc.copyHandles[] = handle

proc cmifParseResponse*(res: ptr CmifResponse; base: pointer; isDomain: bool; size: U32): Result {.
    inline, cdecl, importc: "cmifParseResponse".} =
  var base = base
  var hipc: HipcResponse = hipcParseResponse(base)
  var start: pointer = cmifGetAlignedDataStart(hipc.dataWords, base)
  var hdr: ptr CmifOutHeader = nil
  var objects: ptr U32 = nil
  if isDomain:
    var domainHdr: ptr CmifDomainOutHeader = cast[ptr CmifDomainOutHeader](start)
    hdr = cast[ptr CmifOutHeader]((domainHdr + 1))
    objects = cast[ptr U32]((cast[ptr U8](hdr) + sizeof((CmifOutHeader)) +
        size))
  else:
    hdr = cast[ptr CmifOutHeader](start)
  if hdr.magic != Cmif_Out_Header_Magic:
    return makeResult(ModuleLibnx, LibnxErrorInvalidCmifOutHeader)
  if r_Failed(hdr.result):
    return hdr.result
  ## !!!Ignored construct:  * res = ( CmifResponse ) { . data = hdr + 1 , . objects = objects , . copy_handles = hipc . copy_handles , . move_handles = hipc . move_handles , } ;
  ## Error: expected ';'!!!
  return 0

proc cmifResponseGetObject*(res: ptr CmifResponse): U32 {.inline, cdecl,
    importc: "cmifResponseGetObject".} =
  res.objects += 1
  return res.objects[]

proc cmifResponseGetCopyHandle*(res: ptr CmifResponse): Handle {.inline, cdecl,
    importc: "cmifResponseGetCopyHandle".} =
  res.copyHandles += 1
  return res.copyHandles[]

proc cmifResponseGetMoveHandle*(res: ptr CmifResponse): Handle {.inline, cdecl,
    importc: "cmifResponseGetMoveHandle".} =
  res.moveHandles += 1
  return res.moveHandles[]

proc cmifConvertCurrentObjectToDomain*(h: Handle; outObjectId: ptr U32): Result {.
    inline, cdecl, importc: "cmifConvertCurrentObjectToDomain".} =
  var p = armGetTls()
  discard cmifMakeControlRequest(p, 0, 0)
  var rc: Result = svcSendSyncRequest(h)
  if r_Succeeded(rc):
    var resp: CmifResponse = CmifResponse()
    var p = armGetTls()
    rc = cmifParseResponse(addr(resp), p, false, sizeof((U32)).U32)
    if r_Succeeded(rc) and outObjectId != nil:
      outObjectId[] = cast[ptr U32](resp.data)[]
  return rc

proc cmifCopyFromCurrentDomain*(h: Handle; objectId: U32; outH: ptr Handle): Result {.
    inline, cdecl, importc: "cmifCopyFromCurrentDomain".} =
  var p = armGetTls()
  var raw: pointer = cmifMakeControlRequest(p, 1, sizeof((U32)).U32)
  cast[ptr U32](raw)[] = objectId
  var rc: Result = svcSendSyncRequest(h)
  if r_Succeeded(rc):
    var resp: CmifResponse = CmifResponse()
    p = armGetTls()
    rc = cmifParseResponse(addr(resp), p, false, 0)
    if r_Succeeded(rc) and outH != nil:
      outH[] = resp.moveHandles[0]
  return rc

proc cmifCloneCurrentObject*(h: Handle; outH: ptr Handle): Result {.inline, cdecl,
    importc: "cmifCloneCurrentObject".} =
  discard cmifMakeControlRequest(armGetTls(), 2, 0)
  var rc: Result = svcSendSyncRequest(h)
  if r_Succeeded(rc):
    var resp: CmifResponse = CmifResponse()
    rc = cmifParseResponse(addr(resp), armGetTls(), false, 0.U32)
    if r_Succeeded(rc) and outH != nil:
      outH[] = resp.moveHandles[0]
  return rc

proc cmifQueryPointerBufferSize*(h: Handle; outSize: ptr U16): Result {.inline, cdecl,
    importc: "cmifQueryPointerBufferSize".} =
  discard cmifMakeControlRequest(armGetTls(), 3, 0)
  var rc: Result = svcSendSyncRequest(h)
  if r_Succeeded(rc):
    var resp: CmifResponse = CmifResponse()
    rc = cmifParseResponse(addr(resp), armGetTls(), false, sizeof((U16)).U32)
    if r_Succeeded(rc) and outSize != nil:
      outSize[] = cast[ptr U16](resp.data)[]
  return rc

proc cmifCloneCurrentObjectEx*(h: Handle; tag: U32; outH: ptr Handle): Result {.inline,
    cdecl, importc: "cmifCloneCurrentObjectEx".} =
  var raw: pointer = cmifMakeControlRequest(armGetTls(), 4, sizeof((U32)).U32)
  cast[ptr U32](raw)[] = tag
  var rc: Result = svcSendSyncRequest(h)
  if r_Succeeded(rc):
    var resp: CmifResponse = CmifResponse()
    rc = cmifParseResponse(addr(resp), armGetTls(), false, 0)
    if r_Succeeded(rc) and outH != nil:
      outH[] = resp.moveHandles[0]
  return rc
