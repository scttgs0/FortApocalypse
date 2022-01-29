;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT1.S
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
START           sei
                cld
                ldx #Z2_LEN
_3              lda Z2,X
                sta RAM2_STUFF,X
                dex
                bne _3
                lda #%00111110
                sta SDMCTL
                lda #$14
                sta PRIOR
                lda #%00000011
                sta GRACTL
                sta SKCTL
                lda #>PLAYER
                sta PMBASE
                lda #>CHR_SET1
                sta CHBAS

                ldx #0
                stx AUDCTL
                stx COLOR4
                stx TIM6_VAL
                stx PILOT_SKILL
                stx GRAV_SKILL
                inx                     ; X=1
                stx ELEVATOR_DX
                inx                     ; X=2
                stx CHOPS

                lda #<LINE1
                sta VDSLST
                lda #>LINE1
                sta VDSLST+1

                jsr M_START

                lda #TITLE_MODE
                sta MODE

SET_FONTS ;unused
                ldx #0
_3              lda FNT1,X
                sta CHR_SET1+15,X
                lda FNT1+$100-15,X
                sta CHR_SET1+$100,X
                lda FNT1+$200-15,X
                sta CHR_SET1+$200,X

                lda FNT2,X
                sta CHR_SET2+$100+8,X
                lda FNT2+$100-8,X
                sta CHR_SET2+$200,X
                lda FNT2+$200-8,X
                sta CHR_SET2+$300,X
                inx
                bne _3

                ldx #Z1_LEN
_4              lda Z1,X
                sta RAM1_STUFF,X
                dex
                bpl _4

                lda #$40
                sta NMIEN
                cli

                brl Title


;=======================================
;
;=======================================
MAIN
                lda MODE
                cmp #GO_MODE
                beq _2

                lda FRAME
_1              cmp FRAME
                beq _1

_2              lda MODE
                cmp #GO_MODE
                bne _6
  
                jsr MOVE_PODS
                jsr MOVE_TANKS
                jsr MOVE_CRUISE_MISSILES
                jsr MOVE_SLAVES
  
                jsr SET_SCANNER
                jsr CHECK_FUEL_BASE
                jsr CHECK_FORT
                jsr CHECK_LEVEL

_6              jsr CHECK_HYPER_CHAMBER
                jsr CHECK_MODES
                jsr ReadKeyboard

                lda DEMO_STATUS
                bpl _3
  
                inc DEMO_STATUS         ; =0
  
                lda #START_MODE
                sta MODE

_3              lda MODE
                cmp #TITLE_MODE
                beq _5

                cmp #OPTION_MODE
                bne _4

_5              lda FRAME
                and #%00000100
                beq _4

                dec TIM6_VAL
                bne _4

                jmp Title

_4              jmp MAIN


;=======================================
;
;=======================================
CHECK_LEVEL
                lda LEVEL
                beq DO_LEVEL_1
                cmp #1
                bne _1
                jmp DO_LEVEL_2
_1              jmp DO_LEVEL_3
_2              rts


;=======================================
;
;=======================================
DO_LEVEL_1
                lda CHOPPER_STATUS
                cmp #LAND
                bne _1
                lda CHOP_Y
                cmp #35
                blt _1
                lda CHOP_X
                cmp #130
                blt _1
                cmp #130+6+1
                bge _1
                lda SLAVES_LEFT
                bne PSL
                inc LEVEL               ; =1
                jsr GIVE_BONUS
                jsr CLEAR_INFO
                jsr CLEAR_SOUNDS
                lda #STOP_MODE
                sta MODE
                lda #130
                sta TEMP1
                lda #40
                sta TEMP2
                jsr COMPUTE_MAP_ADR
                lda ADR1
                sta TEMP3
                lda ADR1+1
                sta TEMP4
                lda #3
                sta TEMP2
_2              jsr MOVE_RAMP
                ldy #5
