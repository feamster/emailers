.SUFFIXES = .fig .eps	

TEX = $(wildcard *.tex)
PS = $(subst .tex,.ps,$(TEX))
PDF = $(subst .tex,.pdf,$(TEX))

all: $(PS)
pdf: $(PDF)

%.dvi: %.tex 
	latex $<

%.ps: %.dvi
	dvips $< -o $@

%.pdf: %.ps
	ps2pdf $< $@

clean:
	rm -f *.dvi *.log *.aux *.ps
