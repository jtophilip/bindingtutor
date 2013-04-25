# Thanks to Xomp for this Makefile fragment (heavily modified)

#
# Specify the targets
#
if DOCS
all: docs
docs: bindingtutor.pdf
else
all: 
endif

DOCS_MARKDOWN_SOURCE = \
	Acknowledgments.md BindingModels.md ChangeLog.md ContactUs.md \
	GettingStarted.md HowTo.md RunningBindingTutor.md Troubleshooting.md

EXTRA_DIST = $(DOCS_MARKDOWN_SOURCE) COPYING Introduction.md Introduction.tex \
	FilingATicket.md _Sidebar.md images 

#
# Find the files
#
MARKDOWN_FILES = $(DOCS_MARKDOWN_SOURCE:%.md=$(srcdir)/%.md)

BUILT_TEX_FILES = $(DOCS_MARKDOWN_SOURCE:.md=.tex)
TEX_FILES = $(BUILT_TEX_FILES)
MASTER_FILE = $(builddir)/bindingtutor.tex

#
# Specify what to remove with 'make clean' (note that we don't remove the wiki files)
#
CLEANFILES = *.aux *.dvi *.lof *.log *.lot *.out *.toc $(BUILT_TEX_FILES) bindingtutor.pdf

#
# Add our directories to the TeX search path
#
if WINDOWS
  SEPARATOR=";"
else
  SEPARATOR=":"
endif

TEXINPUTS_PATH = "$(srcdir)$(SEPARATOR)$(builddir)$(SEPARATOR)$(srcdir)/images$(SEPARATOR)"


#
# If any of the .tex files or .bib files is newer than the .pdf, run TeX twice on the
# master file.  If there is an .lof, .lot, or .toc file, run three times.
#
bindingtutor.pdf: %.pdf: $(TEX_FILES) $(MASTER_FILE)
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
.md.tex:
	$(PANDOC) -f markdown -t latex --chapters --no-wrap $< | $(SED) "s|itemize|compactitem|g" | $(SED) "s|enumerate|compactenum|g" | $(SED) 's|\$${IMAGES}/\(.*\)}\\{.*\\}$$|\1}|g' | $(SED) 's|href{\\\$$\\{DOCS\\}:\([^}]*\)}{\([^}]*\)}|hyperref[chapter:\1]{\2}|g' | $(SED) "s|\(\\\\chapter{.*}\)|\1\\\\label{chapter:$*}|" > $@


#
# Install the documentation if we built it
#
if DOCS
doc_DATA = bindingtutor.pdf
endif


#
# Clean up after ourselves
#
RCSCLEANFILES = Makefile.in Makefile bindingtutor.tex

.PHONY: rcsclean
rcsclean:
	rm -f $(RCSCLEANFILES)

