REPORT=ngf-vita
LATEX=pdflatex
BIBTEX=bibtex --min-crossrefs=1000
REF1=ref
REF2=rfc

TEX = $(wildcard *.tex)
CLS = $(wildcard *.cls)
SRCS = $(TEX)
REFS=$(REF1).bib $(REF2).bib

all: pdf

pdf: $(SRCS) $(CLS)
	$(LATEX) $(REPORT)
	$(LATEX) $(REPORT)

$(REPORT).ps: $(REPORT).dvi
#	dvips -Pcmz -t letter $(REPORT).dvi -o $(REPORT).ps
	dvips -Ppdf -G0 -t letter $(REPORT).dvi -o $(REPORT).ps



view: $(REPORT).dvi
	xdvi $(REPORT).dvi

print: $(REPORT).dvi
	dvips $(REPORT).dvi

#pdf: $(REPORT).ps
#	ps2pdf14 $< $(REPORT).pdf

printer: $(REPORT).ps
	lpr $(REPORT).ps

tidy:
	rm -f *.dvi *.aux *.log *.blg *.bbl

clean:
	rm -f *~ *.dvi *.aux *.log *.blg *.bbl $(REPORT).pdf
