CC=clang
CPPFLAGS=-I$(ICSDKHOME)/include
CFLAGS=-Wall -Werror
# -DMAC_OSX -D_GNU_SOURCE -DSLTS_ENABLE -DSLMXMX_ENABLE -D_REENTRANT -DNS_THREADS -DSS_64BIT_SERVER -DORAX86_64 -DBIT64 -DMACHINE64 -DSLS8NATIVE -DSLU8NATIVE -m64 -D_BCERT_API_ -DRSA_PLATFORM=RSA_MAC_X86_64_DARWIN
LDFLAGS=-L$(ICLIBHOME)
LDLIBS=-lclntsh

PROC=./proc
# Note - if we have a working d/b conn, can add SQLCHECK=FULL to have proc
# check statements against schemas
PROCFLAGS=CODE=ANSI_C INCLUDE=$(ICSDKHOME)/include LINES=YES

PROGRAMS=a procdemo

all: $(PROGRAMS)

.PHONY: clean
clean:
	$(RM) $(PROGRAMS:%=%.gpc) $(PROGRAMS:%=%.gc) \
		$(PROGRAMS:%=%.c) $(PROGRAMS:%=%.lis) $(PROGRAMS)

.ONESHELL:
%.gpc: %.pc
	set -e
	cat <<-EOH >$@
	#pragma GCC diagnostic pop
	#if defined(ORA_PROC) || !defined(__GNUC__)
	#define __attribute__(x)
	typedef unsigned long long uint64_t;
	typedef long long int64_t;
	#endif
	
	EOH
	cat $< >>$@

.ONESHELL:
%.gc: %.gpc
	$(PROC) $(PROCFLAGS) INAME=$< ONAME=$@
	# Why doesn't .INTERMEDIATE work for this?
	$(RM) $*.lis

.ONESHELL:
%.c: %.gc
	cat <<-EOH >$@
	#pragma GCC diagnostic push
	#pragma GCC diagnostic ignored "-Wall"
	
	EOH
	cat $< >>$@
