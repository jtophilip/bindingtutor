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
AS_IF([test "x$ZIP" != "xno"],
  [AC_MSG_CHECKING([whether zip is Info-ZIP zip])
   AS_IF([$ZIP -h | $GREP -q -e "Info-ZIP"],
     [AC_MSG_RESULT([yes])
      good_zip=yes],
     [AC_MSG_RESULT([no])
      good_zip=no
      ZIP=""])],
  [good_zip=no])
if test "x$good_zip" = "xno" ; then
  ifelse(["$#"], ["0"], [AC_MSG_ERROR([Unable to find a working Info-ZIP zip])], [$1])
fi])
