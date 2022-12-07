## *
##  @file nxlink.h
##  @brief Netloader (nxlink) utilities
##  @author WinterMute
##  @copyright libnx Authors
##

import
  ../types

export types

type
  InAddr* = object

const
  NXLINK_SERVER_PORT* = 28280
  NXLINK_CLIENT_PORT* = 28771

var nxLinkHost*{.importc: "__nxlink_host".}: InAddr

proc nxlinkConnectToHost*(redirStdout: bool; redirStderr: bool): cint {.cdecl,
    importc: "nxlinkConnectToHost".}
## *
##  @brief Connects to the nxlink host, setting up an output stream.
##  @param[in] redirStdout Whether to redirect stdout to nxlink output.
##  @param[in] redirStderr Whether to redirect stderr to nxlink output.
##  @return Socket fd on success, negative number on failure.
##  @note The socket should be closed with close() during application cleanup.
##

proc nxlinkStdio*(): cint {.inline, cdecl.} =
  ## / Same as \ref nxlinkConnectToHost but redirecting both stdout/stderr.
  return nxlinkConnectToHost(true, true)

proc nxlinkStdioForDebug*(): cint {.inline, cdecl.} =
  ## / Same as \ref nxlinkConnectToHost but redirecting only stderr.
  return nxlinkConnectToHost(false, true)
