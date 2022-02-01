;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT2.S
;---------------------------------------
; OPTIONS SET-UP
; MOVE PODS
; MOVE CRUISE MISSILE
; MOVE TANKS
; CHECK HYPER CHAMBERS
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

READ_USER
                lda CONSOL
                cmp CONSOL_FLAG
                beq _4
                sta CONSOL_FLAG
                ldx #0
                stx TIM6_VAL
                cmp #6                  ; START
                bne _1
                lda #START_MODE
                sta MODE
;               LDA #1                  ; OFF
                sta DEMO_STATUS
                jmp _9
_1              ldx MODE
                cpx #OPTION_MODE
                bne _2
                jsr CHECK_OPTIONS
                jmp _9
_2              cmp #3                  ; OPTION
                beq _3
                cmp #5                  ; SELECT
                bne _4
_3              lda #OPTION_MODE
                sta MODE
;               LDA #1      OFF
                sta DEMO_STATUS
                jsr SCREEN_OFF
                lda #0
                sta OPT_NUM
                jsr CHECK_OPTIONS
                jmp _9
_4              lda SKSTAT
                and #%00000100
                bne _9
                lda KBCODE
                cmp #$21                ; SPACE
                bne _9
                lda MODE
                pha
                lda #PAUSE_MODE
                sta MODE
                jsr ClearSounds
_37             lda SKSTAT
                and #%00000100
                beq _37
_5              lda SKSTAT
                and #%00000100
                bne _38
                lda KBCODE
                cmp #$21                ; SPACE
                beq _6
_38             lda CONSOL
                cmp #7
                bne _6
                lda TRIG0
                bne _5
_6              lda SKSTAT
                and #%00000100
                beq _6
                pla
                sta MODE

_9              rts

CHECK_OPTIONS
                lda CONSOL
                cmp #3                  ; OPTION
                bne _2
                ldx OPT_NUM
                inx
                cpx #3
                blt _1
                ldx #0
_1              stx OPT_NUM
_2              cmp #5                  ; SELECT
                bne _8
                lda OPT_NUM
;               CMP #0
                bne _4
                ldx GRAV_SKILL
                inx
                cpx #3
                blt _3
                ldx #0
_3              stx GRAV_SKILL
_4              cmp #1
                bne _6
                ldx PILOT_SKILL
                inx
                cpx #3
                blt _5
                ldx #0
_5              stx PILOT_SKILL
_6              cmp #2
                bne _8
                ldx CHOPS
                inx
                cpx #3
                blt _7
                ldx #0
_7              stx CHOPS

_8              lda #13
                sta TEMP1
                lda #1
                sta TEMP2
                ldx #<OPTT1
                ldy #>OPTT1
                jsr PRINT
                lda #0
                sta TEMP1
                lda #3
                sta TEMP2
                ldx #<OPTT2
                ldy #>OPTT2
                jsr PRINT
                lda #28
                sta TEMP1
                ldx #<OPTT3
                ldy #>OPTT3
                jsr PRINT
;               JSR PRINT_OPTS
;               RTS

PRINT_OPTS
                lda #0
                sta TEMP1
                lda #7                  ; OPTION
                sta TEMP2

                ldx #<OPT1
                ldy #>OPT1
                jsr PRINT

                inc TEMP2
                inc TEMP2
                ldx #<OPT2
                ldy #>OPT2
                jsr PRINT

                inc TEMP2
                inc TEMP2
                ldx #<OPT3
                ldy #>OPT3
                jsr PRINT

                lda OPT_NUM
                asl
                clc
                adc #7                  ; OPTION
                sta TEMP2
                lda OPT_NUM
                asl
                tax
                lda OPT_TAB,X
                sta ADR2
                lda OPT_TAB+1,X
                sta ADR2+1
                jsr CCL
                ldy #0
                sty TEMP5
                sty TEMP6
_1              ldy TEMP5
                lda (ADR2),Y
;               CMP #0
                beq _3
                cmp #$FF
                beq _2
                ora #$80
                ldy TEMP6
                sta (ADR1),Y
                inc TEMP6
                clc
                adc #32
_3              ldy TEMP6
                sta (ADR1),Y
                inc TEMP6
                inc TEMP5
                bne _1                  ; FORCED
