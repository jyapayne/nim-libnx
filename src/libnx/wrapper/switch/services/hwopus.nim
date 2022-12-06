## *
##  @file hwopus.h
##  @brief Hardware Opus audio service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../kernel/tmem

type
  HwopusDecoder* {.bycopy.} = object
    s*: Service
    tmem*: TransferMemory
    multistream*: bool


## / This structure is the start of opusin for \ref hwopusDecodeInterleaved, with the actual opus packet following this.
## / These fields are big-endian.

type
  HwopusHeader* {.bycopy.} = object
    size*: U32                 ## /< Size of the packet following this header.
    finalRange*: U32           ## /< Indicates the final range of the codec encoder's entropy coder. This can be left at zero.


## / Used internally.

type
  HwopusMultistreamState* {.bycopy.} = object
    sampleRate*: S32
    channelCount*: S32
    totalStreamCount*: S32
    stereoStreamCount*: S32
    channelMapping*: array[256, U8]


proc hwopusDecoderInitialize*(decoder: ptr HwopusDecoder; sampleRate: S32;
                             channelCount: S32): Result {.cdecl,
    importc: "hwopusDecoderInitialize".}
proc hwopusDecoderExit*(decoder: ptr HwopusDecoder) {.cdecl,
    importc: "hwopusDecoderExit".}
## / Only available on [3.0.0+].
## / See libopus multistream docs.

proc hwopusDecoderMultistreamInitialize*(decoder: ptr HwopusDecoder;
                                        sampleRate: S32; channelCount: S32;
                                        totalStreamCount: S32;
                                        stereoStreamCount: S32;
                                        channelMapping: ptr U8): Result {.cdecl,
    importc: "hwopusDecoderMultistreamInitialize".}
## / Decodes opus data.

proc hwopusDecodeInterleaved*(decoder: ptr HwopusDecoder; decodedDataSize: ptr S32;
                             decodedSampleCount: ptr S32; opusin: pointer;
                             opusinSize: csize_t; pcmbuf: ptr S16;
                             pcmbufSize: csize_t): Result {.cdecl,
    importc: "hwopusDecodeInterleaved".}