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

;=======================================
; Space = toggle Pause Mode
; Option (F2) = delegate to Opt handler
; Select (F3) = delegate to Opt handler
; Start (F4) = switch to Start Mode
;---------------------------------------
; Any activity will cancel the Demo
; All keypresses are delegated to the
;   Option screen while in Option mode
; Capture (endless loop) while Pasused
;=======================================
ReadKeyboard    .proc
v_demoTimer     .var TIM6_VAL
;---

                lda CONSOL              ; read the console keys
                cmp CONSOL_FLAG         ; update consol_flag if it has changed
                beq _doSelect
                sta CONSOL_FLAG

                ldx #0                  ; reset inactivity timer
                stx v_demoTimer

                cmp #6                  ; START pressed? (0=pressed)
                bne _chk_mode

                lda #START_MODE         ; MODE=START
                sta MODE
                sta DEMO_STATUS         ; disable Demo
                jmp _XIT

_chk_mode       ldx MODE                ; Options Screen has its own handler
                cpx #OPTION_MODE        ; continue if not on the Options screen
                bne _determine_key

                jsr CheckOptions       ; transfer to the Option handler
                jmp _XIT
_determine_key  cmp #3                  ; OPTION pressed?
                beq _doOption

                cmp #5                  ; SELECT pressed?
                bne _doSelect

_doOption       lda #OPTION_MODE        ; switch to Options screen
                sta MODE
                sta DEMO_STATUS         ; disable Demo
                jsr ScreenOff           ; update display

                lda #0
                sta OPT_NUM
                jsr CheckOptions        ; transfer to the Option handler
                jmp _XIT

_doSelect       lda SKSTAT              ; is the key still pressed?
                and #%00000100
                bne _XIT                ; still pressed then exit

                lda KBCODE              ; was it the spacebar?
                cmp #$21
                bne _XIT                ; ignore other keys... exit

                lda MODE                ; enter Pause mode
                pha
                lda #PAUSE_MODE         ; MODE=PAUSE
                sta MODE
                jsr ClearSounds         ; stop sounds

_wait1          lda SKSTAT              ; capture...
                and #%00000100
                beq _wait1              ; don't leave until we exist Pause mode

_next1          lda SKSTAT              ; is the key still pressed?
                and #%00000100
                bne _debounce

                lda KBCODE              ; was it the spacebar?
                cmp #$21
                beq _wait2              ; exit once the key is released

_debounce       lda CONSOL              ; debounce... ensure all three console keys are released
                cmp #7
                bne _wait2

                lda TRIG0               ; exit after debounce if trigger is pressed
                bne _next1

_wait2          lda SKSTAT              ; debounce... wait for release
                and #%00000100
                beq _wait2

                pla
                sta MODE
_XIT            rts
                .endproc


;=======================================
;
;=======================================
CheckOptions   .proc
;v_???          .var ADR1
;v_???          .var ADR2
v_posX          .var TEMP1
v_posY          .var TEMP2
;v_???          .var TEMP5
;v_???          .var TEMP6
;---

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
                sta v_posX
                lda #1
                sta v_posY
                ldx #<txtOptTitle1
                ldy #>txtOptTitle1
                jsr Print               ; (13, 1) 'OPTIONS'

                lda #0
                sta v_posX
                lda #3
                sta v_posY
                ldx #<txtOptTitle2
                ldy #>txtOptTitle2
                jsr Print               ; (0, 3) 'OPTION'

                lda #28
                sta v_posX
                ldx #<txtOptTitle3
                ldy #>txtOptTitle3
                jsr Print               ; (28, 3) 'SELECT'

PrintOptions      .block
                lda #0
                sta v_posX
                lda #7
                sta v_posY
                ldx #<txtOptGravity
                ldy #>txtOptGravity
                jsr Print               ; (0, 7) 'GRAVITY SKILL'

                inc v_posY
                inc v_posY
                ldx #<txtOptPilot
                ldy #>txtOptPilot
                jsr Print               ; (0, 9) 'PILOT SKILL'

                inc v_posY
                inc v_posY
                ldx #<txtOptRobo
                ldy #>txtOptRobo
                jsr Print               ; (0, 11) 'ROBO PILOTS'

                lda OPT_NUM
                asl
                clc
                adc #7                  ; OPTION
                sta v_posY
                lda OPT_NUM
                asl
                tax
                lda OptTable,x
                sta ADR2
                lda OptTable+1,x
                sta ADR2+1
                jsr CalcCursorLoc

                ldy #0
                sty TEMP5
                sty TEMP6
