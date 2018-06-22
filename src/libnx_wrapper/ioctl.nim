import strutils
import ospaths
const headerioctl = currentSourcePath().splitPath().head & "/nx/include/switch/gfx/ioctl.h"
## The below defines are based on Linux kernel ioctl.h.

const
  UNV_IOC_NRBITS* = 8
  UNV_IOC_TYPEBITS* = 8
  UNV_IOC_SIZEBITS* = 14
  UNV_IOC_DIRBITS* = 2
  UNV_IOC_NRMASK* = ((1 shl UNV_IOC_NRBITS) - 1)
  UNV_IOC_TYPEMASK* = ((1 shl UNV_IOC_TYPEBITS) - 1)
  UNV_IOC_SIZEMASK* = ((1 shl UNV_IOC_SIZEBITS) - 1)
  UNV_IOC_DIRMASK* = ((1 shl UNV_IOC_DIRBITS) - 1)
  UNV_IOC_NRSHIFT* = 0
  UNV_IOC_TYPESHIFT* = (UNV_IOC_NRSHIFT + UNV_IOC_NRBITS)
  UNV_IOC_SIZESHIFT* = (UNV_IOC_TYPESHIFT + UNV_IOC_TYPEBITS)
  UNV_IOC_DIRSHIFT* = (UNV_IOC_SIZESHIFT + UNV_IOC_SIZEBITS)

## 
##  Direction bits.
## 

const
  UNV_IOC_NONE* = 0
  UNV_IOC_WRITE* = 1
  UNV_IOC_READ* = 2

template UNV_IOC*(dir, `type`, nr, size: untyped): untyped =
  (((dir) shl UNV_IOC_DIRSHIFT) or ((`type`) shl UNV_IOC_TYPESHIFT) or
      ((nr) shl UNV_IOC_NRSHIFT) or ((size) shl UNV_IOC_SIZESHIFT))

##  used to create numbers

template UNV_IO*(`type`, nr: untyped): untyped =
  UNV_IOC(UNV_IOC_NONE, (`type`), (nr), 0)

template UNV_IOR*(`type`, nr, size: untyped): untyped =
  UNV_IOC(UNV_IOC_READ, (`type`), (nr), sizeof((size)))

template UNV_IOW*(`type`, nr, size: untyped): untyped =
  UNV_IOC(UNV_IOC_WRITE, (`type`), (nr), sizeof((size)))

template UNV_IOWR*(`type`, nr, size: untyped): untyped =
  UNV_IOC(UNV_IOC_READ or UNV_IOC_WRITE, (`type`), (nr), sizeof((size)))

##  used to decode ioctl numbers..

template UNV_IOC_DIR*(nr: untyped): untyped =
  (((nr) shr UNV_IOC_DIRSHIFT) and UNV_IOC_DIRMASK)

template UNV_IOC_TYPE*(nr: untyped): untyped =
  (((nr) shr UNV_IOC_TYPESHIFT) and UNV_IOC_TYPEMASK)

template UNV_IOC_NR*(nr: untyped): untyped =
  (((nr) shr UNV_IOC_NRSHIFT) and UNV_IOC_NRMASK)

template UNV_IOC_SIZE*(nr: untyped): untyped =
  (((nr) shr UNV_IOC_SIZESHIFT) and UNV_IOC_SIZEMASK)

const
  DUnv_in* = true
  DUnv_out* = true
  DUnv_inout* = true
