all: cv.ps

view: all
	gv -antialias cv.ps

pdf: cv.ps
	ps2pdf14 cv.ps cv.pdf

cv.ps: cv.dvi
	dvips -tletter -o cv.ps cv.dvi

cv.dvi: cv.tex currvita.sty ref.bib
	latex cv
	./makebib
	latex cv
	latex cv
