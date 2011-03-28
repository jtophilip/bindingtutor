dnl @synopsis MTB_PROG_MATLAB([ACTION-IF-NOT-FOUND])
dnl
dnl This macro sets the following variables:
dnl  - MATLAB (path to MATLAB)
dnl  - MCC (path to MCC)
dnl  - MATLABBITS (32 or 64, installed version of matlab)
dnl  - MATLABPATH (the path to MATLAB)
dnl
dnl The user may modify these by setting
dnl  - --with-matlab=PATH (set path to MATLAB)
dnl  - --with-matlab-flags=FLAGS (add flags to MATLAB command line)
dnl  - --with-matlab-bits=32/64
dnl
dnl If MATLAB cannot be found at all, execute ACTION-IF-NOT-FOUND
dnl if specified, otherwise fail with an error.
dnl
dnl @category Miscellaneous
dnl @author Charles Pence <charles@charlespence.net>
dnl @version 2010-06-13
dnl @license LGPL

AC_DEFUN([MTB_PROG_MATLAB],[

# Get the operating system
AC_REQUIRE([AC_CANONICAL_HOST])
AS_CASE([$host_os],
  [*mingw32*], [_matlab_os="windows"],
  [*cygwin*],  [_matlab_os="windows"],
               [_matlab_os=""])


# Let the user specify the path to MATLAB
AC_ARG_WITH([matlab],
  [AS_HELP_STRING([--with-matlab@<:@=DIR@:>@],
    [build with MATLAB (in DIR if given) @<:@default=look in $PATH@:>@])],
  [],
  [with_matlab=""])


# Locate MATLAB and set $matlab_path
AS_IF([test "x$with_matlab" = "x"],
  [AC_PATH_PROGS([matlab], [matlab], [no])],
  [AC_PATH_PROGS([matlab], [matlab], [no], [$with_matlab])])
AS_IF([test "x$matlab" = "xno"],
  [ifelse(["$#"], ["0"], [AC_MSG_ERROR([Unable to find MATLAB])], [$1])],
  [matlab_binary="$matlab"
   matlab_path=$(AS_DIRNAME(["$matlab_binary"]))])


# Let the user send some command-line parameters to MATLAB if
# required
AC_ARG_WITH([matlab-flags],
  [AS_HELP_STRING([--with-matlab-flags=FLAGS],
    [pass FLAGS to the MATLAB Compiler])],
  [],
  [with_matlab_flags=""])


MATLAB="\"$matlab\" $with_matlab_flags"
MATLABPATH="$matlab_path"
AC_SUBST([MATLAB])
AC_SUBST([MATLABPATH])


# Figure out whether MATLAB is 32 or 64 bit, letting the user force it
AC_ARG_WITH([matlab-bits],
  [AS_HELP_STRING([--with-matlab-bits@<:@=32/64@:>@],
    [force 32- or 64-bit MATLAB @<:@default=determine based on installed MATLAB@:>@])],
  [],
  [with_matlab_bits=""])
AC_MSG_CHECKING([whether MATLAB is 32-bit or 64-bit])
AS_IF([test "x$with_matlab_bits" = "x"],
  [AS_IF([test "x$_matlab_os" != "xwindows"],
     ["$matlab" -e | $GREP -e ARCH= | $SED s/^ARCH=// | $GREP -q 64 2> /dev/null
      AS_IF([test $? -eq 0],
        [AC_MSG_RESULT([64-bit])
         MATLABBITS=64],
        [AC_MSG_RESULT([32-bit])
         MATLABBITS=32])],
     [AS_IF([test -d "$MATLABPATH/win64"],
        [AC_MSG_RESULT([64-bit])
         MATLABBITS=64],
        [AC_MSG_RESULT([32-bit])
         MATLABBITS=32])])],
  [MATLABBITS=$with_matlab_bits
   AC_MSG_RESULT([$with_matlab_bits (forced)])])
AC_SUBST([MATLABBITS])


# Make sure mcc is in $matlab_path (or, in the funny Windows location)
AC_PATH_PROGS([mcc], [mcc], [no], [$matlab_path])
AS_IF([test "x$mcc" = "xno"],
  [AC_PATH_PROGS([mcc], [mcc], [no], [$matlab_path/win$MATLABBITS])
   AS_IF([test "x$mcc" = "xno"],
     [ifelse(["$#"], ["0"], [AC_MSG_ERROR([Unable to find MATLAB MCC compiler])], [$1])])])

MCC="\"$mcc\" $with_matlab_flags"
AC_SUBST([MCC])



# If we're not on Win32, we can check to make sure these parameters
# actually work (and not on Win32 is the only time we need to specify
# complex parameters)
AS_IF([test "x$_matlab_os" != "xwindows"],
  [AC_MSG_CHECKING([whether matlab is properly configured])
   "$MATLAB" -e > /dev/null 2>&1
   AS_IF([test $? -eq 0],
         [AC_MSG_RESULT([yes])],
         [AC_MSG_RESULT([no])
          AC_MSG_ERROR([MATLAB cannot be executed.  Specify a path to it with --with-matlab, and check whether you need to pass any command-line parameters to MATLAB with --with-matlab-flags.])])])
])
