#ifndef _EMP_INFO_H
#define _EMP_INFO_H
#define UNAME_LEN      20 
#define PWD_LEN        11 
 
/*
 * Use the precompiler typedef'ing capability to create
 * null-terminated strings for the authentication host
 * variables. (This isn't really necessary--plain char *'s
 * would work as well. This is just for illustration.)
 */
typedef char asciiz[PWD_LEN]; 

extern asciiz     username; 
extern asciiz     password; 

struct emp_info 
{ 
    asciiz     emp_name; 
    float      salary; 
    float      commission; 
}; 
#endif
