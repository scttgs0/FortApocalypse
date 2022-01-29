;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT5.S
;---------------------------------------
; SET SCANNER
; CHECK FORT
;
; LINE INTERUPTS
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
DO_CHECKSUM2    ldy #0
                sty TEMP1
                sty ADR1
                lda #$90
                sta ADR1+1
                clc

_next1          adc (ADR1),Y
                bcc _1
                inc TEMP1
_1              iny
                bne _next1
                inc ADR1+1
                ldx ADR1+1
                cpx #$B0
                bne _next1
                ;cmp #0
                cmp #$C7
                bne _2
                lda TEMP1
                ;cmp #0
                cmp #$f8
                beq _XIT

_2              .byte $12

_XIT            rts


;=======================================
;
;=======================================
POS_IT
                stx TEMP3
                ldx TEMP1
                lda TEMP2
                jsr MULT_BY_40
                txa
                lsr
                lsr
                lsr
                clc
                adc #<SCANNER+3
                adc TEMP1
                sta ADR2
                lda #>SCANNER
                adc TEMP2
                sta ADR2+1
                txa
                and #7
                tax
                ldy #0
                lda (ADR2),Y
                eor POS_MASK1,X
                sta (ADR2),Y
                ldx TEMP3
                rts


;=======================================
;
;=======================================
MULT_BY_40
                sta TEMP1
                asl
                asl
                adc TEMP1

                ldy #0
                sty TEMP2
                asl
                rol TEMP2
                asl
                rol TEMP2
                asl
                rol TEMP2
                sta TEMP1
                rts


;=======================================
;
;=======================================
CHECK_FORT
                lda FORT_STATUS
                cmp #EXPLODE
                beq _1
                rts

_1
DO_CHECKSUM1 ;unused
                ldy #0
                sty TEMP1
                sty ADR1
                lda #$90
                sta ADR1+1
                clc

_1              adc (ADR1),Y
                bcc _2
                inc TEMP1
_2              iny
                bne _1
                inc ADR1+1
                ldx ADR1+1
                cpx #$B0
                bne _1
                ;cmp #0
                cmp #$C7
                bne _4
                lda TEMP1
                ;cmp #0
                cmp #$F8
                beq _3

_4              .byte $12
_3

NEXT_PART1 ;unused
                ldx #$00
                ldy #$50
                jsr INC_SCORE
                jsr GIVE_BONUS
                lda #STOP_MODE
                sta MODE
                lda #$99
                sta BONUS1
                sta BONUS2
                lda #$76
                sta LAND_CHOP_X
                lda #$A0
                sta LAND_CHOP_Y
                lda #$6E
                sta LAND_X
                lda #$11
                sta LAND_Y
                lda #$07
                sta LAND_FX
                lda #$96
                sta LAND_FY
                lda #8
                sta LAND_CHOP_ANGLE
                ldx #16-1
                lda #0
_90             sta WINDOW_1,X
                dex
                bpl _90
                lda #0
                sta TEMP3
                sta TEMP4
                sta TEMP6
_2              lda #121
                sta TEMP1
                lda #20
                sta TEMP2
                jsr ComputeMapAddr
                lda TEMP3
                asl
                tax
                lda FORT_EXP,X
                sta ADR2
                lda FORT_EXP+1,X
                sta ADR2+1
_3              ldy TEMP4
                lda (ADR2),Y
                sta TEMP5
                ldy #7+8+8
_4              ldx #2
                lda #0
                ror TEMP5
                bcc _5
                lda #EXP
_5              sta (ADR1),Y
                dey
                dex
                bpl _5
                tya
                bpl _4
                inc ADR1+1
                inc TEMP6
                lda TEMP6
                cmp #3
                bne _3
                lda #0
                sta TEMP6
                inc TEMP4
                lda TEMP4
                cmp #6
                bne _3
                lda #0
                sta TEMP4
                lda #$10
                sta BAK2_COLOR
                lda #$CF
                sta AUDC4
                ldy #15
_6              ldx #2
                jsr WAIT_FRAME
                inc BAK2_COLOR
                lda #1
                sta S3_VAL
                lda RANDOM
                sta AUDF4
                dey
                bpl _6
                lda #0
                sta BAK2_COLOR
                inc TEMP3
                lda TEMP3
                cmp #4
                bne _2
                lda #GO_MODE
                sta MODE
                lda #OFF
                sta FORT_STATUS
                sta LASER_STATUS

                jmp CLEAR_SOUNDS

;---------------------------------------
;---------------------------------------

FORT_EXP        .addr FORT_EX1,FORT_EX2
                .addr FORT_EX3,FORT_EX4


;=======================================
;
;=======================================
LINE1           pha
                txa
                pha
                lda #<LINE2
                sta VDSLST
                lda #>LINE2
                sta VDSLST+1

                ldx #0
_1              txa
                sta WSYNC
                asl
                ora #$E0
                sta COLBK
                inx
                cpx #8
                bne _1

                beq LINEC               ; FORCED


;=======================================
;
;=======================================
LINE2
                pha
                txa
                pha
                lda #<LINE3
                sta VDSLST
                lda #>LINE3
                sta VDSLST+1
                ldx #2
_0              lda ROCKET_X,X
                sta HPOSM0,X
                dex
                bpl _0

                ldx #7
_1              txa
                sta WSYNC
                asl
                ora #$E0
                sta COLBK
                dex
                bpl _1

LINEC           lda #0
                sta COLBK
                pla
                tax
                pla
                rti


;=======================================
;
;=======================================
LINE3
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


;=======================================
;
;=======================================
LINE4
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
_0              sta HPOSP0,X
                dex
                bpl _0
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


;=======================================
;
;=======================================
DO_CHECKSUM3
                ldx #0
                txa
                clc
_1              adc $B980,X
                inx
                bne _1
                ;cmp #$0
                cmp #$90
                beq _2

                .byte $12

_2              rts

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
