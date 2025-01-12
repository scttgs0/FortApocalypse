
;--------------------------------------
;--------------------------------------
; FILE: FORT5.ASM
;--------------------------------------
; MOVE SLAVES
; FUEL BASE
; SET SCANNER
; CHECK FORT
;
; LINE INTERRUPTS
; SOUNDS
;--------------------------------------
;--------------------------------------


;======================================
;
;======================================
DoChecksum2    .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;---

                ldy #$00
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

                cmp #$C7
                bne _2

                lda TEMP1
                ;cmp #$00
                cmp #$f8
                beq _XIT

;--------------------------------------
_2              .byte $12
;--------------------------------------

_XIT            rts
                .endproc


;======================================
;
;======================================
MoveSlaves      .proc
                ldx SLAVE_NUM
                lda SLAVE_STATUS,X
                cmp #OFF
                beq _2

                cmp #PICKUP
                bne _1

                jsr S_COL2

                ldx #$00
                stx AUDC3

                ldy #$08
                jsr IncreaseScore

                inc SLAVES_SAVED

                jmp _2

_1              jsr SlaveCollision
                bcs _2

                jsr SlaveErase
                jsr SlaveMove
                jsr SlaveDraw

; - - - - - - - - - - - - - - - - - - -
;   Copy Protection
; - - - - - - - - - - - - - - - - - - -
                dec SlaveMove
; - - - - - - - - - - - - - - - - - - -

_2              ldx SLAVE_NUM
                inx
                cpx #$08
                bcc _3

                ldx #$00
_3              stx SLAVE_NUM

                lda PLAY_SCRN+5
                beq _XIT

                dec TIM9_VAL
                bne _XIT

                jsr ClearInfo

_XIT            rts
                .endproc


;======================================
;
;======================================
GetSlaveAddr    .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda SLAVE_X,X
                sta TEMP1
                lda SLAVE_Y,X
                sta TEMP2

                jmp ComputeMapAddr

                .endproc


;======================================
;
;======================================
SlaveCollision  .proc
;v_???          .var ADR1
;---

                jsr GetSlaveAddr

                ldy #$00
                lda (ADR1),Y
                beq S_COL2

                cmp #EXP
                beq S_COL2

                cmp #MISS_LEFT
                beq S_COL2

                cmp #MISS_RIGHT
                beq S_COL2

                dec ADR1+1

                lda (ADR1),Y
                beq S_COL2

                cmp #EXP
                beq S_COL2

                cmp #MISS_LEFT
                beq S_COL2

                cmp #MISS_RIGHT
                beq S_COL2

                clc
                rts
                .endproc


;======================================
;
;======================================
S_COL2          .proc
;v_???          .var TEMP2
;---

                jsr SlaveErase

                lda #OFF
                sta SLAVE_STATUS,X

                dec SLAVES_LEFT

                .endproc

                ;[fall-through]


;======================================
;
;======================================

PrintSlavesLeft .proc
;v_???          .var TEMP1
;---

                lda #$09                ; (9,0)
                sta TEMP1
                lda #$00
                sta TEMP2

                ldx #<txtMenRemain      ; "MEN  TO  RESCUE"
                ldy #>txtMenRemain
                jsr Print

                lda SLAVES_LEFT
                ora #$10+128
                sta PLAY_SCRN+5

                cmp #$10+128
                bne _1

                lda #$0A+128
_1              and #$8F
                sta PLAY_SCRN+6

                lda #90
                sta TIM9_VAL

                sec
                rts
                .endproc


;======================================
;
;======================================
SlaveErase      .proc
;v_???          .var ADR1
;---

                jsr GetSlaveAddr

                ldy #$00
                lda #$48                ; '^H'
                sta (ADR1),Y

                dec ADR1+1

                lda #$1F                ; '?'
                sta (ADR1),Y

                rts
                .endproc


;======================================
;
;======================================
SlaveMove       .proc
;v_???          .var ADR1
;---

_next1          lda SLAVE_DX,X
                bmi _1

                inc SLAVE_DX,X
                lda SLAVE_DX,X
                and #$01
                ora #$10
                sta SLAVE_DX,X

                inc SLAVE_X,X

                jmp _2

_1              dec SLAVE_DX,X
                lda SLAVE_DX,X
                and #$01
                ora #$F0
                sta SLAVE_DX,X

                dec SLAVE_X,X

