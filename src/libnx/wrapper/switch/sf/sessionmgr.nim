import
  ../types, ../kernel/mutex, ../kernel/condvar

const
  NX_SESSION_MGR_MAX_SESSIONS* = 16

type
  SessionMgr* {.bycopy.} = object
    sessions*: array[Nx_Session_Mgr_Max_Sessions, Handle]
    numSessions*: U32
    freeMask*: U32
    mutex*: Mutex
    condvar*: CondVar
    numWaiters*: U32


proc sessionmgrCreate*(mgr: ptr SessionMgr; rootSession: Handle; numSessions: U32): Result {.
    cdecl, importc: "sessionmgrCreate".}
proc sessionmgrClose*(mgr: ptr SessionMgr) {.cdecl, importc: "sessionmgrClose".}
proc sessionmgrAttachClient*(mgr: ptr SessionMgr): cint {.cdecl,
    importc: "sessionmgrAttachClient".}
proc sessionmgrDetachClient*(mgr: ptr SessionMgr; slot: cint) {.cdecl,
    importc: "sessionmgrDetachClient".}
proc sessionmgrGetClientSession*(mgr: ptr SessionMgr; slot: cint): Handle {.inline, cdecl.} =
  return mgr.sessions[slot]
