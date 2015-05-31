TEX = $(wildcard *.tex)
CLS = $(wildcard *.cls)
SRCS = $(TEX) $(CLS)
WEB-INT = kendall.gtnoise.net:public_html/cv-internal
RPTDIR = gaia.cc.gatech.edu:www/rpt

PAPER1 = papers-annotated/snare:usenix09.pdf
PAPER2 = papers-annotated/wise:sigcomm2008.pdf
PAPER3 = papers-annotated/switchblade:sigcomm10.pdf
PAPERS = $(PAPER1) $(PAPER2) $(PAPER3)

PACKAGE-ZIP = feamster-rpt-06142010.zip
PACKAGE = feamster-rpt-06142010.pdf
CV = CV.pdf
RESEARCH = research-rpt.pdf
TEACHING = teaching-rpt.pdf
LETTERS = letter-writers.pdf
PUBS = publications.pdf

all: pdf

view: all
	gv -antialias cv.ps

#pdf: cv.ps
#	ps2pdf14 cv.ps cv.pdf

#cv.pdf: cv.ps
#	ps2pdf14 cv.ps

#cv.ps: cv.dvi
#	dvips -G0 -Ppdf -tletter -o cv.ps cv.dvi

nobib:
	pdflatex cv
	pdflatex cv

pdf: $(SRCS) ref.bib
	pdflatex cv
	./makebib
	pdflatex cv
	pdflatex cv

package: pdf split
	pdftk cv.pdf $(PAPERS)  output $(PACKAGE)
	zip -r $(PACKAGE-ZIP) $(PACKAGE) $(CV) $(RESEARCH) $(TEACHING) $(LETTERS) $(PUBS) $(PAPERS)

package-web: package
	scp $(PACKAGE) $(PACKAGE-ZIP) $(CV) $(RESEARCH) $(TEACHING) $(LETTERS) $(PUBS) $(RPTDIR)
	scp $(PAPERS) $(RPTDIR)/papers

split: pdf
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dFirstPage=1 -dLastPage=36 -sOUTPUTFILE=$(CV) cv.pdf
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dFirstPage=37 -dLastPage=37 -sOUTPUTFILE=$(TEACHING) cv.pdf
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dFirstPage=38 -dLastPage=43 -sOUTPUTFILE=$(RESEARCH) cv.pdf
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dFirstPage=44 -dLastPage=44 -sOUTPUTFILE=$(LETTERS) cv.pdf
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dFirstPage=45 -dLastPage=45 -sOUTPUTFILE=$(PUBS) cv.pdf
#	pdftk cv.pdf cat 1-36 output $(CV)
#	pdftk cv.pdf cat 37 output $(TEACHING)
#	pdftk cv.pdf cat 38-43 output $(RESEARCH)
#	pdftk cv.pdf cat 44 output $(LETTERS)
#	pdftk cv.pdf cat 45 output $(PUBS)

web: split
	scp CV.pdf teaching.pdf research.pdf $(WEB-INT)

clean:
	rm -f *.aux *.blg *.bbl *.log *~ cv.ps cv.pdf *.dvi
