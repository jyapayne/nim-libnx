## *
##  @file env.h
##  @brief Homebrew environment definitions and utilities.
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../types, ../services/acc

## / Structure representing an entry in the homebrew environment configuration.

type
  ConfigEntry* {.bycopy.} = object
    key*: U32                  ## /< Type of entry
    flags*: U32                ## /< Entry flags
    value*: array[2, U64]       ## /< Entry arguments (type-specific)


## / Entry flags

const
  EntryFlagIsMandatory* = bit(0) ## /< Specifies that the entry **must** be processed by the homebrew application.

## /< Types of entry

const
  EntryTypeEndOfList* = 0       ## /< Entry list terminator.
  EntryTypeMainThreadHandle* = 1 ## /< Provides the handle to the main thread.
  EntryTypeNextLoadPath* = 2    ## /< Provides a buffer containing information about the next homebrew application to load.
  EntryTypeOverrideHeap* = 3    ## /< Provides heap override information.
  EntryTypeOverrideService* = 4 ## /< Provides service override information.
  EntryTypeArgv* = 5            ## /< Provides argv.
  EntryTypeSyscallAvailableHint* = 6 ## /< Provides syscall availability hints (SVCs 0x00..0x7F).
  EntryTypeAppletType* = 7      ## /< Provides APT applet type.
  EntryTypeAppletWorkaround* = 8 ## /< Indicates that APT is broken and should not be used.
  EntryTypeReserved9* = 9       ## /< Unused/reserved entry type, formerly used by StdioSockets.
  EntryTypeProcessHandle* = 10  ## /< Provides the process handle.
  EntryTypeLastLoadResult* = 11 ## /< Provides the last load result.
  EntryTypeRandomSeed* = 14     ## /< Provides random data used to seed the pseudo-random number generator.
  EntryTypeUserIdStorage* = 15  ## /< Provides persistent storage for the preselected user id.
  EntryTypeHosVersion* = 16     ## /< Provides the currently running Horizon OS version.
  EntryTypeSyscallAvailableHint2* = 17 ## /< Provides syscall availability hints (SVCs 0x80..0xBF).

const
  EnvAppletFlagsApplicationOverride* = bit(0) ## /< Use AppletType_Application instead of AppletType_SystemApplication.

## / Loader return function.

type
  LoaderReturnFn* = proc (resultCode: cint) {.cdecl.}

## *
##  @brief Parses the homebrew loader environment block (internally called).
##  @param ctx Reserved.
##  @param main_thread Reserved.
##  @param saved_lr Reserved.
##

proc envSetup*(ctx: pointer; mainThread: Handle; savedLr: LoaderReturnFn) {.cdecl,
    importc: "envSetup".}
## / Returns information text about the loader, if present.

proc envGetLoaderInfo*(): cstring {.cdecl, importc: "envGetLoaderInfo".}
## / Returns the size of the loader information text.

proc envGetLoaderInfoSize*(): U64 {.cdecl, importc: "envGetLoaderInfoSize".}
## / Retrieves the handle to the main thread.

proc envGetMainThreadHandle*(): Handle {.cdecl, importc: "envGetMainThreadHandle".}
## / Returns true if the application is running as NSO, otherwise NRO.

proc envIsNso*(): bool {.cdecl, importc: "envIsNso".}
## / Returns true if the environment has a heap override.

proc envHasHeapOverride*(): bool {.cdecl, importc: "envHasHeapOverride".}
## / Returns the address of the overriden heap.

proc envGetHeapOverrideAddr*(): pointer {.cdecl, importc: "envGetHeapOverrideAddr".}
## / Returns the size of the overriden heap.

proc envGetHeapOverrideSize*(): U64 {.cdecl, importc: "envGetHeapOverrideSize".}
## / Returns true if the environment has an argv array.

proc envHasArgv*(): bool {.cdecl, importc: "envHasArgv".}
## / Returns the pointer to the argv array.

proc envGetArgv*(): pointer {.cdecl, importc: "envGetArgv".}
## *
##  @brief Returns whether a syscall is hinted to be available.
##  @param svc Syscall number to test.
##  @returns true if the syscall is available.
##

proc envIsSyscallHinted*(svc: cuint): bool {.cdecl, importc: "envIsSyscallHinted".}
## / Returns the handle to the running homebrew process.

proc envGetOwnProcessHandle*(): Handle {.cdecl, importc: "envGetOwnProcessHandle".}
## / Returns the loader's return function, to be called on program exit.

proc envGetExitFuncPtr*(): LoaderReturnFn {.cdecl, importc: "envGetExitFuncPtr".}
## / Sets the return function to be called on program exit.

proc envSetExitFuncPtr*(`addr`: LoaderReturnFn) {.cdecl,
    importc: "envSetExitFuncPtr".}
## *
##  @brief Configures the next homebrew application to load.
##  @param path Path to the next homebrew application to load (.nro).
##  @param argv Argument string to pass.
##

proc envSetNextLoad*(path: cstring; argv: cstring): Result {.cdecl,
    importc: "envSetNextLoad".}
## / Returns true if the environment supports envSetNextLoad.

proc envHasNextLoad*(): bool {.cdecl, importc: "envHasNextLoad".}
## / Returns the Result from the last NRO.

proc envGetLastLoadResult*(): Result {.cdecl, importc: "envGetLastLoadResult".}
## / Returns true if the environment provides a random seed.

proc envHasRandomSeed*(): bool {.cdecl, importc: "envHasRandomSeed".}
## *
##  @brief Retrieves the random seed provided by the environment.
##  @param out Pointer to a u64[2] buffer which will contain the random seed on return.
##

proc envGetRandomSeed*(`out`: array[2, U64]) {.cdecl, importc: "envGetRandomSeed".}
## / Returns a pointer to the user id storage area (if present).

proc envGetUserIdStorage*(): ptr AccountUid {.cdecl, importc: "envGetUserIdStorage".}