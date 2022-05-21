;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: engine_main.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
CartridgeStart  .proc
;v_???          .var ADR1
;---

                sei
                lda #$B3
                pha
                ldx #$00
                txa
_next1          sta $0000,x             ; zero-page
                .sta_ix_spr_xpos
                sta DMACLT,x
                sta AUDF1,x
                sta PORTA,x
                inx
                bne _next1

                ldy #$01
                sty ADR1+1
                dey                     ; Y=0
                sty ADR1
_next2          sta (ADR1),y
                iny
                bne _next2

                inc ADR1+1
                ldx ADR1+1
                cpx #$C0
                bne _next2

                lda #$34
                pha
                ldx #$00
_next3          lda BOOT_STUFF,x
                sta $01C0,x             ; L01C0
                inx
                bpl _next3

                cli
                rts
                .endproc


;=======================================
;
;=======================================
START           ;.proc
                sei
                cld
                ldx #Z2_LEN
_next1          lda Z2,x
                sta RAM2_STUFF,x
                dex
                bne _next1

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

SET_FONTS       .block
                ldx #0
_next1          lda FNT1,x
                sta CHR_SET1+15,x
                lda FNT1+$100-15,x
                sta CHR_SET1+$100,x
                lda FNT1+$200-15,x
                sta CHR_SET1+$200,x

                lda FNT2,x
                sta CHR_SET2+$100+8,x
                lda FNT2+$100-8,x
                sta CHR_SET2+$200,x
                lda FNT2+$200-8,x
                sta CHR_SET2+$300,x
                inx
                bne _next1

; relocate the display list into RAM
                ldx #Z1_LEN
_next2          lda Z1,x
                sta RAM1_STUFF,x
                dex
                bpl _next2

                lda #$40
                sta NMIEN
                cli

                brl Title

                .endblock
                ;.endproc


;=======================================
;
;=======================================
MAIN            .proc
                lda MODE
                cmp #GO_MODE
                beq _1

                lda FRAME
_next1          cmp FRAME
                beq _next1

_1              lda MODE
                cmp #GO_MODE
                bne _2

                jsr MovePods
                jsr MoveTanks
                jsr MoveCruiseMissiles
                jsr MoveSlaves

                jsr SetScanner
                jsr CheckFuelBase
                jsr CheckFort
                jsr CheckLevel

_2              jsr CheckHyperchamber
                jsr CheckModes
                jsr ReadKeyboard

                lda DEMO_STATUS
                bpl _3

                inc DEMO_STATUS         ; =0

                lda #START_MODE
                sta MODE

_3              lda MODE
                cmp #TITLE_MODE
                beq _4

                cmp #OPTION_MODE
                bne _5

_4              lda FRAME
                and #%00000100
                beq _5

                dec TIM6_VAL
                bne _5

                jmp Title

_5              jmp MAIN

                .endproc


;=======================================
;
;=======================================
CheckLevel      .proc
                lda LEVEL
                beq DoLevel1

                cmp #1
                bne _1

                jmp DoLevel2
_1              jmp DoLevel3

                rts
                .endproc


;=======================================
;
;=======================================
DoLevel1        .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;v_???          .var TEMP2
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                lda CHOPPER_STATUS
                cmp #kLAND
                bne _XIT

                lda CHOP_Y
                cmp #35
                blt _XIT

                lda CHOP_X
                cmp #130
                blt _XIT

                cmp #130+6+1
                bge _XIT

                lda SLAVES_LEFT
                bne PSL

                inc LEVEL               ; =1
                jsr GiveBonus
                jsr ClearInfo
                jsr ClearSounds

                lda #STOP_MODE
                sta MODE
                lda #130
                sta TEMP1
                lda #40
                sta TEMP2
                jsr ComputeMapAddr

                lda ADR1
                sta TEMP3
                lda ADR1+1
                sta TEMP4

                lda #3
                sta TEMP2
_next1          jsr MoveRamp

                ldy #5