_3              ldx #5
                jsr WAIT_FRAME
                jsr HOVER
                inc CHOPPER_Y
                dey
                bpl _3
                lda TEMP3
                sta ADR1
                lda TEMP4
                sta ADR1+1
                dec TEMP2
                bne _2
                dec MAIN+32             ; PROT
                lda #NEW_LEVEL_MODE
                sta MODE
_1              rts


;=======================================
;
;=======================================
PSL             jmp PRINT_SLAVES_LEFT


;=======================================
;
;=======================================
MOVE_RAMP
                ldx #4
_1              lda ADR1
                sta ADR2
                ldy ADR1+1
                dey
                sty ADR2+1
                ldy #5
_2              lda (ADR2),Y
                sta (ADR1),Y
                dey
                bpl _2
                dec ADR1+1
                dex
                bpl _1
                rts


;=======================================
;
;=======================================
DO_LEVEL_2
                lda FORT_STATUS
                cmp #OFF
                bne _1
                lda CHOP_Y
                cmp #2
                bge _1
                lda CHOP_X
                cmp #130
                blt _1
                cmp #130+4+1
                bge _1
                lda SLAVES_LEFT
                bne PSL
                inc LEVEL               ; =2
                jsr GIVE_BONUS
                asl M_NEW_PLAYER        ; PROT
                lda #NEW_LEVEL_MODE
                sta MODE
_1              rts


;=======================================
;
;=======================================
DO_LEVEL_3
                lda CHOPPER_STATUS
                cmp #LAND
                bne _1
                lda CHOP_Y
                cmp #13
                bge _1
                lda CHOP_X
                cmp #$17
                blt _1
                cmp #$F4
                bge _1
                jsr GIVE_BONUS
                inc LEVEL               ; =3
                dec M_GAME_OVER
                lda #GAME_OVER_MODE
                sta MODE
_1              rts


;=======================================
;
;=======================================
UNPACK
_0              jsr GET_BYTE
                ldy #0
                ldx TEMP4
                bne _10
_1              cmp CHR1,Y
                beq _2
                iny
                cpy #CHR1_L
                bne _1
_9              ldx #1
                bne _3                  ; FORCED
_10             cmp CHR2,Y
                beq _2
                iny
                cpy #CHR2_L
                bne _10
                beq _9                  ; FORCED
_2              sta TEMP1
                jsr GET_BYTE
                tax
                lda TEMP1
_3              ldy #0
                sta (ADR2),Y
                inc ADR2
                bne _4
                inc ADR2+1
_4              dex
                bne _3
                lda ADR2
                cmp TEMP2
                lda ADR2+1
                sbc TEMP3
                bcc _0
                rts


;=======================================
;
;=======================================
GET_BYTE
                ldy #0
                lda (ADR1),Y
                inc ADR1
                bne _1
                inc ADR1+1
_1              rts

;---------------------------------------
;---------------------------------------

CHR1            .byte $00,$61,$0E,$0F,$10,$11,$0A,$0B       ; ' a./01*+' atari-ascii
                .byte $0C,$0D,$03,$07,$1F,$73,$74           ; ',-#'?st'

                .byte $41,$44,$48,$58,$59,$5A,$D8
                .byte $47+128
CHR1_L          = *-CHR1

CHR2            .byte $00,$55,$AA,$FF
CHR2_L          = *-CHR2

PACK_ADR        .addr PACKED_MAP+$000   ; LEVEL_1
                .addr PACKED_MAP+$62B   ; LEVEL_2
                .addr PACKED_MAP+$000   ; LEVEL_1


;=======================================
;
;=======================================
CHECK_MODES
                lda MODE
_1              cmp #START_MODE
                bne _2
                jmp M_START
_2              cmp #GAME_OVER_MODE
                bne _3
                jmp M_GAME_OVER
_3              cmp #NEW_LEVEL_MODE
                bne _4
                jmp M_NEW_LEVEL
_4              cmp #NEW_PLAYER_MODE
                bne _30
                jmp M_NEW_PLAYER

