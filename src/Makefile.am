# MATLAB Compiler source compilation #
######################################

# Make sure to build the binary
all: MTBindingSim.prj
.PHONY: dmg rcsclean clean-local-mac64app


# Indicate that we're going to install the binary (with a slight hack).  Note that
# on Mac64, we have an .app bundle, which we won't install anywhere automatically.
if MACBUNDLE
install-exec-hook:
	@echo ==================================================
	@echo Mac OS X application bundle is prepared at:
	@echo $(abs_builddir)/BindingTutor
	@echo
	@echo To run BindingTutor, double-click this application
	@echo bundle, or copy it to your Applications folder.
	@echo ==================================================
else
  EXTRA_SCRIPTS = BindingTutor BindingTutor.exe
  bin_SCRIPTS = @PROG_NAME@
endif


# Again, fool Automake by putting in dummy compilation instructions for the things
# that might be in bin_SCRIPTS
BindingTutor: MTBindingSim.prj
BindingTutor.exe: MTBindingSim.prj
AM_INSTALLCHECK_STD_OPTIONS_EXEMPT = $(EXTRA_SCRIPTS)


# Get the list of source files we need
MTBindingSim_MATLAB = \
	MTBindingSim.m \
	MAP2_binding.m MAP2_saturation.m \
	MAP_binding.m MAP_saturation.m \
	competition.m \
	dimer_binding.m dimer_saturation.m \
	first_order_binding.m first_order_saturation.m \
	pseudocooperativity_binding.m pseudocooperativity_saturation.m \
	seam_lattice_binding.m seam_lattice_saturation.m \
	sites_binding.m sites_saturation.m
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
	$(MCC) $(MATLABFLAGS) -v -d $(builddir) -m $$MFILES)
	if test -d $(builddir)/MTBindingSim.app ; then \
		chmod 644 $(builddir)/MTBindingSim.app/Contents/Resources/membrane.icns; \
		cp $(top_srcdir)/doc/wiki/images/icon/icon.icns $(builddir)/MTBindingSim.app/Contents/Resources/membrane.icns; \
		mv MTBindingSim.app BindingTutor.app \
	fi
	if test -e $(builddir)/MTBindingSim.exe ; then \
		cp $(top_srcdir)/doc/wiki/images/icon/icon.ico $(builddir)/out.ico; \
		$(top_srcdir)/tools/ResHacker.exe -add MTBindingSim.exe, out.exe, out.ico, ICONGROUP, AAA,; \
		if test -e $(builddir)/out.exe ; then \
			mv -f $(builddir)/out.exe $(builddir)/MTBindingSim.exe; \
		fi; \
		rm -f out.exe out.ico; \
		mv MTBindingSim.exe BindingTutor.exe \
	fi

# Clean up after MCC
CLEANFILES = *.c MTBindingSim.prj BindingTutor BindingTutor.exe mccExcludedFiles.log readme.txt run_MTBindingSim.sh
clean-local: clean-local-mac64app
clean-local-mac64app:
	-rm -rf BindingTutor.app

RCSCLEANFILES = Makefile.in Makefile
rcsclean:
	rm -f $(RCSCLEANFILES)


# Include everything in the source distribution
EXTRA_DIST = $(MTBindingSim_MATLAB) $(MTBindingSim_FIG)


# Make a DMG file on Mac OS X
if MACBUNDLE

DMG_NAME=@PACKAGE_TARNAME@-@PACKAGE_VERSION@.dmg

TEMPLATE_DMG_SRC=@top_srcdir@/build/dmg/template.dmg.bz2

WC_DMG=@builddir@/wc.dmg
WC_DIR=@builddir@/wc

DMG_DOCUMENTATION_FILES=@top_builddir@/doc/bindingtutor.pdf @top_srcdir@/AUTHORS @top_srcdir@/COPYING @top_srcdir@/ChangeLog @top_srcdir@/ChangeLog-2012 @top_srcdir@/ChangeLog-2011 @top_srcdir@/ChangeLog-2010 @top_srcdir@/NEWS @top_srcdir@/THANKS

$(WC_DMG): $(TEMPLATE_DMG_SRC)
	bzcat $< > $@

$(DMG_NAME): MTBindingSim.prj $(WC_DMG)
	mkdir -p $(WC_DIR)
	hdiutil attach "$(WC_DMG)" -noautoopen -quiet -mountpoint "$(WC_DIR)"
	ditto @builddir@/BindingTutor.app "$(WC_DIR)/BindingTutor.app"
	cp @top_srcdir@/README $(WC_DIR)
	for i in $(DMG_DOCUMENTATION_FILES); do \
		cp "$$i" "$(WC_DIR)/Documentation/"; \
	done
	WC_DEV=`hdiutil info | grep "$(WC_DIR)" | grep "Apple_HFS" | awk '{print $$1}'` && \
	hdiutil detach $$WC_DEV -quiet -force
	rm -f "$(DMG_NAME)"
	hdiutil convert "$(WC_DMG)" -quiet -format UDZO -imagekey zlib-level=9 -o "$@"
	rm -rf $(WC_DIR)
	rm $(WC_DMG)


dmg: $(DMG_NAME)
	mv $(DMG_NAME) @top_builddir@
	@echo ==================================================
	@echo @PACKAGE_TARNAME@-@PACKAGE_VERSION@ installer ready for distribution:
	@echo $(DMG_NAME)
	@echo ==================================================

endif
