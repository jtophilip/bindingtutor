# MATLAB Compiler source compilation #
######################################

# Make sure to build the binary
all: MTBindingSim.prj
.PHONY: bindist rcsclean clean-local-mac64app


# Indicate that we're going to install the binary (with a slight hack).  Note that
# on Mac64, we have an .app bundle, which we won't install anywhere automatically.
if MACBUNDLE
install-exec-hook:
	@echo ==================================================
	@echo Mac OS X application bundle is prepared at:
	@echo $(abs_builddir)/MTBindingSim
	@echo
	@echo To run MTBindingSim, double-click this application
	@echo bundle, or copy it to your Applications folder.
	@echo ==================================================
else
  EXTRA_SCRIPTS = MTBindingSim MTBindingSim.exe
  bin_SCRIPTS = @PROG_NAME@
endif


# Again, fool Automake by putting in dummy compilation instructions for the things
# that might be in bin_SCRIPTS
MTBindingSim: MTBindingSim.prj
MTBindingSim.exe: MTBindingSim.prj
AM_INSTALLCHECK_STD_OPTIONS_EXEMPT = $(EXTRA_SCRIPTS)


# Get the list of source files we need
MTBindingSim_MATLAB = \
	MTBindingSim.m \
	MAP2_binding.m MAP2_saturation.m \
	MAP_binding.m MAP_saturation.m \
	competition.m \
	cooperativity_binding.m cooperativity_saturation.m \
	dimer_binding.m dimer_saturation.m \
	first_order_binding.m first_order_saturation.m \
	seam_lattice_binding.m seam_lattice_saturation.m
MTBindingSim_FIG = MTBindingSim.fig

# Build using MCC.  We fake out the automatic build by making it think we're building
# the .prj file, which is an intermediate file produced by MCC.  Copy the icon file
# into the bundle on OS X (which MATLAB chmod's to unwriteable by default).
MTBindingSim.prj: $(MTBindingSim_MATLAB) $(MTBindingSim_FIG)
	(MFILES=""; \
	for i in $(MTBindingSim_MATLAB) ; do \
		MFILES="$$MFILES $(top_srcdir)/src/$$i"; \
	done; \
	export MFILES; \
	PATH="$$PATH:$(MATLABPATH)" $(MCC) $(MATLABFLAGS) -v -d $(builddir) -m $$MFILES)
	if test -d $(builddir)/MTBindingSim.app ; then \
		chmod 644 $(builddir)/MTBindingSim.app/Contents/Resources/membrane.icns; \
		cp $(top_srcdir)/doc/wiki/images/icon/icon.icns $(builddir)/MTBindingSim.app/Contents/Resources/membrane.icns; \
	fi
	if test -e $(builddir)/MTBindingSim.exe ; then \
		cp $(top_srcdir)/doc/wiki/images/icon/icon.ico $(builddir)/out.ico; \
		$(top_srcdir)/tools/ResHacker.exe -add MTBindingSim.exe, out.exe, out.ico, ICONGROUP, AAA,; \
		if test -e $(builddir)/out.exe ; then \
			mv -f $(builddir)/out.exe $(builddir)/MTBindingSim.exe; \
		fi; \
		rm -f out.exe out.ico; \
	fi

# Clean up after MCC
CLEANFILES = *.c MTBindingSim.prj MTBindingSim MTBindingSim.exe mccExcludedFiles.log readme.txt run_MTBindingsim.sh
clean-local: clean-local-mac64app
clean-local-mac64app:
	-rm -rf MTBindingSim.app

RCSCLEANFILES = Makefile.in Makefile
rcsclean:
	rm -f $(RCSCLEANFILES)


# Include everything in the source distribution
EXTRA_DIST = $(MTBindingSim_MATLAB) $(MTBindingSim_FIG)


# Figure out the name of the binary distribution
if WINDOWS
  PLATFORM_NAME=win
else !WINDOWS
if MAC
  PLATFORM_NAME=mac
else !MAC
  PLATFORM_NAME=linux
endif
endif

if THIRTYTWO
  BITS_NAME=
else
  BITS_NAME=64
endif

BINARY_NAME=@PACKAGE_TARNAME@-@PACKAGE_VERSION@-$(PLATFORM_NAME)$(BITS_NAME)-bin


# Figure out the contents of the binary distribution
ALL_BINARY_FILES=@top_srcdir@/AUTHORS @top_srcdir@/COPYING @top_srcdir@/ChangeLog @top_srcdir@/NEWS @top_srcdir@/README @top_srcdir@/THANKS

if WINDOWS
  PLATFORM_BINARY_FILES=@builddir@/MTBindingSim.exe
else !WINDOWS

if MAC
if SIXTYFOUR
  PLATFORM_BINARY_FILES=@builddir@/MTBindingSim.app
else !SIXTYFOUR
  PLATFORM_BINARY_FILES=@builddir@/MTBindingSim @builddir@/run_MTBindingSim.sh
endif

else !MAC
  PLATFORM_BINARY_FILES=@builddir@/MTBindingSim @builddir@/run_MTBindingSim.sh
endif
endif

BINARY_FILES=$(ALL_BINARY_FILES) $(PLATFORM_BINARY_FILES)


# And, make the binary package
bindist: MTBindingSim.prj
	$(MKDIR_P) @builddir@/$(BINARY_NAME)
	test ! -d @builddir@/MTBindingSim.app || find @builddir@/MTBindingSim.app -exec chmod u+rwx "{}" \;
	cp -fR @top_builddir@/doc/mtbindingsim.pdf @builddir@/$(BINARY_NAME)/ || exit 1
	cp -fR $(BINARY_FILES) @builddir@/$(BINARY_NAME)/ || exit 1
	$(ZIP) -r $(BINARY_NAME).zip $(BINARY_NAME)
	rm -rf $(BINARY_NAME)/
	mv $(BINARY_NAME).zip @top_builddir@
	@echo ==================================================
	@echo @PACKAGE_TARNAME@-@PACKAGE_VERSION@ binary ready for distribution:
	@echo $(BINARY_NAME).zip
	@echo ==================================================


