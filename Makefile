#
# Makefile for MTBindingSim
#
# This is used only for various housekeeping and distribution tasks.
#

SHELL = /bin/sh
SUBDIRS = doc

.PHONY: binary subdirs $(SUBDIRS)

# Do not make the binary unless specifically requested
all: ChangeLog subdirs

SOURCES = \
	src/MTBindingSim.m src/MAP2_binding.m src/MAP2_saturation.m \
	src/MAP_binding.m src/MAP_saturation.m src/competition.m \
	src/cooperativity_binding.m src/cooperativity_saturation.m \
	src/first_order_binding.m src/first_order_saturation.m \
	src/seam_lattice_binding.m src/seam_lattice_saturation.m

binary: $(SOURCES)
	mcc -d build/mcc -m $^


ChangeLog: .svn/entries
	build/svn2cl.sh --linelen=80 --authors=build/authors.xml --reparagraph

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

