CC=gcc
CFLAGS=-I$(ICSDKHOME)/include -Wall
LDFLAGS=-L$(ICLIBHOME)
LDLIBS=-lclntsh
LINT=splint
LINTFLAGS=-I$(ICSDKHOME)/include

PROC=./proc

PROGRAMS=a procdemo

all: $(PROGRAMS)

lint: $(PROGRAMS:=.ln)

.PHONY: clean
clean:
	$(RM) $(PROGRAMS:%=%.pc.gcc) $(PROGRAMS:%=%.c) \
		$(PROGRAMS:%=%.pc.lis) $(PROGRAMS:%=%.ln) $(PROGRAMS)

# Work around proc not groking gcc extensions
.INTERMEDIATE: %.lis
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
