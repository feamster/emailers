all: cv.pdf

cv.pdf: cv.tex currvita.sty ref.bib
	pdflatex cv
	./makebib
	pdflatex cv
	pdflatex cv

clean:
	rm -f *.aux *.blg *.bbl *.log *~ cv.ps cv.pdf *.dvi
