import strutils
import ospaths
const headeripc = currentSourcePath().splitPath().head & "/nx/include/switch/kernel/ipc.h"
## *
##  @file ipc.h
##  @brief Inter-process communication handling
##  @author plutoo
##  @copyright libnx Authors
## 

import
  libnx/wrapper/types,
  libnx/wrapper/result, libnx/wrapper/tls, libnx/wrapper/svc

## / IPC input header magic

const
  SFCI_MAGIC* = 0x49434653

## / IPC output header magic

const
  SFCO_MAGIC* = 0x4F434653

## / IPC invalid object ID

const
  IPC_INVALID_OBJECT_ID* = uint32.high

## /@name IPC request building
## /@{
## / IPC command (request) structure.

const
  IPC_MAX_BUFFERS* = 8
  IPC_MAX_OBJECTS* = 8

type
  BufferType* {.size: sizeof(cint).} = enum
    BufferType_Normal = 0,      ## /< Regular buffer.
    BufferType_Type1 = 1,       ## /< Allows ProcessMemory and shared TransferMemory.
    BufferType_Invalid = 2, BufferType_Type3 = 3
  BufferDirection* {.size: sizeof(cint).} = enum
    BufferDirection_Send = 0, BufferDirection_Recv = 1, BufferDirection_Exch = 2
  IpcCommandType* {.size: sizeof(cint).} = enum
    IpcCommandType_Invalid = 0, IpcCommandType_LegacyRequest = 1,
    IpcCommandType_Close = 2, IpcCommandType_LegacyControl = 3,
    IpcCommandType_Request = 4, IpcCommandType_Control = 5,
    IpcCommandType_RequestWithContext = 6, IpcCommandType_ControlWithContext = 7
  DomainMessageType* {.size: sizeof(cint).} = enum
    DomainMessageType_Invalid = 0, DomainMessageType_SendMessage = 1,
    DomainMessageType_Close = 2





## / IPC domain message header.

type
  DomainMessageHeader* {.importc: "DomainMessageHeader", header: headeripc, bycopy.} = object
    Type* {.importc: "Type".}: uint8
    NumObjectIds* {.importc: "NumObjectIds".}: uint8
    Length* {.importc: "Length".}: uint16
    ThisObjectId* {.importc: "ThisObjectId".}: uint32
    Pad* {.importc: "Pad".}: array[2, uint32]

  IpcCommand* {.importc: "IpcCommand", header: headeripc, bycopy.} = object
    NumSend* {.importc: "NumSend".}: csize ##  A
    NumRecv* {.importc: "NumRecv".}: csize ##  B
    NumExch* {.importc: "NumExch".}: csize ##  W
    Buffers* {.importc: "Buffers".}: array[IPC_MAX_BUFFERS, pointer]
    BufferSizes* {.importc: "BufferSizes".}: array[IPC_MAX_BUFFERS, csize]
    BufferTypes* {.importc: "BufferTypes".}: array[IPC_MAX_BUFFERS, BufferType]
    NumStaticIn* {.importc: "NumStaticIn".}: csize ##  X
    NumStaticOut* {.importc: "NumStaticOut".}: csize ##  C
    Statics* {.importc: "Statics".}: array[IPC_MAX_BUFFERS, pointer]
    StaticSizes* {.importc: "StaticSizes".}: array[IPC_MAX_BUFFERS, csize]
    StaticIndices* {.importc: "StaticIndices".}: array[IPC_MAX_BUFFERS, uint8]
    SendPid* {.importc: "SendPid".}: bool
    NumHandlesCopy* {.importc: "NumHandlesCopy".}: csize
    NumHandlesMove* {.importc: "NumHandlesMove".}: csize
    Handles* {.importc: "Handles".}: array[IPC_MAX_OBJECTS, Handle]
    NumObjectIds* {.importc: "NumObjectIds".}: csize
    ObjectIds* {.importc: "ObjectIds".}: array[IPC_MAX_OBJECTS, uint32]


## *
##  @brief Initializes an IPC command structure.
##  @param cmd IPC command structure.
## 

proc ipcInitialize*(cmd: ptr IpcCommand) {.inline, cdecl, importc: "ipcInitialize",
                                       header: headeripc.}
