AC_INIT([MTBindingSim], [0.5], [jtophilip@gmail.com], [mtbindingsim], [http://code.google.com/p/mtbindingsim/])
AC_PREREQ([2.65])

AC_CONFIG_SRCDIR([src/MTBindingSim.m])
AC_CONFIG_AUX_DIR([build/aux])
AC_CONFIG_MACRO_DIR([build/m4])

AM_INIT_AUTOMAKE([gnits no-dependencies])

AC_EXEEXT
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