_next2          ldx #5
                jsr WaitFrame
                jsr Hover

                inc CHOPPER_Y
                dey
                bpl _next2

                lda TEMP3
                sta ADR1
                lda TEMP4
                sta ADR1+1
                dec TEMP2
                bne _next1

                ;-----------------------
                ; Copy Protection
                ;-----------------------
                ; dec MAIN+32
                ;-----------------------

                lda #NEW_LEVEL_MODE
                sta MODE
_XIT            rts
                .endproc


;=======================================
;
;=======================================
PSL             .proc
                jmp PrintSlavesLeft

                .endproc


;=======================================
;
;=======================================
MoveRamp        .proc
;v_???          .var ADR1
;v_???          .var ADR2
;---

                ldx #4
_next1          lda ADR1
                sta ADR2
                ldy ADR1+1
                dey
                sty ADR2+1
                ldy #5
_next2          lda (ADR2),y
                sta (ADR1),y
                dey
                bpl _next2

                dec ADR1+1
                dex
                bpl _next1

                rts
                .endproc


;=======================================
;
;=======================================
DoLevel2        .proc
                lda FORT_STATUS
                cmp #kOFF
                bne _XIT

                lda CHOP_Y
                cmp #2
                bge _XIT

                lda CHOP_X
                cmp #130
                blt _XIT

                cmp #130+4+1
                bge _XIT

                lda SLAVES_LEFT
                bne PSL

                inc LEVEL               ; =2
                jsr GiveBonus

                ;-----------------------
                ; Copy Protection
                ;-----------------------
                ; asl M_NewPlayer
                ;-----------------------

                lda #NEW_LEVEL_MODE
                sta MODE
_XIT            rts
                .endproc


;=======================================
;
;=======================================
DoLevel3        .proc
                lda CHOPPER_STATUS
                cmp #kLAND
                bne _XIT

                lda CHOP_Y
                cmp #13
                bge _XIT

                lda CHOP_X
                cmp #$17
                blt _XIT

                cmp #$F4
                bge _XIT

                jsr GiveBonus

                inc LEVEL               ; =3

                dec M_GameOver
                lda #GAME_OVER_MODE
                sta MODE
_XIT            rts
                .endproc


;=======================================
;
;=======================================
Unpack          .proc
;v_???          .var ADR2
;v_???          .var TEMP2
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

_next1          jsr GetByte

                ldy #0
                ldx TEMP4
                bne _next4

_next2          cmp CHR1,y
                beq _1

                iny
                cpy #CHR1_L
                bne _next2

_next3          ldx #1
                bra _next5

_next4          cmp CHR2,y
                beq _1

                iny
                cpy #CHR2_L
                bne _next4
                bra _next3

_1              sta TEMP1
                jsr GetByte

                tax
                lda TEMP1
_next5          ldy #0
                sta (ADR2),y
                inc ADR2
                bne _2

                inc ADR2+1
_2              dex
                bne _next5

                lda ADR2
                cmp TEMP2
                lda ADR2+1
                sbc TEMP3
                bcc _next1

                rts
                .endproc


;=======================================
;
;=======================================
GetByte         .proc
;v_???          .var ADR1
;---

                ldy #0
                lda (ADR1),y
                inc ADR1
                bne _XIT

                inc ADR1+1
_XIT            rts
                .endproc

;---------------------------------------
;---------------------------------------

CHR1            .byte $00,$61,$0E,$0F,$10,$11,$0A,$0B
                .byte $0C,$0D,$03,$07,$1F,$73,$74

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
CheckModes      .proc
                lda MODE
                cmp #START_MODE
                bne _1
                jmp M_START

_1              cmp #GAME_OVER_MODE
                bne _2
                jmp M_GameOver

_2              cmp #NEW_LEVEL_MODE
                bne _3
                jmp M_NewLevel

_3              cmp #NEW_PLAYER_MODE
                bne _4
                jmp M_NewPlayer

                ;-----------------------
                ; Copy Protection
                ;-----------------------
