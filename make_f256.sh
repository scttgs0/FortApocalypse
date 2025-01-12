
mkdir -p obj/

# -------------------------------------

64tass  --m65816 \
        --c256-pgz \
        --output-exec=BOOT \
        --long-address \
        -D PGZ=1 \
        -o obj/fort.pgx \
        --list=obj/fort.lst \
        --labels=obj/fort.lbl \
        fort.asm
