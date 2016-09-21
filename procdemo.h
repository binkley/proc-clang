#ifndef _PROCDEMO_H
#define _PROCDEMO_H
#define UNAME_LEN      20 
#define DB_STR_MAX        11 

/*
 * Use the precompiler typedef'ing capability to create
 * null-terminated strings for the authentication host
 * variables. (This isn't really necessary--plain char *'s
 * would work as well. This is just for illustration.)
 */
typedef char asciiz[DB_STR_MAX]; 
#endif
