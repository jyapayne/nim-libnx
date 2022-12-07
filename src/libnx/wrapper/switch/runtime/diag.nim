## *
##  @file diag.h
##  @brief Debugging and diagnostics utilities
##  @author fincs
##  @copyright libnx Authors
##

import
  ../types, ../result

## *
##  @brief Aborts program execution with a result code.
##  @param[in] res Result code.
##

proc diagAbortWithResult*(res: Result) {.cdecl, importc: "diagAbortWithResult".}
