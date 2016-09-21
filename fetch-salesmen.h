#ifndef _FETCH_SALESMEN_H
#define _FETCH_SALESMEN_H
#include "emp-info.h"

typedef void (*employee_handler)(const emp_info_t *p_emp_info, void *extra);

extern void fetch_salesmen(const employee_handler handle_employee, void *extra);
#endif
