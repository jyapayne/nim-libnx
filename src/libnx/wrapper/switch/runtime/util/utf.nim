## *
##  @file utf.h
##  @brief UTF conversion functions.
##  @author mtheall
##  @copyright libnx Authors
##

import
  ../../types

proc decodeUtf8*(`out`: ptr uint32; `in`: ptr uint8): SsizeT {.cdecl,
    importc: "decode_utf8".}
## * Convert a UTF-8 sequence into a UTF-32 codepoint
##
##   @param[out] out Output codepoint
##   @param[in]  in  Input sequence
##
##   @returns number of input code units consumed
##   @returns -1 for error
##

proc decodeUtf16*(`out`: ptr uint32; `in`: ptr uint16): SsizeT {.cdecl,
    importc: "decode_utf16".}
## * Convert a UTF-16 sequence into a UTF-32 codepoint
##
##   @param[out] out Output codepoint
##   @param[in]  in  Input sequence
##
##   @returns number of input code units consumed
##   @returns -1 for error
##

proc encodeUtf8*(`out`: ptr uint8; `in`: uint32): SsizeT {.cdecl, importc: "encode_utf8".}
## * Convert a UTF-32 codepoint into a UTF-8 sequence
##
##   @param[out] out Output sequence
##   @param[in]  in  Input codepoint
##
##   @returns number of output code units produced
##   @returns -1 for error
##
##   @note \a out must be able to store 4 code units
##

proc encodeUtf16*(`out`: ptr uint16; `in`: uint32): SsizeT {.cdecl,
    importc: "encode_utf16".}
## * Convert a UTF-32 codepoint into a UTF-16 sequence
##
##   @param[out] out Output sequence
##   @param[in]  in  Input codepoint
##
##   @returns number of output code units produced
##   @returns -1 for error
##
##   @note \a out must be able to store 2 code units
##

proc utf8ToUtf16*(`out`: ptr uint16; `in`: ptr uint8; len: csize_t): SsizeT {.cdecl,
    importc: "utf8_to_utf16".}
## * Convert a UTF-8 sequence into a UTF-16 sequence
##
##   Fills the output buffer up to \a len code units.
##   Returns the number of code units that the input would produce;
##   if it returns greater than \a len, the output has been
##   truncated.
##
##   @param[out] out Output sequence
##   @param[in]  in  Input sequence (null-terminated)
##   @param[in]  len Output length
##
##   @returns number of output code units produced
##   @returns -1 for error
##
##   @note \a out is not null-terminated
##

proc utf8ToUtf32*(`out`: ptr uint32; `in`: ptr uint8; len: csize_t): SsizeT {.cdecl,
    importc: "utf8_to_utf32".}
## * Convert a UTF-8 sequence into a UTF-32 sequence
##
##   Fills the output buffer up to \a len code units.
##   Returns the number of code units that the input would produce;
##   if it returns greater than \a len, the output has been
##   truncated.
##
##   @param[out] out Output sequence
##   @param[in]  in  Input sequence (null-terminated)
##   @param[in]  len Output length
##
##   @returns number of output code units produced
##   @returns -1 for error
##
##   @note \a out is not null-terminated
##

proc utf16ToUtf8*(`out`: ptr uint8; `in`: ptr uint16; len: csize_t): SsizeT {.cdecl,
    importc: "utf16_to_utf8".}
## * Convert a UTF-16 sequence into a UTF-8 sequence
##
##   Fills the output buffer up to \a len code units.
##   Returns the number of code units that the input would produce;
##   if it returns greater than \a len, the output has been
##   truncated.
##
##   @param[out] out Output sequence
##   @param[in]  in  Input sequence (null-terminated)
##   @param[in]  len Output length
##
##   @returns number of output code units produced
##   @returns -1 for error
##
##   @note \a out is not null-terminated
##

proc utf16ToUtf32*(`out`: ptr uint32; `in`: ptr uint16; len: csize_t): SsizeT {.cdecl,
    importc: "utf16_to_utf32".}
## * Convert a UTF-16 sequence into a UTF-32 sequence
##
##   Fills the output buffer up to \a len code units.
##   Returns the number of code units that the input would produce;
##   if it returns greater than \a len, the output has been
##   truncated.
##
##   @param[out] out Output sequence
##   @param[in]  in  Input sequence (null-terminated)
##   @param[in]  len Output length
##
##   @returns number of output code units produced
##   @returns -1 for error
##
##   @note \a out is not null-terminated
##

proc utf32ToUtf8*(`out`: ptr uint8; `in`: ptr uint32; len: csize_t): SsizeT {.cdecl,
    importc: "utf32_to_utf8".}
## * Convert a UTF-32 sequence into a UTF-8 sequence
##
##   Fills the output buffer up to \a len code units.
##   Returns the number of code units that the input would produce;
##   if it returns greater than \a len, the output has been
##   truncated.
##
##   @param[out] out Output sequence
##   @param[in]  in  Input sequence (null-terminated)
##   @param[in]  len Output length
##
##   @returns number of output code units produced
##   @returns -1 for error
##
##   @note \a out is not null-terminated
##

proc utf32ToUtf16*(`out`: ptr uint16; `in`: ptr uint32; len: csize_t): SsizeT {.cdecl,
    importc: "utf32_to_utf16".}
## * Convert a UTF-32 sequence into a UTF-16 sequence
##
##   @param[out] out Output sequence
##   @param[in]  in  Input sequence (null-terminated)
##   @param[in]  len Output length
##
##   @returns number of output code units produced
##   @returns -1 for error
##
##   @note \a out is not null-terminated
##

