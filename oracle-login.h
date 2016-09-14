#ifndef _ORACLE_LOGIN_H
#define _ORACLE_LOGIN_H
#include "emp-info.h"

extern struct emp_info *oracle_login(const char *account, const char *credentials);
#endif