_2              jsr GetSlaveAddr

                ldy #$00
                lda (ADR1),Y
                cmp #$48
                beq _XIT

                lda SLAVE_DX,X
                eor #$E0
                sta SLAVE_DX,X

                jmp _next1

_XIT            rts
                .endproc


;======================================
;
;======================================
SlaveDraw       .proc
;v_???          .var ADR1
;---

                jsr GetSlaveAddr

                ldy #$00
                lda SLAVE_DX,X
                pha

                and #$03
                tax

                pla
                bpl _1

                lda SLAVE_CHR_B_L,X
                sta (ADR1),Y

                dec ADR1+1

                lda SLAVE_CHR_T_L,X
                sta (ADR1),Y

                rts

_1              lda SLAVE_CHR_B_R,X
                sta (ADR1),Y

                dec ADR1+1

                lda SLAVE_CHR_T_R,X
                sta (ADR1),Y

                rts
                .endproc


;======================================
;
;======================================
SlavePickUp     .proc
                ldx #$08-0
_next1          dex
                bpl _1

                clc
                rts

_1              lda SLAVE_STATUS,X
                cmp #OFF
                beq _next1

                lda SLAVE_X,X
                sec
                sbc CHOP_X
                bpl _2

                eor #-2

_2              cmp #$04
                bcs _next1

                lda SLAVE_Y,X
                sec
                sbc CHOP_Y
                bpl _3

                eor #-2

_3              cmp #$04
                bcs _next1

                lda #PICKUP
                sta SLAVE_STATUS,X

                lda #$A8
                sta AUDC3

                lda #$20
                sta AUDF3

                sec
                rts
                .endproc


;--------------------------------------
;--------------------------------------

SLAVE_CHR_T_L   .byte $4A,$4A
SLAVE_CHR_T_R   .byte $49,$49

LAND_CHR
SLAVE_CHR_B_L   .byte $3E,$3D
SLAVE_CHR_B_R   .byte $3B,$3C
                .byte $44


;--------------------------------------
;--------------------------------------
LAND_LEN        = *-LAND_CHR-1
;--------------------------------------

txtMenRemain    .byte $AD,$A5,$AE,$00,$00                   ; 'MEN  ' atari-ascii
                .byte $B4,$AF,$00,$00                       ; 'TO  '
                .byte $B2,$A5,$B3,$A3,$B5,$A5               ; 'RESCUE'
                .byte $FF


;======================================
;
;======================================
CheckFuelBase   .proc
v_posX          .var TEMP1
v_posY          .var TEMP2
;---

                lda FUEL_STATUS
                cmp #kREFUEL
                bne _1
                jmp Refuel

_1              lda CHOPPER_STATUS
                cmp #LAND
                bne _4

                lda CHOP_Y
                cmp #$07+2
                bcc _4

                cmp #$0B+2
                bcs _4

                ldx CHOP_X
                lda LEVEL
                bne _2

                cpx #$15+2
                bcc _4

                cpx #$EC+2+6
                bcs _4
                jmp _3

_2              cpx #$82
                bcc _4

                cpx #$82+6
                bcs _4

_3              lda #kREFUEL
                sta FUEL_STATUS

; - - - - - - - - - - - - - - - - - - -
;   Copy Protection
; - - - - - - - - - - - - - - - - - - -
                asl ComputeMapAddr
; - - - - - - - - - - - - - - - - - - -

                lda #$01
                sta TIM4_VAL

                lda #$04
                sta FUEL_TEMP

_4              lda #$00
                ldx FUEL_STATUS
                cpx #kREFUEL
                beq _6

                lda FUEL2
                bne _XIT

                lda FRAME
                and #%00001000
                bne _5

                lda #$09                ; (9,0)
                sta v_posX
                lda #$00
                sta v_posY

                lda #$A4
                sta AUDC2
                sta AUDF2

                ldx #<txtLowOnFuel      ; "LOW  ON  FUEL"
                ldy #>txtLowOnFuel
                jsr Print
                jmp _XIT

_5              lda #$A4
_6              sta AUDC2
                lda #$88
                sta AUDF2

                jsr ClearInfo

_XIT            rts
                .endproc


;--------------------------------------
;--------------------------------------

txtLowOnFuel    .byte $AC,$AF,$B7,$00,$00                   ; 'LOW  ' atari-ascii
                .byte $AF,$AE,$00,$00                       ; 'ON  '
                .byte $A6,$B5,$A5,$AC                       ; 'FUEL'
                .byte $FF


