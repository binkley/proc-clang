#if defined(ORA_PROC) || !defined(__GNUC__)
#define __attribute__(x)
typedef unsigned long long uint64_t;
typedef long long int64_t;
#endif
