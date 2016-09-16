#include "dump-stack.h"

#include <dlfcn.h>
#include <execinfo.h>
#include <stddef.h>

void dump_stack(const int fd) {
    const int max_n = 4;
    void *stack[max_n];
    const size_t n = backtrace(stack, max_n);
    backtrace_symbols_fd(stack, n, fd);
}
