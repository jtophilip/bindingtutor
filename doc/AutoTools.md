## Introduction

MTBindingSim is built using the [GNU Autotoos](http://sources.redhat.com/automake/automake.html#Autotools-Introduction).  This page provides some documentation as to the internals of this build system.  First come the user (that is, developer) visible parts, then some ramblings about how the internals are put together.

## Using the Autotools System

To begin, the MTBindingSim build system uses some relatively recent features of the GNU Build System, and so you should be sure to have current versions installed of the following programs (the versions used by the development team are given):

  * [Autoconf](http://www.gnu.org/software/autoconf/) 2.69
  * [Automake](http://www.gnu.org/software/automake/) 1.12.2

### Configuring MTBindingSim

If you check out the MTBindingSim source from Subversion, you won't have any configuration scripts.  You need to generate these by executing

    autoreconf

at the terminal prompt.  This will generate the `configure` script.  If you download a source tarball, the `configure` script will be included.

To generate makefiles, you need to execute

    ./configure

at the prompt.  The MTBindingSim `configure` script accepts a few parameters, if you need to adjust the behavior of the MTBindingSim build process for your system.  Before running `configure`, you may set the following environment variables:

  * `WHICH`: the path to a functioning `which` command.
  * `ZIP`: the path to a functioning Info-ZIP `zip` command.  Not required to build MTBindingSim, only to produce binary distributions.
  * `pdflatex`: the path to a functioning `pdflatex` command.
  * `kpsewhich`: the path to a functioning `kpsewhich` command.
  * `latex`: the path to a functioning `latex` command.
  * `pandoc`: the path to a functioning `pandoc` command. These last four are not required to build MTBindingSim, only to produce the PDF documentation book.

Also, the following command-line parameters may be passed to `configure`:

  * `--with-matlab=DIR`: If your MATLAB installation is not available on the `PATH`, you may specify its directory here.
  * `--with-matlab-flags=FLAGS`: Pass additional flags to the MATLAB command-line executable.  This is mostly used if you are running 32-bit MATLAB on a 64-bit host, in which case the MATLAB executable must be informed that it should run in 32-bit mode, using a flag such as `-win32` or `-maci`.
  * `--with-matlab-bits=32` or `--with-matlab-bits=64`: `configure` attempts to detect whether your MATLAB installation is 32-bit or 64-bit, using various environment variable and path tricks.  Occasionally, or if !MathWorks alters some of the tricks we use, this detection may fail.  You can force the test using this parameter.

## Building MTBindingSim

Once you have generated makefiles using `configure`, you can build by executing

    make

Binaries will be placed in the `src` directory, and, if the TeX tools are available and detected, the PDF documentation book will be placed in the `doc` directory.

## Maintainer Details

Everything below here is of interest only to maintainers who need to deal with updating the build system.

### Autoconf

There's a few custom Autoconf macros which we've had to use, located in `build/m4`.  Mostly these are unremarkable, but a few are worthy of note.  First is `ac_prog_objc.m4`.  Autoconf sees MATLAB's `.m` files in the `src` directory, and thinks that we're dealing with Objective C sources.  It then complains if you don't have `AC_PROG_OBJC` in `configure.ac`.  If you add that, however, the compilation will fail on any system that doesn't have an Objective C compiler installed.  So we override `AC_PROG_OBJC` to be an empty function, and everybody wins.

The other is `mtb_prog_matlab.m4`, which is the core of the complicated MATLAB detection.  First we find MATLAB, and figure out (using `which`) where it lives on the path.  We make sure that we have MCC (which is called `mcc.bat` on Windows), and we let the user specify some MATLAB flags.  On non-Windows platforms, we can run `matlab -e` (which just prints out MATLAB's environment variables) and check its return value to make sure that MATLAB is properly configured and can run.  On Windows, there's no substitute for this check, and the build is just a little less robust.  We can also use the return value from `matlab -e` to check whether the MATLAB installation is 32- or 64-bit (by looking at the `ARCH` environment variable).  On Windows, we're reduced to seeing if the directory that contains the `matlab` executable has a `win32` or a `win64` subdirectory.  It's inelegant, but it seems to work.  And the user can override it if the check fails.

### Automake

There's a few make targets of interest to maintainers.  For one, `make distcheck` passes, and you should call that every time a new version of the source is released.

Also, we've added a `make rcsclean` target, which completely erases all traces of the Autotools and gets you back to what looks like freshly checked out source from SVN.

Finally, there is a `make bindist` target, which produces a ZIP file containing the binaries on this platform (if `zip` is on the path and works).