_30             rol CHECK_MODES         ; PROT
                rts


;=======================================
;
;=======================================
M_START
                jsr SCREEN_OFF
                ldx #0
                stx LEVEL
                stx SCORE1
                stx SCORE2
                stx SCORE3
                stx BONUS1
                stx BONUS2
                stx TIM1_VAL
                stx FUEL1
                stx FUEL2
                stx GAME_POINTS
                stx SLAVES_SAVED
                inx                     ; X=1
                stx ELEVATOR_TIM
                stx TANK_SPD
                stx MISSILE_SPD
                lda #128
                sta TIM2_VAL
                lda #ON
                sta FORT_STATUS
                sta LASER_STATUS
                lda #EMPTY
                sta FUEL_STATUS
                lda #OFF
                sta R_STATUS
                ldx GRAV_SKILL
                lda GRAV_TAB,X
                sta GRAV_SKL
                ldx CHOPS
                lda CHOP_TAB,X
                ldy DEMO_STATUS
                bne _0
                lda #2
_0              sta MAIN                ; PROT
                sta CHOP_LEFT
                ldx PILOT_SKILL
                lda LASER_TAB,X
                sta LASER_SPD
                lda POD_TAB,X
                sta START_PODS
                lda ROBOT_TAB,X
                sta ROBOT_SPD
                lda TANK_TAB,X
                sta TANK_SPEED
                lda MISSILE_TAB,X
                sta MISSILE_SPEED
                lda ELEVATOR_TAB,X
                sta ELEVATOR_SPD
                ldx #7
                lda #0
_1              sta WINDOW_1,X
                sta WINDOW_2,X
                dex
                bpl _1
                ldx #7
                lda #$55
                ldy RANDOM
                bmi _3
_2              sta WINDOW_1,X
                dex
                bpl _2
                bmi _4                  ; FORCED
_3              sta WINDOW_2,X
                dex
                bpl _3
_4              lda #NEW_LEVEL_MODE
                sta MODE
                rts

;---------------------------------------
;---------------------------------------

GRAV_TAB
                .byte $F,7
ROBOT_TAB
                .byte 3,1,0
CHOP_TAB
                .byte $7,$9,$11
LASER_TAB
                .byte 4,8,16
POD_TAB
                .byte 13-1,26-1,MAX_PODS-1
TANK_TAB
                .byte 4
MISSILE_TAB
                .byte 3,2,1
ELEVATOR_TAB
                .byte 37+25,37+10,37+0


;=======================================
;
;=======================================
M_NEW_PLAYER
                jsr SCREEN_OFF
                sed
                lda CHOP_LEFT
                sec
                sbc #1
                sta CHOP_LEFT
                cld
                cmp #$99
                bne _1
                lda #GAME_OVER_MODE
                sta MODE
                rts

_1              lda #$1F                ; CHOPPER CLR
                sta PCOLR0
                sta PCOLR1
                lda FUEL_STATUS
                cmp #EMPTY
                bne _10
                dec UPDATE_CHOPPER      ; PROT
                lda #FULL
                sta FUEL_STATUS
                ldx #0
                stx FUEL1
                inx                     ; X=1
                stx FUEL2
_10             lda #4
                sta TEMP1
                lda #8
                sta TEMP2
                ldx #<txtPilot1
                ldy #>txtPilot1
                jsr PRINT
                lda #5
                sta TEMP1
                lda #10
                sta TEMP2
                ldx #<txtPilot2
                ldy #>txtPilot2
                jsr PRINT
                lda #<PLAY_SCRN+428
                sta S_ADR
                lda #>PLAY_SCRN+428
                sta S_ADR+1
                ldx #0
                stx S_FLG
                stx DEMO_COUNT
                inx                     ; X=1
                lda CHOP_LEFT
                jsr DDIG

                jsr DO_CHECKSUM2
                ldx #75
                jsr WAIT_FRAME

                lda LAND_X
                sta SX
                lda LAND_Y
                sta SY
                lda LAND_FX
                sta SX_F
                lda LAND_FY
                sta SY_F
                lda LAND_CHOP_X
                sta CHOPPER_X
                lda LAND_CHOP_Y
                sta CHOPPER_Y
                lda LAND_CHOP_ANGLE
                sta CHOPPER_ANGLE
                lda #0
                sta CHOPPER_COL
                jsr SCREEN_ON
                lda #BEGIN
                sta CHOPPER_STATUS
                lda #GO_MODE
                sta MODE
                rts