## / IPC buffer descriptor.

type
  IpcBufferDescriptor* {.importc: "IpcBufferDescriptor", header: headeripc, bycopy.} = object
    Size* {.importc: "Size".}: uint32 ## /< Size of the buffer.
    Addr* {.importc: "Addr".}: uint32 ## /< Lower 32-bits of the address of the buffer
    Packed* {.importc: "Packed".}: uint32 ## /< Packed data (including higher bits of the address)
  

## / IPC static send-buffer descriptor.

type
  IpcStaticSendDescriptor* {.importc: "IpcStaticSendDescriptor", header: headeripc,
                            bycopy.} = object
    Packed* {.importc: "Packed".}: uint32 ## /< Packed data (including higher bits of the address)
    Addr* {.importc: "Addr".}: uint32 ## /< Lower 32-bits of the address
  

## / IPC static receive-buffer descriptor.

type
  IpcStaticRecvDescriptor* {.importc: "IpcStaticRecvDescriptor", header: headeripc,
                            bycopy.} = object
    Addr* {.importc: "Addr".}: uint32 ## /< Lower 32-bits of the address of the buffer
    Packed* {.importc: "Packed".}: uint32 ## /< Packed data (including higher bits of the address)
  

## *
##  @brief Adds a buffer to an IPC command structure.
##  @param cmd IPC command structure.
##  @param buffer Address of the buffer.
##  @param size Size of the buffer.
##  @param type Buffer type.
## 

proc ipcAddSendBuffer*(cmd: ptr IpcCommand; buffer: pointer; size: csize;
                      `type`: BufferType) {.inline, cdecl,
    importc: "ipcAddSendBuffer", header: headeripc.}
## *
##  @brief Adds a receive-buffer to an IPC command structure.
##  @param cmd IPC command structure.
##  @param buffer Address of the buffer.
##  @param size Size of the buffer.
##  @param type Buffer type.
## 

proc ipcAddRecvBuffer*(cmd: ptr IpcCommand; buffer: pointer; size: csize;
                      `type`: BufferType) {.inline, cdecl,
    importc: "ipcAddRecvBuffer", header: headeripc.}
## *
##  @brief Adds an exchange-buffer to an IPC command structure.
##  @param cmd IPC command structure.
##  @param buffer Address of the buffer.
##  @param size Size of the buffer.
##  @param type Buffer type.
## 

proc ipcAddExchBuffer*(cmd: ptr IpcCommand; buffer: pointer; size: csize;
                      `type`: BufferType) {.inline, cdecl,
    importc: "ipcAddExchBuffer", header: headeripc.}
## *
##  @brief Adds a static-buffer to an IPC command structure.
##  @param cmd IPC command structure.
##  @param buffer Address of the buffer.
##  @param size Size of the buffer.
##  @param index Index of buffer.
## 

proc ipcAddSendStatic*(cmd: ptr IpcCommand; buffer: pointer; size: csize; index: uint8) {.
    inline, cdecl, importc: "ipcAddSendStatic", header: headeripc.}
## *
##  @brief Adds a static-receive-buffer to an IPC command structure.
##  @param cmd IPC command structure.
##  @param buffer Address of the buffer.
##  @param size Size of the buffer.
##  @param index Index of buffer.
## 

proc ipcAddRecvStatic*(cmd: ptr IpcCommand; buffer: pointer; size: csize; index: uint8) {.
    inline, cdecl, importc: "ipcAddRecvStatic", header: headeripc.}
## *
##  @brief Adds a smart-buffer (buffer + static-buffer pair) to an IPC command structure.
##  @param cmd IPC command structure.
##  @param ipc_buffer_size IPC buffer size.
##  @param buffer Address of the buffer.
##  @param size Size of the buffer.
##  @param index Index of buffer.
## 

proc ipcAddSendSmart*(cmd: ptr IpcCommand; ipc_buffer_size: csize; buffer: pointer;
                     size: csize; index: uint8) {.inline, cdecl,
    importc: "ipcAddSendSmart", header: headeripc.}
