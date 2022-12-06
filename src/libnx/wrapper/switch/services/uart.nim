## *
##  @file uart.h
##  @brief UART service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../sf/service

## / UartPort

type
  UartPort* = enum
    UartPortBluetooth = 1,      ## /< Bluetooth
    UartPortJoyConR = 2,        ## /< Joy-Con(R)
    UartPortJoyConL = 3,        ## /< Joy-Con(L)
    UartPortMCU = 4             ## /< MCU


## / UartPortForDev

type
  UartPortForDev* = enum
    UartPortForDevJoyConR = 1,  ## /< Joy-Con(R)
    UartPortForDevJoyConL = 2,  ## /< Joy-Con(L)
    UartPortForDevBluetooth = 3 ## /< Bluetooth


## / FlowControlMode

type
  UartFlowControlMode* = enum
    UartFlowControlModeNone = 0, ## /< None
    UartFlowControlModeHardware = 1 ## /< Hardware


## / PortEventType

type
  UartPortEventType* = enum
    UartPortEventTypeSendBufferEmpty = 0, ## /< SendBufferEmpty
    UartPortEventTypeSendBufferReady = 1, ## /< SendBufferReady
    UartPortEventTypeReceiveBufferReady = 2, ## /< ReceiveBufferReady
    UartPortEventTypeReceiveEnd = 3 ## /< ReceiveEnd


## / PortSession

type
  UartPortSession* {.bycopy.} = object
    s*: Service                ## /< IPortSession


## / Initialize uart.

proc uartInitialize*(): Result {.cdecl, importc: "uartInitialize".}
## / Exit uart.

proc uartExit*() {.cdecl, importc: "uartExit".}
## / Gets the Service object for the actual uart service session.

proc uartGetServiceSession*(): ptr Service {.cdecl, importc: "uartGetServiceSession".}
## *
##  @brief HasPort
##  @param[in] port \ref UartPort
##  @param[out] out Output success flag.
##

proc uartHasPort*(port: UartPort; `out`: ptr bool): Result {.cdecl,
    importc: "uartHasPort".}
## *
##  @brief HasPortForDev
##  @param[in] port \ref UartPortForDev
##  @param[out] out Output success flag.
##

proc uartHasPortForDev*(port: UartPortForDev; `out`: ptr bool): Result {.cdecl,
    importc: "uartHasPortForDev".}
## *
##  @brief IsSupportedBaudRate
##  @param[in] port \ref UartPort
##  @param[in] baud_rate BaudRate
##  @param[out] out Output success flag.
##

proc uartIsSupportedBaudRate*(port: UartPort; baudRate: U32; `out`: ptr bool): Result {.
    cdecl, importc: "uartIsSupportedBaudRate".}
## *
##  @brief IsSupportedBaudRateForDev
##  @param[in] port \ref UartPortForDev
##  @param[in] baud_rate BaudRate
##  @param[out] out Output success flag.
##

proc uartIsSupportedBaudRateForDev*(port: UartPortForDev; baudRate: U32;
                                   `out`: ptr bool): Result {.cdecl,
    importc: "uartIsSupportedBaudRateForDev".}
## *
##  @brief IsSupportedFlowControlMode
##  @param[in] port \ref UartPort
##  @param[in] flow_control_mode \ref UartFlowControlMode
##  @param[out] out Output success flag.
##

proc uartIsSupportedFlowControlMode*(port: UartPort;
                                    flowControlMode: UartFlowControlMode;
                                    `out`: ptr bool): Result {.cdecl,
    importc: "uartIsSupportedFlowControlMode".}
## *
##  @brief IsSupportedFlowControlModeForDev
##  @param[in] port \ref UartPortForDev
##  @param[in] flow_control_mode \ref UartFlowControlMode
##  @param[out] out Output success flag.
##

proc uartIsSupportedFlowControlModeForDev*(port: UartPortForDev;
    flowControlMode: UartFlowControlMode; `out`: ptr bool): Result {.cdecl,
    importc: "uartIsSupportedFlowControlModeForDev".}
