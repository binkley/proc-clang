#ifndef _PRINT_SALESMEN_H
#define _PRINT_SALESMEN_H
typedef int (*printf_t)(const char *format, ...);

#ifdef __cplusplus
extern "C" {
#endif
extern void print_salesmen_with(printf_t printer);
/* Cannot use inline declaration because of Pro*C */
extern void print_salesmen();
#ifdef __cplusplus
}
#endif
#endif
