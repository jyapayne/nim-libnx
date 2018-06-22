/**
 * @file tls.h
 * @brief AArch64 thread local storage.
 * @author plutoo
 * @copyright libnx Authors
 */
#pragma once
#include "../types.h"
 
/**
 * @brief Gets the thread local storage buffer.
 * @return The thread local storage buffer.
 */
static inline void* armGetTls(void);