_4              ; rol CheckModes
                ;-----------------------

                rts
                .endproc


;=======================================
;
;=======================================
M_START         .proc
                jsr ScreenOff
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

                lda #kON
                sta FORT_STATUS
                sta LASER_STATUS

                lda #kEMPTY
                sta FUEL_STATUS

                lda #kOFF
                sta R_STATUS

                ldx GRAV_SKILL
                lda GRAV_TAB,x
                sta GRAV_SKL
                ldx CHOPS
                lda CHOP_TAB,x
                ldy DEMO_STATUS
                bne _1

                lda #2

                ;-----------------------
                ; Copy Protection
                ;-----------------------
_1              ; sta MAIN
                ;-----------------------

                sta CHOP_LEFT

                ldx PILOT_SKILL
                lda LASER_TAB,x
                sta LASER_SPD
                lda POD_TAB,x
                sta START_PODS

                lda ROBOT_TAB,x
                sta ROBOT_SPD

                lda TANK_TAB,x
                sta TANK_SPEED

                lda MISSILE_TAB,x
                sta MISSILE_SPEED

                lda ELEVATOR_TAB,x
                sta ELEVATOR_SPD

                ldx #7
                lda #0
_next1          sta WINDOW_1,x
                sta WINDOW_2,x
                dex
                bpl _next1

                ldx #7
                lda #$55
                ldy RANDOM
                bmi _next3

_next2          sta WINDOW_1,x
                dex
                bpl _next2
                bra _2

_next3          sta WINDOW_2,x
                dex
                bpl _next3

_2              lda #NEW_LEVEL_MODE
                sta MODE
                rts
                .endproc

;---------------------------------------
;---------------------------------------

GRAV_TAB        .byte $F,7
ROBOT_TAB       .byte 3,1,0
CHOP_TAB        .byte $7,$9,$11
LASER_TAB       .byte 4,8,16
POD_TAB         .byte 13-1,26-1,MAX_PODS-1
TANK_TAB        .byte 4
MISSILE_TAB     .byte 3,2,1
ELEVATOR_TAB    .byte 37+25,37+10,37+0


;=======================================
;
;=======================================
M_NewPlayer     .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                jsr ScreenOff

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
                cmp #kEMPTY
                bne _2

                ;-----------------------
                ; Copy Protection
                ;-----------------------
                ; dec UpdateChopper
                ;-----------------------

                lda #kFULL
                sta FUEL_STATUS
                ldx #0
                stx FUEL1
                inx                     ; X=1
                stx FUEL2
_2              lda #4
                sta TEMP1
                lda #8
                sta TEMP2
                ldx #<txtPilot1
                ldy #>txtPilot1
                jsr Print

                lda #5
                sta TEMP1
                lda #10
                sta TEMP2
                ldx #<txtPilot2
                ldy #>txtPilot2
                jsr Print

                lda #<PLAY_SCRN+428
                sta SCRN_ADR
                lda #>PLAY_SCRN+428
                sta SCRN_ADR+1

                ldx #0
                stx SCRN_FLG
                stx DEMO_COUNT
                inx                     ; X=1
                lda CHOP_LEFT
                jsr DoNumbers.DDIG

                jsr DoChecksum2

                ldx #75
                jsr WaitFrame

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

                jsr ScreenOn

                lda #kBEGIN
                sta CHOPPER_STATUS
                lda #GO_MODE
                sta MODE
                rts
                .endproc


;=======================================
;
;=======================================
M_NewLevel      .proc
;v_???          .var ADR1
;v_???          .var ADR2
;v_???          .var TEMP1
;v_???          .var TEMP2
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                jsr ScreenOff

                lda #12
                sta TEMP1
                lda #6
                sta TEMP2
                ldx #<txtEnter
                ldy #>txtEnter
                jsr Print

                lda #2
                sta TEMP1
                lda #8
                sta TEMP2
                ldy LEVEL
                dey                     ; Y=0
                beq _1

                ldx #<txtEnterL1
                ldy #>txtEnterL1
                jsr Print
                jmp _2

