# Prerequisites

* GNU Make
* [RGBDS](https://rgbds.gbdev.io/)
* (optional) bsdiff
* (optional) [Save state patch by Matt Currie](https://github.com/mattcurrie/gb-save-states)

# Building
1. Place a copy of the original ROM in the root directory under the filename `Kirby's Dream Land (UE) [!].gb`.
2. (optional) Copy the save state patch `Kirby's Dream Land (UE) [!].gb.bsdiff` into the root directory.
3. Run `make`. This builds the patched ROM `kirby_practice.gb` in the root directory.
