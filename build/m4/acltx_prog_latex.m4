dnl @synopsis ACLTX_PROG_LATEX([ACTION-IF-NOT-FOUND])
dnl
dnl This macro find a latex application and set the variable latex to
dnl the name of the application or to no if not found if
dnl ACTION-IF-NOT-FOUND is not specified, configure fail when then
dnl application is not found.
dnl
dnl It is possible to set manually the program to use using latex=...
dnl
dnl @category LaTeX
dnl @author Boretti Mathieu <boretti@eig.unige.ch>
dnl @version 2006-07-16
dnl @license LGPL

AC_DEFUN([ACLTX_PROG_LATEX],[
AC_ARG_VAR(latex,[specify default latex application])
if test "$ac_cv_env_latex_set" = "set" ; then
    AC_MSG_CHECKING([Checking for latex])
    latex="$ac_cv_env_latex_value";
    AC_MSG_RESULT([$latex (from parameter)])
else
    AC_CHECK_PROGS(latex,[latex elatex lambda],no)
fi
if test $latex = "no" ;
then
	ifelse($#,0,[AC_MSG_ERROR([Unable to find the latex application])],
        $1)
fi])
