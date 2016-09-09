CC=clang
CPPFLAGS=-I$(ICSDKHOME)/include
CFLAGS=-Wall -fcolor-diagnostics
# -DMAC_OSX -D_GNU_SOURCE -DSLTS_ENABLE -DSLMXMX_ENABLE -D_REENTRANT -DNS_THREADS -DSS_64BIT_SERVER -DORAX86_64 -DBIT64 -DMACHINE64 -DSLS8NATIVE -DSLU8NATIVE -m64 -D_BCERT_API_ -DRSA_PLATFORM=RSA_MAC_X86_64_DARWIN
LDFLAGS=-L$(ICLIBHOME)
LDLIBS=-lclntsh

COMPILE.c=./clang-filtered $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c

PROC=./proc
# Note - if we have a working d/b conn, can add SQLCHECK=FULL to have proc
# check statements against schemas
PROCFLAGS=CODE=ANSI_C INCLUDE=$(ICSDKHOME)/include LINES=YES

PROGRAMS=a procdemo

all: $(PROGRAMS)

.PHONY: clean
clean:
	$(RM) $(PROGRAMS:%=%.c) $(PROGRAMS:%=%.lis) $(PROGRAMS)

.ONESHELL:
%.c: %.pc
	$(PROC) $(PROCFLAGS) INAME=$< ONAME=$@
	$(RM) $*.lis # Why doesn't .INTERMEDIATE work for this?
