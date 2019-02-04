# -*- MakeFile -*-
# put common definitions in here
CC	= gcc
PRJCFLAGS	= -g
LD	= gcc
LDFLAGS	=
AR	= ar
ARFLAGS	=
RANLIB	= ranlib
RM	= rm
ECHO	= echo

CPPFLAGS=-g $(shell root-config --cflags)
LDFLAGS=-g $(shell root-config --ldflags)
LDLIBS=$(shell root-config --libs)


CFLAGS = -Wall -Wextra -std=c99 -pedantic -pthread -c $(DEBUG)
LFLAGS = -Wall -std=c99 -pedantic -pthread $(DEBUG)

arch = sm_61

SIMDIR =


#SHELL	= /bin/sh

.SILENT :