_1              ldx #<txtEnterL2
                ldy #>txtEnterL2
                jsr Print

_2              ldx LEVEL
                lda LEVEL_COLOR,x
                sta BAK_COLOR
                sta COLOR0
                txa
                asl
                tax
                lda LEVEL_START,x
                sta SX
                lda LEVEL_START+1,x
                sta SY

                lda LEVEL_CHOP_START,x
                sta CHOPPER_X
                lda LEVEL_CHOP_START+1,x
                sta CHOPPER_Y

                lda #0
                sta SX_F
                ldy LEVEL
                cpy #2
                beq _3

                lda #7
_3              sta SY_F
                lda #8
                sta CHOPPER_ANGLE

                jsr RestorePoint
                jsr DoChecksum3

                lda #$99
                sta BONUS1
                sta BONUS2

                ldx #MAX_TANKS-1
_next1          ldy LEVEL
                dey
                beq _4

                lda TANK_START_X_L1,x
                sta TANK_START_X,x
                lda TANK_START_Y_L1,x
                bra _5

_4              lda TANK_START_X_L2,x
                sta TANK_START_X,x
                lda TANK_START_Y_L2,x
_5              sta TANK_START_Y,x

                lda #kBEGIN
                sta TANK_STATUS,x

                lda #kOFF
                sta CM_STATUS,x

                dex
                bpl _next1

                sta R_STATUS
                ldx #MAX_PODS-1
_next2          sta POD_STATUS,x
                dex
                bpl _next2

                ldx START_PODS
                lda #kBEGIN
_next3          sta POD_STATUS,x
                dex
                bpl _next3

                lda #0
                sta POD_NUM
                sta SLAVE_NUM

                lda LEVEL
                asl
                tax
                lda PACK_ADR,x
                sta ADR1
                lda PACK_ADR+1,x
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
                jsr Unpack

MAKE_CONTURE    .block
                lda #<MAP
                sta ADR1
                lda #>MAP
                sta ADR1+1

                ldy #0
_next1          lda (ADR1),y
                cmp #$73                ; 's'
                bne _1

_next2          lda RANDOM
                and #3
                beq _next2

                clc
                adc #$62-1
                bra _2

_1              cmp #$74                ; 't'
                bne _2

_next3          lda RANDOM
                and #3
                beq _next3

                clc
                adc #$65-1
_2              sta (ADR1),y
                iny
                bne _next1

                inc ADR1+1
                lda ADR1+1
                cmp #>MAP+$2800
                bne _next1

                lda #<MAP
                sta ADR1
                lda #>MAP
                sta ADR1+1

                lda #<MAP+255-40
                sta ADR2
                lda #>MAP+255-40
                sta ADR2+1

                ldx #0
_next4          ldy #0
_next5          lda (ADR1),y
                sta (ADR2),y
                iny
                cpy #40
                bne _next5

                inc ADR1+1
                inc ADR2+1
                inx
                cpx #40
                bne _next4

                ldy LEVEL
                cpy #2
                bne _3

                lda #$7E
                sta TEMP1
                lda #$13
                sta TEMP2
                jsr ComputeMapAddr

                ldx #2
_next6          ldy #$D
                lda #0
_next7          sta (ADR1),y
                dey
                bpl _next7

                inc ADR1+1
                dex
                bpl _next6

_3              lda LEVEL
                asl
                tax

                lda SCAN_INFO,x
                sta ADR1
                lda SCAN_INFO+1,x
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
                jsr Unpack

                lda #<SCANNER
                sta ADR1
                lda #>SCANNER
                sta ADR1+1
                lda #<SCANNER+$1B
                sta ADR2
                lda #>SCANNER+$1B
                sta ADR2+1

                ldx #39
_next8          ldy #12
_next9          lda (ADR1),y
                sta (ADR2),y
                dey
                bpl _next9

                lda ADR1
                clc
                adc #40
                sta ADR1
                bcc _4

                inc ADR1+1
