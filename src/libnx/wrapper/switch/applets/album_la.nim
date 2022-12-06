## *
##  @file album_la.h
##  @brief Wrapper for using the Album LibraryApplet.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types

## / Arg type values pushed for the applet input storage, stored as an u8.

type
  AlbumLaArg* = enum
    AlbumLaArg_ShowAlbumFiles = 0, ## /< ShowAlbumFiles. Only displays AlbumFiles associated with the application which launched the Album applet, with the filter button disabled.
    AlbumLaArg_ShowAllAlbumFiles = 1, ## /< ShowAllAlbumFiles. Displays all AlbumFiles, with filtering allowed.
    AlbumLaArg_ShowAllAlbumFilesForHomeMenu = 2 ## /< ShowAllAlbumFilesForHomeMenu. Similar to ::AlbumLaArg_ShowAllAlbumFiles.


## *
##  @brief Launches the applet with ::AlbumLaArg_ShowAlbumFiles and playStartupSound=false.
##

proc albumLaShowAlbumFiles*(): Result {.cdecl, importc: "albumLaShowAlbumFiles".}
## *
##  @brief Launches the applet with ::AlbumLaArg_ShowAllAlbumFiles and playStartupSound=false.
##

proc albumLaShowAllAlbumFiles*(): Result {.cdecl,
                                        importc: "albumLaShowAllAlbumFiles".}
## *
##  @brief Launches the applet with ::AlbumLaArg_ShowAllAlbumFilesForHomeMenu and playStartupSound=true.
##

proc albumLaShowAllAlbumFilesForHomeMenu*(): Result {.cdecl,
    importc: "albumLaShowAllAlbumFilesForHomeMenu".}