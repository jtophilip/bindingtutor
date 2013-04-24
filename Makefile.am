# Root Automake file for MTBindingSim #
#######################################

ACLOCAL_AMFLAGS = -I build/m4
SUBDIRS = build doc src tools
.PHONY: changes dmg rcsclean


# Install the docs here to $(docdir)
doc_DATA = AUTHORS COPYING ChangeLog INSTALL NEWS README THANKS


# Update the ChangeLog
changes:
	$(srcdir)/tools/gitlog-to-changelog --since=2013-01-01 > $(srcdir)/ChangeLog


# Build the Mac DMG file (only in src, only on Mac)
if MACBUNDLE
if DOCS
dmg:
	(cd doc && $(MAKE) mtbindingsim.pdf) || exit 1
	(cd src && $(MAKE) $(AM_MAKEFLAGS) $@) || exit 1
else
dmg:
	@echo "Cannot build binary distribution, TeX is required to build the PDF documentation."
endif
endif


# There's no way to fool Automake, we just have to do make rcsclean
# manually.  Any way to try to hook into "maintainer-clean", say,
# just causes "missing" to rebuild all the files we just deleted.

RCSCLEANFILES = configure Makefile Makefile.in config.status config.cache config.log \
  configure.lineno config.status.lineno Makefile
rcsclean: clean
	for dir in $(SUBDIRS) ; do \
	  (cd $$dir && $(MAKE) $(AM_MAKEFLAGS) $@) || exit 1; \
	done
	rm -f $(RCSCLEANFILES)
	rm -rf autom4te.cache


# Don't put .svn directories in the distribution file
dist-hook:
	rm -rf `find $(distdir)/ -type d -name .svn`