;=======================================
;
;=======================================
M_NEW_LEVEL
                jsr SCREEN_OFF
                lda #12
                sta TEMP1
                lda #6
                sta TEMP2
                ldx #<txtEnter
                ldy #>txtEnter
                jsr PRINT
                lda #2
                sta TEMP1
                lda #8
                sta TEMP2
                ldy LEVEL
                dey                     ; Y=0
                beq _0
_5              ldx #<txtEnterL1
                ldy #>txtEnterL1
                jsr PRINT
                jmp _1
_0              ldx #<txtEnterL2
                ldy #>txtEnterL2
                jsr PRINT
_1              ldx LEVEL
                lda LEVEL_COLOR,X
                sta BAK_COLOR
                sta COLOR0
                txa
                asl
                tax
                lda LEVEL_START,X
                sta SX
                lda LEVEL_START+1,X
                sta SY
                lda LEVEL_CHOP_START,X
                sta CHOPPER_X
                lda LEVEL_CHOP_START+1,X
                sta CHOPPER_Y
                lda #0
                sta SX_F
                ldy LEVEL
                cpy #2
                beq _4
                lda #7
_4              sta SY_F
                lda #8
                sta CHOPPER_ANGLE
                jsr SAVE_POS
                jsr DO_CHECKSUM3
                lda #$99
                sta BONUS1
                sta BONUS2

                ldx #MAX_TANKS-1
_2              ldy LEVEL
                dey
                beq _91
                lda TANK_START_X_L1,X
                sta TANK_START_X,X
                lda TANK_START_Y_L1,X
                bne _92                 ; FORCED
_91             lda TANK_START_X_L2,X
                sta TANK_START_X,X
                lda TANK_START_Y_L2,X
_92             sta TANK_START_Y,X
                lda #BEGIN
                sta TANK_STATUS,X
                lda #OFF
                sta CM_STATUS,X
                dex
                bpl _2

                sta R_STATUS

                ldx #MAX_PODS-1
_6              sta POD_STATUS,X
                dex
                bpl _6
                ldx START_PODS
                lda #BEGIN
_7              sta POD_STATUS,X
                dex
                bpl _7
                lda #0
                sta POD_NUM
                sta SLAVE_NUM

                lda LEVEL
                asl
                tax
                lda PACK_ADR,X
                sta ADR1
                lda PACK_ADR+1,X
                sta ADR1+1
                lda #<MAP
                sta ADR2
                lda #>MAP
                sta ADR2+1
                lda #<MAP+$2800
                sta TEMP2
                lda #>MAP+$2800
                sta TEMP3
                lda #0
                sta TEMP4
                jsr UNPACK

MAKE_CONTURE ;unused
                lda #<MAP
                sta ADR1
                lda #>MAP
                sta ADR1+1
                ldy #0
_1              lda (ADR1),Y
                cmp #$73                ; 's'
                bne _3
_2              lda RANDOM
                and #3
                beq _2
                clc
                adc #$62-1
                bne _5                  ; FORCED
_3              cmp #$74                ; 't'
                bne _5
_4              lda RANDOM
                and #3
                beq _4
                clc
                adc #$65-1
