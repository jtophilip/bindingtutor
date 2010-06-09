dnl @synopsis AC_PROG_PDFLATEX
dnl
dnl This macro find a pdflatex application and set the variable
dnl pdflatex to the name of the application or to no if not found if
dnl ACTION-IF-NOT-FOUND is not specified, configure fail when then
dnl application is not found.
dnl
dnl @category LaTeX
dnl @author Boretti Mathieu <boretti@eig.unige.ch>
dnl @version 2006-07-16
dnl @license LGPL

AC_DEFUN([ACLTX_PROG_PDFLATEX],[
AC_CHECK_PROGS(pdflatex,[pdflatex],no)
if test $pdflatex = "no" ;
then
	ifelse($#,0,[AC_MSG_ERROR([Unable to find the pdflatex application])],
        $1)
fi
])
