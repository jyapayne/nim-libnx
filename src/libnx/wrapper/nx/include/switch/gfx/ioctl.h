#pragma once

//The below defines are based on Linux kernel ioctl.h.

#define UNV_IOC_NRBITS	8
#define UNV_IOC_TYPEBITS	8
#define UNV_IOC_SIZEBITS	14
#define UNV_IOC_DIRBITS	2

#define UNV_IOC_NRMASK	((1 << UNV_IOC_NRBITS)-1)
#define UNV_IOC_TYPEMASK	((1 << UNV_IOC_TYPEBITS)-1)
#define UNV_IOC_SIZEMASK	((1 << UNV_IOC_SIZEBITS)-1)
#define UNV_IOC_DIRMASK	((1 << UNV_IOC_DIRBITS)-1)

#define UNV_IOC_NRSHIFT	0
#define UNV_IOC_TYPESHIFT	(UNV_IOC_NRSHIFT+UNV_IOC_NRBITS)
#define UNV_IOC_SIZESHIFT	(UNV_IOC_TYPESHIFT+UNV_IOC_TYPEBITS)
#define UNV_IOC_DIRSHIFT	(UNV_IOC_SIZESHIFT+UNV_IOC_SIZEBITS)

/*
 * Direction bits.
 */
#define UNV_IOC_NONE	0U
#define UNV_IOC_WRITE	1U
#define UNV_IOC_READ	2U

#define UNV_IOC(dir,type,nr,size) \
	(((dir)  << UNV_IOC_DIRSHIFT) | \
	 ((type) << UNV_IOC_TYPESHIFT) | \
	 ((nr)   << UNV_IOC_NRSHIFT) | \
	 ((size) << UNV_IOC_SIZESHIFT))

/* used to create numbers */
#define UNV_IO(type,nr)		UNV_IOC(UNV_IOC_NONE,(type),(nr),0)
#define UNV_IOR(type,nr,size)	UNV_IOC(UNV_IOC_READ,(type),(nr),sizeof(size))
#define UNV_IOW(type,nr,size)	UNV_IOC(UNV_IOC_WRITE,(type),(nr),sizeof(size))
#define UNV_IOWR(type,nr,size)	UNV_IOC(UNV_IOC_READ|UNV_IOC_WRITE,(type),(nr),sizeof(size))

/* used to decode ioctl numbers.. */
#define UNV_IOC_DIR(nr)		(((nr) >> UNV_IOC_DIRSHIFT) & UNV_IOC_DIRMASK)
#define UNV_IOC_TYPE(nr)		(((nr) >> UNV_IOC_TYPESHIFT) & UNV_IOC_TYPEMASK)
#define UNV_IOC_NR(nr)		(((nr) >> UNV_IOC_NRSHIFT) & UNV_IOC_NRMASK)
#define UNV_IOC_SIZE(nr)		(((nr) >> UNV_IOC_SIZESHIFT) & UNV_IOC_SIZEMASK)

#define DUnv_in
#define DUnv_out
#define DUnv_inout
