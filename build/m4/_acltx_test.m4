dnl @synopsis _ACLTX_TEST(FILEDATA,VARIABLETOSET,[NOCLEAN])
dnl
dnl This macros execute the latex application with FILEDATA as input
dnl and set VARIABLETOSET the yes or no depending of the result if
dnl NOCLEAN is set, the folder used for the test is not delete after
dnl testing
dnl
dnl @category LaTeX
dnl @author Boretti Mathieu boretti@eig.unige.ch
dnl @version 2006-07-16
dnl @license LGPL

AC_DEFUN([_ACLTX_TEST],[
AC_REQUIRE([ACLTX_PROG_LATEX])
rm -rf conftest.dir/.acltx
AS_MKDIR_P([conftest.dir/.acltx])
cd conftest.dir/.acltx
m4_ifval([$2],[$2="no"; export $2;])
cat > conftest.tex << ACLEOF
$1
ACLEOF
cat conftest.tex | $latex 2>&1 1>output m4_ifval([$2],[&& $2=yes])
cd ..
cd ..
sed 's/^/| /' conftest.dir/.acltx/conftest.tex >&5
echo "$as_me:$LINENO: executing cat conftest.tex | $latex" >&5
sed 's/^/| /' conftest.dir/.acltx/output >&5
m4_ifval([$3],,[rm -rf conftest.dir/.acltx])
])
