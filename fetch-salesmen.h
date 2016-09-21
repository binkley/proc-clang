#ifndef _FETCH_SALESMEN_H
#define _FETCH_SALESMEN_H
#include "emp-info.h"

typedef void (*employee_handler)(struct emp_info *emp_rec_ptr, void *extra);

#ifdef __cplusplus
extern "C" {
#endif
extern void fetch_salesmen(employee_handler handle_employee, void *extra);
#ifdef __cplusplus
}
#endif
#endif
