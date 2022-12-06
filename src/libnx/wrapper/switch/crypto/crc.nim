## *
##  @file crc.h
##  @brief Hardware accelerated CRC32 implementation.
##  @copyright libnx Authors
##

import
  ../types

{.emit: """
#include <arm_acle.h>

#define _CRC_ALIGN(sz, insn) \
do { \
    if (((uintptr_t)src_u8 & sizeof(sz)) && (u64)len >= sizeof(sz)) { \
        crc = __crc32##insn(crc, *((const sz *)src_u8)); \
        src_u8 += sizeof(sz); \
        len -= sizeof(sz); \
    } \
} while (0);

#define _CRC_REMAINDER(sz, insn) \
do { \
    if (len & sizeof(sz)) { \
        crc = __crc32##insn(crc, *((const sz *)src_u8)); \
        src_u8 += sizeof(sz); \
    } \
} while (0)
""".}

proc crc32CalculateWithSeed*(seed: U32; src: pointer; size: csize_t): U32 {.inline,
    cdecl.} =
  ## / Calculate a CRC32 over data using a seed.
  ## / Can be used to calculate a CRC32 in chunks using an initial seed of zero for the first chunk.
  {.emit: """
    const u8 *src_u8 = (const u8 *)src;

    u32 crc = ~seed;
    s64 len = size;

    _CRC_ALIGN(u8,  b);
    _CRC_ALIGN(u16, h);
    _CRC_ALIGN(u32, w);

    while ((len -= sizeof(u64)) >= 0) {
        crc = __crc32d(crc, *((const u64 *)src_u8));
        src_u8 += sizeof(u64);
    }

    _CRC_REMAINDER(u32, w);
    _CRC_REMAINDER(u16, h);
    _CRC_REMAINDER(u8,  b);
    """.}

  {.emit: "`result` = ~crc;".}


proc crc32Calculate*(src: pointer; size: csize_t): U32 {.inline, cdecl.} =
  ## / Calculate a CRC32 over data.
  return crc32CalculateWithSeed(0, src, size)


proc crc32cCalculateWithSeed*(seed: U32; src: pointer; size: csize_t): U32 {.inline,
    cdecl.} =
  ## / Calculate a CRC32C over data using a seed.
  ## / Can be used to calculate a CRC32C in chunks using an initial seed of zero for the first chunk.

  {.emit: """
    const u8 *src_u8 = (const u8 *)src;

    u32 crc = ~seed;
    s64 len = size;

    _CRC_ALIGN(u8,  cb);
    _CRC_ALIGN(u16, ch);
    _CRC_ALIGN(u32, cw);

    while ((len -= sizeof(u64)) >= 0) {
        crc = __crc32cd(crc, *((const u64 *)src_u8));
        src_u8 += sizeof(u64);
    }

    _CRC_REMAINDER(u32, cw);
    _CRC_REMAINDER(u16, ch);
    _CRC_REMAINDER(u8,  cb);
    """.}

  {.emit: "`result` = ~crc;".}

proc crc32cCalculate*(src: pointer; size: csize_t): U32 {.inline, cdecl.} =
  ## / Calculate a CRC32C over data.
  return crc32cCalculateWithSeed(0, src, size)
