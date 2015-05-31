HOST=kendall-square.cc.gt.atl.ga.us
DIR=/usr/local/www/apache22/data/classes/cs6250/fall_2010

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
