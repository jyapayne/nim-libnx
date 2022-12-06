## *
##  @file nifm_la.h
##  @brief Wrapper for using the nifm LibraryApplet (the launched applet varies).
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../services/nifm

## *
##  @brief Uses \ref nifmGetResult, then on failure launches the applet.
##  @param r \ref NifmRequest
##

proc nifmLaHandleNetworkRequestResult*(r: ptr NifmRequest): Result {.cdecl,
    importc: "nifmLaHandleNetworkRequestResult".}