#ifndef _MOCK_ORACLE_H
#define _MOCK_ORACLE_H

#include <stddef.h>

typedef struct _data_field {
    void *data;
    size_t len;
    struct _data_field *next;
} data_field_t;

extern void TEST_DATA(const int n, ...);
extern const data_field_t *_STRING(const char *s);
extern const data_field_t *_INT(const int i);
extern const data_field_t *_FLOAT(const float f);
#endif
