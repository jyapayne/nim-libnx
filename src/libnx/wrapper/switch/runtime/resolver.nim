import
  ../types

## / Fetches the last resolver Switch result code of the current thread.

proc resolverGetLastResult*(): Result {.cdecl, importc: "resolverGetLastResult".}
## / Retrieves a handle used to cancel the next resolver command on the current thread.

proc resolverGetCancelHandle*(): U32 {.cdecl, importc: "resolverGetCancelHandle".}
## / Retrieves whether service discovery is enabled for resolver commands on the current thread.

proc resolverGetEnableServiceDiscovery*(): bool {.cdecl,
    importc: "resolverGetEnableServiceDiscovery".}
## / [5.0.0+] Retrieves whether the DNS cache is used to resolve queries on the current thread (not implemented).

proc resolverGetEnableDnsCache*(): bool {.cdecl,
                                       importc: "resolverGetEnableDnsCache".}
## / Enables or disables service discovery for the current thread.

proc resolverSetEnableServiceDiscovery*(enable: bool) {.cdecl,
    importc: "resolverSetEnableServiceDiscovery".}
## / [5.0.0+] Enables or disables the usage of the DNS cache on the current thread (not implemented).

proc resolverSetEnableDnsCache*(enable: bool) {.cdecl,
    importc: "resolverSetEnableDnsCache".}
## / Cancels a previous resolver command (handle obtained with \ref resolverGetCancelHandle prior to calling the command).

proc resolverCancel*(handle: U32): Result {.cdecl, importc: "resolverCancel".}
## / [5.0.0+] Removes a hostname from the DNS cache (not implemented).

proc resolverRemoveHostnameFromCache*(hostname: cstring): Result {.cdecl,
    importc: "resolverRemoveHostnameFromCache".}
## / [5.0.0+] Removes an IP address from the DNS cache (not implemented).

proc resolverRemoveIpAddressFromCache*(ip: U32): Result {.cdecl,
    importc: "resolverRemoveIpAddressFromCache".}