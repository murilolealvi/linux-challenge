
SRC = ./src
BIN = ./bin
INCLUDE = ./include
OBJ = ./obj

TARGET = $(BIN)/program
SOURCES = $(wildcard $(SRC)/*.f90)
OBJECTS = $(patsubst $(SRC)/$.f90, $(OBJ)/%.o, $(SOURCES))
#OBJECTS = $(SOURCES:.f90=.o) if the objects would be placed on src/ directory
#grab .f90 files and replace them as .o files destined to obj/ directory

COMPILER = gfortran

#$^ all dependencies
#$@ the target
#$< first dependency


all: $(TARGET)

$(TARGET): $(OBJECTS) #previous exe, linking stage
	@mkdir -p $(BIN) $(INCLUDE)

	$(COMPILER) $^ -J $(INCLUDE) -o $@


$(OBJ)/%.o: $(SRC)/%.f90 #compile every object, previous lib
	@mkdir -p $(OBJ)

	$(COMPILER) -c $< -J $(INCLUDE) -o $@

clean:
	@rm -rf $(OBJ) $(BIN) $(INCLUDE)

#not confuse clean and all as files
.PHONY: all clean
