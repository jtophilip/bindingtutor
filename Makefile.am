# Root Automake file for MTBindingSim #
#######################################

ACLOCAL_AMFLAGS = -I build/m4
SUBDIRS = build doc src tools
.PHONY: changes bindist rcsclean


# Update the ChangeLog
changes:
	$(srcdir)/tools/svn2cl.sh --linelen=80 --authors=$(srcdir)/tools/authors.xml --reparagraph -o $(srcdir)/ChangeLog


# Build the binary distribution (only in src)
if BINDIST
bindist:
	(cd src && $(MAKE) $(AM_MAKEFLAGS) $@) || exit 1
else
bindist:
	@echo "Cannot build binary distribution, the 'zip' utility cannot be found."
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

