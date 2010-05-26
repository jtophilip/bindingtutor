#
# Makefile for MTBindingSim
#
# This is used only for various housekeeping and distribution tasks.
#

SHELL = /bin/sh
SUBDIRS = doc

.PHONY: subdirs $(SUBDIRS)

ChangeLog: .svn/entries
	build/svn2cl.sh --linelen=80 --authors=build/authors.xml --reparagraph

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

