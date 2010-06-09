# MATLAB Compiler source compilation #
######################################

# Make sure to build the binary
all: MTBindingSim.prj


# Get the list of source files we need
MTBindingSim_MATLAB = \
	MTBindingSim.m MAP2_binding.m MAP2_saturation.m \
	MAP_binding.m MAP_saturation.m competition.m \
	cooperativity_binding.m cooperativity_saturation.m \
	first_order_binding.m first_order_saturation.m \
	seam_lattice_binding.m seam_lattice_saturation.m
MTBindingSim_FIG = MTBindingSim.fig

# Build using MCC.  We fake out the automatic build by making it think we're building
# the .prj file, which is an intermediate file produced by MCC.
MTBindingSim.prj: $(MTBindingSim_MATLAB) $(MTBindingSim_FIG)
	(MFILES=""; \
	for i in $(MTBindingSim_MATLAB) ; do \
		MFILES="$$MFILES $(top_srcdir)/src/$$i"; \
	done; \
	export MFILES; \
	$(MCC) -v -d $(builddir) -m $$MFILES)

# Clean up after MCC
CLEANFILES = *.c MTBindingSim.prj MTBindingSim MTBindingSim.exe mccExcludedFiles.log readme.txt run_MTBindingsim.sh
clean-local: clean-local-mac64app
.PHONY: clean-local-mac64app
clean-local-mac64app:
	-rm -rf MTBindingSim.app

