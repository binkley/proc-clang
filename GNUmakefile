CC=./clangw
CFLAGS=-Wall -g
CPPFLAGS=-I$(ICSDKHOME)/include
LDFLAGS=-L$(ICLIBHOME) -L.
LDLIBS=-lclntsh
PROC=./procw
# Note - if we have a working d/b conn, can add SQLCHECK=FULL to have proc
# check statements against schemas
PROCFLAGS=CODE=ANSI_C $(CPPFLAGS:-I%=INCLUDE=%) LINES=YES

.PHONY: all
all: procdemo

.PHONY: check
check: $(patsubst %-test.c,%-test,$(wildcard *-test.c))
	./run-test ${^:%=./%}

.PHONY: clean
clean:
	$(RM) $(patsubst %.pc,%.c,$(wildcard *.pc)) $(patsubst %.pc,%,$(wildcard *.pc)) $(patsubst %-test.c,%-test,$(wildcard *-test.c)) *.o *.lis *.a

ctest.o: CPPFLAGS += -Ictest
%-test.o: CPPFLAGS += -Ictest

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
