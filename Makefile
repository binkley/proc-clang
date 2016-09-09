CC=gcc
CFLAGS=-I$$ICSDKHOME/include -Wall

PROC=./proc

PROGRAMS=a procdemo

all: $(PROGRAMS)

.PHONY: clean
clean:
	$(RM) *.c *.lis *.gc $(PROGRAMS)

# Work around proc not groking gcc extensions
.ONESHELL:
%.c: %.pc
	cat <<-EOH >$<.gcc
	#if defined(ORA_PROC) || !defined(__GNUC__)
	#define __attribute__(x)
	typedef unsigned long long uint64_t;
	typedef long long int64_t;
	#endif
	
	EOH
	cat $< >>$<.gcc
	$(PROC) INAME=$<.gcc ONAME=$@ INCLUDE=$$ICSDKHOME/include &&
	$(RM) $<.gcc