## *
##  @brief Adds a smart-receive-buffer (buffer + static-receive-buffer pair) to an IPC command structure.
##  @param cmd IPC command structure.
##  @param ipc_buffer_size IPC buffer size.
##  @param buffer Address of the buffer.
##  @param size Size of the buffer.
##  @param index Index of buffer.
## 

proc ipcAddRecvSmart*(cmd: ptr IpcCommand; ipc_buffer_size: csize; buffer: pointer;
                     size: csize; index: uint8) {.inline, cdecl,
    importc: "ipcAddRecvSmart", header: headeripc.}
## *
##  @brief Tags an IPC command structure to send the PID.
##  @param cmd IPC command structure.
## 

proc ipcSendPid*(cmd: ptr IpcCommand) {.inline, cdecl, importc: "ipcSendPid",
                                    header: headeripc.}
## *
##  @brief Adds a copy-handle to be sent through an IPC command structure.
##  @param cmd IPC command structure.
##  @param h Handle to send.
##  @remark The receiving process gets a copy of the handle.
## 

proc ipcSendHandleCopy*(cmd: ptr IpcCommand; h: Handle) {.inline, cdecl,
    importc: "ipcSendHandleCopy", header: headeripc.}
## *
##  @brief Adds a move-handle to be sent through an IPC command structure.
##  @param cmd IPC command structure.
##  @param h Handle to send.
##  @remark The sending process loses ownership of the handle, which is transferred to the receiving process.
## 

proc ipcSendHandleMove*(cmd: ptr IpcCommand; h: Handle) {.inline, cdecl,
    importc: "ipcSendHandleMove", header: headeripc.}
## *
##  @brief Prepares the header of an IPC command structure.
##  @param cmd IPC command structure.
##  @param sizeof_raw Size in bytes of the raw data structure to embed inside the IPC request
##  @return Pointer to the raw embedded data structure in the request, ready to be filled out.
## 

proc ipcPrepareHeader*(cmd: ptr IpcCommand; sizeof_raw: csize): pointer {.inline,
    cdecl, importc: "ipcPrepareHeader", header: headeripc.}
## *
##  @brief Dispatches an IPC request.
##  @param session IPC session handle.
##  @return Result code.
## 

proc ipcDispatch*(session: Handle): Result {.inline, cdecl, importc: "ipcDispatch",
    header: headeripc.}
## /@}
## /@name IPC response parsing
## /@{
## / IPC parsed command (response) structure.

type
  IpcParsedCommand* {.importc: "IpcParsedCommand", header: headeripc, bycopy.} = object
    CommandType* {.importc: "CommandType".}: IpcCommandType ## /< Type of the command
    HasPid* {.importc: "HasPid".}: bool ## /< true if the 'Pid' field is filled out.
    Pid* {.importc: "Pid".}: uint64 ## /< PID included in the response (only if HasPid is true)
    NumHandles* {.importc: "NumHandles".}: csize ## /< Number of handles copied.
    Handles* {.importc: "Handles".}: array[IPC_MAX_OBJECTS, Handle] ## /< Handles.
    WasHandleCopied* {.importc: "WasHandleCopied".}: array[IPC_MAX_OBJECTS, bool] ## /< true if the handle was moved, false if it was copied.
    IsDomainMessage* {.importc: "IsDomainMessage".}: bool ## /< true if the the message is a Domain message.
    MessageType* {.importc: "MessageType".}: DomainMessageType ## /< Type of the domain message.
    MessageLength* {.importc: "MessageLength".}: uint32 ## /< Size of rawdata (for domain messages).
    ThisObjectId* {.importc: "ThisObjectId".}: uint32 ## /< Object ID to call the command on (for domain messages).
    NumObjectIds* {.importc: "NumObjectIds".}: csize ## /< Number of object IDs (for domain messages).
    ObjectIds* {.importc: "ObjectIds".}: array[IPC_MAX_OBJECTS, uint32] ## /< Object IDs (for domain messages).
    NumBuffers* {.importc: "NumBuffers".}: csize ## /< Number of buffers in the response.
    Buffers* {.importc: "Buffers".}: array[IPC_MAX_BUFFERS, pointer] ## /< Pointers to the buffers.
    BufferSizes* {.importc: "BufferSizes".}: array[IPC_MAX_BUFFERS, csize] ## /< Sizes of the buffers.
    BufferTypes* {.importc: "BufferTypes".}: array[IPC_MAX_BUFFERS, BufferType] ## /< Types of the buffers.
    BufferDirections* {.importc: "BufferDirections".}: array[IPC_MAX_BUFFERS,
        BufferDirection]      ## /< Direction of each buffer.
    NumStatics* {.importc: "NumStatics".}: csize ## /< Number of statics in the response.
    Statics* {.importc: "Statics".}: array[IPC_MAX_BUFFERS, pointer] ## /< Pointers to the statics.
    StaticSizes* {.importc: "StaticSizes".}: array[IPC_MAX_BUFFERS, csize] ## /< Sizes of the statics.
    StaticIndices* {.importc: "StaticIndices".}: array[IPC_MAX_BUFFERS, uint8] ## /< Indices of the statics.
    NumStaticsOut* {.importc: "NumStaticsOut".}: csize ## /< Number of output statics available in the response.
    Raw* {.importc: "Raw".}: pointer ## /< Pointer to the raw embedded data structure in the response.
    RawWithoutPadding* {.importc: "RawWithoutPadding".}: pointer ## /< Pointer to the raw embedded data structure, without padding.
    RawSize* {.importc: "RawSize".}: csize ## /< Size of the raw embedded data.
  

