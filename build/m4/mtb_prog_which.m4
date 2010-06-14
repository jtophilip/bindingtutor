dnl @synopsis MTB_PROG_WHICH([ACTION-IF-NOT-FOUND])
dnl
dnl This macro finds which, setting the variable WHICH to
dnl the name of the application or to no if not found.
dnl Executes ACTION-IF-NOT-FOUND if not found if specified,
dnl otherwise fails with an error.
dnl
dnl @category Miscellaneous
dnl @author Charles Pence <charles@charlespence.net>
dnl @version 2010-06-13
dnl @license LGPL

AC_DEFUN([MTB_PROG_WHICH],[
AC_ARG_VAR([WHICH],[which command])
AC_CHECK_PROGS([WHICH],[which],[no])
AS_IF([test "x$WHICH" = "x"],
  [ifelse(["$#"], ["0"], [AC_MSG_ERROR([Unable to find which])], [$1])])])
