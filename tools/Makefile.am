EXTRA_DIST = docutils rst2latex.py wikir.py \
	authors.xml svn2cl.sh svn2cl.xsl \
	googlecode_upload.py ResHacker.exe

dist-hook:
	rm -f `find $(distdir)/docutils -name *.pyc`

.PHONY: rcsclean
RCSCLEANFILES = Makefile.in Makefile
rcsclean:
	rm -f $(RCSCLEANFILES)
	rm -f `find $(srcdir)/docutils -name *.pyc`

