#ifndef _PRINT_SALESMEN_H
#define _PRINT_SALESMEN_H
typedef int (*printf_t)(const char *format, ...);
extern void print_salesmen(printf_t printer);
#endif
