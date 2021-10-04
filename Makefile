NAME := kirby_practice

GFX := gfx

BUILD_DIR := build
BSDIFF_DIR := bsdiff

KIRBY_ROM := Kirby's Dream Land (UE) [!].gb
SOURCE_FILE := $(NAME).asm
OBJECT_FILE := $(BUILD_DIR)/$(NAME).o
OUTPUT_ROM := $(NAME).gb
SYM_ROM := $(BUILD_DIR)/$(NAME).sym
BSDIFF := $(BSDIFF_DIR)/$(NAME).bsdiff
SAVESTATE_BSDIFF := Kirby's Dream Land (UE) [!].gb.bsdiff
TEMP_ROM := $(BUILD_DIR)/kirby_temp.gb

all:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BSDIFF_DIR)
	bspatch "$(KIRBY_ROM)" "$(TEMP_ROM)" "$(SAVESTATE_BSDIFF)" ||\
		cp "$(KIRBY_ROM)" "$(TEMP_ROM)"
	rgbgfx -f -o $(GFX)/cursor.2bpp $(GFX)/cursor.png
	rgbgfx -f -o $(GFX)/version_v10.2bpp $(GFX)/version_v10.png
	rgbasm -E $(SOURCE_FILE) -o $(OBJECT_FILE)
	rgblink -n $(SYM_ROM) -O $(TEMP_ROM) -o $(OUTPUT_ROM) $(OBJECT_FILE)
	rgbfix -f gh $(OUTPUT_ROM)
	bsdiff "$(KIRBY_ROM)" $(OUTPUT_ROM) $(BSDIFF)

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(BSDIFF_DIR)
	rm -rf $(OUTPUT_ROM)
