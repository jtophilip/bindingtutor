# MATLAB Compiler source compilation #
######################################

bin_PROGRAMS = mtbindingsim

# We have to confuse Automake here, or it will choke on the MATLAB m-files.
# It's strange for an entire executable to be built in a single call.  First,
# specify all the M-sources.  We put the fig file in _SOURCES just as a dummy
# call to keep Automake from trying to build "mtbindingsim.c".  We put the 
# M-files in EXTRA_SOURCES, to tell Automake that we're going to deal with
# building those manually.
mtbindingsim_SOURCES = MTBindingSim.fig
EXTRA_mtbindingsim_SOURCES = \
	MTBindingSim.m MAP2_binding.m MAP2_saturation.m \
	MAP_binding.m MAP_saturation.m competition.m \
	cooperativity_binding.m cooperativity_saturation.m \
	first_order_binding.m first_order_saturation.m \
	seam_lattice_binding.m seam_lattice_saturation.m

# Make sure that Automake knows that mtbindingsim depends on the sources
mtbindingsim_DEPENDENCIES = $(EXTRA_mtbindingsim_SOURCES)

# And override how we "link" the mtbindingsim executable, calling out to MCC
mtbindingsim_LINK = (MFILES=""; \
	for i in $(EXTRA_mtbindingsim_SOURCES) ; do \
		MFILES="$$MFILES $(top_srcdir)/src/$$i"; \
	done; \
	export MFILES; \
	$(MCC) -v -d $(builddir) -m $$MFILES)

# Clean up after MCC
CLEANFILES = *.c MTBindingSim.prj MTBindingSim$(EXEEXT) mccExcludedFiles.log readme.txt run_MTBindingsim.sh
clean-local: clean-local-mac64app
.PHONY: clean-local-mac64app
clean-local-mac64app:
	-rm -rf MTBindingSim.app

