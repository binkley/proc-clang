#ifndef _PRINT_SALESMEN_H
#define _PRINT_SALESMEN_H
typedef int (*printf_t)(const char *format, ...);
extern void print_salesmen_with(printf_t printer);
/* Cannot use inline declaration because of Pro*C */
extern void print_salesmen();
#endif
