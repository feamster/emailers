# requires gmake

.PRECIOUS: %.dvi

DIRECTORY= discussions/week03

FILES= $(patsubst %.tex,%.ps, $(wildcard *.tex)) \
       $(patsubst %.tex,%.pdf, $(wildcard *.tex)) \
       $(FIGURES)

FIGURES= $(patsubst %.jpg,%.eps, $(wildcard *.jpg))

all: $(FILES)

%.dvi : %.tex;
	texi2dvi $<

%.ps : %.dvi;
	dvips -o -t letter $<

%.pdf : %.ps;
	ps2pdf $<

%.zip: %;
	zip -r $@ $^

check:
	@ for file in $(FILES); \
          do if [ ! -f $$file ]; \
            then echo "The file '$(DIRECTORY)/$$file' is missing!!!"; \
          fi \
        done

clean:
	- rm *.dvi *.ps *.pdf *.log *.out *.eps *.bak *.aux *~ \#* core* \
          *.tgz *.x *.zip

rc: clean
