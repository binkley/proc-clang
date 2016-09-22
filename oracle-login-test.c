#include "oracle-login.h"

#include <ctest.h>

CTEST(OracleLoginUnitTest, LoginTest)
{
    /* Test passes if login works */
    oracle_login("scott", "tiger", "no-such-host/no-such-db");
}
