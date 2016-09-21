extern "C" {
#include "fetch-salesmen.c"
}

#include <cstring>
#include <vector>

#include <gtest/gtest.h>
#include "mock-oracle.h"

#include <iostream>

static std::vector<struct emp_info *> employees;

extern "C" {
static void save_data(struct emp_info *emp_rec_ptr, void *extra) {
    struct emp_info *copy = new emp_info;
    strcpy(copy->emp_name, emp_rec_ptr->emp_name);
    copy->salary = emp_rec_ptr->salary;
    copy->commission = emp_rec_ptr->commission;
    employees.push_back(copy);
}
}

TEST(MockOracle, FetchMockData) {
    RESET_DATA();
    TEST_DATA(3, _STRING("John Smith"), _FLOAT(3.14159f), _FLOAT(2.71828f));
    TEST_DATA(3, _STRING("Mary Jones"), _FLOAT(3.14159f), _FLOAT(2.71828f));

    fetch_salesmen(save_data, 0);

    EXPECT_EQ(2, employees.size());

    struct emp_info *emp_rec_ptr = employees[0];
    EXPECT_STREQ("John Smith", emp_rec_ptr->emp_name);
    EXPECT_EQ(3.14159f, emp_rec_ptr->salary);
    EXPECT_EQ(2.71828f, emp_rec_ptr->commission);
}
