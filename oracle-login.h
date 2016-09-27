#ifndef _ORACLE_LOGIN_H
#define _ORACLE_LOGIN_H
typedef int (*printf_t)(const char *format, ...);

extern void oracle_login_with(char const *username, char const *password,
        const char *connect, printf_t printer);
extern void oracle_login(char const *username, char const *password,
        const char *connect);
#endif
