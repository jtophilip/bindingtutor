dnl @synopsis ACLTX_CLASS(CLASSNAME,VARIABLETOSET[,ACTION-IF-FOUND[,ACTION-IF-NOT-FOUND]])
dnl
dnl This macros test is class CLASSNAME exists and work and set
dnl VARIABLETOSET to yes or no If ACTION-IF-FOUND (and
dnl ACTION-IF-NOT-FOUND) are set, do the correct action
dnl
dnl @category LaTeX
dnl @author Boretti Mathieu <boretti@eig.unige.ch>
dnl @version 2006-07-16
dnl @license LGPL

AC_DEFUN([ACLTX_CLASS],[
ACLTX_PACKAGE_LOCATION($1.cls,$2_location)
if test "[$]$2_location" = "no" ; then
    AC_MSG_WARN([Unable to locate the $1.cls file])
    [ac_cv_latex_class_]translit($1,[-],[_])="no";
else
AC_CACHE_CHECK([for usability of class $1],[ac_cv_latex_class_]translit($1,[-],[_]),[
_ACLTX_TEST([\documentclass{$1}
\begin{document}
\end{document}],[ac_cv_latex_class_]translit($1,[-],[_]))
])
fi
$2=$[ac_cv_latex_class_]translit($1,[-],[_]) ; export $2;
AC_SUBST($2)
ifelse($#,2,[],$#,3,[
    if test "[$]$2" = "yes" ;
    then
        $3
    fi
],$#,4,[
    ifelse($3,[],[
        if test "[$]$2" = "no" ;
        then
            $4
        fi
    ],[
        if test "[$]$2" = "yes" ;
        then
            $3
        else
            $4
        fi
    ])
])

])
