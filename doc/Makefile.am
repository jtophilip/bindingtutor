# Thanks to Xomp for this Makefile fragment (heavily modified)

#
# Specify the targets
#
if DOCS
all: docs
docs: mtbindingsim.pdf
else
all: 
endif

docs-wiki: $(WIKI_FILES)

DOCS_RST_SOURCE = Introduction.rst OperatingSystem.rst
EXTRA_DIST = $(DOCS_RST_SOURCE) Format.txt docutils-template.inc wiki

#
# Find the files
#
RST_FILES = $(DOCS_RST_SOURCE:%.rst=$(srcdir)/%.rst)

# This substitution for WIKI_FILES will work, we're doing the more complicated substitution
# in the suffix rule down below.
WIKI_FILES = $(DOCS_RST_SOURCE:.rst=.wiki)
TEX_FILES = $(DOCS_RST_SOURCE:.rst=.tex)
MASTER_FILE = $(builddir)/mtbindingsim.tex

#
# Specify what to remove with 'make clean' (note that we don't remove the wiki files)
#
CLEANFILES = *.aux *.dvi *.lof *.log *.lot *.out *.toc $(TEX_FILES) mtbindingsim.pdf

#
# Add our directories to the TeX search path
#
if WINDOWS
  SEPARATOR=";"
else
  SEPARATOR=":"
endif

TEXINPUTS_PATH = "$(srcdir)$(SEPARATOR)$(builddir)$(SEPARATOR)$(srcdir)/wiki/images$(SEPARATOR)"


#
# If any of the .tex files or .bib files is newer than the .pdf, run TeX twice on the
# master file.  If there is an .lof, .lot, or .toc file, run three times.
#
mtbindingsim.pdf: %.pdf: $(TEX_FILES) $(MASTER_FILE)
	@is_newer=NO; \
	for i in $(TEX_FILES) $(MASTER_FILE) ; do \
		if [ $$i = $*.bbl -a ! -f $$i ] ; then continue; fi; \
		if [ ! -f $$i ] ; then \
			echo ERROR: cannot build $@: missing dependency file $$i; \
			exit 1; \
		fi; \
		if [ ! $$i -ot $@ ] ; then \
			is_newer="YES"; \
		fi; \
	done; \
	if [ $$is_newer = "YES" ] ; then \
		(TEXINPUTS="${TEXINPUTS_PATH}"; export TEXINPUTS; $(pdflatex) -halt-on-error -interaction nonstopmode -output-directory $(builddir) $(MASTER_FILE)); \
		(TEXINPUTS="${TEXINPUTS_PATH}"; export TEXINPUTS; $(pdflatex) -halt-on-error -interaction nonstopmode -output-directory $(builddir) $(MASTER_FILE)); \
		if [ -f $*.lof -o -f $*.lot -o -f $*.toc ] ; then \
			(TEXINPUTS="${TEXINPUTS_PATH}"; export TEXINPUTS; $(pdflatex) -halt-on-error -interaction nonstopmode -output-directory $(builddir) $(MASTER_FILE)); \
		fi; \
	fi;


#
# Suffix rules to build various documentation files
#
.rst.wiki:
	(OUTFILE=$(srcdir)/wiki/$*.wiki; export OUTFILE; $(top_srcdir)/tools/wikir.py $< | $(SED) "s|\$$(IMAGES)\(.*\)$$|http://mtbindingsim.googlecode.com/svn/wiki/images\1.png|g" > $$OUTFILE)

.rst.tex: docutils-template.inc
	$(top_srcdir)/tools/rst2latex.py --no-section-numbering --template=$(top_srcdir)/doc/docutils-template.inc $< | $(SED) "s|\$$(IMAGES)/\(.*\)}}$$|\1.png}}|g" > $@



RCSCLEANFILES = Makefile.in

.PHONY: rcsclean
rcsclean:
	rm -f $(RCSCLEANFILES)

