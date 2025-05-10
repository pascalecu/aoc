ARCH     := aarch64
AS       := $(ARCH)-linux-gnu-as
LD       := $(ARCH)-linux-gnu-ld
CPP      := $(ARCH)-linux-gnu-cpp

YEAR     ?= 2024
DAY      ?= 01

ASM_DIR     := asm/$(YEAR)
INPUT_DIR   := input/$(YEAR)/$(DAY)
SRC         := $(ASM_DIR)/day$(DAY).S
PRE         := $(ASM_DIR)/day$(DAY).s
OBJ         := $(ASM_DIR)/day$(DAY).o
BIN         := $(ASM_DIR)/day$(DAY)

.PHONY: all build run clean clean-all

all: build

build: $(BIN)

# Preprocess .S → .s
$(PRE): $(SRC)
	@mkdir -p $(dir $@)
	@echo "[CPP] $< → $@"
	$(CPP) -E -P -I/usr/aarch64-linux-gnu/include $< -o $@

# Assemble .s → .o
$(OBJ): $(PRE)
	@echo "[AS]  $< → $@"
	$(AS) -o $@ $<

# Link .o → binary
$(BIN): $(OBJ)
	@echo "[LD]  $< → $@"
	$(LD) -o $@ $<

run: build
	@echo "=== Running day $(DAY) for year $(YEAR) ==="
	@if [ -f $(INPUT_DIR)/puzzle.txt ]; then \
	  cat $(INPUT_DIR)/puzzle.txt | $(BIN); \
	else \
	  echo "(no input file found — running without input)"; \
	  $(BIN); \
	fi

clean:
	@echo "[CLEAN] $(DAY)/$(YEAR)"
	@rm -f $(PRE) $(OBJ) $(BIN)

clean-all:
	@echo "[CLEAN] All object, binary, and preprocessed files"
	@find asm -type f \( -name "*.o" -o -name "*.s" -o -name "a.out" -o -type f -executable \) -delete
