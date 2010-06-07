#
# Build both wiki and TeX-format documentation
#

all: doc-wiki doc-latex

RST_FILES = $(wildcard *.rst)
WIKI_FILES = $(patsubst %.rst,wiki/%.wiki,$(RST_FILES))
TEX_FILES = $(patsubst %.rst,latex/generated/%.tex,$(RST_FILES))

# Build .wiki from .rst
wiki/%.wiki: %.rst
	../build/wikir.py $< > wiki/$*.wiki
	sed -e "s|\$$(IMAGES)\(.*\)$$|http://mtbindingsim.googlecode.com/svn/wiki/images\1.png|g" wiki/$*.wiki > wiki/$*.tmp
	mv -f wiki/$*.tmp wiki/$*.wiki

# Build TeX from .rst
latex/generated/%.tex: %.rst
	../build/rst2latex.py --no-section-numbering --template=latex/docutils-template.tex $< > latex/generated/$*.tex
	sed -e "s|\$$(IMAGES)/\(.*\)}}$$|\1.png}}|g" latex/generated/$*.tex > latex/generated/$*.tmp
	mv -f latex/generated/$*.tmp latex/generated/$*.tex

# The main TeX file depends on the subchapters
latex/mtbindingsim.tex: $(TEX_FILES)

# And the PDF is built from the main file (add the generated folder as well
# as the images folder to the search path)

DO_TEXINPUTS = TEXINPUTS="latex:latex/generated:wiki/images:"
PDFTEX_OPTIONS = -halt-on-error -interaction nonstopmode -output-directory latex

latex/mtbindingsim.pdf: latex/mtbindingsim.tex
	cd latex
	$(DO_TEXINPUTS) pdflatex $(PDFTEX_OPTIONS) mtbindingsim.tex
	$(DO_TEXINPUTS) pdflatex $(PDFTEX_OPTIONS) mtbindingsim.tex

doc-wiki: $(WIKI_FILES)
doc-latex: latex/mtbindingsim.pdf

clean:
	rm -f latex/*.aux latex/*.log latex/*.toc latex/*.out

distclean:
	rm -f $(WIKI_FILES)
	rm -f $(TEX_FILES)
	rm -f latex/mtbindingsim.pdf

