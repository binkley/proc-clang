CC=gcc
CFLAGS=-I$(ICSDKHOME)/include -Wall
LDFLAGS=-L$(ICLIBHOME)
LDLIBS=-lclntsh

PROC=./proc

PROGRAMS=a procdemo

all: $(PROGRAMS)

.PHONY: clean
clean:
	$(RM) *.pc.gcc *.c *.lis $(PROGRAMS)

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