_2

                lda #28
                sta TEMP1
                lda #7                  ; OPTION
                sta TEMP2
                lda GRAV_SKILL
                asl
                tay
                ldx OPT_1,Y
                lda OPT_1+1,Y
                tay
                jsr PRINT

                inc TEMP2
                inc TEMP2
                lda PILOT_SKILL
                asl
                tay
                ldx OPT_2,Y
                lda OPT_2+1,Y
                tay
                jsr PRINT

                inc TEMP2
                inc TEMP2
                lda CHOPS
                asl
                tay
                ldx OPT_3,Y
                lda OPT_3+1,Y
                tay
                jmp PRINT
;               RTS


OPTT1           .byte $2F,$30,$34,$29,$2F,$2E,$33           ; 'OPTIONS' atari-ascii
                .byte $FF
OPTT2           .byte $2F,$30,$34,$29,$2F,$2E               ; 'OPTION'
                .byte $FF
OPTT3           .byte $33,$25,$2C,$25,$23,$34               ; 'SELECT'
                .byte $FF
OPT1            .byte $27,$32,$21,$36,$29,$34,$39,$00       ; 'GRAVITY '
                .byte $33,$2B,$29,$2C,$2C                   ; 'SKILL'
                .byte $FF
OPT2            .byte $30,$29,$2C,$2F,$34,$00               ; 'PILOT '
                .byte $33,$2B,$29,$2C,$2C                   ; 'SKILL'
                .byte $FF
OPT3            .byte $32,$2F,$22,$2F,$00                   ; 'ROBO '
                .byte $30,$29,$2C,$2F,$34,$33               ; 'PILOTS'
                .byte $FF
OPT1_1          .byte $37,$25,$21,$2B,$00,$00,$00,$00       ; 'WEAK    '
                .byte $FF
OPT1_2          .byte $2E,$2F,$32,$2D,$21,$2C               ; 'NORMAL'
                .byte $FF
OPT1_3          .byte $33,$34,$32,$2F,$2E,$27               ; 'STRONG'
                .byte $FF
OPT2_1          .byte $2E,$2F,$36,$29,$23,$25               ; 'NOVICE'
                .byte $FF
OPT2_2          .byte $30,$32,$2F,$00,$00,$00,$00,$00,$00   ; 'PRO      '
                .byte $FF
OPT2_3          .byte $25,$38,$30,$25,$32,$34               ; 'EXPERT'
                .byte $FF
OPT3_1          .byte $33,$25,$36,$25,$2E,$00,$00,$00       ; 'SEVEN   '
                .byte $FF
OPT3_2          .byte $2E,$29,$2E,$25,$00,$00,$00,$00       ; 'NINE    '
                .byte $FF
OPT3_3          .byte $25,$2C,$25,$36,$25,$2E               ; 'ELEVEN'
                .byte $FF
OPT_1
                .addr OPT1_1,OPT1_2,OPT1_3
OPT_2
                .addr OPT2_1,OPT2_2,OPT2_3
OPT_3
                .addr OPT3_1,OPT3_2,OPT3_3
OPT_TAB
                .addr OPT1,OPT2,OPT3

MOVE_PODS
                lda #POD_SPEED
_1              pha
                jsr MP1
                pla
                sec
                sbc #1
                bne _1
_2              rts

MP1
                ldx POD_NUM

                lda POD_STATUS,X
                sta POD_COM
                and #$0F
                cmp #OFF
                beq P_END
                cmp #BEGIN
                bne _1
                jmp P_BEGIN

_1              jsr P_COL
                bcs P_END
                jsr P_ERASE
                jsr P_MOVE
                jsr P_DRAW

P_END
                ldx POD_NUM
                inx
                cpx #MAX_PODS
                blt _1
                ldx #0
_1              stx POD_NUM
                rts

GET_POD_ADR
                lda POD_X,X
                sta TEMP1
                lda POD_Y,X
                sta TEMP2
                jmp ComputeMapAddr

GET_POD_VAL
                jsr GET_POD_ADR
                ldy #0
                lda (ADR1),Y
                sta TEMP1
                iny
                lda (ADR1),Y
                sta TEMP2
                rts

PUT_POD_VAL
                jsr GET_POD_ADR
                ldy #0
                lda TEMP3
                sta (ADR1),Y
                iny
                lda TEMP4
                sta (ADR1),Y
                rts

POS_POD
                lda POD_X,X
                sta TEMP1
                lda POD_Y,X
                sta TEMP2
                jmp POS_IT