_next1          ldy TEMP5
                lda (ADR2),y
                beq _1
                cmp #$FF
                beq _2

                ora #$80
                ldy TEMP6
                sta (ADR1),y
                inc TEMP6
                clc
                adc #32
_1              ldy TEMP6
                sta (ADR1),y
                inc TEMP6
                inc TEMP5
                bne _next1                  ; FORCED

_2              lda #28
                sta v_posX
                lda #7
                sta v_posY
                lda GRAV_SKILL
                asl
                tay
                ldx OptGravityTable,y
                lda OptGravityTable+1,y
                tay
                jsr Print               ; (28, 7) 'WEAK|NORMAL|STRONG'

                inc v_posY
                inc v_posY
                lda PILOT_SKILL
                asl
                tay
                ldx OptPilotTable,y
                lda OptPilotTable+1,y
                tay
                jsr Print               ; (28, 9) 'NOVICE|PRO|EXPERT'

                inc v_posY
                inc v_posY
                lda CHOPS
                asl
                tay
                ldx OptRoboTable,y
                lda OptRoboTable+1,y
                tay
                jmp Print               ; (28, 11) 'SEVEN|NINE|ELEVEN'

                .endblock
                .endproc

;---------------------------------------
;---------------------------------------

txtOptTitle1    .byte $2F,$30,$34,$29,$2F,$2E,$33           ; 'OPTIONS' atari-ascii
                .byte $FF
txtOptTitle2    .byte $2F,$30,$34,$29,$2F,$2E               ; 'OPTION'
                .byte $FF
txtOptTitle3    .byte $33,$25,$2C,$25,$23,$34               ; 'SELECT'
                .byte $FF

txtOptGravity   .byte $27,$32,$21,$36,$29,$34,$39,$00       ; 'GRAVITY '
                .byte $33,$2B,$29,$2C,$2C                   ; 'SKILL'
                .byte $FF
txtOptPilot     .byte $30,$29,$2C,$2F,$34,$00               ; 'PILOT '
                .byte $33,$2B,$29,$2C,$2C                   ; 'SKILL'
                .byte $FF
txtOptRobo      .byte $32,$2F,$22,$2F,$00                   ; 'ROBO '
                .byte $30,$29,$2C,$2F,$34,$33               ; 'PILOTS'
                .byte $FF

txtOptGravity1  .byte $37,$25,$21,$2B,$00,$00,$00,$00       ; 'WEAK    '
                .byte $FF
txtOptGravity2  .byte $2E,$2F,$32,$2D,$21,$2C               ; 'NORMAL'
                .byte $FF
txtOptGravity3  .byte $33,$34,$32,$2F,$2E,$27               ; 'STRONG'
                .byte $FF

txtOptPilot1    .byte $2E,$2F,$36,$29,$23,$25               ; 'NOVICE'
                .byte $FF
txtOptPilot2    .byte $30,$32,$2F,$00,$00,$00,$00,$00       ; 'PRO      '
                .byte $00
                .byte $FF
txtOptPilot3    .byte $25,$38,$30,$25,$32,$34               ; 'EXPERT'
                .byte $FF

txtOptRobo1     .byte $33,$25,$36,$25,$2E,$00,$00,$00       ; 'SEVEN   '
                .byte $FF
txtOptRobo2     .byte $2E,$29,$2E,$25,$00,$00,$00,$00       ; 'NINE    '
                .byte $FF
txtOptRobo3     .byte $25,$2C,$25,$36,$25,$2E               ; 'ELEVEN'
                .byte $FF

OptGravityTable .addr txtOptGravity1,txtOptGravity2,txtOptGravity3
OptPilotTable   .addr txtOptPilot1,txtOptPilot2,txtOptPilot3
OptRoboTable    .addr txtOptRobo1,txtOptRobo2,txtOptRobo3

