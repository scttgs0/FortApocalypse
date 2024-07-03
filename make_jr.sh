
mkdir -p obj/

# -------------------------------------

64tass  --m65c02 \
        --flat \
        --nostart \
        -o obj/fortJR.bin \
        --list=obj/fortJR.lst \
        --labels=obj/fortJR.lbl \
        fort.asm