;======================================
;
;======================================
Refuel          .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;v_???          .var TEMP3
;---

                dec TIM4_VAL
                bne FE

                lda #$01
                sta TIM4_VAL

                lda FUEL_TEMP
                bmi F1

DF1             lda #$09+2
                sta TEMP2
                lda FUEL_TEMP
                sta TEMP3

                ldx LEVEL
                dex                     ; X=1?
                beq _1

                lda #$15+2
                sta TEMP1

                jsr DrawBase

                lda #$EC+2
                bne _2                  ; [unc]

_1              lda #$82
_2              sta TEMP1

                jsr DrawBase

                dec FUEL_TEMP

FE              rts

F1              ldx #$01
                lda CHOP_Y
                cmp #$0B+2
                bcs _1

                ldx #$00
                stx AUDC2
_1              stx SND4_VAL

                lda CHOP_Y
                cmp #$08+2
                bcs FE

                lda #FULL
                sta FUEL_STATUS

                lda #$04
                sta FUEL_TEMP

                jsr DF1
                jmp RestorePoint

                .endproc


;======================================
;
;======================================
DrawBase        .proc
;v_???          .var ADR1
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                jsr ComputeMapAddr

                lda #$04
                sta TEMP4

                lda TEMP3               ; x6
                asl
                clc
                adc TEMP3
                asl

                tax
_next1          ldy #$00
_next2          lda BASE_SHAPE,X
                sta (ADR1),Y

                inx
                iny
                cpy #$06
                bne _next2

                inc ADR1+1

                dec TEMP4
                bpl _next1

                rts
                .endproc


;--------------------------------------
;--------------------------------------

BASE_SHAPE      .byte $00,$00,$00,$00,$00,$00    ; .... .... .... .... .... ....
                .byte $00,$00,$00,$00,$00,$00    ; .... .... .... .... .... ....
                .byte $00,$00,$00,$00,$00,$00    ; .... .... .... .... .... ....
                .byte $00,$00,$00,$00,$00,$00    ; .... .... .... .... .... ....
                .byte $44,$44,$44,$44,$44,$44    ; G.G. G.G. G.G. G.G. G.G. G.G.
                .byte $55,$58,$58,$58,$58,$56    ; GGGG GGR. GGR. GGR. GGR. GGGR
                .byte $55,$26,$35,$25,$2C,$56    ; GGGG .RGR .#GG .RGG .R#. GGGR
                .byte $55,$58,$58,$58,$58,$56    ; GGGG GGR. GGR. GGR. GGR. GGGR
                .byte $54,$00,$00,$00,$00,$54    ; GGG. .... .... .... .... GGG.


;======================================
;
;======================================
SetScanner      .proc
;v_???          .var ADR1
;v_???          .var ADR2
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda #$00
                sta TEMP1
                sta TEMP2

; - - - - - - - - - - - - - - - - - - -
;   Copy Protection
; - - - - - - - - - - - - - - - - - - -
                inc DrawMap
; - - - - - - - - - - - - - - - - - - -

                lda SY
                beq _2
                bmi _2

                cmp #$11
                bcc _1

                lda #$10
_1              jsr MULT_BY_40

_2              lda SX
                lsr
                lsr
                lsr
                clc
                adc #<SCANNER
                adc TEMP1
                sta ADR1
                lda #>SCANNER
                adc TEMP2
                sta ADR1+1

                lda ADR1
                sta SCAN_ADR1
                lda ADR1+1
                sta SCAN_ADR1+1

                lda #<S_LINE1
                sta SCAN_ADR2
                sta ADR2
                lda #>S_LINE1
                sta SCAN_ADR2+1
                sta ADR2+1

                jsr DO_LINE

                lda #<S_LINE2
                sta SCAN_ADR2
                sta ADR2
                lda #>S_LINE2
                sta SCAN_ADR2+1
                sta ADR2+1

                jsr DO_LINE

                lda #<S_LINE3
                sta SCAN_ADR2
                sta ADR2
                lda #>S_LINE3
                sta SCAN_ADR2+1
                sta ADR2+1

                jmp DO_LINE

                rts
                .endproc


;======================================
;
;======================================
PositionIt      .proc
;v_???          .var ADR2
;v_???          .var TEMP1
;v_???          .var TEMP2
;v_???          .var TEMP3
;---

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
                and #$07
                tax

                ldy #$00
                lda (ADR2),Y
                eor POS_MASK1,X
                sta (ADR2),Y

                ldx TEMP3
                rts
                .endproc