_4              lda ADR2
                clc
                adc #40
                sta ADR2
                bcc _5

                inc ADR2+1
_5              dex
                bpl _next8

                ;-----------------------
                ; Copy Protection
                ;-----------------------
                ; inc MAIN
                ;-----------------------

                .endblock


S_BEGIN         .block
                ldx #8
                stx SLAVES_LEFT
                dex                     ; X=7
                lda #kOFF
_next1          sta SLAVE_STATUS,x
                dex
                bpl _next1

                lda LEVEL
                cmp #2
                beq _2

                ldx #7
_next2          lda #<MAP
                sta ADR1
                lda #>MAP
                sta ADR1+1

                ldy #0
_next3          lda (ADR1),y
                cmp #$48                ; '^H'
                bne _1

                iny
                lda (ADR1),y
                dey
                cmp #$48
                bne _1

                dec ADR1+1
                lda (ADR1),y
                inc ADR1+1
                cmp #$1F                ; '?'
                bne _1

                lda RANDOM
                cmp #10
                blt _1

                cmp #50
                bge _1

                tya
                clc
                adc #5
                sta SLAVE_X,x
                lda ADR1+1
                sec
                sbc #>MAP
                sta SLAVE_Y,x

                lda #1
                sta (ADR1),y

                lda #kON
                sta SLAVE_STATUS,x

                lda #$10
                sta SLAVE_DX,x
                dex
                bmi _2

_1              iny
                bne _next3

                inc ADR1+1
                lda ADR1+1
                cmp #>MAP+$2800
                bne _next3

                txa
                bpl _next2

_2              lda #NEW_PLAYER_MODE
                sta MODE
                rts
                .endblock
                .endproc

;---------------------------------------
;---------------------------------------

LEVEL_COLOR     .byte $42
                .byte $C2
                .byte $42
LEVEL_CHOP_START
                .byte 90,100
                .byte 119,100
                .byte 116,170
LEVEL_START     .byte $02,$FF
                .byte $6D,$FF
                .byte $6E,$18
SCAN_INFO       .addr PACKED_SCAN+0     ; LVL 1
                .addr PACKED_SCAN+$1E9  ; LVL 2
                .addr PACKED_SCAN+0     ; LVL 1
TANK_START_X_L1 .byte $53,$63,$90,$A0,$59,$AE
TANK_START_Y_L1 .byte $12,$12,$12,$12,$26,$26
TANK_START_X_L2 .byte $50,$65,$A0,$B5,$3D,$54
TANK_START_Y_L2 .byte $0C,$0C,$0C,$0C,$26,$26


;=======================================
;
;=======================================
IncreaseGamePoints .proc
                clc
                adc GAME_POINTS
                sta GAME_POINTS
                rts
                .endproc

;---------------------------------------
;---------------------------------------

M_TAB           .char -2,-1,0


;=======================================
;
;=======================================
M_GameOver      .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                jsr ScreenOff

                lda SLAVES_SAVED
                lsr
                lsr
                jsr IncreaseGamePoints
                lda FORT_STATUS
                cmp #kOFF
                bne _1

                lda #3
                jsr IncreaseGamePoints

_1              lda LEVEL
                cmp #3
                bne _2

                inc GAME_POINTS
_2              jsr IncreaseGamePoints

                lda SCORE3
                jsr IncreaseGamePoints

                ldx GRAV_SKILL
                lda M_TAB,x
                jsr IncreaseGamePoints

                lda #2
                clc
                sbc CHOPS
                eor #-1
                jsr IncreaseGamePoints

                ldx PILOT_SKILL
                lda M_TAB,x
                jsr IncreaseGamePoints

                lda GAME_POINTS
                bpl _3

                lda #0
_3              cmp #16
                blt _4

                lda #15
_4              sta GAME_POINTS

                lda SCORE3
                cmp HI3
                bne _5

                lda SCORE2
                cmp HI2
                bne _5

                lda SCORE1
                cmp HI1
                blt _6

