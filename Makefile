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
check: oracle-login-test print-salesmen-test
	./run-test ${^:%=./%}

.PHONY: clean
clean:
	$(RM) procdemo.c emp-info.c sql-error.c oracle-login.c print-salesmen.c procdemo oracle-login-test print-salesmen-test *.o *.lis

procdemo: LDFLAGS+=-L$(GTEST_HOME)
procdemo: LDLIBS+=-lgtest -lgtest_main
procdemo: procdemo.o emp-info.o sql-error.o oracle-login.o print-salesmen.o

oracle-login-test: LDFLAGS+=-L$(GTEST_HOME)
oracle-login-test: LDLIBS+=-lgtest -lgtest_main
oracle-login-test: oracle-login-test.o emp-info.o sql-error.o print-salesmen.o

print-salesmen-test: LDFLAGS+=-L$(GTEST_HOME)
print-salesmen-test: LDLIBS+=-lgtest -lgtest_main
print-salesmen-test: print-salesmen-test.o

%.c: %.pc
ifndef ICLIBHOME
	$(error ICLIBHOME undefined)
endif
ifndef ICSDKHOME
	$(error ICSDKHOME undefined)
endif
	$(PROC) $(PROCFLAGS) INAME=$< ONAME=$@

procdemo.o: procdemo.c oracle-login.h print-salesmen.h

oracle-login-test.o: CPPFLAGS+=-I$(GTEST_HOME)/include
oracle-login-test.o: oracle-login.c oracle-login-test.cc
ifndef GTEST_HOME
	$(error GTEST_HOME undefined)
endif

print-salesmen-test.o: CPPFLAGS+=-I$(GTEST_HOME)/include
print-salesmen-test.o: print-salesmen.c print-salesmen-test.cc
ifndef GTEST_HOME
	$(error GTEST_HOME undefined)
endif

