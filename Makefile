CC=gcc
CFLAGS=-I$(ICSDKHOME)/include -Wall
# -DMAC_OSX -D_GNU_SOURCE -DSLTS_ENABLE -DSLMXMX_ENABLE -D_REENTRANT -DNS_THREADS -DSS_64BIT_SERVER -DORAX86_64 -DBIT64 -DMACHINE64 -DSLS8NATIVE -DSLU8NATIVE -m64 -D_BCERT_API_ -DRSA_PLATFORM=RSA_MAC_X86_64_DARWIN
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
	$(RM) $<.gcc $<.lis