;======================================
;
;======================================
MULT_BY_40      .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                sta TEMP1
                asl
                asl
                adc TEMP1

                ldy #$00
                sty TEMP2
                asl
                rol TEMP2
                asl
                rol TEMP2
                asl
                rol TEMP2
                sta TEMP1

                rts
                .endproc


;======================================
;
;======================================
DO_LINE         .proc
;v_???          .var ADR1
;v_???          .var ADR2
;v_???          .var TEMP1
;---

                lda #$07
                sta TEMP1

_next1          ldx #$0C
                ldy #$00
_next2          lda (ADR1),Y
                sta (ADR2),Y

                inc ADR1
                bne _1

                inc ADR1+1

_1              lda ADR2
                clc
                adc #$08
                sta ADR2
                lda ADR2+1
                adc #$00
                sta ADR2+1

                dex
                bne _next2

                lda SCAN_ADR1
                clc
                adc #$28
                sta SCAN_ADR1
                sta ADR1
                lda SCAN_ADR1+1
                adc #$00
                sta SCAN_ADR1+1
                sta ADR1+1

                inc SCAN_ADR2
                bne _2

                inc SCAN_ADR2+1

_2              lda SCAN_ADR2
                sta ADR2
                lda SCAN_ADR2+1
                sta ADR2+1

                dec TEMP1
                bpl _next1

                rts
                .endproc


;======================================
;
;======================================
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
                cmp #EXPLODE
                beq DoChecksum1

                rts

; - - - - - - - - - - - - - - - - - - -
DoChecksum1     .block
                ldy #$00
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

                ;cmp #$00
                cmp #$C7
                bne _2

                lda TEMP1
                ;cmp #$00
                cmp #$F8
                beq _XIT

;--------------------------------------
_2              .byte $12
;--------------------------------------

_XIT            .endblock

; - - - - - - - - - - - - - - - - - - -
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

                lda #$08
                sta LAND_CHOP_ANGLE

                ldx #$10-1
                lda #$00
_next1          sta WINDOW_1,X

                dex
                bpl _next1

                lda #$00
                sta TEMP3
                sta TEMP4
                sta TEMP6

_next2          lda #$79
                sta TEMP1
                lda #$14
                sta TEMP2

                jsr ComputeMapAddr

                lda TEMP3
                asl
                tax

                lda FORT_EXP,X
                sta ADR2
                lda FORT_EXP+1,X
                sta ADR2+1

_next3          ldy TEMP4
                lda (ADR2),Y
                sta TEMP5

                ldy #$07+8+8
_next4          ldx #$02
                lda #$00
                ror TEMP5
                bcc _next5

                lda #EXP
_next5          sta (ADR1),Y

                dey
                dex
                bpl _next5

                tya
                bpl _next4

                inc ADR1+1

                inc TEMP6
                lda TEMP6
                cmp #$03
                bne _next3

                lda #$00
                sta TEMP6

                inc TEMP4
                lda TEMP4
                cmp #$06
                bne _next3

                lda #0
                sta TEMP4

                lda #$10
                sta BAK2_COLOR

                lda #$CF
                sta AUDC4

                ldy #$0F
_next6          ldx #$02
                jsr WaitFrame

                inc BAK2_COLOR

                lda #$01
                sta SND3_VAL

                lda RANDOM
                sta AUDF4

                dey
                bpl _next6

                lda #$00
                sta BAK2_COLOR

                inc TEMP3
                lda TEMP3
                cmp #$04
                bne _next2

                lda #GO_MODE
                sta MODE

                lda #OFF
                sta FORT_STATUS
                sta LASER_STATUS

                jmp ClearSounds

                .endblock
                .endproc


;--------------------------------------
;--------------------------------------

FORT_EXP        .addr FORT_EX1,FORT_EX2
                .addr FORT_EX3,FORT_EX4


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; DLI (Head)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dliLINE1        .proc
                pha
                txa
                pha

                lda #<dliLINE2
                sta VDSLST
                lda #>dliLINE2
                sta VDSLST+1

                ldx #$00
_next1          txa
                sta WSYNC

                asl
                ora #$E0
                sta COLBK

                inx
                cpx #$08
                bne _next1
                beq dliLINE2.LINEC         ; [unc]

                .endproc


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; DLI (Stage 2)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dliLINE2        .proc
                pha
                txa
                pha

                lda #<dliLINE3
                sta VDSLST
                lda #>dliLINE3
                sta VDSLST+1

                ldx #$02
