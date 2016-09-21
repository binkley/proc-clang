#include "fetch-salesmen.h"

#include <stdlib.h>
#include <string.h>

#include <ctest.h>
#include "mock-oracle.h"

static struct emp_info *employees[3]; /* Really, will you hire more than 3 people? */
static int n_employees;

static void save_data(struct emp_info *emp_rec_ptr, void *extra) {
    struct emp_info *copy = (struct emp_info *) malloc(sizeof(struct emp_info));
    strcpy(copy->emp_name, emp_rec_ptr->emp_name);
    copy->salary = emp_rec_ptr->salary;
    copy->commission = emp_rec_ptr->commission;
    employees[n_employees++] = copy;
}

CTEST(MockOracle, FetchMockData) {
    RESET_DATA();
    TEST_DATA(3, _STRING("John Smith"), _FLOAT(3.14159f), _FLOAT(2.71828f));
    TEST_DATA(3, _STRING("Mary Jones"), _FLOAT(3.14159f), _FLOAT(2.71828f));

    fetch_salesmen(save_data, 0);

    ASSERT_EQUAL(2, n_employees);

    struct emp_info *emp_rec_ptr = employees[0];
    ASSERT_STR("John Smith", emp_rec_ptr->emp_name);
    /* ASSERT_EQUAL(3.14159f, emp_rec_ptr->salary);
    ASSERT_EQUAL(2.71828f, emp_rec_ptr->commission); */
}
