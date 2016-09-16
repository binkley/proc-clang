extern "C" {
#include "print-salesmen.c"
}

#include <gtest/gtest.h>

#include <stdarg.h>
#include <stdio.h>
#include <iostream>
#include <vector>

#include "dump-stack.h"

static std::vector<char*> messages;
static const int max = 128;

extern "C" {
static int check_printing(const char *format, ...) {
    dump_stack(1);
    std::cout << "check_printing: " << format << std::endl;

    va_list ap;
    va_start(ap, format);
    char* buf = new char[max];
    int c = vsnprintf(buf, max, format, ap);
    va_end(ap);
    messages.push_back(buf);

    std::cout << "check_printing: (" << c << ") " << buf << std::endl;

    return c;
}
}

TEST(PrintSalesmenUnitTest, OutputTest)
{
    print_salesmen_with(check_printing);
    ASSERT_STREQ("\n\nThe company's salespeople are--\n\n", messages[0]);
}
