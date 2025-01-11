
mkdir -p obj/

# -------------------------------------

64tass  --m65xx \
        --atari-xex \
        -b \
        -o obj/fortapocalypse.rom \
        --list=obj/fortapocalypse_a8_rom.lst \
        --labels=obj/fortapocalypse_a8_rom.lbl \
        fort.asm