_5              sta (ADR1),Y
                iny
                bne _1
                inc ADR1+1
                lda ADR1+1
                cmp #>MAP+$2800
                bne _1

                lda #<MAP
                sta ADR1
                lda #>MAP
                sta ADR1+1
                lda #<MAP+255-40
                sta ADR2
                lda #>MAP+255-40
                sta ADR2+1
                ldx #0
_6              ldy #0
_7              lda (ADR1),Y
                sta (ADR2),Y
                iny
                cpy #40
                bne _7
                inc ADR1+1
                inc ADR2+1
                inx
                cpx #40
                bne _6

                ldy LEVEL
                cpy #2
                bne _71

                lda #$7E
                sta TEMP1
                lda #$13
                sta TEMP2
                jsr COMPUTE_MAP_ADR
                ldx #2
_69             ldy #$D
                lda #0
_70             sta (ADR1),Y
                dey
                bpl _70
                inc ADR1+1
                dex
                bpl _69
_71             lda LEVEL
                asl
                tax
                lda SCAN_INFO,X
                sta ADR1
                lda SCAN_INFO+1,X
                sta ADR1+1
                lda #<SCANNER
                sta ADR2
                lda #>SCANNER
                sta ADR2+1
                lda #<SCANNER+1600
                sta TEMP2
                lda #>SCANNER+1600
                sta TEMP3
                lda #1
                sta TEMP4
                jsr UNPACK

                lda #<SCANNER
                sta ADR1
                lda #>SCANNER
                sta ADR1+1
                lda #<SCANNER+$1B
                sta ADR2
                lda #>SCANNER+$1B
                sta ADR2+1
                ldx #39
_50             ldy #12
_51             lda (ADR1),Y
                sta (ADR2),Y
                dey
                bpl _51
                lda ADR1
                clc
                adc #40
                sta ADR1
                bcc _52
                inc ADR1+1
_52             lda ADR2
                clc
                adc #40
                sta ADR2
                bcc _53
                inc ADR2+1
_53             dex
                bpl _50
                inc MAIN                ; PROT

S_BEGIN ;unused
                ldx #8
                stx SLAVES_LEFT
                dex                     ; X=7
                lda #OFF
_1              sta SLAVE_STATUS,X
                dex
                bpl _1
                lda LEVEL
                cmp #2
                beq _12
                ldx #7
_9              lda #<MAP
                sta ADR1
                lda #>MAP
                sta ADR1+1

                ldy #0
_10             lda (ADR1),Y
                cmp #$48                ; '^H'
                bne _11
                iny
                lda (ADR1),Y
                dey
                cmp #$48
                bne _11
                dec ADR1+1
                lda (ADR1),Y
                inc ADR1+1
                cmp #$1F                ; '?'
                bne _11
                lda RANDOM
                cmp #10
                blt _11
                cmp #50
                bge _11
                tya
                clc
                adc #5
                sta SLAVE_X,X
                lda ADR1+1
                sec
                sbc #>MAP
                sta SLAVE_Y,X
                lda #1
                sta (ADR1),Y
                lda #ON
                sta SLAVE_STATUS,X
                lda #$10
                sta SLAVE_DX,X
                dex
                bmi _12
_11             iny
                bne _10
                inc ADR1+1
                lda ADR1+1
                cmp #>MAP+$2800
                bne _10
                txa
                bpl _9

_12
                lda #NEW_PLAYER_MODE
                sta MODE
                rts

;---------------------------------------
;---------------------------------------

LEVEL_COLOR
                .byte $42
                .byte $C2
                .byte $42
LEVEL_CHOP_START
                .byte 90,100
                .byte 119,100
                .byte 116,170
LEVEL_START
                .byte $02,$FF
                .byte $6D,$FF
                .byte $6E,$18
SCAN_INFO
                .addr PACKED_SCAN+0     ; LVL 1
                .addr PACKED_SCAN+$1E9  ; LVL 2
                .addr PACKED_SCAN+0     ; LVL 1
TANK_START_X_L1
                .byte $53,$63,$90,$A0,$59,$AE
TANK_START_Y_L1
                .byte $12,$12,$12,$12,$26,$26
