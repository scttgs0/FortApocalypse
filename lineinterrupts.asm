;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: lineinterrupts.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
LINE1           .proc
                pha
                txa
                pha
                lda #<LINE2
                sta VDSLST
                lda #>LINE2
                sta VDSLST+1

                ldx #0
_next1          txa
                sta WSYNC
                asl
                ora #$E0
                sta COLBK
                inx
                cpx #8
                bne _next1

                bra LINE2.LINEC

                .endproc


;=======================================
;
;=======================================
LINE2           .proc
                pha
                txa
                pha
                lda #<LINE3
                sta VDSLST
                lda #>LINE3
                sta VDSLST+1

                ldx #2
_next1          lda ROCKET_X,X
                sta HPOSM0,X
                dex
                bpl _next1

                ldx #7
_next2          txa
                sta WSYNC
                asl
                ora #$E0
                sta COLBK
                dex
                bpl _next2

LINEC           lda #0
                sta COLBK
                pla
                tax
                pla
                rti
                .endproc


;=======================================
;
;=======================================
LINE3           .proc
                pha
                php
                cld

                lda #<LINE4
                sta VDSLST
                lda #>LINE4
                sta VDSLST+1

                lda ROBOT_X
                sta HPOSP2
                clc
                adc #8
                sta HPOSP3
                lda #>CHR_SET2
                sta WSYNC
                sta CHBASE

                lda BAK_COLOR
                sta COLPF0
                lda #$0A
                sta COLPF1
                lda #$93
                sta COLPF2
                lda FRAME
                sta COLPF3

                sta WSYNC
                lda BAK2_COLOR
                sta COLBK

                plp
                pla
                rti
                .endproc

;=======================================
;
;=======================================
LINE4           .proc
                pha
                txa
                pha
                tya
                pha
                php

                cld
                lda #<LINE1
                sta VDSLST
                lda #>LINE1
                sta VDSLST+1

                ldx #7
                lda #0
_next1          sta HPOSP0,X
                dex
                bpl _next1

                sta WSYNC
                sta COLBK

                lda MODE
                cmp #STOP_MODE
                beq _1

                cmp #GO_MODE
                bne _2

_1              jsr DO_SOUNDS

_2              plp
                pla
                tay
                pla
                tax
                pla
                rti
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
