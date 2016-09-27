# Proc*C experiment

## Setup on MacOS

1. Update submodule for [Xian Yi's ctest fork](https://github.com/xianyi/ctest):
   ```
$ git submodule update --init  # Run this after cloning this repo
$ git submodule update --remote  # Run this after pulling this repo
```

2. Download the basic Oracle software (including library dependencies) from:
   http://www.oracle.com/technetwork/topics/precomp-112010-084940.html

3. Download the Oracle SDK (including pre-compiler) from:
   http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html

4. Unzip the two archives manually.  If you unzip with the MacOS shell, the
   two archives unpack to the same directory, and MacOS helpfully renames the
   second one, appending a " 2".  It is preferable to unpack the archive
   contents into the same directory.  Let's refer to the unpacked directory
   as `ICLIBHOME` (e.g., `/tmp/instantclient_12_1`) and the `sdk` directory
   within as `ICSDKHOME`.

5. Fix the library name.  This is so the compiler tool chain can link without
   too much pain (the alternative involves various hard-coding version in
   `Makefile`):

   ```
$ cd $ICLIBHOME
$ ln -s libclntsh.dylib.12.1 libclntsh.dylib
```

6. Install MacOS command-line tools.  By default XCode does not install
   command line tools, and `proc` cannot find `/usr/include` and friends.  This
   is [an El Capitan
thing and Sierra](http://superuser.com/questions/995360/missing-usr-include-in-os-x-el-capitan):

   ```
$ xcode-select --install
$ xcodebuild -license
```

7. Install llvm from homebrew.  This gets you `clang`, which is superior to
   `gcc`, command-line compatible, and great for lint-y warnings.  It is also
   what newer versions of XLC (IBM's compiler) are based on, although SWMS is
   using a much older pre-clang version of XLC.

8. Export these:

    ```
$ export ICLIBHOME=...  # Needed to build
$ export ICSDKHOME=$ICLIBHOME/sdk  # Needed to build
$ export LD_LIBRARY_PATH=$ICLIBHOME:$LD_LIBRARY_PATH  # Needed to run, but not to build
```

## If all goes well

Try:
```
# Build output elided
$ make all
$ ./procdemo

Connected to ORACLE as user: scott


The company's salespeople are--

Salesperson   No.    Salary   Commission
-----------   ----   ------   ----------
ALLEN         7499  1600.00       300.00
WARD          7521  1250.00       500.00
MARTIN        7654  1250.00      1400.00
TURNER        7844  1500.00         0.00

GOOD-BYE!!

$ make check
$ make check
TEST 1/1 OracleLoginUnitTest:LoginTest 
Connected to ORACLE as user: scott
[OK]
RESULTS: 1 tests (1 ok, 0 failed, 0 skipped) ran in 0 ms
TEST 1/1 MockOracle:FetchMockData [OK]
RESULTS: 1 tests (1 ok, 0 failed, 0 skipped) ran in 0 ms
TEST 1/1 PrintSalesmenUnitTest:OutputTest [OK]
RESULTS: 1 tests (1 ok, 0 failed, 0 skipped) ran in 0 ms
Summary: 3 PASSED, 0 FAILED, 0 ERRORED

$ make clean
```
This means it worked!  However, it also means you have no database connection.
Win some, lose some.
