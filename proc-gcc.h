#if defined(ORA_PROC) || !defined(__GNUC__)
#define __attribute__(x)
#endif
#ifdef ORA_PROC
typedef unsigned long long uint64_t;
typedef long long int64_t;
#endif
