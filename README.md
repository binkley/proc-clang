# Proc*C experiment

## Setup on MacOS

1. Download the basic software (including library dependencies) from:
   http://www.oracle.com/technetwork/topics/precomp-112010-084940.html
2. Download the SDK (including pre-compiler) from:
   http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html
3. Unzip the two archives manually.  If you unzip with the MacOS shell, the
   two archives unpack to the same directory, and MacOS helpfully renames the
   second one, appending a " 2".  It is preferable to unpack the archive
   contents into the same directory.  Let's refer to the unpacked directory
   as `ICLIBHOME` (e.g., `/tmp/instantclient_12_1`) and the `sdk` directory
   within as `ICSDKHOME`.
4. Export these:
```
$ export ICLIBHOME=...  # Needed to build
$ export ICSDKHOME=$ICLIBHOME/sdk  # Needed to build
$ export LD_LIBRARY_PATH=$ICLIBHOME  # Needed to run, but not to build
```
5. Fix the library names.  This is so the compiler tool chain can link without
   too much pain (the alternative involves various hard-coding hacks in
   `Makefile`):
```
cd $ICLIBHOME
ln -s libclntsh.dylib.12.1 libclntsh.so
```
6. Install MacOS command-line tools.  By default XCode does not install
   command line tools, and `proc` cannot find `/usr/include` and friends.  This
   is [an El Capitan
thing](http://superuser.com/questions/995360/missing-usr-include-in-os-x-el-capitan):
```
$ xcode-select --install
```
7. Install llvm from homebrew.  This gets you `clang`, which is superior to
   `gcc`, command-line compatible, and great for lint-y warnings.  It is also
   what newer versions of XLC (IBM's compiler) are based on, although SWMS is
   using a much older pre-clang version of XLC.

## If all goes well

Try:
```
$ make
$ ./a
The salary is 0.
$ ./procdemo

ORACLE error--
ORA-12162: TNS:net service name is incorrectly specified

$ make clean
```
This means it worked!  However, it also means you have no database connection.
Win some, lose some.