_next1          lda SCORE1
                sta HI1
                lda SCORE2
                sta HI2
                lda SCORE3
                sta HI3
                jmp _6

_5              bge _next1

_6              lda #2
                sta TEMP1
                lda #0
                sta TEMP2
                sta SCRN_FLG
                ldx #<txtHighScore
                ldy #>txtHighScore
                jsr Print

                lda #<PLAY_SCRN+24
                sta SCRN_ADR
                lda #>PLAY_SCRN+24
                sta SCRN_ADR+1

                ldx #5
                lda HI3
                jsr DoNumbers.DDIG

                lda HI2
                jsr DoNumbers.DDIG

                lda HI1
                jsr DoNumbers.DDIG

                lda #3
                sta TEMP1
                lda #5
                sta TEMP2
                ldx #<txtGmOvrMission   ; YOUR
                ldy #>txtGmOvrMission   ; MISSION
                jsr Print

                lda #21
                sta TEMP1
                ldx #<txtGmOvrAbort     ; ABORTED
                ldy #>txtGmOvrAbort
                lda LEVEL
                cmp #3
                bne _7

                ldx #<txtGmOvrComplete  ; COMPLETED
                ldy #>txtGmOvrComplete
_7              jsr Print

                ldx #7
                stx TEMP1
                inx                     ; X=8
                stx TEMP2
                ldx #<txtGmOvrRank      ; YOUR
                ldy #>txtGmOvrRank      ; RANK
                jsr Print

                lda #21
                sta TEMP1
                lda #10
                sta TEMP2
                ldx #<txtGmOvrClass     ; CLASS
                ldy #>txtGmOvrClass
                jsr Print

                lda GAME_POINTS
                and #3
                eor #3
                clc
                adc #1
                ldy #12
                ora #$10+$80
                sta (ADR1),y
                cmp #$10+128
                bne _8

                lda #$A+128
_8              iny
                and #$8F
                sta (ADR1),y
                lda #3
                sta TEMP1
                lda GAME_POINTS
                lsr
                lsr
                and #3
                asl
                tay
                ldx txtGmOvrRating,y
                lda txtGmOvrRating+1,y
                tay
                jsr Print

                lda #-1
                sta TIM6_VAL

                ;-----------------------
                ; Copy Protection
                ;-----------------------
                ; ror ScreenOff
                ;-----------------------

                lda #TITLE_MODE
                sta MODE
                sta DEMO_STATUS
                rts
                .endproc


;=======================================
;
;=======================================
DoExplode       .proc
                ldx #7
_next1          lda EXP_SHAPE,x
                and RANDOM
                sta EXPLOSION,x
                sta EXPLOSION2,x
                dex
                bpl _next1

                ldx #3
_next2          lda RANDOM
                and #$0F
                ora #$A0
                sta MISS_CHR_LEFT,x
                inx
                cpx #5
                bne _next2

                ldx #3
_next3          lda RANDOM
                and #$E0
                ora #$0A
                sta MISS_CHR_RIGHT,x
                inx
                cpx #5
                bne _next3

                rts
                .endproc


;=======================================
;
;=======================================
DoNumbers       .proc
                lda MODE
                cmp #NEW_PLAYER_MODE
                beq _XIT

                cmp #GAME_OVER_MODE
                bne DO_N

_XIT            rts

; SCORE
DO_N            .block
                lda #<SCORE_DIG
                sta SCRN_ADR
                lda #>SCORE_DIG
                sta SCRN_ADR+1

                lda #0
                sta SCRN_FLG
                ldx #5
                lda SCORE3
                jsr DDIG

                lda SCORE2
                jsr DDIG

                lda SCORE1
                jsr DDIG

; DEC BONUS
                lda MODE
                cmp #GO_MODE
                bne _1

                lda BONUS1
                ora BONUS2
                beq _1

                lda FRAME
                and #7
                bne _1

                sed
                lda BONUS1
                sec
                sbc #1
                sta BONUS1
                lda BONUS2
                sbc #0
                sta BONUS2
                cld

