HOST=www.gtnoise.net
DIR=/srv/www/noise.gatech.edu/data/classes/cs6250/fall_2011

LDIR=$(DIR)/lectures/

SRCS = $(wildcard *.*)
LECTURES = lectures/*.pdf lectures/*.ppt lectures/*.pptx

all: web commit

commit: web
	svn commit

web: local
	scp -C $(SRCS) Makefile $(HOST):$(DIR)
	rsync -avz -e ssh -r $(LECTURES) $(HOST):$(LDIR)/

local: $(SRCS)
	./datereplace.rb index.html
	./mklectures.rb > syllabus.html
