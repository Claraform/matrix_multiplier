# This Makefile requires GNU make, which is called gmake on Solaris systems
#
# 'make'        : builds and runs the project
# 'make clean'  : remove build products

PROG = bin/*

OBJS = obj/*

ARCH = $(shell uname -m)
OS   = $(shell uname -s)

CC = gcc

default:	
	$(CC) $(INCLUDE) -c main.c -o obj/main.o
	$(CC) $(INCLUDE) -c Timer.c -o obj/Timer.o
	$(CC) -o bin/GoldenMeasure obj/main.o obj/Timer.o 	

clean:
	rm -f -r $(PROG) $(OBJS)

run:
	bin/GoldenMeasure
