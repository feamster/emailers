# requires gmake

.PRECIOUS: %.dvi

DIRECTORY= practice-exams

FILES= $(patsubst %.tex,%.ps, $(wildcard *.tex)) \
       $(patsubst %.tex,%.pdf, $(wildcard *.tex))

all: $(FILES)

%.dvi : %.tex;
	texi2dvi $<

%.ps : %.dvi;
	dvips -o -t letter $<

%.pdf : %.ps;
	ps2pdf $<

check:
	@ for file in $(FILES); \
          do if [ ! -f $$file ]; \
            then echo "The file '$(DIRECTORY)/$$file' is missing!!!"; \
          fi \
        done

clean:
	- rm *.dvi *.ps *.pdf *.log *.out *.eps *.bak *.aux *~ \#* core*

rc: clean
