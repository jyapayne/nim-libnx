## *
##  @file cache.h
##  @brief AArch64 cache operations.
##  @author plutoo
##  @copyright libnx Authors
##

proc armDCacheFlush*(`addr`: pointer; size: csize_t) {.cdecl,
    importc: "armDCacheFlush".}
## *
##  @brief Performs a data cache flush on the specified buffer.
##  @param addr Address of the buffer.
##  @param size Size of the buffer, in bytes.
##  @remarks Cache flush is defined as Clean + Invalidate.
##  @note The start and end addresses of the buffer are forcibly rounded to cache line boundaries (read from CTR_EL0 system register).
##

proc armDCacheClean*(`addr`: pointer; size: csize_t) {.cdecl,
    importc: "armDCacheClean".}
## *
##  @brief Performs a data cache clean on the specified buffer.
##  @param addr Address of the buffer.
##  @param size Size of the buffer, in bytes.
##  @note The start and end addresses of the buffer are forcibly rounded to cache line boundaries (read from CTR_EL0 system register).
##

proc armICacheInvalidate*(`addr`: pointer; size: csize_t) {.cdecl,
    importc: "armICacheInvalidate".}
## *
##  @brief Performs an instruction cache invalidation clean on the specified buffer.
##  @param addr Address of the buffer.
##  @param size Size of the buffer, in bytes.
##  @note The start and end addresses of the buffer are forcibly rounded to cache line boundaries (read from CTR_EL0 system register).
##

proc armDCacheZero*(`addr`: pointer; size: csize_t) {.cdecl, importc: "armDCacheZero".}
## *
##  @brief Performs a data cache zeroing operation on the specified buffer.
##  @param addr Address of the buffer.
##  @param size Size of the buffer, in bytes.
##  @note The start and end addresses of the buffer are forcibly rounded to cache line boundaries (read from CTR_EL0 system register).
##

