ARCH	:= aarch64
AS		:= $(ARCH)-linux-gnu-as
LD		:= $(ARCH)-linux-gnu-ld

YEAR ?= 2024
DAY ?= 01

ASM_DIR := asm/$(YEAR)
INPUT_DIR := input/$(YEAR)/$(DAY)
SRC := $(ASM_DIR)/day$(DAY).S
OBJ := $(ASM_DIR)/day$(DAY).o
BIN := $(ASM_DIR)/day$(DAY)

.PHONY: build run clean clean-all

build:
	@echo "Assembling day $(DAY) for year $(YEAR)..."
	$(AS) -o $(OBJ) $(SRC)
	$(LD) -o $(BIN) $(OBJ)

run: build
	@echo "=== Running day $(DAY) for year $(YEAR) ==="
	@cat $(INPUT_DIR)/puzzle.txt | $(BIN)

clean:
	@echo "Cleaning day $(DAY) for year $(YEAR)..."
	@rm -f $(OBJ) $(BIN)

clean-all:
	@echo "Cleaning all object and binary files..."
	@find asm -type f \( -name "*.o" -o -name "a.out" -o -type f -executable \) -delete
