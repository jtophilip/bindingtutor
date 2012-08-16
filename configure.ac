###############################################################################
# Autoconf and Automake
###############################################################################
AC_INIT([MTBindingSim], [0.13], [jphilip@nd.edu], [mtbindingsim], [http://code.google.com/p/mtbindingsim/])
AC_PREREQ([2.61])

AC_CONFIG_SRCDIR([src/MTBindingSim.m])
AC_CONFIG_AUX_DIR([build/aux])
AC_CONFIG_MACRO_DIR([build/m4])

AM_INIT_AUTOMAKE([1.8.3 -Wall -Werror gnits no-dependencies no-exeext dist-zip])


###############################################################################
# Build System
###############################################################################

# Prevent cross-compilation, because MCC doesn't support it
AC_CANONICAL_BUILD
AC_CANONICAL_HOST

AC_MSG_CHECKING([whether we are cross-compiling])
if test "$build" != "$host" ; then
  AC_MSG_RESULT([yes])
  AC_MSG_ERROR([BUILD and HOST systems differ: the MATLAB Compiler does not support cross-compilation])
else
  AC_MSG_RESULT([no])
fi

# Define conditionals for our build platforms
AS_CASE([$host_os],
  [*mingw32*], [os="windows"],
  [*cygwin*],  [os="windows"],
  [*darwin*],  [os="mac"],
               [os="unix"])

AM_CONDITIONAL([WINDOWS], [test "x$os" = "xwindows"])
AM_CONDITIONAL([MAC], [test "x$os" = "xmac"])

AC_MSG_CHECKING([for build system type])
AC_MSG_RESULT([$os])


###############################################################################
# Standard system utilities
###############################################################################

AC_PROG_LN_S
AC_PROG_MKDIR_P
AC_PROG_SED
AC_PROG_GREP
AM_PATH_PYTHON(,, [:])

# The following just silences an Autoconf warning.  You need not have an
# Objective-C compiler to build MTBindingSim.
AC_PROG_OBJC


###############################################################################
# Compiling and binary distribution
###############################################################################

# Look for MATLAB, MCC, etc.
MTB_PROG_MATLAB
AM_CONDITIONAL([THIRTYTWO], [test "x$MATLABBITS" != "x64"])
AM_CONDITIONAL([SIXTYFOUR], [test "x$MATLABBITS" = "x64"])

# We have to set the binary name here, not out in Makefile.am, or the
# substitutions don't work right.
AS_IF([test "x$os" = "xwindows"],
  [PROG_NAME="MTBindingSim.exe"],
  [AS_IF([test "x$os" = "xmac" -a "x$MATLABBITS" = "x64"],
     [PROG_NAME="MTBindingSim.app"],
     [PROG_NAME="MTBindingSim"])])
AC_SUBST([PROG_NAME])

# Also, mark here if we're making an application bundle (on OS X 64-bit),
# because it acts much differently in the installation phase
AM_CONDITIONAL([MACBUNDLE], [test "x$os" = "xmac" -a "x$MATLABBITS" = "x64"])


###############################################################################
# Documentation
###############################################################################

# Determine if we can build the documentation
ACLTX_PROG_PDFLATEX([have_pdflatex="no"])
ACLTX_PROG_KPSEWHICH([have_kpsewhich="no"])
if [ test "x$have_kpsewhich" != "xno" ] ; then
  ACLTX_CLASS([book],[have_book])
  ACLTX_PACKAGE([inputenc],[book],[have_inputenc])
  ACLTX_PACKAGE([mathpazo],[book],[have_mathpazo])
  ACLTX_PACKAGE([hyperref],[book],[have_hyperref])
fi
AC_CHECK_PROGS([PANDOC],[pandoc],[have_pandoc="no"])
AM_CONDITIONAL([DOCS],
  [test "x$have_pdflatex" != "xno" -a "x$have_kpsewhich" != "xno" -a \
        "x$have_book" = "xyes" -a \
        "x$have_inputenc" = "xyes" -a "x$have_mathpazo" = "xyes" -a \
        "x$have_hyperref" = "xyes" -a \
        "x$have_pandoc" = "xyes" -a \
        "x$PYTHON" != "x:"])


###############################################################################
# Output
###############################################################################

AC_CONFIG_FILES([
  Makefile
    build/Makefile
      build/MTBindingSim.nsi
    doc/Makefile
      doc/mtbindingsim.tex
    src/Makefile
    tools/Makefile
])
AC_OUTPUT
