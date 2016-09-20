#include <stdarg.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include <sqlca.h>

typedef struct _field {
    void *data;
    size_t len;
} data_field_t;

extern void RESET_DATA();
extern void TEST_DATA(const int n, ...);
extern data_field_t _STRING(const char *s);
extern data_field_t _FLOAT(const float f);
