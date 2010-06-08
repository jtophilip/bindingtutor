# Thanks to Xomp for this Makefile fragment (heavily modified)

#
# Specify the targets
#
all: docs
docs: mtbindingsim.pdf
wiki: $(WIKI_FILES)

RST_FILES = Introduction.rst OperatingSystem.rst
BIB_FILES = 

#
# Find the files
#
WIKI_FILES = $(RST_FILES:.rst=.wiki)
TEX_FILES = $(RST_FILES:.rst=.tex)
MASTER_FILE = $(top_srcdir)/doc/mtbindingsim.tex

mtbindingsim_LATEX = $(TEX_FILES) $(BIB_FILES) $(MASTER_FILE)
mtbindingsim_BBL = mtbindingsim.bbl

#
# Specify what to remove with 'make clean' (note that we don't remove the wiki files)
#
CLEANFILES = *.aux *.bbl *.blg *.dvi *.lof *.log *.lot *.out *.toc $(TEX_FILES) mtbindingsim.pdf

#
# Add our directories to the TeX search path
#
TEXINPUTS_PATH = $(top_srcdir)/doc/latex:$(top_builddir)/doc:$(top_srcdir)/doc/wiki/images:


#
# If any of the .tex files or .bib files is newer than the .pdf, run TeX twice on the
# master file.  If there is an .lof, .lot, or .toc file, run three times.
#
mtbindingsim.pdf: %.pdf: $(mtbindingsim_LATEX) $(mtbindingsim_BBL)
	@is_newer=NO; \
	for i in $(mtbindingsim_LATEX) $(mtbindingsim_BBL) ; do \
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
		(TEXINPUTS="${TEXINPUTS_PATH}"; export TEXINPUTS; pdflatex -halt-on-error -interaction nonstopmode -output-directory $(top_builddir)/doc $(MASTER_FILE)); \
		(TEXINPUTS="${TEXINPUTS_PATH}"; export TEXINPUTS; pdflatex -halt-on-error -interaction nonstopmode -output-directory $(top_builddir)/doc $(MASTER_FILE)); \
		if [ -f $*.lof -o -f $*.lot -o -f $*.toc ] ; then \
			(TEXINPUTS="${TEXINPUTS_PATH}"; export TEXINPUTS; pdflatex -halt-on-error -interaction nonstopmode -output-directory $(top_builddir)/doc $(MASTER_FILE)); \
		fi; \
	fi;

#
# If any of the .bib or .tex files is newer than the .bbl file, run TeX and BibTeX.
#
mtbindingsim.bbl: $(mtbindingsim_LATEX)
	@bbl_filename=$*.bbl; \
	is_newer=NO; \
	has_bib=NO; \
	for i in $(mtbindingsim_LATEX) ; do \
		if [ ! $$i -ot $$bbl_filename ] ; then \
			is_newer="YES"; \
		fi; \
		file_prefix=`echo $$i | $(SED) 's/\.bib$$//'`; \
		if [ -z $$file_prefix ] ; then continue; fi; \
		if [ $$file_prefix != $$i ] ; then \
			has_bib="YES"; \
		fi; \
	done; \
	if [ $$is_newer = "YES" -a $$has_bib = "YES" ] ; then \
		(TEXINPUTS="${TEXINPUTS_PATH}"; export TEXINPUTS; pdflatex -halt-on-error -interaction nonstopmode -output-directory $(top_builddir)/doc $(MASTER_FILE)); \
		(cd $(top_builddir)/doc && bibtex mtbindingsim); \
	fi;

mtbindingsim_LATEX:
	@true

#
# Suffix rules to build various documentation files
#
SUFFIXES = .wiki .tex .pdf .rst .bbl
.rst.wiki:
	(OUTFILE=$(top_srcdir)/doc/wiki/$@; export OUTFILE; $(top_srcdir)/build/wikir.py $< | $(SED) "s|\$$(IMAGES)\(.*\)$$|http://mtbindingsim.googlecode.com/svn/wiki/images\1.png|g" > $$OUTFILE)
.rst.tex:
	$(top_srcdir)/build/rst2latex.py --no-section-numbering --template=$(top_srcdir)/doc/docutils-template.inc $< | $(SED) "s|\$$(IMAGES)/\(.*\)}}$$|\1.png}}|g" > $@

.tex.pdf:
	(TEXINPUTS="${TEXINPUTS_PATH}"; export TEXINPUTS; pdflatex -halt-on-error -interaction nonstopmode -output-directory $(top_builddir)/doc $< $@)
	(TEXINPUTS="${TEXINPUTS_PATH}"; export TEXINPUTS; pdflatex -halt-on-error -interaction nonstopmode -output-directory $(top_builddir)/doc $< $@)
.tex.bbl:
	(TEXINPUTS="${TEXINPUTS_PATH}"; export TEXINPUTS; pdflatex -halt-on-error -interaction nonstopmode -output-directory $(top_builddir)/doc $< $@)
	bibtex $*	
