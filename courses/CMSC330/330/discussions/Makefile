# requires gmake

.PRECIOUS: %.dvi

DIRECTORY= discussions

DIRECTORIES= $(wildcard week??)

FILES= $(patsubst %.tex,%.ps, $(wildcard *.tex)) \
       $(patsubst %.tex,%.pdf, $(wildcard *.tex))

all: $(FILES)
	for directory in $(DIRECTORIES); do make -C $$directory all; done

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
