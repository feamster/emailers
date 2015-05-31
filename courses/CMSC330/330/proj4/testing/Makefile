NAME= proj4
TEST_SCRIPTS= $(wildcard public? public?? secret? secret??)
TEST_INPUTS= $(wildcard public*input secret*input)
TEST_OUTPUTS= $(wildcard public*output secret*output)
OTHER_FILES_IN_TESTING_SETUP= get_input.ml makefile
CANONICAL_FILES= scanner.ml scanner_loop.ml parser.ml parser_loop.ml \
                 interpreter.ml interpreter_loop.ml Makefile

all:
	# make clean
	- rm -f *~ *.cmo *.zip scanner parser interpreter
	touch *.ml
	make get_input.cmo
	- make -f Makefile scanner
	- make -f Makefile parser
	- make -f Makefile interpreter

%.cmo: %.ml
	ocamlc -c $<

zipfiles: $(NAME)-canonical.zip $(NAME)-tester.zip

$(NAME)-canonical.zip: $(CANONICAL_FILES)
	zip -9 $@ $^

$(NAME)-tester.zip: $(TEST_SCRIPTS) $(TEST_INPUTS) $(TEST_OUTPUTS) \
                    $(OTHER_FILES_IN_TESTING_SETUP) test.properties
	zip -9 $@ $^

clean:
	- rm -f *~ *.cmo *.zip scanner parser interpreter
