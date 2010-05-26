#
# Makefile for MTBindingSim
#
# This is used only for various housekeeping and distribution tasks.
#

SHELL = /bin/sh
.PHONY: ChangeLog

ChangeLog:
	touch ChangeLog
	build/svn2cl.sh --linelen=80 --authors=build/authors.xml --reparagraph

