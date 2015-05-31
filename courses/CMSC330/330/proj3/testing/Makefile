# this shouldn't do anything since nothing needs to be compiled

NAME= proj3
TEST_SCRIPTS= $(wildcard public? public?? secret? secret??)
TEST_INPUTS= $(wildcard public*ml secret*ml)
TEST_OUTPUTS= $(wildcard public*output secret*output)
OTHER_FILES_IN_TESTING_SETUP= utilities.ml

all: zipfiles utilities.cmo
	chmod u+x $(TEST_SCRIPTS)

%.cmo: %.ml
	ocamlc -c $<

zipfiles: $(NAME)-canonical.zip $(NAME)-tester.zip

$(NAME)-canonical.zip: $(wildcard part?.ml)
	zip -9 $@ $^

$(NAME)-tester.zip: $(TEST_SCRIPTS) $(TEST_INPUTS) $(TEST_OUTPUTS) \
                    $(OTHER_FILES_IN_TESTING_SETUP) Makefile test.properties
	zip -9 $@ $^

clean:
	- rm -f *~
