# this shouldn't do anything since nothing needs to be compiled. 

NAME= proj1
TEST_SCRIPTS= $(wildcard public? public?? secret? secret??)
TEST_INPUTS= $(wildcard public*input secret*input)
TEST_OUTPUTS= $(wildcard public*output secret*output)
OTHER_FILES_IN_TESTING_SETUP= 

all: zipfiles
	chmod u+x $(NAME).rb
	chmod u+x $(TEST_SCRIPTS)
	# allowing students to just read the prologue and epilogue
	# - rm prologue epilogue

zipfiles: $(NAME)-canonical.zip $(NAME)-tester.zip

$(NAME)-canonical.zip: $(NAME).rb
	zip -9 $@ $^

$(NAME)-tester.zip: $(TEST_SCRIPTS) $(TEST_INPUTS) $(TEST_OUTPUTS) \
                    $(OTHER_FILES_IN_TESTING_SETUP) Makefile test.properties
	zip -9 $@ $^

clean:
	- rm -f *~