## *
##  @brief Parse an IPC command response into an IPC parsed command structure.
##  @param IPC parsed command structure to fill in.
##  @return Result code.
## 

proc ipcParse*(r: ptr IpcParsedCommand): Result {.inline, cdecl, importc: "ipcParse",
    header: headeripc.}
## *
##  @brief Queries the size of an IPC pointer buffer.
##  @param session IPC session handle.
##  @param size Output variable in which to store the size.
##  @return Result code.
## 

proc ipcQueryPointerBufferSize*(session: Handle; size: ptr csize): Result {.inline,
    cdecl, importc: "ipcQueryPointerBufferSize", header: headeripc.}
## *
##  @brief Closes the IPC session with proper clean up.
##  @param session IPC session handle.
##  @return Result code.
## 

proc ipcCloseSession*(session: Handle): Result {.inline, cdecl,
    importc: "ipcCloseSession", header: headeripc.}
## /@}
## /@name IPC domain handling
## /@{
## *
##  @brief Converts an IPC session handle into a domain.
##  @param session IPC session handle.
##  @param object_id_out Output variable in which to store the object ID.
##  @return Result code.
## 

proc ipcConvertSessionToDomain*(session: Handle; object_id_out: ptr uint32): Result {.
    inline, cdecl, importc: "ipcConvertSessionToDomain", header: headeripc.}
## *
##  @brief Adds an object ID to be sent through an IPC domain command structure.
##  @param cmd IPC domain command structure.
##  @param object_id Object ID to send.
## 

proc ipcSendObjectId*(cmd: ptr IpcCommand; object_id: uint32) {.inline, cdecl,
    importc: "ipcSendObjectId", header: headeripc.}
## *
##  @brief Prepares the header of an IPC command structure (domain version).
##  @param cmd IPC command structure.
##  @param sizeof_raw Size in bytes of the raw data structure to embed inside the IPC request
##  @oaram object_id Domain object ID.
##  @return Pointer to the raw embedded data structure in the request, ready to be filled out.
## 

proc ipcPrepareHeaderForDomain*(cmd: ptr IpcCommand; sizeof_raw: csize; object_id: uint32): pointer {.
    inline, cdecl, importc: "ipcPrepareHeaderForDomain", header: headeripc.}
## *
##  @brief Parse an IPC command response into an IPC parsed command structure (domain version).
##  @param IPC parsed command structure to fill in.
##  @return Result code.
## 

proc ipcParseForDomain*(r: ptr IpcParsedCommand): Result {.inline, cdecl,
    importc: "ipcParseForDomain", header: headeripc.}
## *
##  @brief Closes a domain object by ID.
##  @param session IPC session handle.
##  @param object_id ID of the object to close.
##  @return Result code.
## 

proc ipcCloseObjectById*(session: Handle; object_id: uint32): Result {.inline, cdecl,
    importc: "ipcCloseObjectById", header: headeripc.}
## /@}
