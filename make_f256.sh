
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

cp obj/fort.pgx /media/scott/ExternData/src/GameEngines/FoenixRetroSystems/bin/SDCARD_JR/
cp obj/fort.lst /media/scott/ExternData/src/GameEngines/FoenixRetroSystems/bin/SDCARD_JR/
