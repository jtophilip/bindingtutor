# Root Automake file for MTBindingSim #
#######################################

ACLOCAL_AMFLAGS = -I build/m4

SUBDIRS = build doc src tools

.PHONY: changes bindist
changes:
	$(srcdir)/tools/svn2cl.sh --linelen=80 --authors=$(srcdir)/tools/authors.xml --reparagraph -o $(srcdir)/ChangeLog

if BINDIST
bindist:
	(cd src && $(MAKE) $(AM_MAKEFLAGS) $@) || exit 1
else
bindist:
	@echo "Cannot build binary distribution, the 'zip' utility cannot be found."
endif
