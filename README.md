# Proc*C experiment

1. Download from
   http://www.oracle.com/technetwork/topics/precomp-112010-084940.html
2. Download from
   http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html
3. Unzip the two archives manually.  If you unzip with the MacOS shell, it
   helpfully renames the second one, appending a " 2".  It is preferable to
   unpack the archive contents into the same directory.  Let's refer to the
   unpacked directory as `ICLIBHOME` (e.g., `/tmp/instantclient_12_1`) and the
   `sdk` directory within as `ICSDKHOME`.
4. Export these:
```
$ export ICLIBHOME=...
$ export ICSDKHOME=$ICLIBHOME/sdk
$ export LD_LIBRARY_PATH=$ICLIBHOME
```
5. Fix the library names.  This is so the compiler tool chain can link without
   too much pain:
```
cd $ICLIBHOME
ln -s libclntsh.dylib.12.1 libclntsh.so
```
6. Install MacOS command-line tools.  By default XCode does not install
   command line tools, and `proc` cannot find `/usr/include` otherwise.  This
   is [an El Capitan
thing](http://superuser.com/questions/995360/missing-usr-include-in-os-x-el-capitan):
```
$ xcode-select --install
```
7. Optionally edit `$IC/precomp/admin/pcscfg.cfg` and add or edit this
   line, else `proc` will blow up complaining about GCC extensions found in
   `/usr/include`:
```
parse=PARTIAL
```
   *CAVEAT* -- However this breaks some simple cases such as local variables
   used to receive data from Oracle.  The alternative is to leave `parse` at
   its default ("FULL") and lie to `proc` about the compiler.  Include this at
   the top of "C" source files before including any system headers.  A pity it
   also disables some GCC optimizations:
```c
#ifdef ORA_PROC
# define __attribute__(x)
#endif
```
8. Similarly export `PATH` to include `$IC/sdk`.  The same advice for a
   wrapper script or subshell applies.  After steps #6 and #7 the
   (`proc`)[proc] wrapper script.
9. Install `splint` (a `lint` look-a-like) via Homebrew.
10. There is a convenient (`Makefile`)[Makefile] which turns a Pro*C source
    file into an executable of the same basename.