## *
##  @brief Creates an \ref UartPortSession.
##  @note Use \ref uartPortSessionOpenPort or \ref uartPortSessionOpenPortForDev before using any other cmds.
##  @param[out] s \ref UartPortSession
##

proc uartCreatePortSession*(s: ptr UartPortSession): Result {.cdecl,
    importc: "uartCreatePortSession".}
## *
##  @brief IsSupportedPortEvent
##  @param[in] port \ref UartPort
##  @param[in] port_event_type \ref UartPortEventType
##  @param[out] out Output success flag.
##

proc uartIsSupportedPortEvent*(port: UartPort; portEventType: UartPortEventType;
                              `out`: ptr bool): Result {.cdecl,
    importc: "uartIsSupportedPortEvent".}
## *
##  @brief IsSupportedPortEventForDev
##  @param[in] port \ref UartPortForDev
##  @param[in] port_event_type \ref UartPortEventType
##  @param[out] out Output success flag.
##

proc uartIsSupportedPortEventForDev*(port: UartPortForDev;
                                    portEventType: UartPortEventType;
                                    `out`: ptr bool): Result {.cdecl,
    importc: "uartIsSupportedPortEventForDev".}
## *
##  @brief IsSupportedDeviceVariation
##  @note Only available on [7.0.0+].
##  @param[in] port \ref UartPort
##  @param[in] device_variation DeviceVariation
##  @param[out] out Output success flag.
##

proc uartIsSupportedDeviceVariation*(port: UartPort; deviceVariation: U32;
                                    `out`: ptr bool): Result {.cdecl,
    importc: "uartIsSupportedDeviceVariation".}
## *
##  @brief IsSupportedDeviceVariationForDev
##  @note Only available on [7.0.0+].
##  @param[in] port \ref UartPortForDev
##  @param[in] device_variation DeviceVariation
##  @param[out] out Output success flag.
##

proc uartIsSupportedDeviceVariationForDev*(port: UartPortForDev;
    deviceVariation: U32; `out`: ptr bool): Result {.cdecl,
    importc: "uartIsSupportedDeviceVariationForDev".}
## /@name IPortSession
## /@{
## *
##  @brief Close an \ref UartPortSession.
##  @param s \ref UartPortSession
##

proc uartPortSessionClose*(s: ptr UartPortSession) {.cdecl,
    importc: "uartPortSessionClose".}
## *
##  @brief OpenPort
##  @note This is not usable when the specified \ref UartPort is already being used.
##  @param s \ref UartPortSession
##  @param[out] out Output success flag.
##  @param[in] port \ref UartPort
##  @param[in] baud_rate BaudRate
##  @param[in] flow_control_mode \ref UartFlowControlMode
##  @param[in] device_variation [7.0.0+] DeviceVariation
##  @param[in] is_invert_tx [6.0.0+] IsInvertTx
##  @param[in] is_invert_rx [6.0.0+] IsInvertRx
##  @param[in] is_invert_rts [6.0.0+] IsInvertRts
##  @param[in] is_invert_cts [6.0.0+] IsInvertCts
##  @param[in] send_buffer Send buffer, must be 0x1000-byte aligned.
##  @param[in] send_buffer_length Send buffer size, must be 0x1000-byte aligned.
##  @param[in] receive_buffer Receive buffer, must be 0x1000-byte aligned.
##  @param[in] receive_buffer_length Receive buffer size, must be 0x1000-byte aligned.
##

proc uartPortSessionOpenPort*(s: ptr UartPortSession; `out`: ptr bool; port: UartPort;
                             baudRate: U32; flowControlMode: UartFlowControlMode;
                             deviceVariation: U32; isInvertTx: bool;
                             isInvertRx: bool; isInvertRts: bool; isInvertCts: bool;
                             sendBuffer: pointer; sendBufferLength: U64;
                             receiveBuffer: pointer; receiveBufferLength: U64): Result {.
    cdecl, importc: "uartPortSessionOpenPort".}
