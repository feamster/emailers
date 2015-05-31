# requires gmake

# It's more convenient for me to use makefiles to build Latex documents-
# since I use pstricks for some figures, and pstricks doesn't work with
# pdflatex, I use latex -> dvips -> ps2pdf (actually I use texi2dvi to run
# Latex).  Just "make" is easier....

DIRECTORIES= discussions exam1 final handouts lectures misc proj1 proj2	\
             proj3 proj4 proj5 proj6 quizzes

all:
	for directory in $(DIRECTORIES); do make -C $$directory all; done

check:
	@ for directory in $(DIRECTORIES); \
          do make -s -C $$directory check; \
        done

clean:
	- rm *.dvi *.ps *.pdf *.log *.out *.eps *.bak *.aux *~ \#* core* *.x
	for directory in $(DIRECTORIES); do make -C $$directory clean; done

rc:
	for directory in $(DIRECTORIES); do make -C $$directory rc; done