_next1          lda ROCKET_X,X
                sta HPOSM0,X

                dex
                bpl _next1

                ldx #$07
_next2          txa
                sta WSYNC

                asl
                ora #$E0
                sta COLBK

                dex
                bpl _next2

LINEC           lda #$00
                sta COLBK

                pla
                tax
                pla
                rti
                .endproc


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; DLI (Stage 3)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dliLINE3        .proc
                pha
                php
                cld

                lda #<dliLINE4
                sta VDSLST
                lda #>dliLINE4
                sta VDSLST+1

                lda ROBOT_X
                sta HPOSP2
                clc
                adc #$08
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


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; DLI (Tail)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dliLINE4        .proc
                pha
                txa
                pha
                tya
                pha
                php

                cld
                lda #<dliLINE1
                sta VDSLST
                lda #>dliLINE1
                sta VDSLST+1

                ldx #$07
                lda #$00
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

_1              jsr DoSounds

_2              plp
                pla
                tay
                pla
                tax
                pla
                rti
                .endproc


;======================================
;
;======================================
DoChecksum3     .proc
                ldx #0
                txa
                clc
_next1          adc $B980,X

                inx
                bne _next1

                ;cmp #$00
                cmp #$90
                beq _XIT

;--------------------------------------
                .byte $12
;--------------------------------------

_XIT            rts
                .endproc


;======================================
;
;======================================
DoSounds        .proc

S1              .block                  ; CHOPPER SOUND
                lda CHOPPER_STATUS
                cmp #OFF
                beq _XIT

                lda FRAME
                and #$02
                bne _XIT

                lda #$83
                sta AUDC1

                lda SND1_1_VAL
                bpl _1

                lda SND1_2_VAL
_1              sec
                sbc #$04
                sta SND1_1_VAL
                sta AUDF1

_XIT            .endblock

; - - - - - - - - - - - - - - - - - - -
S2              .block                  ; MISSILE SOUND
                lda SND2_VAL
                bmi _XIT

                eor #$3F
                clc
                adc #$10
                sta AUDF2

                ldx #$86
                cmp #$3F+16
                bne _1

                ldx #$00
_1              stx AUDC2

                dec SND2_VAL

_XIT            .endblock

; - - - - - - - - - - - - - - - - - - -
S3              .block                  ; EXPLOSION SOUND
                lda SND3_VAL
                beq _XIT

                lda RANDOM
                and #$03
                ora SND3_VAL
                adc #$10
                sta AUDF3

                inc SND3_VAL
                lda SND3_VAL
                cmp #$31
                bne _1

                lda #$00
                sta SND3_VAL

_1              ldx #$48
                cmp #$00
                bne _2

                tax                     ; X=0
_2              stx AUDC3

_XIT            .endblock

; - - - - - - - - - - - - - - - - - - -
S4              .block                  ; RE-FUEL SOUND
                lda SND4_VAL
                beq _XIT

                ldx #$00
                lda FRAME
                and #$07
                beq _1

                ldx #$18
_1              ldy #$00
                lda FUEL1
                cmp #<MAX_FUEL
                lda FUEL2
                sbc #>MAX_FUEL
                bcs _2

                ldy #$A6
                sed
                lda FUEL1
                clc
                adc #$04
                sta FUEL1
                lda FUEL2
                adc #$00
                sta FUEL2

                cld
_2              stx AUDF2
                sty AUDC2

_XIT            .endblock

; - - - - - - - - - - - - - - - - - - -
S5              .block                  ; HYPER CHAMBER SOUND
                lda SND5_VAL
                beq _XIT

                inc SND5_VAL

                cmp #$50
                bne _1

                lda #$00
                sta SND5_VAL
_1              sta AUDF2

                lda #$A8
                sta AUDC2

_XIT            .endblock

; - - - - - - - - - - - - - - - - - - -
S6              .block                  ; CRUISE MISSILE SOUND
                lda FRAME
                and #$01
                bne _XIT

                lda SND6_VAL
                beq _XIT

                inc SND6_VAL

                cmp #$20
                bcc _1

                ldx #$00
                stx SND6_VAL

_1              sta AUDF4

                lda #$07
                sta AUDC4

_XIT            rts
                .endblock
                .endproc
