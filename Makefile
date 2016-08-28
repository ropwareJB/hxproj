
make: FORCE
	haxe Make.hxml

.PHONY: make clean

FORCE: 

clean: rm -rf bin/*
