#ifndef _MOCK_ORACLE_H
#define _MOCK_ORACLE_H

#include <stddef.h>

typedef struct _data_field {
    void *data;
    size_t len;
} data_field_t;

extern void RESET_DATA();
extern void TEST_DATA(const int n, ...);
extern data_field_t *_STRING(const char *s);
extern data_field_t *_FLOAT(const float f);
#endif
