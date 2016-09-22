CC=./clangw
CFLAGS=-Wall -g
CPPFLAGS=-I$(ICSDKHOME)/include
# -DMAC_OSX -D_GNU_SOURCE -DSLTS_ENABLE -DSLMXMX_ENABLE -D_REENTRANT -DNS_THREADS -DSS_64BIT_SERVER -DORAX86_64 -DBIT64 -DMACHINE64 -DSLS8NATIVE -DSLU8NATIVE -m64 -D_BCERT_API_ -DRSA_PLATFORM=RSA_MAC_X86_64_DARWIN
LDFLAGS=-L$(ICLIBHOME) -L.
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

ctest.o: CPPFLAGS += -I$(CTEST_HOME)
%-test.o: CPPFLAGS += -I$(CTEST_HOME)

%.c: %.pc
ifndef ICLIBHOME
	$(error ICLIBHOME undefined)
endif
ifndef ICSDKHOME
	$(error ICSDKHOME undefined)
endif
	$(PROC) $(PROCFLAGS) INAME=$< ONAME=$@

-lprocdemo: libprocdemo.a(sql-error.o emp-info.o oracle-login.o fetch-salesmen.o print-salesmen.o)
-ltesting: libtesting.a(mock-oracle.o ctest.o)

procdemo: procdemo.o -lprocdemo

define BUILD_test
$(1): $(1:%=%.o) -lprocdemo -ltesting
endef
$(foreach t,$(wildcard *-test.c),$(eval $(call BUILD_test,$(t:%.c=%))))

Makefile: ;
