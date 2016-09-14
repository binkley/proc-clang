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

all: procdemo

.PHONY: check
check: procdemo-test
	./run-test ${^:%=./%}

.PHONY: clean
clean:
	$(RM) procdemo.c emp-info.c sql-error.c procdemo procdemo-test *.o *.lis

procdemo: LDFLAGS+=-L$(GTEST_HOME)
procdemo: LDLIBS+=-lgtest -lgtest_main
procdemo: procdemo.o emp-info.o sql-error.o

procdemo-test: LDFLAGS+=-L$(GTEST_HOME)
procdemo-test: LDLIBS+=-lgtest -lgtest_main
procdemo-test: procdemo-test.o emp-info.o sql-error.o

%.c: %.pc
ifndef ICLIBHOME
	$(error ICLIBHOME undefined)
endif
ifndef ICSDKHOME
	$(error ICSDKHOME undefined)
endif
	$(PROC) $(PROCFLAGS) INAME=$< ONAME=$@

procdemo.o: procdemo.c emp-info.h sql-error.h

procdemo-test.o: CPPFLAGS+=-I$(GTEST_HOME)/include
procdemo-test.o: procdemo.c procdemo-test.cc emp-info.h sql-error.h
ifndef GTEST_HOME
	$(error GTEST_HOME undefined)
endif