OptTable        .addr txtOptGravity,txtOptPilot,txtOptRobo


;=======================================
;
;=======================================
MovePods        .proc
                lda #POD_SPEED
_next1          pha
                jsr MovePods1

                pla
                sec
                sbc #1
                bne _next1

                rts
                .endproc


;=======================================
;
;=======================================
MovePods1       .proc
                ldx POD_NUM

                lda POD_STATUS,x
                sta POD_COM
                and #$0F
                cmp #OFF
                beq PodsEnd

                cmp #BEGIN
                bne _1

                jmp PodBegin

_1              jsr PodCollision
                bcs PodsEnd

                jsr PodErase
                jsr PodMove
                jsr PodDraw
                .endproc

                ;[fall-through]


;=======================================
;
;=======================================
PodsEnd         .proc
                ldx POD_NUM
                inx
                cpx #MAX_PODS
                blt _1

                ldx #0
_1              stx POD_NUM
                rts
                .endproc


;=======================================
;
;=======================================
GetPodAddr      .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda POD_X,x
                sta TEMP1
                lda POD_Y,x
                sta TEMP2
                jmp ComputeMapAddr

                .endproc

;=======================================
;
;=======================================
GetPodValue     .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                jsr GetPodAddr

                ldy #0
                lda (ADR1),y
                sta TEMP1
                iny
                lda (ADR1),y
                sta TEMP2
                rts
                .endproc


;=======================================
;
;=======================================
PutPodValue     .proc
;v_???          .var ADR1
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                jsr GetPodAddr

                ldy #0
                lda TEMP3
                sta (ADR1),y
                iny
                lda TEMP4
                sta (ADR1),y
                rts
                .endproc


;=======================================
;
;=======================================
PositionPod     .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda POD_X,x
                sta TEMP1
                lda POD_Y,x
                sta TEMP2
                jmp PositionIt

                .endproc


;=======================================
;
;=======================================
PodBegin        .proc
;v_???          .var ADR1
;---

_next1          lda RANDOM
                cmp #50
                blt _next1

                cmp #256-50
                bge _next1

                sta POD_X,x
_next2          lda RANDOM
                cmp #40
                bge _next2

                sta POD_Y,x
                jsr GetPodAddr

                ldy #0
                lda (ADR1),y
                iny
                ora (ADR1),y
                bne _next1

                lda #ON
                sta POD_STATUS,x
                sta POD_COM
                jsr PodDraw

                lda #$01
                sta POD_DX,x
                jmp PodsEnd

                .endproc


;=======================================
;
;=======================================
PodCollision    .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                jsr GetPodValue
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

_1              jsr PodErase

                lda #OFF
                sta POD_STATUS,x
                ldx #$50
                ldy #$00
                jsr IncreaseScore

                sec
                rts
                .endproc


;=======================================
;
;=======================================
PodErase        .proc
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                jsr PositionPod

                lda POD_TEMP1,x
                sta TEMP3
                lda POD_TEMP2,x
                sta TEMP4
                jmp PutPodValue

                .endproc


;=======================================
;
;=======================================
PodDraw         .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                jsr PositionPod
                jsr GetPodValue

                lda TEMP1
                sta POD_TEMP1,x
                lda TEMP2
                sta POD_TEMP2,x
                lda POD_COM
                lsr
                lsr
                lsr
                tay
                lda POD_CHR,y
                sta TEMP3
                lda POD_CHR+1,y
                sta TEMP4
                jmp PutPodValue

                .endproc


;=======================================
;
;=======================================
PodMove         .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

_next1          lda POD_DX,x
                bpl _1

                lda POD_COM
                sec
                sbc #$10
                and #$3F
                sta POD_COM
                and #$F0
                cmp #$30
                bne _2

                dec POD_X,x
                jmp _2

_1              lda POD_COM
                clc
                adc #$10
                and #$3F
                sta POD_COM
                and #$F0
                bne _2

                inc POD_X,x
_2              lda POD_X,x
                sta TEMP1
                lda POD_Y,x
                sta TEMP2
                jsr ComputeMapAddr

                ldy #0
                lda (ADR1),y
                iny
                ora (ADR1),y
                bne _3

                lda POD_X,x
                cmp #50
                blt _3

                cmp #256-50
                blt _4

