


SRC = ./src
BIN = ./bin
INCLUDE = ./include
OBJ = ./obj


all: lib exe

lib: module.o

exe:
	gfortran $(OBJ)/*.o $(SRC)/program.f90 -o $(BIN)/program

%.o: $(SRC)/%.f90 %(INCLUDE)/%.mod
	gfortran -c $< -I $(INCLUDE) -o $(OBJ)/$@