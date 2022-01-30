m8i8            .macro
                sep #$30
                .as
                .xs
                .endm

m8i16           .macro
                sep #$20
                .as
                rep #$10
                .xl
                .endm

m16i8           .macro
                rep #$20
                .al
                sep #$10
                .xs
                .endm

m16i16          .macro
                rep #$30
                .al
                .xl
                .endm

m8              .macro
                sep #$20
                .as
                .endm

m16             .macro
                rep #$20
                .al
                .endm

i8              .macro
                sep #$10
                .xs
                .endm

i16             .macro
                rep #$10
                .xl
                .endm

setdp           .macro
                pha
                php

                .m16
                lda @w #\1
                tcd
                .dpage \1

                plp
                pla
                .endm

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
                .endm

mouse_off       .macro
                php

                .m8
                stz MOUSE_PTR_CTRL_REG_L

                plp
                .endm

mouse_on        .macro
                pha
                php

                .m8
                lda #1
                sta MOUSE_PTR_CTRL_REG_L

                plp
                pla
                .endm
