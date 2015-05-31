# this shouldn't do anything since nothing needs to be compiled. 

#
# special rule different for $(NAME) in all and $(NAME)-canonical.zip,
# unlike the earlier projects
#

NAME= proj5
TEST_SCRIPTS= $(wildcard public? public?? secret? secret??)
TEST_INPUTS= $(wildcard public*input secret*input)
TEST_OUTPUTS= $(wildcard public*output secret*output)
OTHER_FILES_IN_TESTING_SETUP= $(wildcard public*rb secret*rb) simulate.rb \
                              run-ruby-program

# special rule here
all: zipfiles
	chmod u+x metro.rb simulate.rb run-ruby-program
	chmod u+x $(TEST_SCRIPTS)

zipfiles: $(NAME)-canonical.zip $(NAME)-tester.zip

# special rule here
$(NAME)-canonical.zip: metro.rb
	zip -9 $@ $^

$(NAME)-tester.zip: $(TEST_SCRIPTS) $(TEST_INPUTS) $(TEST_OUTPUTS) \
                    $(OTHER_FILES_IN_TESTING_SETUP) Makefile test.properties
	zip -9 $@ $^

clean:
	- rm -f *~
