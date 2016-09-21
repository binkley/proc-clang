#include "fetch-salesmen.h"

#include <stdlib.h>
#include <string.h>

#include <ctest.h>
#include "mock-oracle.h"

static emp_info_t *employees[3]; /* Really, will you hire more than 3 people? */
static int n_employees;

static void
save_data(const emp_info_t *p_emp_info, void *extra) {
    emp_info_t *copy = (emp_info_t *) malloc(sizeof(emp_info_t));
    strcpy(copy->emp_name, p_emp_info->emp_name);
    copy->salary = p_emp_info->salary;
    copy->commission = p_emp_info->commission;
    employees[n_employees++] = copy;
}

CTEST(MockOracle, FetchMockData) {
    RESET_DATA();
    TEST_DATA(3, _STRING("John Smith"), _FLOAT(3.14159f), _FLOAT(2.71828f));
    TEST_DATA(3, _STRING("Mary Jones"), _FLOAT(3.14159f), _FLOAT(2.71828f));

    fetch_salesmen(save_data, 0);

    ASSERT_EQUAL(2, n_employees);

    const emp_info_t *p_emp_info = employees[0];
    ASSERT_STR("John Smith", p_emp_info->emp_name);
    /* ASSERT_EQUAL(3.14159f, p_emp_info->salary);
    ASSERT_EQUAL(2.71828f, p_emp_info->commission); */
}
