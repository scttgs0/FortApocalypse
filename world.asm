;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: world.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
DrawMap         .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

DO_X            .block
                ldx CHOPPER_X
                cpx #MIN_RIGHT+1
                blt _2

                ldx #MIN_RIGHT
                stx CHOPPER_X
                lda SX
                cmp #$D8+1
                blt _1

                lda #1+1
                sta SX
_1              dec SX_F
                lda SX_F
                and #3
                eor #3
                bne _2

                inc SX
_2              cpx #MIN_LEFT
                bge _XIT

                ldx #MIN_LEFT
                stx CHOPPER_X
                lda SX
                cmp #1+1+1
                bge _3

                lda #$D8+1
                sta SX
_3              inc SX_F
                lda SX_F
                and #3
                bne _XIT

                dec SX
_XIT            .endblock

DO_Y            .block
                lda SY
                cmp #24
                beq _1

                ldx CHOPPER_Y
                cpx #MIN_DOWN+1
                blt _1

                ldx #MIN_DOWN
                stx CHOPPER_Y
                bra _2

_1              ldx CHOPPER_Y
                cpx #MAX_DOWN+1
                blt _3

                lda #MAX_DOWN
                sta CHOPPER_Y
                lda SY_F
                and #7
                bne _2

                lda SY
                cmp #24
                beq _3

_2              inc SY_F
                lda SY_F
                and #7
                bne _3

                inc SY
_3              lda SY
                cmp #-1
                beq _4

                cpx #MIN_UP
                bge _4

                ldx #MIN_UP
                stx CHOPPER_Y
                bra _5

_4              cpx #MAX_UP
                bge _6

                lda #MAX_UP
                sta CHOPPER_Y
                lda SY_F
                and #7
                eor #7
                bne _5

                lda SY
                cmp #-1
                beq _6

_5              dec SY_F
                lda SY_F
                and #7
                eor #7
                bne _6

                dec SY
_6              lda SX_F
                and #3
                sta HSCROL
                lda SY_F
                and #7
                sta VSCROL
                lda SX
                sta TEMP1_I
                lda SY
                sta TEMP2_I
                jsr ComputeMapAddrI

; for each map row, recalculate the display list LMS address
                ldx #0
                ldy #MAP_LINES
_nextRow        inx
                lda ADR1_I
                sta DSP_MAP,x
                inx
                lda ADR1_I+1
                sta DSP_MAP,x

                inc ADR1_I+1
                inx
                dey
                bne _nextRow

                rts
                .endblock
                .endproc


;=======================================
;
;=======================================
ComputeMapAddrI .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                lda #<MAP-5
                clc
                adc TEMP1_I
                sta ADR1_I
                lda #>MAP-5
                adc #0
                sta ADR1_I+1
                lda TEMP2_I
                clc
                adc ADR1_I+1
                sta ADR1_I+1
                rts
                .endproc


;=======================================
;
;=======================================
ComputeMapAddr  .proc
;v_???          .var ADR1
v_posX          .var TEMP1
v_posY          .var TEMP2
;---

                lda #<MAP-5
                clc
                adc v_posX
                sta ADR1
                lda #>MAP-5
                adc #0
                sta ADR1+1

                lda v_posY
                clc
                adc ADR1+1
                sta ADR1+1
                rts
                .endproc


;=======================================
;
;=======================================
DoBlocks        .proc
                lda FRAME
                and #$7F
                bne _XIT

                ldx #32-1
                lda #0
_next1          sta BLOCK_1,x
                dex
                bpl _next1

                lda SID_RANDOM
                bmi _1

                ldx #7
                lda #$55
_next2          sta BLOCK_1,x
                dex
                bpl _next2

_1              lda SID_RANDOM
                bmi _2

                ldx #7
                lda #$55
_next3          sta BLOCK_2,x
                dex
                bpl _next3

_2              lda SID_RANDOM
                bmi _3

                ldx #7
                lda #$55
_next4          sta BLOCK_3,x
                dex
                bpl _next4

_3              lda SID_RANDOM
                bmi _XIT

                ldx #7
                lda #$55
_next5          sta BLOCK_4,x
                dex
                bpl _next5

_XIT            rts
                .endproc


;=======================================
;
;=======================================
CheckFort       .proc
;v_???          .var ADR1
;v_???          .var ADR2
;v_???          .var TEMP1
;v_???          .var TEMP2
;v_???          .var TEMP3
;v_???          .var TEMP4
;v_???          .var TEMP5
;v_???          .var TEMP6
;---

                lda FORT_STATUS
                cmp #kEXPLODE
                beq DoChecksum1

                rts

DoChecksum1    .block
                ldy #0
                sty TEMP1
                sty ADR1
                lda #$90
                sta ADR1+1
                clc
_next1          adc (ADR1),y
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
                cmp #$F8
                beq _XIT

_2              .byte $12
_XIT            .endblock


NEXT_PART1      .block
                ldx #$00
                ldy #$50
                jsr IncreaseScore
                jsr GiveBonus

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
_next1          stz WINDOW_1,x
                dex
                bpl _next1

                stz TEMP3
                stz TEMP4
                stz TEMP6
_next2          lda #121
                sta TEMP1
                lda #20
                sta TEMP2
                jsr ComputeMapAddr

                lda TEMP3
                asl
                tax
                lda FORT_EXP,x
                sta ADR2
                lda FORT_EXP+1,x
                sta ADR2+1
_next3          ldy TEMP4
                lda (ADR2),y
                sta TEMP5
                ldy #7+8+8
_next4          ldx #2
                lda #0
                ror TEMP5
                bcc _next5

                lda #EXP
_next5          sta (ADR1),y
                dey
                dex
                bpl _next5

                tya
                bpl _next4

                inc ADR1+1
                inc TEMP6
                lda TEMP6
                cmp #3
                bne _next3

                stz TEMP6
                inc TEMP4
                lda TEMP4
                cmp #6
                bne _next3

                stz TEMP4
                lda #$10
                sta BAK2_COLOR
                lda #$CF
                sta SID_CTRL3
                ldy #15
_next6          ldx #2
                jsr WaitFrame

                inc BAK2_COLOR
                lda #1
                sta SND3_VAL
                lda SID_RANDOM
                sta SID_FREQ3
                dey
                bpl _next6

                stz BAK2_COLOR
                inc TEMP3
                lda TEMP3
                cmp #4
                bne _next2

                lda #GO_MODE
                sta MODE
                lda #kOFF
                sta FORT_STATUS
                sta LASER_STATUS

                jmp ClearSounds

                .endblock
                .endproc

;---------------------------------------
;---------------------------------------

FORT_EXP        .addr FORT_EX1,FORT_EX2
                .addr FORT_EX3,FORT_EX4

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
