#
# Makefile for MTBindingSim
#
# This is used only for various housekeeping and distribution tasks.
#

SHELL = /bin/sh
.PHONY: ChangeLog binary

SOURCES = \
	src/MTBindingSim.m src/MTBindingSim.fig src/MAP2_binding.m src/MAP2_saturation.m \
	src/MAP_bind.m src/competition.m src/cooperativity.m src/first_order.m \
	src/seam_lattice.m

ChangeLog:
	touch ChangeLog
	build/svn2cl.sh --linelen=80 --authors=build/authors.xml --reparagraph

binary: $(SOURCES)
	mcc -d build/mcc -m $^

