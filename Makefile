CC=./clangw
CFLAGS=-Wall
CPPFLAGS=-I$(ICSDKHOME)/include
CXX=./clangw++
CXXFLAGS=-Wall
# -DMAC_OSX -D_GNU_SOURCE -DSLTS_ENABLE -DSLMXMX_ENABLE -D_REENTRANT -DNS_THREADS -DSS_64BIT_SERVER -DORAX86_64 -DBIT64 -DMACHINE64 -DSLS8NATIVE -DSLU8NATIVE -m64 -D_BCERT_API_ -DRSA_PLATFORM=RSA_MAC_X86_64_DARWIN
LDFLAGS=-L$(ICLIBHOME)
LDLIBS=-lclntsh
PROC=./procw
# Note - if we have a working d/b conn, can add SQLCHECK=FULL to have proc
# check statements against schemas
PROCFLAGS=CODE=ANSI_C INCLUDE=$(ICSDKHOME)/include LINES=YES

PROGRAMS=a procdemo

all: $(PROGRAMS)

ifndef GTEST_HOME
	$(error GTEST_HOME undefined)
endif

# Why can't I build a-test.o directly?
%-test.o: CPPFLAGS += -I. -I$(GTEST_HOME)/include
%-test.o: %.c %-test.cc
	$(COMPILE.cc) $(OUTPUT_OPTION) $*-test.cc
%-test: CPPFLAGS += -I. -I$(GTEST_HOME)/include
%-test: LDFLAGS += -L$(GTEST_HOME)
%-test: LDLIBS += -lgtest -lgtest_main
%-test: %.c %-test.cc
	$(LINK.cc) $*-test.cc $(LOADLIBES) $(LDLIBS) -o $@

check: $(PROGRAMS:%=%-test)
	./run-test $^

.PHONY: clean
clean:
	$(RM) $(PROGRAMS:%=%.c) $(PROGRAMS:%=%.lis) *.o $(PROGRAMS) $(PROGRAMS:%=%-test)

# TODO: If *.c already made, but env is wrong, this does not catch
# the issue
%.c: %.pc
ifndef ICLIBHOME
	$(error ICLIBHOME undefined)
endif
	$(PROC) $(PROCFLAGS) INAME=$< ONAME=$@
