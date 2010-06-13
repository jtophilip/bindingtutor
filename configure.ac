#
# Autoconf and Automake initialization
#
AC_INIT([MTBindingSim], [0.5], [jtophilip@gmail.com], [mtbindingsim], [http://code.google.com/p/mtbindingsim/])
AC_PREREQ([2.65])

AC_CONFIG_SRCDIR([src/MTBindingSim.m])
AC_CONFIG_AUX_DIR([build/aux])
AC_CONFIG_MACRO_DIR([build/m4])

AM_INIT_AUTOMAKE([gnits no-dependencies no-exeext])


#
# Information about system type
#

# Prevent cross-compilation, because MCC doesn't support it
AC_CANONICAL_BUILD
AC_CANONICAL_HOST

AC_MSG_CHECKING([whether we are cross-compiling])
if test "$build" != "$host" ; then
  AC_MSG_RESULT([yes])
  AC_MSG_ERROR([BUILD and HOST systems differ: the MATLAB Compiler does not support cross-compilation])
else
  AC_MSG_RESULT([no])
fi

# Define conditionals for our build platforms
case $host_os in
  *mingw32* ) os="windows";;
   *cygwin* ) os="windows";;
   *darwin* ) os="mac";;
          * ) os="";;
esac

case $host_cpu in
 *x86_64* ) sixtyfour="yes";;
   *ia64* ) sixtyfour="yes";;
        * ) sixtyfour="no";;
esac

AM_CONDITIONAL([WINDOWS], [test "x$os" = "xwindows"])
AM_CONDITIONAL([MAC], [test "x$os" = "xmac"])

AC_MSG_CHECKING([for build system type])
if test "x$os" = "xwindows" ; then
  AC_MSG_RESULT([windows])
elif test "x$os" = "xmac" ; then
  AC_MSG_RESULT([mac])
else
  AC_MSG_RESULT([linux])
fi


#
# External program support
#

AC_PROG_LN_S
AC_PROG_SED
AC_PROG_GREP

# The following just silences an Autoconf warning.  You need not have an
# Objective-C compiler to build MTBindingSim.
AC_PROG_OBJC

# Determine if we can build the documentation
ACLTX_PROG_PDFLATEX([have_pdflatex="no"])
ACLTX_PROG_KPSEWHICH([have_kpsewhich="no"])
if [ test "x$have_kpsewhich" != "xno" ] ; then
  ACLTX_CLASS([book],[have_book])
  ACLTX_PACKAGE([inputenc],[book],[have_inputenc])
  ACLTX_PACKAGE([mathpazo],[book],[have_mathpazo])
  ACLTX_PACKAGE([hyperref],[book],[have_hyperref])
fi

AM_CONDITIONAL([DOCS],
  [test "x$have_pdflatex" != "xno" -a "x$have_kpsewhich" != "xno" -a \
        "x$have_book" = "xyes" -a \
        "x$have_inputenc" = "xyes" -a "x$have_mathpazo" = "xyes" -a \
        "x$have_hyperref" = "xyes"])

# Look for MATLAB, and let the user specify where it lives
AC_ARG_WITH([matlab],
  [AS_HELP_STRING([--with-matlab@<:@=DIR@:>@],
    [build with MATLAB (in DIR if given) @<:@default=look in $PATH@:>@])],
  [],
  [with_matlab=""])

AS_IF([test "x$with_matlab" = "x"], [AC_CHECK_PROGS([MCC], [mcc mcc.bat])],
      [AC_CHECK_PROGS([MCC], [mcc mcc.bat], [], [$with_matlab])])

if test "x$MCC" = "x"; then
  AC_MSG_ERROR([Cannot find the MATLAB Compiler, specify its path with --with-matlab])
fi

# Let the user send some command-line parameters to MATLAB
AC_ARG_WITH([matlab-flags],
  [AS_HELP_STRING([--with-matlab-flags=FLAGS],
    [pass FLAGS to the MATLAB Compiler])],
  [],
  [with_matlab_flags=""])
AC_SUBST([MATLABFLAGS], [$with_matlab_flags])

# Check whether matlab works
AC_MSG_CHECKING([whether matlab is properly configured])
PATH="${PATH}:$with_matlab" matlab $with_matlab_flags -e > /dev/null 2>&1
if test "x$?" = "x0"; then
  AC_MSG_RESULT([yes])
else
  AC_MSG_RESULT([no])
  AC_MSG_ERROR([MATLAB cannot be executed.  Specify a path to it with --with-matlab, and check whether you need to pass any command-line parameters to MATLAB with --with-matlab-flags.])
fi

# Figure out whether this is 32-bit or 64-bit MATLAB
AC_MSG_CHECKING([whether MATLAB is 32-bit or 64-bit])
PATH="${PATH}:$with_matlab" matlab $with_matlab_flags -e | $GREP -e ARCH= | $SED s/^ARCH=// | $GREP -q 64 2> /dev/null
if test "x$?" = "x0" ; then
  AC_MSG_RESULT([64-bit])
  matlab_sixtyfour=yes
else
  AC_MSG_RESULT([32-bit])
  matlab_sixtyfour=no
fi

AM_CONDITIONAL([THIRTYTWO], [test "x$matlab_sixtyfour" = "xno"])
AM_CONDITIONAL([SIXTYFOUR], [test "x$matlab_sixtyfour" = "xyes"])


#
# Write out files
#

AC_CONFIG_FILES([Makefile build/Makefile doc/Makefile doc/mtbindingsim.tex src/Makefile tools/Makefile])
AC_OUTPUT