P_BEGIN
_1              lda RANDOM
                cmp #50
                blt _1
                cmp #256-50
                bge _1
                sta POD_X,X
_2              lda RANDOM
                cmp #40
                bge _2
                sta POD_Y,X
                jsr GET_POD_ADR
                ldy #0
                lda (ADR1),Y
                iny
                ora (ADR1),Y
                bne _1
                lda #ON
                sta POD_STATUS,X
                sta POD_COM
                jsr P_DRAW
                lda #$01
                sta POD_DX,X
                jmp P_END

P_COL
                jsr GET_POD_VAL
                lda TEMP1
                cmp #MISS_LEFT
                beq _1
                cmp #MISS_RIGHT
                beq _1
                cmp #EXP
                beq _1
                lda TEMP2
                cmp #MISS_LEFT
                beq _1
                cmp #MISS_RIGHT
                beq _1
                cmp #EXP
                beq _1
                clc
                rts
_1              jsr P_ERASE
                lda #OFF
                sta POD_STATUS,X
                ldx #$50
                ldy #$00
                jsr INC_SCORE
                sec
                rts

P_ERASE
                jsr POS_POD
                lda POD_TEMP1,X
                sta TEMP3
                lda POD_TEMP2,X
                sta TEMP4
                jmp PUT_POD_VAL

P_DRAW
                jsr POS_POD
                jsr GET_POD_VAL
                lda TEMP1
                sta POD_TEMP1,X
                lda TEMP2
                sta POD_TEMP2,X
                lda POD_COM
                lsr
                lsr
                lsr
                tay
                lda POD_CHR,Y
                sta TEMP3
                lda POD_CHR+1,Y
                sta TEMP4
                jmp PUT_POD_VAL

P_MOVE
_0              lda POD_DX,X
                bpl _1
                lda POD_COM
                sec
                sbc #$10
                and #$3F
                sta POD_COM
                and #$F0
                cmp #$30
                bne _2
                dec POD_X,X
                jmp _2
_1              lda POD_COM
                clc
                adc #$10
                and #$3F
                sta POD_COM
                and #$F0
;               CMP #0
                bne _2
                inc POD_X,X
_2              lda POD_X,X
                sta TEMP1
                lda POD_Y,X
                sta TEMP2
                jsr ComputeMapAddr
                ldy #0
                lda (ADR1),Y
                iny
                ora (ADR1),Y
                bne _3
                lda POD_X,X
                cmp #50
                blt _3
                cmp #256-50
                blt _4
_3              lda POD_DX,X
                eor #-2
                sta POD_DX,X
                jmp _0
_4

                lda POD_COM
                sta POD_STATUS,X
                rts

POD_CHR
                .byte $40,$00
                .byte $5B,$5C
                .byte $5D,$5E
                .byte $00,$5F

MOVE_CRUISE_MISSILES
                dec MISSILE_SPD
                bne MCE
                lda MISSILE_SPEED
                sta MISSILE_SPD

MM1
                ldx #MAX_TANKS-1
M_ST
                lda CM_STATUS,X
                cmp #OFF
                beq M_END
                cmp #BEGIN
                bne _1
                jmp M_BEGIN

_1              jsr M_COL
                bcs M_END
                jsr M_ERASE
                jsr M_MOVE
                jsr M_DRAW

M_END
                lda TANK_STATUS,X
                cmp #ON
                bne _2
                lda TANK_Y,X
                sec
                sbc CHOP_Y
                bmi _2
                cmp #14
                bge _2
                lda CM_STATUS,X
                cmp #OFF
                bne _2
                lda CHOP_X
                sec
                sbc #2
                sbc TANK_X,X
                bpl _1
                eor #-2
_1              cmp #9
                bge _2
                lda #BEGIN
                sta CM_STATUS,X

_2              dex
                bpl M_ST
MCE
                ldx #MAX_TANKS-1
_1              lda CM_STATUS,X
                cmp #OFF
                bne _2
                dex
                bpl _1
                lda #0
                sta AUDC4
                sta SND6_VAL
_2              rts

GET_MISS_ADR
                lda CM_X,X
                sta TEMP1
                lda CM_Y,X
                sta TEMP2
                jmp ComputeMapAddr

M_BEGIN
                ldy TANK_X,X
                iny
                tya
                sta CM_X,X
                lda TANK_Y,X
                sec
                sbc #2
                sta CM_Y,X
                ldy #LEFT
                lda CHOP_X
                sec
                sbc TANK_X,X
                bmi _1
                ldy #RIGHT
