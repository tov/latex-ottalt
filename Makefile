PDFLATEX	= pdflatex
LATEX		= latex
MAKEINDEX	= makeindex

PKG		= ottalt

all: $(PKG).sty $(PKG).pdf

FROM_DTX = $(PKG).sty $(PKG).ott Makefile.sample.pre listproc.sty

$(FROM_DTX): $(PKG).ins $(PKG).dtx
	$(RM) $(FROM_DTX)
	$(LATEX) $<

Makefile.sample: Makefile.sample.pre
	sed 's/^ //;s/        /	/g' $< > $@

$(PKG).pdf $(PKG).idx $(PKG).glo: $(PKG).ott.tex

$(PKG).pdf: $(PKG).sty $(PKG).ind $(PKG).gls
%.pdf:	%.dtx
	$(LATEX) $<
	$(PDFLATEX) $<

%.idx %.glo: %.dtx %.sty
	$(LATEX) $<

%.ind:	%.idx
	$(MAKEINDEX) -s gind.ist $<

%.gls:	%.glo
	$(MAKEINDEX) -s gglo.ist -o $@ $<

CLEAN = $(PKG).ind $(PKG).idx \
	$(PKG).gls $(PKG).glo $(PKG).aux $(PKG).log \
	$(PKG).out $(PKG).dvi $(PKG).ilg $(PKG).hd \
	$(PKG).toc Makefile.sample.pre $(PKG).ottdump

VCLEAN = $(CLEAN) $(PKG).pdf $(PKG).sty listproc.sty \
	 Makefile.sample $(PKG).ott $(PKG).ott.tex

clean:
	$(RM) $(CLEAN)

vclean:
	$(RM) $(VCLEAN)

.PRECIOUS: $(PKG).ottdump

include Makefile.sample
