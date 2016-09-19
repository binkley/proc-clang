extern "C" {
#include "oracle-login.c"
}

#include <gtest/gtest.h>

TEST(OracleLoginUnitTest, LoginTest)
{
    /* Test passes if login works */
    oracle_login("scott", "tiger");
}
