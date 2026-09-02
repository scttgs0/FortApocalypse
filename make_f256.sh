
mkdir -p obj/

# -------------------------------------

64tass  --m65816 \
        --c256-pgz \
        --output-exec=BOOT \
        --long-address \
        -o obj/fort.pgz \
        --list=obj/fort.lst \
        --labels=obj/fort.lbl \
        fort.asm
