HOST=www.gtnoise.net
DIR=/srv/www/noise.gatech.edu/data/classes/cs3251/spring_2013

LDIR=$(DIR)/lectures/

SRCS = $(wildcard *.*)
LECTURES = lectures/*.pdf lectures/*.ppt

all: web

web: local
	scp -C $(SRCS) Makefile $(HOST):$(DIR)
	rsync -avz -e ssh -r $(LECTURES) $(HOST):$(LDIR)/

local: $(SRCS)
	./datereplace.rb index.html
	./mklectures.rb > syllabus.html