; BONUS
_1              lda #<BONUS_DIG
                sta SCRN_ADR
                lda #>BONUS_DIG
                sta SCRN_ADR+1

                lda #0
                sta SCRN_FLG
                ldx #3
                lda BONUS2
                jsr DDIG

                lda BONUS1
                jsr DDIG

; DEC FUEL
                lda MODE
                cmp #GO_MODE
                bne _3

                lda FUEL_STATUS
                cmp #kFULL
                bne _3

                lda FUEL1
                ora FUEL2
                beq _2

                lda FRAME
                and #15
                bne _3

                sed
                lda FUEL1
                sec
                sbc #1
                sta FUEL1
                lda FUEL2
                sbc #0
                sta FUEL2
                cld
                jmp _3

_2              lda #kEMPTY
                sta FUEL_STATUS

; FUEL
_3              lda #<FUEL_DIG
                sta SCRN_ADR
                lda #>FUEL_DIG
                sta SCRN_ADR+1

                lda #0
                sta SCRN_FLG
                ldx #3
                lda FUEL2
                jsr DDIG

                lda FUEL1
                .endblock


DDIG            .block                  ; DRAW DIGIT
                tay
                lda SCRN_FLG
                bne _1

                tya
                and #$F0
                bne _1

                tya
                ora #$A0
                tay
                bne _2

_1              lda #1
                sta SCRN_FLG
_2              lda SCRN_FLG
                bne _3

                tya
                and #$F
                bne _3

                tya
                ora #$A
                tay
                bne _4

_3              lda #1
                sta SCRN_FLG
_4              tya
                sta SCRN_TEMP
                lsr
                lsr
                lsr
                lsr
                jsr DRAW

                lda SCRN_TEMP
                and #$F
                .endblock


DRAW            .block
                cmp #$A
                bne _2

                cpx #0
                bne _1

                lda #0
                bra _2

_1              lda #<$F0+128           ; BLANK
_2              clc
                adc #$10+128            ; '0'
                ldy #0
                sta (SCRN_ADR),y
                cmp #$10+128
                bne _3

                lda #$A+128
_3              iny
                and #$8F
                sta (SCRN_ADR),y
                lda SCRN_ADR
                clc
                adc #2
                sta SCRN_ADR
                lda SCRN_ADR+1
                adc #0
                sta SCRN_ADR+1
                dex
                rts
                .endblock
                .endproc


;=======================================
;
;=======================================
IncreaseScore   .proc
                lda DEMO_STATUS
                beq _XIT

                sed
                txa
                clc
                adc SCORE1
                sta SCORE1

                tya
                adc SCORE2
                sta SCORE2

                lda SCORE3
                adc #0
                sta SCORE3
                cld
_XIT            rts
                .endproc

;---------------------------------------
;---------------------------------------

DEMO_STICK
                .byte $0B,$0B,$0B,$0B,$09,$09,$09,$09
                .byte $09,$09,$0A,$0A,$0A,$0A,$0B,$09
                .byte $09,$0B,$0A,$0A,$0B,$09,$0B,$0A
                .byte $0B,$09,$0B,$0A,$0A,$0A,$0A,$0B
                .byte $0B,$09,$09,$0B,$0B,$0A,$09,$0D
                .byte $09,$0B,$0A,$0A,$0A,$0A,$0A,$0A
                .byte $0B,$09,$09,$09,$0A,$0E,$06,$07
                .byte $07,$07,$05,$05,$05,$05,$07,$06
                .byte $06,$07,$05,$06,$06,$07,$05,$05
                .byte $07,$06,$05,$07,$07,$07,$06,$06
                .byte $06,$06,$06,$07,$07,$06,$05,$05
                .byte $07,$06,$06,$07,$05,$05,$06,$06
                .byte $06,$06,$07,$05,$05,$07,$06,$06
                .byte $07,$06,$09,$09

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