## *
##  @brief OpenPortForDev
##  @note See the notes for \ref uartPortSessionOpenPort.
##  @param s \ref UartPortSession
##  @param[out] out Output success flag.
##  @param[in] port \ref UartPortForDev
##  @param[in] baud_rate BaudRate
##  @param[in] flow_control_mode \ref UartFlowControlMode
##  @param[in] device_variation [7.0.0+] DeviceVariation
##  @param[in] is_invert_tx [6.0.0+] IsInvertTx
##  @param[in] is_invert_rx [6.0.0+] IsInvertRx
##  @param[in] is_invert_rts [6.0.0+] IsInvertRts
##  @param[in] is_invert_cts [6.0.0+] IsInvertCts
##  @param[in] send_buffer Send buffer, must be 0x1000-byte aligned.
##  @param[in] send_buffer_length Send buffer size, must be 0x1000-byte aligned.
##  @param[in] receive_buffer Receive buffer, must be 0x1000-byte aligned.
##  @param[in] receive_buffer_length Receive buffer size, must be 0x1000-byte aligned.
##

proc uartPortSessionOpenPortForDev*(s: ptr UartPortSession; `out`: ptr bool;
                                   port: UartPortForDev; baudRate: U32;
                                   flowControlMode: UartFlowControlMode;
                                   deviceVariation: U32; isInvertTx: bool;
                                   isInvertRx: bool; isInvertRts: bool;
                                   isInvertCts: bool; sendBuffer: pointer;
                                   sendBufferLength: U64; receiveBuffer: pointer;
                                   receiveBufferLength: U64): Result {.cdecl,
    importc: "uartPortSessionOpenPortForDev".}
## *
##  @brief GetWritableLength
##  @param s \ref UartPortSession
##  @param[out] out Output WritableLength.
##

proc uartPortSessionGetWritableLength*(s: ptr UartPortSession; `out`: ptr U64): Result {.
    cdecl, importc: "uartPortSessionGetWritableLength".}
## *
##  @brief Send
##  @param s \ref UartPortSession
##  @param[in] in_data Input data buffer.
##  @param[in] size Input data buffer size.
##  @param[out] out Output size.
##

proc uartPortSessionSend*(s: ptr UartPortSession; inData: pointer; size: csize_t;
                         `out`: ptr U64): Result {.cdecl,
    importc: "uartPortSessionSend".}
## *
##  @brief GetReadableLength
##  @param s \ref UartPortSession
##  @param[out] out Output ReadableLength.
##

proc uartPortSessionGetReadableLength*(s: ptr UartPortSession; `out`: ptr U64): Result {.
    cdecl, importc: "uartPortSessionGetReadableLength".}
## *
##  @brief Receive
##  @param s \ref UartPortSession
##  @param[out] out_data Output data buffer.
##  @param[in] size Output data buffer size.
##  @param[out] out Output size.
##

proc uartPortSessionReceive*(s: ptr UartPortSession; outData: pointer; size: csize_t;
                            `out`: ptr U64): Result {.cdecl,
    importc: "uartPortSessionReceive".}
## *
##  @brief BindPortEvent
##  @note The Event must be closed by the user after using \ref uartPortSessionUnbindPortEvent.
##  @param s \ref UartPortSession
##  @param[in] port_event_type \ref UartPortEventType
##  @param[in] threshold Threshold
##  @param[out] out Output success flag.
##  @param[out] out_event Output Event with autoclear=false.
##

proc uartPortSessionBindPortEvent*(s: ptr UartPortSession;
                                  portEventType: UartPortEventType;
                                  threshold: S64; `out`: ptr bool;
                                  outEvent: ptr Event): Result {.cdecl,
    importc: "uartPortSessionBindPortEvent".}
## *
##  @brief UnbindPortEvent
##  @param s \ref UartPortSession
##  @param[in] port_event_type \ref UartPortEventType
##  @param[out] out Output success flag.
##

proc uartPortSessionUnbindPortEvent*(s: ptr UartPortSession;
                                    portEventType: UartPortEventType;
                                    `out`: ptr bool): Result {.cdecl,
    importc: "uartPortSessionUnbindPortEvent".}
## /@}
