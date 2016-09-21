CC=./clangw
CFLAGS=-Wall -g
CPPFLAGS=-I$(ICSDKHOME)/include
CXX=./clangw++
CXXFLAGS=-Wall -g
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
check: $(patsubst %-test.cc,%-test,$(wildcard *-test.cc))
	./run-test ${^:%=./%}

.PHONY: clean
clean:
	$(RM) $(patsubst %.pc,%.c,$(wildcard *.pc)) $(patsubst %.pc,%,$(wildcard *.pc)) $(patsubst %-test.cc,%-test,$(wildcard *-test.cc)) *.o *.lis *.a

define BUILD_test
.DELETE_ON_ERROR: $(1:%=%.o)
$(1:%=%.o): CPPFLAGS += -I$$(GTEST_ROOT)/include
$(1:%=%.o): $(1:%-test=%.c) $(1:%=%.cc)
ifndef GTEST_ROOT
	$$(error GTEST_ROOT undefined)
endif
	$$(COMPILE.cc) $$(OUTPUT_OPTION) $(1:%=%.cc)

$(1): LDFLAGS += -L$$(GTEST_ROOT)
$(1): LDLIBS += -lgtest -lgtest_main -lc++
$(1): $(1:%=%.o)
endef
$(foreach t,$(wildcard *-test.cc),$(eval $(call BUILD_test,$(t:%.cc=%))))

%.c: %.pc
ifndef ICLIBHOME
	$(error ICLIBHOME undefined)
endif
ifndef ICSDKHOME
	$(error ICSDKHOME undefined)
endif
	$(PROC) $(PROCFLAGS) INAME=$< ONAME=$@

procdemo: procdemo.o emp-info.o sql-error.o oracle-login.o print-salesmen.o fetch-salesmen.o
fetch-salesmen-test: fetch-salesmen-test.o sql-error.o mock-oracle.o
oracle-login-test: oracle-login-test.o emp-info.o sql-error.o mock-oracle.o
print-salesmen-test: print-salesmen-test.o dump-stack.o sql-error.o oracle-login.o mock-oracle.o fetch-salesmen.o

