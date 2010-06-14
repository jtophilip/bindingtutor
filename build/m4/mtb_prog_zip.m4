dnl @synopsis MTB_PROG_ZIP([ACTION-IF-NOT-FOUND])
dnl
dnl This macro locates a 'zip' binary, and sets the variable ZIP
dnl to its location if found.  Execute ACTION-IF-NOT-FOUND
dnl if not found, otherwise fail with an error.  If found, the binary
dnl is confirmed to be an Info-ZIP 'zip' binary.
dnl
dnl @category Miscellaneous
dnl @author Charles Pence <charles@charlespence.net>
dnl @version 2010-06-13
dnl @license LGPL

AC_DEFUN([MTB_PROG_ZIP],[
AC_CHECK_PROGS([ZIP], [zip], [no])
AC_ARG_VAR([ZIP],[zip command])
if test "x$ZIP" != "xno" ; then
  AC_MSG_CHECKING([whether zip is Info-ZIP zip])
  if $ZIP -h | $GREP -q -e "Info-ZIP" ; then
    AC_MSG_RESULT([yes])
    good_zip=yes
  else
    AC_MSG_RESULT([no])
    good_zip=no
    ZIP=""
  fi
else
  good_zip=no
fi
if test "x$good_zip" = "xno" ; then
  if test $# -eq 0 ; then
    AC_MSG_ERROR([Unable to find a working Info-ZIP zip])
  else
    $1
  fi
fi])
