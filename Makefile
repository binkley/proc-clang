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

.PHONY: check
check: $(PROGRAMS:%=%-test)
	set -e ; for t in $^ ; do ./$$t ; done

.PHONY: clean
clean:
	$(RM) $(PROGRAMS:%=%.c) $(PROGRAMS) $(PROGRAMS:%=%-test) *.o *.lis

%.c: %.pc
ifndef ICLIBHOME
	$(error ICLIBHOME undefined)
endif
ifndef ICSDKHOME
	$(error ICSDKHOME undefined)
endif
	$(PROC) $(PROCFLAGS) INAME=$< ONAME=$@

# TODO: Why do I need to flag as intermediate?
.INTERMEDIATE: a.c a-test.o
a-test.o: CPPFLAGS+=-I$(GTEST_HOME)/include
a-test.o: a.c a-test.cc
ifndef GTEST_HOME
	$(error GTEST_HOME undefined)
endif
.INTERMEDIATE: procdemo.c procdemo-test.o
procdemo-test.o: CPPFLAGS+=-I$(GTEST_HOME)/include
procdemo-test.o: procdemo.c procdemo-test.cc
ifndef GTEST_HOME
	$(error GTEST_HOME undefined)
endif

# TODO: Why isn't this working with pattern rules?
%-test.o: CPPFLAGS+=-I$(GTEST_HOME)/include
%-test.o: %.c %-test.cc
ifndef GTEST_HOME
	$(error GTEST_HOME undefined)
endif
	$(COMPILE.cc) $(OUTPUT_OPTION) $*-test.cc

%-test: LDFLAGS+=-L$(GTEST_HOME)
%-test: LDLIBS+=-lgtest -lgtest_main
%-test: %-test.o