_3              lda POD_DX,x
                eor #-2
                sta POD_DX,x
                jmp _next1

_4              lda POD_COM
                sta POD_STATUS,x
                rts
                .endproc

;---------------------------------------
;---------------------------------------

POD_CHR         .byte $40,$00
                .byte $5B,$5C
                .byte $5D,$5E
                .byte $00,$5F


;=======================================
;
;=======================================
MoveCruiseMissiles .proc
                dec MISSILE_SPD
                bne MCE

                lda MISSILE_SPEED
                sta MISSILE_SPD

                ldx #MAX_TANKS-1


M_ST            .block
                lda CM_STATUS,x
                cmp #OFF
                beq M_END

                cmp #BEGIN
                bne _1

                jmp MissileBegin

_1              jsr MissileCollision

                bcs M_END

                jsr MissileErase
                jsr MissileMove
                jsr MissileDraw

                .endblock


M_END           .block
                lda TANK_STATUS,x
                cmp #ON
                bne _2

                lda TANK_Y,x
                sec
                sbc CHOP_Y
                bmi _2

                cmp #14
                bge _2

                lda CM_STATUS,x
                cmp #OFF
                bne _2

                lda CHOP_X
                sec
                sbc #2
                sbc TANK_X,x
                bpl _1

                eor #-2
_1              cmp #9
                bge _2

                lda #BEGIN
                sta CM_STATUS,x
_2              dex
                bpl M_ST

                .endblock


MCE             .block
                ldx #MAX_TANKS-1
_next1          lda CM_STATUS,x
                cmp #OFF
                bne _XIT

                dex
                bpl _next1

                lda #0
                sta AUDC4
                sta SND6_VAL
_XIT            rts
                .endblock
                .endproc


;=======================================
;
;=======================================
GetMissileAddr  .proc
v_posX          .var TEMP1
v_posY          .var TEMP2
;---

                lda CM_X,x
                sta v_posX
                lda CM_Y,x
                sta v_posY
                jmp ComputeMapAddr

                .endproc


;=======================================
;
;=======================================
MissileBegin    .proc
                ldy TANK_X,x
                iny
                tya
                sta CM_X,x
                lda TANK_Y,x
                sec
                sbc #2
                sta CM_Y,x
                ldy #LEFT
                lda CHOP_X
                sec
                sbc TANK_X,x
                bmi _1

                ldy #RIGHT
_1              tya
                sta CM_STATUS,x
                lda #0
                sta CM_TEMP,x
                lda #20
                sta CM_TIME,x
                lda #1
                sta SND6_VAL
                jmp MoveCruiseMissiles.M_END

                .endproc


;=======================================
;
;=======================================
MissileCollision .proc
;v_???          .var ADR1
v_preserveX     .var TEMP1
;---

                jsr GetMissileAddr

                ldy #0
                lda (ADR1),y
                cmp #EXP
                beq M_COL2

                clc
                rts

M_COL2          jsr MissileErase

                lda #1
                sta SND3_VAL
                lda #OFF
                sta CM_STATUS,x

                lda #-1
                sta CM_TIME,x

                stx v_preserveX
                ldx #$10
                ldy #$00
                jsr IncreaseScore

                ldx v_preserveX

                sec
                rts
                .endproc


;=======================================
;
;=======================================
MissileErase    .proc
;v_???          .var ADR1
;---

                jsr GetMissileAddr

                lda CM_TEMP,x
                cmp #EXP_WALL
                beq _1

                cmp #$60+128
                bge _XIT

                cmp #$40
                beq _XIT

                cmp #$5B
                blt _1

                cmp #$5F+1
                blt _XIT

_1              ldy #0
                sta (ADR1),y
_XIT            rts
                .endproc


;=======================================
;
;=======================================
MissileMove     .proc
;v_???          .var ADR1
v_distance      .var TEMP1
;---

                lda CM_STATUS,x
                cmp #LEFT
                beq _1

                inc CM_X,x
                jmp _2

_1              dec CM_X,x
_2              lda CM_TIME,x
                bpl _3

_next1          inc CM_Y,x
                jmp _6