_1              tya
                sta CM_STATUS,X
                lda #0
                sta CM_TEMP,X
                lda #20
                sta CM_TIME,X
                lda #1
                sta SND6_VAL
                jmp M_END

M_COL
                jsr GET_MISS_ADR
                ldy #0
                lda (ADR1),Y
                cmp #EXP
                beq M_COL2
                clc
                rts

M_COL2
                jsr M_ERASE
                lda #1
                sta SND3_VAL
                lda #OFF
                sta CM_STATUS,X
                lda #-1
                sta CM_TIME,X
                stx TEMP1
                ldx #$10
                ldy #$00
                jsr INC_SCORE
                ldx TEMP1
                sec
                rts

M_ERASE
                jsr GET_MISS_ADR
                lda CM_TEMP,X
                cmp #EXP_WALL
                beq _2
                cmp #$60+128
                bge _1
                cmp #$40
                beq _1
                cmp #$5B
                blt _2
                cmp #$5F+1
                blt _1
_2              ldy #0
                sta (ADR1),Y
_1              rts

M_MOVE
                lda CM_STATUS,X
                cmp #LEFT
                beq _1
                inc CM_X,X
                jmp _2
_1              dec CM_X,X
_2              lda CM_TIME,X
                bpl _3
_4              inc CM_Y,X
                jmp _8
_3              lda CHOP_X
                sec
                sbc CM_X,X
                sta TEMP1
                lda CM_STATUS,X
                cmp #LEFT
                bne _5
                lda TEMP1
                bpl _4
                bmi _6                  ; FORCED
_5              lda TEMP1
                bmi _4
_6              lda CM_X,X
                cmp #$D8
                bge _4
                cmp #$2D
                blt _4
                ldy CHOP_Y
                iny
                tya
                sec
                sbc CM_Y,X
                beq _8
                bpl _7
                dec CM_Y,X
                jmp _8
_7              inc CM_Y,X
_8              jsr GET_MISS_ADR
                ldy #0
                lda (ADR1),Y
                cmp #MISS_LEFT
                beq _7
                cmp #MISS_RIGHT
                beq _7
_9              lda CM_TIME,X
                bmi _10
                dec CM_TIME,X
_10             rts

M_DRAW
                jsr GET_MISS_ADR
                ldy #0
                lda (ADR1),Y
                sta CM_TEMP,X
                lda #MISS_LEFT
                ldy CM_STATUS,X
                cpy #LEFT
                beq _1
                lda #MISS_RIGHT
_1              ldy #0
                sta (ADR1),Y
                lda CM_TEMP,X
                jsr CHECK_CHR
                bcc _2
                jmp M_COL2
_2              rts

CHECK_HYPER_CHAMBER
                lda MODE
                cmp #HYPERSPACE_MODE
                bne _1
                lda #STOP_MODE
                sta MODE
                lda #$F
                sta BAK2_COLOR
                ldx #2
                jsr WAIT_FRAME
                lda #$0
                sta BAK2_COLOR
                lda RANDOM
                and #3
                tax
                lda H_XF,X
                sta SX_F
                lda H_YF,X
                sta SY_F
                lda H_X,X
                sta SX
                lda H_Y,X
                sta SY
                lda H_CX,X
                sta CHOPPER_X
                lda H_CY,X
                sta CHOPPER_Y
                lda #8
                sta CHOPPER_ANGLE
                lda #0
                sta CHOPPER_COL
                lda #GO_MODE
                sta MODE
;               JSR RestorePoint
_1              rts

H_XF
                .byte $DD,$76,$10,$4B
H_YF
                .byte $7A,$7B,$B8,$B8
H_X
                .byte $22,$BC,$55,$87
H_Y
                .byte $0F,$0F,$18,$18
H_CX
                .byte $73,$78,$76,$75
H_CY
                .byte $8C,$89,$AF,$AF

CHECK_CHR
                ldy #0
                sty ADR2+1
                and #$7F
                asl
                rol ADR2+1
                asl
                rol ADR2+1
                asl
                rol ADR2+1
                clc
                adc #<CHR_SET2
                sta ADR2
                lda #>CHR_SET2
                adc ADR2+1
                sta ADR2+1
                ldy #7
