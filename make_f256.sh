
mkdir -p obj/

# -------------------------------------

64tass  --m65c02 \
        --flat \
        --nostart \
        -D PGX=1 \
        -o obj/fort.pgx \
        --list=obj/fort.lst \
        --labels=obj/fort.lbl \
        fort.asm


64tass  --m65c02 \
        --flat \
        --nostart \
        -D PGX=0 \
        -o obj/fortB.bin \
        --list=obj/fortB.lst \
        --labels=obj/fortB.lbl \
        fort.asm
