dnl @synopsis ACLTX_PACKAGE_LOCATION(FILENAME,VARIABLETOSET)
dnl
dnl Find the file FILENAME in the acces path of texmf and set
dnl VARIABLETOSET to the location or no if not found
dnl
dnl @category LaTeX
dnl @author Boretti Mathieu <boretti@eig.unige.ch>
dnl @version 2006-07-16
dnl @license LGPL

AC_DEFUN([ACLTX_PACKAGE_LOCATION],[
AC_REQUIRE([ACLTX_PROG_KPSEWHICH])
AC_CACHE_CHECK([for location of $1],[ac_cv_latex_location_]translit($1,[-.],[__]),[
[ac_cv_latex_location_]translit($1,[-.],[__])=`$kpsewhich $1`; export [ac_cv_latex_location_]translit($1,[-.],[__]);
if test "[ac_cv_latex_location_]translit($1,[-.],[__])" = "";
then
    [ac_cv_latex_location_]translit($1,[-.],[__])="no"; export [ac_cv_latex_location_]translit($1,[-.],[__]);
fi
echo "$as_me:$LINENO: executing $kpsewhich $1" >&5
])
$2=$[ac_cv_latex_location_]translit($1,[-.],[__]); export $2;
AC_SUBST($2)
])