_1              lda (ADR2),Y
                bne _2
                dey
                bpl _1
                clc
                rts
_2              sec
                rts

POS_TANK
                lda TANK_X,X
                sta TEMP1
                ldy TANK_Y,X
                dey
                sty TEMP2
                jsr POS_IT
                lda TANK_Y,X
                sta TEMP2
                rts

MOVE_TANKS
MT1
                dec TANK_SPD
                beq _1
                jmp MT2

_1              lda TANK_SPEED
                sta TANK_SPD

                ldx #MAX_TANKS-1

_2              lda TANK_Y,X
                sta TEMP2
                lda TANK_STATUS,X
                cmp #OFF
                bne _3
                jmp _11
_3              cmp #BEGIN
                bne _5
                lda #ON
                sta TANK_STATUS,X
                lda TANK_START_X,X
                sta TANK_X,X
                lda TANK_START_Y,X
                sta TANK_Y,X
                lda #-1
                ldy RANDOM
                bpl _4
                lda #1
_4              sta TANK_DX,X
                jsr POS_TANK
                jmp _7
_5              cmp #CRASH
                bne _13
                jmp _11

; RESTORE OLD POS
_13             lda TANK_X,X
                sta TEMP1
                jsr ComputeMapAddr
                stx TEMP1
                ldy #0
                txa
                asl
                adc TEMP1
                tax
_6              lda (ADR1),Y
                cmp #EXP
                beq _15
                cmp #MISS_LEFT
                beq _15
                cmp #MISS_RIGHT
                bne _12
_15             ldx TEMP1
                lda #CRASH
                sta TANK_STATUS,X
                ldy #2
                lda #EXP
_14             sta (ADR1),Y
                dey
                bpl _14
                lda #10
                sta TIM5_VAL
                jmp _11
_12             lda TANK_TEMP,X
                sta (ADR1),Y
                inx
                iny
                cpy #3
                bne _6
                ldy #1
                dec ADR1+1
                lda #0
                sta (ADR1),Y

; MOVE X
                ldx TEMP1
_7              jsr POS_TANK
                lda TANK_X,X
                clc
                adc TANK_DX,X
                sta TANK_X,X

; SAVE NEW POS
                jsr POS_TANK
                lda TANK_X,X
                sta TEMP1
                jsr ComputeMapAddr
                stx TEMP1
                ldy #0
                txa
                asl
                adc TEMP1
                tax
_8              lda (ADR1),Y
                sta TANK_TEMP,X
                inx
                iny
                cpy #3
                bne _8

; CHECK FOR COLLISION
                ldx TEMP1
                ldy #0
                jsr CHECK_TANK_COL
                bcs _7
                ldy #2
                jsr CHECK_TANK_COL
                bcs _7

; DRAW TANK
                ldy #2
_9              lda TANK_SHAPE,Y
                sta (ADR1),Y
                dey
                bpl _9
                dec ADR1+1
                ldy #$6F+128            ; 'o'
                lda CHOP_X
                sec
                sbc TANK_X,X
                bpl _10
                ldy #$70+128            ; 'p'
_10             tya
                ldy #1
                sta (ADR1),Y

_11             dex
                bmi MT2
                jmp _2

MT2
                dec TIM5_VAL
                bne _4
                lda #10
                sta TIM5_VAL

                ldx #MAX_TANKS-1
_1              lda TANK_STATUS,X
                cmp #CRASH
                bne _3
                lda #OFF
                sta TANK_STATUS,X
                lda TANK_X,X
                sta TEMP1
                lda TANK_Y,X
                sta TEMP2
                jsr ComputeMapAddr
                stx TEMP1
                ldy #0
                txa
                asl
                adc TEMP1
                tax
_2              lda TANK_TEMP,X
                sta (ADR1),Y
                inx
                iny
                cpy #3
                bne _2
                dec ADR1+1
                ldy #1
                lda #0
                sta (ADR1),Y
                ldx #$50
                ldy #$2
                jsr INC_SCORE

                ldx TEMP1
                jsr POS_TANK

_3              lda TANK_STATUS,X
                cmp #OFF
                bne _10
                lda CHOP_Y
                cmp #3
                blt _10
                sec
                sbc #3
                cmp TANK_START_Y,X
                blt _10
                lda TANK_START_X,X
                sec
                sbc #5
                sta TEMP1
                lda TANK_START_Y,X
                sta TEMP2
                jsr ComputeMapAddr
                ldy #13-1
