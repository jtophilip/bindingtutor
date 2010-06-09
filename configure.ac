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
AS_IF([test "$build" != "$host"], [AC_MSG_ERROR([BUILD and HOST systems differ: the MATLAB Compiler does not support cross-compilation])])

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

AM_CONDITIONAL([THIRTYTWO], [test "x$sixtyfour" = "xno"])
AM_CONDITIONAL([SIXTYFOUR], [test "x$sixtyfour" = "xyes"])


#
# External program support
#

AC_PROG_LN_S
AC_PROG_SED

# The following just silences an Autoconf warning.  You need not have an
# Objective-C compiler to build MTBindingSim.
AC_PROG_OBJC

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

AC_CONFIG_FILES([Makefile doc/Makefile doc/mtbindingsim.tex src/Makefile])

AC_OUTPUT
