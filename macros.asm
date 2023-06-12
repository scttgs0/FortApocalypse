
m8i8            .macro
                sep #$30
                .as
                .xs
                .endmacro

m8i16           .macro
                sep #$20
                .as
                rep #$10
                .xl
                .endmacro

m16i8           .macro
                rep #$20
                .al
                sep #$10
                .xs
                .endmacro

m16i16          .macro
                rep #$30
                .al
                .xl
                .endmacro

m8              .macro
                sep #$20
                .as
                .endmacro

m16             .macro
                rep #$20
                .al
                .endmacro

i8              .macro
                sep #$10
                .xs
                .endmacro

i16             .macro
                rep #$10
                .xl
                .endmacro

setdp           .macro
                pha
                php

                .m16
                lda @w #\1
                tcd
                .dpage \1

                plp
                pla
                .endmacro

setbank         .macro
                pha
                php

                .m8
                lda #\1
                pha
                plb
                .databank \1

                plp
                pla
                .endmacro

mouse_off       .macro
                stz MOUSE_PTR_CTRL_REG_L
                .endmacro

mouse_off_s     .macro
                php

                .m8
                .mouse_off

                plp
                .endmacro

mouse_on        .macro
                lda #1
                sta MOUSE_PTR_CTRL_REG_L
                .endmacro

mouse_on_s      .macro
                pha
                php

                .m8
                .mouse_on

                plp
                pla
                .endmacro

graphics        .macro
                lda #\1
                sta MASTER_CTRL_REG_L

                lda #\2
                sta MASTER_CTRL_REG_H
                .endmacro

graphics_s      .macro
                pha
                php

                .m8
                .graphics \@

                plp
                pla
                .endmacro

border_off      .macro
                stz BORDER_CTRL_REG
                stz BORDER_X_SIZE
                stz BORDER_Y_SIZE
                .endmacro

border_off_s    .macro
                php

                .m8
                .border_off

                plp
                .endmacro

border_on       .macro color, xSize, ySize
                php

                lda #$01
                sta BORDER_CTRL_REG

                lda #\xSize
                sta BORDER_X_SIZE

                lda #\ySize
                sta BORDER_Y_SIZE

                .m16
                lda #\color
                sta BORDER_COLOR_B-1

                plp
                .endmacro

spr_addr        .sfunction num, $AF_0C01+(num*8)
spr_xpos        .sfunction num, $AF_0C04+(num*8)
spr_ypos        .sfunction num, $AF_0C06+(num*8)

sta_spr_xpos    .function num
                sta $AF_0C04+(num*8)
                .endfunction

sta_spr_ypos    .function num
                sta $AF_0C06+(num*8)
                .endfunction

sta_ix_spr_xpos .macro
                pha
                phx

                txa
                asl
                asl
                asl
                tax
                sta $AF_0C04,x

                plx
                pla
                .endmacro
