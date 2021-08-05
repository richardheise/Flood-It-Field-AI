# @file  Makefile
# @brief Arquivo Make
# @date COLOCAR
# @author Richard Fernando Heise Ferreira (GRR20191053)


CPPFLAGS  = -O3
CC = g++

#-----------------------------------------------------------------------------#
all : flood

flood : flood.o matriz.o floodlib.o IAra.o

#-----------------------------------------------------------------------------#

clean :
	$(RM) *.o

#-----------------------------------------------------------------------------#

purge:
	$(RM)  flood *.o
