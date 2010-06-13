# Root Automake file for MTBindingSim #
#######################################

ACLOCAL_AMFLAGS = -I build/m4

SUBDIRS = build doc src tools

.PHONY: changes bindist
changes:
	$(srcdir)/tools/svn2cl.sh --linelen=80 --authors=$(srcdir)/tools/authors.xml --reparagraph -o $(srcdir)/ChangeLog

bindist:
	(cd src && $(MAKE) $(AM_MAKEFLAGS) $@) || exit 1

