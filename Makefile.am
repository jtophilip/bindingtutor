# Root Automake file for MTBindingSim #
#######################################

SUBDIRS = build doc src tools

.PHONY: changes
changes:
	$(srcdir)/tools/svn2cl.sh --linelen=80 --authors=$(srcdir)/tools/authors.xml --reparagraph -o $(srcdir)/ChangeLog