_9              lda (ADR1),Y
                bmi _10
                dey
                bpl _9
                lda #BEGIN
                sta TANK_STATUS,X

_10             dex
                bpl _1
_4              rts

CHECK_TANK_COL
                ldx #HIT_LIST2_LEN
_1              lda (ADR1),Y
                cmp HIT_LIST,X
                beq _2
                dex
                bpl _1
                ldx TEMP1
                clc
                rts
_2              ldx TEMP1
                lda TANK_DX,X
                eor #-2
                sta TANK_DX,X
                sec
                rts

SCREEN_ON
                jsr SCREEN_OFF
                lda #<DSP_LST1
                sta SDLST
                lda #>DSP_LST1
                sta SDLST+1
                rts

SCREEN_OFF
                lda #<DSP_LST2
                sta SDLST
                lda #>DSP_LST2
                sta SDLST+1
                lda #OFF
                sta CHOPPER_STATUS
                sta ROBOT_STATUS
                ldx R_STATUS
                cpx #CRASH
                bne _0
                sta R_STATUS
_0              ldx #$E0
                lda #0
_1              sta CHR_SET1+$200,X
                inx
                bne _1
;               LDX #0
;               LDA #0
_2              sta CHR_SET1+$300,X
                sta PLAY_SCRN+$000,X
                sta PLAY_SCRN+$100,X
                sta PLAY_SCRN+$200,X
                inx
                bne _2
;               LDA #0
                sta SND1_1_VAL
                sta SND2_VAL
                sta SND3_VAL
                sta SND4_VAL
                sta SND5_VAL
                sta SND6_VAL
                sta BAK2_COLOR
                lda #20
                sta SND1_2_VAL
                ldx #MAX_TANKS-1
                stx TIM7_VAL
_3              lda CM_STATUS,X
                cmp #OFF
                beq _4
                lda #OFF
                sta CM_STATUS,X
                jsr M_ERASE
_4              dex
                bpl _3

                ldx #2
_5              lda ROCKET_STATUS,X
                cmp #7                  ; EXP
                bne _6
                lda ROCKET_TEMPX,X
                sta TEMP1
                lda ROCKET_TEMPY,X
                sta TEMP2
                jsr ComputeMapAddr
                ldy #0
                lda ROCKET_TEMP,X
                sta (ADR1),Y
_6              lda #0
                sta ROCKET_STATUS,X
                sta ROCKET_X,X
                dex
                bpl _5

ClearSounds
                lda #0
                sta AUDC1
                sta AUDC2
                sta AUDC3
                sta AUDC4
                rts

CCL
                lda TEMP2
                pha
                lda TEMP1
                pha
                lda TEMP2
                jsr MULT_BY_40
                pla
                pha
                clc
                adc TEMP1
                adc #<PLAY_SCRN
                sta ADR1
                lda #>PLAY_SCRN
                adc TEMP2
                sta ADR1+1
                pla
                sta TEMP1
                pla
                sta TEMP2
                rts

PRINT
                stx ADR2
                sty ADR2+1
                jsr CCL
                ldy #0
                sty TEMP5
                sty TEMP6
_1              ldy TEMP5
                lda (ADR2),Y
;               CMP #0
                beq _3
                cmp #$FF
                beq _2
                ldy TEMP6
                sta (ADR1),Y
                inc TEMP6
                clc
                adc #32
_3              ldy TEMP6
                sta (ADR1),Y
                inc TEMP6
                inc TEMP5
                bne _1                  ; FORCED
_2              rts

GiveBonus
                ldx BONUS1
                ldy BONUS2
                jsr INC_SCORE
                lda #0
                sta BONUS1
                sta BONUS2
                sed
                lda CHOP_LEFT
                clc
                adc #2
                sta CHOP_LEFT
                cld
                ldx #2
;               JSR WAIT_FRAME
;               RTS

WAIT_FRAME
                lda MODE
                sta TEMP_MODE
                lda FRAME
_1              cmp FRAME
                beq _1
                jsr READ_USER
                lda MODE
                cmp TEMP_MODE
                bne _2
                dex
                bne WAIT_FRAME
                rts

_2              ldx #$FF
                txs
                jmp MAIN

ClearInfo
                ldy #40-1
                lda #0
_1              sta PLAY_SCRN,Y
                dey
                bpl _1
                rts

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
