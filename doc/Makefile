#
# Build both wiki and TeX-format documentation
#

RST_FILES = $(wildcard *.rst)
WIKI_FILES = $(patsubst %.rst,wiki/%.wiki,$(RST_FILES))

# Build .wiki from .rst
wiki/%.wiki: %.rst
	../build/wikir.py $< > wiki/$*.wiki

doc-wiki: $(WIKI_FILES)

all: doc-wiki
