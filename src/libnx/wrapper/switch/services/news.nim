## *
##  @file news.h
##  @brief News service IPC wrapper.
##  @author Behemoth
##  @copyright libnx Authors
##

import
  ../kernel/event, ../sf/service, ../types

type
  NewsServiceType* = enum
    NewsServiceTypeAdministrator = 0, ## /< Initializes news:a
    NewsServiceTypeConfiguration = 1, ## /< Initializes news:c
    NewsServiceTypeManager = 2, ## /< Initializes news:m
    NewsServiceTypePost = 3,    ## /< Initializes news:p
    NewsServiceTypeViewer = 4,  ## /< Initializes news:v
    NewsServiceTypeCount
  NewsTopicName* {.bycopy.} = object
    name*: array[0x20, char]

  NewsNewlyArrivedEventHolder* {.bycopy.} = object
    s*: Service

  NewsDataService* {.bycopy.} = object
    s*: Service

  NewsDatabaseService* {.bycopy.} = object
    s*: Service

  NewsOverwriteEventHolder* {.bycopy.} = object
    s*: Service

  NewsRecordV1* {.bycopy.} = object
    newsId*: array[0x18, char]
    userId*: array[0x18, char]
    receivedAt*: S64
    read*: S32
    newly*: S32
    displayed*: S32

  NewsRecord* {.bycopy.} = object
    newsId*: array[0x18, char]
    userId*: array[0x18, char]
    topicId*: NewsTopicName
    receivedAt*: S64
    pad0*: S64
    decorationType*: S32
    read*: S32
    newly*: S32
    displayed*: S32
    feedback*: S32
    pad1*: S32
    extra1*: S32
    extra2*: S32



proc newsInitialize*(serviceType: NewsServiceType): Result {.cdecl,
    importc: "newsInitialize".}
proc newsExit*() {.cdecl, importc: "newsExit".}
proc newsGetServiceSession*(): ptr Service {.cdecl, importc: "newsGetServiceSession".}
proc newsCreateNewlyArrivedEventHolder*(`out`: ptr NewsNewlyArrivedEventHolder): Result {.
    cdecl, importc: "newsCreateNewlyArrivedEventHolder".}
proc newsCreateNewsDataService*(`out`: ptr NewsDataService): Result {.cdecl,
    importc: "newsCreateNewsDataService".}
proc newsCreateNewsDatabaseService*(`out`: ptr NewsDatabaseService): Result {.cdecl,
    importc: "newsCreateNewsDatabaseService".}
proc newsCreateOverwriteEventHolder*(`out`: ptr NewsOverwriteEventHolder): Result {.
    cdecl, importc: "newsCreateOverwriteEventHolder".}
## /< [2.0.0+]

proc newsPostLocalNews*(news: pointer; size: csize_t): Result {.cdecl,
    importc: "newsPostLocalNews".}
proc newsSetPassphrase*(programId: U64; passphrase: cstring): Result {.cdecl,
    importc: "newsSetPassphrase".}
proc newsGetSubscriptionStatus*(filter: cstring; status: ptr U32): Result {.cdecl,
    importc: "newsGetSubscriptionStatus".}
proc newsGetTopicList*(channel: U32; outCount: ptr U32; `out`: ptr NewsTopicName;
                      maxCount: U32): Result {.cdecl, importc: "newsGetTopicList".}
## /< [3.0.0+]

proc newsGetSavedataUsage*(current: ptr U64; total: ptr U64): Result {.cdecl,
    importc: "newsGetSavedataUsage".}
## /< [6.0.0+]

proc newsIsSystemUpdateRequired*(`out`: ptr bool): Result {.cdecl,
    importc: "newsIsSystemUpdateRequired".}
proc newsGetDatabaseVersion*(version: ptr U32): Result {.cdecl,
    importc: "newsGetDatabaseVersion".}
## /< [10.0.0+]

proc newsRequestImmediateReception*(filter: cstring): Result {.cdecl,
    importc: "newsRequestImmediateReception".}
proc newsSetSubscriptionStatus*(filter: cstring; status: U32): Result {.cdecl,
    importc: "newsSetSubscriptionStatus".}
proc newsClearStorage*(): Result {.cdecl, importc: "newsClearStorage".}
proc newsClearSubscriptionStatusAll*(): Result {.cdecl,
    importc: "newsClearSubscriptionStatusAll".}
proc newsGetNewsDatabaseDump*(buffer: pointer; size: U64; `out`: ptr U64): Result {.
    cdecl, importc: "newsGetNewsDatabaseDump".}
proc newsNewlyArrivedEventHolderClose*(srv: ptr NewsNewlyArrivedEventHolder) {.
    cdecl, importc: "newsNewlyArrivedEventHolderClose".}
proc newsNewlyArrivedEventHolderGet*(srv: ptr NewsNewlyArrivedEventHolder;
                                    `out`: ptr Event): Result {.cdecl,
    importc: "newsNewlyArrivedEventHolderGet".}
proc newsDataClose*(srv: ptr NewsDataService) {.cdecl, importc: "newsDataClose".}
proc newsDataOpen*(srv: ptr NewsDataService; fileName: cstring): Result {.cdecl,
    importc: "newsDataOpen".}
proc newsDataOpenWithNewsRecordV1*(srv: ptr NewsDataService;
                                  record: ptr NewsRecordV1): Result {.cdecl,
    importc: "newsDataOpenWithNewsRecordV1".}
proc newsDataRead*(srv: ptr NewsDataService; bytesRead: ptr U64; offset: U64;
                  `out`: pointer; outSize: csize_t): Result {.cdecl,
    importc: "newsDataRead".}
proc newsDataGetSize*(srv: ptr NewsDataService; size: ptr U64): Result {.cdecl,
    importc: "newsDataGetSize".}
proc newsDataOpenWithNewsRecord*(srv: ptr NewsDataService; record: ptr NewsRecord): Result {.
    cdecl, importc: "newsDataOpenWithNewsRecord".}
## /< [6.0.0+]

proc newsDatabaseClose*(srv: ptr NewsDatabaseService) {.cdecl,
    importc: "newsDatabaseClose".}
proc newsDatabaseGetListV1*(srv: ptr NewsDatabaseService; `out`: ptr NewsRecordV1;
                           maxCount: U32; where: cstring; order: cstring;
                           count: ptr U32; offset: U32): Result {.cdecl,
    importc: "newsDatabaseGetListV1".}
proc newsDatabaseCount*(srv: ptr NewsDatabaseService; filter: cstring; count: ptr U32): Result {.
    cdecl, importc: "newsDatabaseCount".}
proc newsDatabaseGetList*(srv: ptr NewsDatabaseService; `out`: ptr NewsRecord;
                         maxCount: U32; where: cstring; order: cstring;
                         count: ptr U32; offset: U32): Result {.cdecl,
    importc: "newsDatabaseGetList".}
## /< [6.0.0+]

proc newsOverwriteEventHolderClose*(srv: ptr NewsOverwriteEventHolder) {.cdecl,
    importc: "newsOverwriteEventHolderClose".}
proc newsOverwriteEventHolderGet*(srv: ptr NewsOverwriteEventHolder;
                                 `out`: ptr Event): Result {.cdecl,
    importc: "newsOverwriteEventHolderGet".}
