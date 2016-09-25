#include "print-salesmen.h"
#include "mock-oracle.h"

#include <ctest.h>

#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>

static char *messages[20];
static int n_messages;

static const int max = 128;

static int check_printing(const char *format, ...) {
    va_list ap;
    va_start(ap, format);
    char* buf = (char *) calloc(1, max);
    int c = vsnprintf(buf, max, format, ap);
    va_end(ap);
    messages[n_messages++] = buf;

    return c;
}

CTEST(PrintSalesmenUnitTest, OutputTest)
{
    RESET_DATA();
    TEST_DATA(3, _STRING("Bob Jones"), _FLOAT(3.14159f), _FLOAT(2.71828f));
    print_salesmen_with(check_printing);
    ASSERT_STR("\n\nThe company's salespeople are--\n\n", messages[0]);
}