_3              lda CHOP_X
                sec
                sbc CM_X,x
                sta v_distance

                lda CM_STATUS,x
                cmp #LEFT
                bne _4

                lda v_distance
                bpl _next1
                bmi _5                  ; FORCED

_4              lda v_distance
                bmi _next1

_5              lda CM_X,x
                cmp #$D8
                bge _next1

                cmp #$2D
                blt _next1

                ldy CHOP_Y
                iny
                tya
                sec
                sbc CM_Y,x
                beq _6
                bpl _next2

                dec CM_Y,x
                jmp _6

_next2          inc CM_Y,x
_6              jsr GetMissileAddr

                ldy #0
                lda (ADR1),y
                cmp #MISS_LEFT
                beq _next2

                cmp #MISS_RIGHT
                beq _next2

                lda CM_TIME,x
                bmi _XIT

                dec CM_TIME,x
_XIT             rts
                .endproc


;=======================================
;
;=======================================
MissileDraw     .proc
;v_???          .var ADR1
;---

                jsr GetMissileAddr

                ldy #0
                lda (ADR1),y
                sta CM_TEMP,x
                lda #MISS_LEFT
                ldy CM_STATUS,x
                cpy #LEFT
                beq _1

                lda #MISS_RIGHT
_1              ldy #0
                sta (ADR1),y
                lda CM_TEMP,x
                jsr CheckChr

                bcc _XIT
                jmp MissileCollision.M_COL2

_XIT            rts
                .endproc


;=======================================
;
;=======================================
CheckHyperchamber .proc
                lda MODE
                cmp #HYPERSPACE_MODE
                bne _XIT

                lda #STOP_MODE
                sta MODE

                lda #$F
                sta BAK2_COLOR

                ldx #2
                jsr WaitFrame

                lda #$0
                sta BAK2_COLOR

                lda RANDOM
                and #3

                tax
                lda H_XF,x
                sta SX_F
                lda H_YF,x
                sta SY_F

                lda H_X,x
                sta SX
                lda H_Y,x
                sta SY

                lda H_CX,x
                sta CHOPPER_X
                lda H_CY,x
                sta CHOPPER_Y

                lda #8
                sta CHOPPER_ANGLE

                lda #0
                sta CHOPPER_COL

                lda #GO_MODE
                sta MODE
_XIT            rts
                .endproc

;---------------------------------------
;---------------------------------------

H_XF            .byte $DD,$76,$10,$4B
H_YF            .byte $7A,$7B,$B8,$B8
H_X             .byte $22,$BC,$55,$87
H_Y             .byte $0F,$0F,$18,$18
H_CX            .byte $73,$78,$76,$75
H_CY            .byte $8C,$89,$AF,$AF


;=======================================
;
;=======================================
CheckChr        .proc
;v_???          .var ADR2
;---

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
_next1          lda (ADR2),y
                bne _XIT

                dey
                bpl _next1

                clc
                rts

_XIT            sec
                rts
                .endproc


;=======================================
;
;=======================================
PositionTank    .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda TANK_X,x
                sta TEMP1

                ldy TANK_Y,x
                dey
                sty TEMP2

                jsr PositionIt

                lda TANK_Y,x
                sta TEMP2
                rts
                .endproc


;=======================================
;
;=======================================
MoveTanks       .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

MT1             .block
                dec TANK_SPD
                beq _1
                jmp MT2

_1              lda TANK_SPEED
                sta TANK_SPD

                ldx #MAX_TANKS-1

_next1          lda TANK_Y,x
                sta TEMP2
                lda TANK_STATUS,x
                cmp #OFF
                bne _2

                jmp _9

_2              cmp #BEGIN
                bne _4

                lda #ON
                sta TANK_STATUS,x
                lda TANK_START_X,x
                sta TANK_X,x
                lda TANK_START_Y,x
                sta TANK_Y,x
                lda #-1
                ldy RANDOM
                bpl _3

                lda #1
_3              sta TANK_DX,x
                jsr PositionTank
                jmp _next4

_4              cmp #CRASH
                bne _5
                jmp _9

