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

.PHONY: all
all: procdemo

.PHONY: check
#check: check_upc-test
check: oracle-login-test print-salesmen-test
	./run-test ${^:%=./%}

.PHONY: clean
clean:
	$(RM) procdemo.c emp-info.c sql-error.c oracle-login.c print-salesmen.c procdemo oracle-login-test print-salesmen-test *.o *.lis

define BUILD_test
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

procdemo.o: procdemo.c oracle-login.h print-salesmen.h
procdemo: procdemo.o emp-info.o sql-error.o oracle-login.o print-salesmen.o
oracle-login-test: oracle-login-test.o emp-info.o sql-error.o print-salesmen.o
print-salesmen-test: print-salesmen-test.o dump-stack.o sql-error.o