TANK_START_X_L2
                .byte $50,$65,$A0,$B5,$3D,$54
TANK_START_Y_L2
                .byte $0C,$0C,$0C,$0C,$26,$26


;=======================================
;
;=======================================
INC_GAME_POINTS
                clc
                adc GAME_POINTS
                sta GAME_POINTS
                rts

;---------------------------------------

M_TAB
                .char -2,-1,0


;=======================================
;
;=======================================
M_GAME_OVER
                jsr SCREEN_OFF

                lda SLAVES_SAVED
                lsr
                lsr
                jsr INC_GAME_POINTS
                lda FORT_STATUS
                cmp #OFF
                bne _1
                lda #3
                jsr INC_GAME_POINTS
_1              lda LEVEL
                cmp #3
                bne _2
                inc GAME_POINTS
_2              jsr INC_GAME_POINTS
                lda SCORE3
                jsr INC_GAME_POINTS

                ldx GRAV_SKILL
                lda M_TAB,X
                jsr INC_GAME_POINTS
                lda #2
                clc
                sbc CHOPS
                eor #-1
                jsr INC_GAME_POINTS
                ldx PILOT_SKILL
                lda M_TAB,X
                jsr INC_GAME_POINTS

                lda GAME_POINTS
                bpl _3
                lda #0
_3              cmp #16
                blt _4
                lda #15
_4              sta GAME_POINTS

                lda SCORE3
                cmp HI3
                bne _51
                lda SCORE2
                cmp HI2
                bne _51
                lda SCORE1
                cmp HI1
                blt _52
_53             lda SCORE1
                sta HI1
                lda SCORE2
                sta HI2
                lda SCORE3
                sta HI3
                jmp _52
_51             bge _53

_52             lda #2
                sta TEMP1
                lda #0
                sta TEMP2
                sta S_FLG
                ldx #<txtHighScore
                ldy #>txtHighScore
                jsr PRINT
                lda #<PLAY_SCRN+24
                sta S_ADR
                lda #>PLAY_SCRN+24
                sta S_ADR+1
                ldx #5
                lda HI3
                jsr DDIG
                lda HI2
                jsr DDIG
                lda HI1
                jsr DDIG

                lda #3
                sta TEMP1
                lda #5
                sta TEMP2
                ldx #<txtGmOvrMission   ; YOUR
                ldy #>txtGmOvrMission   ; MISSION
                jsr PRINT
                lda #21
                sta TEMP1
                ldx #<txtGmOvrAbort     ; ABORTED
                ldy #>txtGmOvrAbort
                lda LEVEL
                cmp #3
                bne _5
                ldx #<txtGmOvrComplete  ; COMPLETED
                ldy #>txtGmOvrComplete
_5              jsr PRINT

                ldx #7
                stx TEMP1
                inx                     ; X=8
                stx TEMP2
                ldx #<txtGmOvrRank      ; YOUR
                ldy #>txtGmOvrRank      ; RANK
                jsr PRINT
                lda #21
                sta TEMP1
                lda #10
                sta TEMP2
                ldx #<txtGmOvrClass     ; CLASS
                ldy #>txtGmOvrClass
                jsr PRINT
                lda GAME_POINTS
                and #3
                eor #3
                clc
                adc #1
                ldy #12
                ora #$10+$80
                sta (ADR1),Y
                cmp #$10+128
                bne _6
                lda #$A+128
_6              iny
                and #$8F
                sta (ADR1),Y
                lda #3
                sta TEMP1
                lda GAME_POINTS
                lsr
                lsr
                and #3
                asl
                tay
                ldx txtGmOvrRating,Y
                lda txtGmOvrRating+1,Y
                tay
                jsr PRINT
                lda #-1
                sta TIM6_VAL
                ror SCREEN_OFF          ; PROT

                lda #TITLE_MODE
                sta MODE
                sta DEMO_STATUS
                rts

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