; RESTORE OLD POS
_5              lda TANK_X,x
                sta TEMP1
                jsr ComputeMapAddr

                stx TEMP1
                ldy #0
                txa
                asl
                adc TEMP1
                tax
_next2          lda (ADR1),y
                cmp #EXP
                beq _6

                cmp #MISS_LEFT
                beq _6

                cmp #MISS_RIGHT
                bne _7

_6              ldx TEMP1
                lda #CRASH
                sta TANK_STATUS,x
                ldy #2
                lda #EXP
_next3          sta (ADR1),y
                dey
                bpl _next3

                lda #10
                sta TIM5_VAL
                jmp _9

_7              lda TANK_TEMP,x
                sta (ADR1),y
                inx
                iny
                cpy #3
                bne _next2

                ldy #1
                dec ADR1+1
                lda #0
                sta (ADR1),y

; MOVE X
                ldx TEMP1
_next4          jsr PositionTank

                lda TANK_X,x
                clc
                adc TANK_DX,x
                sta TANK_X,x

; SAVE NEW POS
                jsr PositionTank

                lda TANK_X,x
                sta TEMP1
                jsr ComputeMapAddr

                stx TEMP1
                ldy #0
                txa
                asl
                adc TEMP1
                tax
_next5          lda (ADR1),y
                sta TANK_TEMP,x
                inx
                iny
                cpy #3
                bne _next5

; check for collision
                ldx TEMP1
                ldy #0
                jsr CheckTankCollision

                bcs _next4
                ldy #2
                jsr CheckTankCollision

                bcs _next4

; DRAW TANK
                ldy #2
_next6          lda TANK_SHAPE,y
                sta (ADR1),y
                dey
                bpl _next6

                dec ADR1+1
                ldy #$6F+128            ; 'o'
                lda CHOP_X
                sec
                sbc TANK_X,x
                bpl _8

                ldy #$70+128            ; 'p'
_8              tya
                ldy #1
                sta (ADR1),y

_9              dex
                bmi MT2

                jmp _next1

                .endblock

MT2             .block
                dec TIM5_VAL
                bne _XIT

                lda #10
                sta TIM5_VAL

                ldx #MAX_TANKS-1
_next1          lda TANK_STATUS,x
                cmp #CRASH
                bne _1

                lda #OFF
                sta TANK_STATUS,x
                lda TANK_X,x
                sta TEMP1
                lda TANK_Y,x
                sta TEMP2
                jsr ComputeMapAddr

                stx TEMP1
                ldy #0
                txa
                asl
                adc TEMP1
                tax
_next2          lda TANK_TEMP,x
                sta (ADR1),y
                inx
                iny
                cpy #3
                bne _next2

                dec ADR1+1
                ldy #1
                lda #0
                sta (ADR1),y
                ldx #$50
                ldy #$2
                jsr IncreaseScore

                ldx TEMP1
                jsr PositionTank

_1              lda TANK_STATUS,x
                cmp #OFF
                bne _2

                lda CHOP_Y
                cmp #3
                blt _2

                sec
                sbc #3
                cmp TANK_START_Y,x
                blt _2

                lda TANK_START_X,x
                sec
                sbc #5
                sta TEMP1
                lda TANK_START_Y,x
                sta TEMP2
                jsr ComputeMapAddr

                ldy #13-1
_next3          lda (ADR1),y
                bmi _2

                dey
                bpl _next3

                lda #BEGIN
                sta TANK_STATUS,x

_2              dex
                bpl _next1

_XIT            rts
                .endblock
                .endproc


;=======================================
;
;=======================================
CheckTankCollision .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;---

                ldx #HIT_LIST2_LEN
_next1          lda (ADR1),y
                cmp HIT_LIST,x
                beq _1

                dex
                bpl _next1

                ldx TEMP1
                clc
                rts

_1              ldx TEMP1
                lda TANK_DX,x
                eor #-2
                sta TANK_DX,x
                sec
                rts
                .endproc


;=======================================
;
;=======================================
ScreenOn        .proc
                jsr ScreenOff

                lda #<DSP_LST1
                sta SDLST
                lda #>DSP_LST1
                sta SDLST+1
                rts
                .endproc


