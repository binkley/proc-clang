#include "oracle-login.h"

#include <ctest.h>

static int
ignore_printing(const char *format, ...)
{
    return 0;
}

CTEST(OracleLoginUnitTest, LoginTest)
{
    /* Test passes if login does not die */
    oracle_login_with("scott", "tiger", "no-such-host/no-such-db",
            ignore_printing);
}
