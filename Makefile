CC=./clangw
CFLAGS=-Wall -g
CPPFLAGS=-I$(ICSDKHOME)/include
# -DMAC_OSX -D_GNU_SOURCE -DSLTS_ENABLE -DSLMXMX_ENABLE -D_REENTRANT -DNS_THREADS -DSS_64BIT_SERVER -DORAX86_64 -DBIT64 -DMACHINE64 -DSLS8NATIVE -DSLU8NATIVE -m64 -D_BCERT_API_ -DRSA_PLATFORM=RSA_MAC_X86_64_DARWIN
LDFLAGS=-L$(ICLIBHOME)
LDLIBS=-lclntsh
PROC=./procw
# Note - if we have a working d/b conn, can add SQLCHECK=FULL to have proc
# check statements against schemas
PROCFLAGS=CODE=ANSI_C INCLUDE=$(ICSDKHOME)/include LINES=YES

.PHONY: all
all: procdemo

.PHONY: check
check: $(patsubst %-test.c,%-test,$(wildcard *-test.c))
	./run-test ${^:%=./%}

.PHONY: clean
clean:
	$(RM) $(patsubst %.pc,%.c,$(wildcard *.pc)) $(patsubst %.pc,%,$(wildcard *.pc)) $(patsubst %-test.c,%-test,$(wildcard *-test.c)) *.o *.lis *.a

%-test.o: CPPFLAGS += -I$(CTEST_HOME)
test-main.o: CPPFLAGS += -I$(CTEST_HOME)

%.c: %.pc
ifndef ICLIBHOME
	$(error ICLIBHOME undefined)
endif
ifndef ICSDKHOME
	$(error ICSDKHOME undefined)
endif
	$(PROC) $(PROCFLAGS) INAME=$< ONAME=$@

procdemo: procdemo.o emp-info.o sql-error.o oracle-login.o print-salesmen.o fetch-salesmen.o
fetch-salesmen-test: fetch-salesmen-test.o fetch-salesmen.o sql-error.o mock-oracle.o test-main.o
oracle-login-test: oracle-login-test.o oracle-login.o emp-info.o sql-error.o mock-oracle.o test-main.o
print-salesmen-test: print-salesmen-test.o print-salesmen.o dump-stack.o sql-error.o oracle-login.o mock-oracle.o fetch-salesmen.o test-main.o

Makefile: ;