;=======================================
;
;=======================================
ScreenOff      .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;v_???          .var TEMP2
v_roboExplodeTimer .var TIM7_VAL
;---

                lda #<DSP_LST2
                sta SDLST
                lda #>DSP_LST2
                sta SDLST+1

                lda #OFF
                sta CHOPPER_STATUS
                sta ROBOT_STATUS

                ldx R_STATUS
                cpx #CRASH
                bne _1

                sta R_STATUS
_1              ldx #$E0
                lda #0
_next1          sta CHR_SET1+$200,x
                inx
                bne _next1

_next2          sta CHR_SET1+$300,x
                sta PLAY_SCRN+$000,x
                sta PLAY_SCRN+$100,x
                sta PLAY_SCRN+$200,x
                inx
                bne _next2

;               lda #0
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
                stx v_roboExplodeTimer
_next3          lda CM_STATUS,x
                cmp #OFF
                beq _2

                lda #OFF
                sta CM_STATUS,x
                jsr MissileErase
_2              dex
                bpl _next3

                ldx #2
_next4          lda ROCKET_STATUS,x
                cmp #7                  ; EXP
                bne _3

                lda ROCKET_TEMPX,x
                sta TEMP1
                lda ROCKET_TEMPY,x
                sta TEMP2
                jsr ComputeMapAddr

                ldy #0
                lda ROCKET_TEMP,x
                sta (ADR1),y
_3              lda #0
                sta ROCKET_STATUS,x
                sta ROCKET_X,x
                dex
                bpl _next4

                .endproc
                ;[fall-through]

;=======================================
;
;=======================================
ClearSounds     .proc
                lda #0
                sta AUDC1
                sta AUDC2
                sta AUDC3
                sta AUDC4
                rts
                .endproc

;=======================================
CalcCursorLoc   .proc
;v_???          .var ADR1
v_posX          .var TEMP1
v_posY          .var TEMP2
;---

                lda v_posY
                pha
                lda v_posX
                pha

                lda v_posY
                jsr MULT_BY_40

                pla
                pha

                clc
                adc v_posX
                adc #<PLAY_SCRN
                sta ADR1
                lda #>PLAY_SCRN
                adc v_posY
                sta ADR1+1

                pla
                sta v_posX
                pla
                sta v_posY
                rts
                .endproc


;=======================================
; Output characters to the screen
;---------------------------------------
; Numerals and letters have 2-halves
;---------------------------------------
; on entry:
;   TEMP1       output x coordinate
;   TEMP2       output y coordinate
;   (X,Y)       input source address
;=======================================
Print           .proc
v_destAddr      .var ADR1
v_sourceAddr    .var ADR2
v_sourceIdx     .var TEMP5
v_destIdx       .var TEMP6
;---

                stx v_sourceAddr
                sty v_sourceAddr+1
                jsr CalcCursorLoc

                ldy #0
                sty v_sourceIdx
                sty v_destIdx

_nextChar       ldy v_sourceIdx
                lda (v_sourceAddr),y
                beq _isSpaceChar        ; blank space does not have 2-halves

                cmp #$FF                ; check for termination character
                beq _XIT

                ldy v_destIdx           ; left-half of glyph
                sta (v_destAddr),y
                inc v_destIdx
                clc
                adc #32
_isSpaceChar    ldy v_destIdx           ; right-half of glyph
                sta (v_destAddr),y
                inc v_destIdx
                inc v_sourceIdx
                bne _nextChar           ; FORCED

_XIT            rts
                .endproc


;=======================================
;
;=======================================
GiveBonus       .proc
                ldx BONUS1
                ldy BONUS2
                jsr IncreaseScore

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
                .endproc

                ;[fall-through]


;=======================================
;
;=======================================
WaitFrame       .proc
                lda MODE
                sta TEMP_MODE
                lda FRAME
_1              cmp FRAME
                beq _1

                jsr ReadKeyboard

                lda MODE
                cmp TEMP_MODE
                bne _2

                dex
                bne WaitFrame

                rts

_2              ldx #$FF
                txs
                jmp MAIN
                .endproc


;=======================================
;
;=======================================
ClearInfo       .proc
                ldy #40-1
                lda #0
_next1          sta PLAY_SCRN,y
                dey
                bpl _next1

                rts
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
