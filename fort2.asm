
;--------------------------------------
;--------------------------------------
; FILE: FORT2.ASM
;--------------------------------------
; OPTIONS SET-UP
; MOVE PODS
; MOVE CRUISE MISSILE
; MOVE TANKS
; CHECK HYPER CHAMBERS
;--------------------------------------
;--------------------------------------

;======================================
; Space = toggle Pause Mode
; Option = delegate to Opt handler
; Select = delegate to Opt handler
; Start = switch to Start Mode
;--------------------------------------
; Any activity will cancel the Demo
; All key-presses are delegated to the
;   Option screen while in Option mode
; Capture (endless loop) while Paused
;======================================
ReadKeyboard    .proc
v_demoTimer     .var TIM6_VAL
;---

                lda CONSOL              ; read the console keys
                cmp CONSOL_FLAG         ; update consol_flag if it has changed
                beq _doSelect

                sta CONSOL_FLAG

                ldx #$00                ; reset inactivity timer
                stx v_demoTimer

                cmp #$06                ; START pressed? (0=pressed)
                bne _chk_mode

                lda #START_MODE         ; MODE=START
                sta MODE
                sta DEMO_STATUS         ; disable Demo

                jmp _XIT

_chk_mode       ldx MODE                ; Options Screen has its own handler
                cpx #OPTION_MODE        ; continue if not on the Options screen
                bne _determine_key

                jsr CheckOptions        ; transfer to the Option handler
                jmp _XIT

_determine_key  cmp #$03                ; OPTION pressed?
                beq _doOption

                cmp #$05                ; SELECT pressed?
                bne _doSelect

_doOption       lda #OPTION_MODE        ; switch to Options screen
                sta MODE
                sta DEMO_STATUS         ; disable Demo

                jsr ScreenOff           ; update display

                lda #$00
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
                cmp #$07
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


;======================================
;
;======================================
CheckOptions   .proc
;v_???          .var ADR1
;v_???          .var ADR2
v_posX          .var TEMP1
v_posY          .var TEMP2
;v_???          .var TEMP5
;v_???          .var TEMP6
;---

                lda CONSOL
                cmp #$03                ; OPTION
                bne _2

                ldx OPT_NUM
                inx
                cpx #$03
                bcc _1

                ldx #$00
_1              stx OPT_NUM

_2              cmp #$05                ; SELECT
                bne _8

                lda OPT_NUM
                bne _4

                ldx GRAV_SKILL
                inx
                cpx #$03
                bcc _3

                ldx #$00
_3              stx GRAV_SKILL

_4              cmp #$01
                bne _6

                ldx PILOT_SKILL
                inx
                cpx #$03
                bcc _5

                ldx #$00
_5              stx PILOT_SKILL

_6              cmp #$02
                bne _8

                ldx CHOPS
                inx
                cpx #$03
                bcc _7

                ldx #$00
_7              stx CHOPS

_8              lda #$0D                ; (13,1)
                sta v_posX
                lda #$01
                sta v_posY

                ldx #<txtOptTitle1      ; "OPTIONS"
                ldy #>txtOptTitle1
                jsr Print

                lda #$00                ; (0,3)
                sta v_posX
                lda #$03
                sta v_posY

                ldx #<txtOptTitle2      ; "OPTION"
                ldy #>txtOptTitle2
                jsr Print

                lda #$1C                ; (28,3)
                sta v_posX

                ldx #<txtOptTitle3      ; "SELECT"
                ldy #>txtOptTitle3
                jsr Print

; - - - - - - - - - - - - - - - - - - -
PrintOptions    .block
                lda #$00                ; (0,7)
                sta v_posX
                lda #$07
                sta v_posY

                ldx #<txtOptGravity     ; "GRAVITY SKILL"
                ldy #>txtOptGravity
                jsr Print

                inc v_posY              ; (0,9)
                inc v_posY

                ldx #<txtOptPilot       ; "PILOT SKILL"
                ldy #>txtOptPilot
                jsr Print

                inc v_posY              ; (0,11)
                inc v_posY

                ldx #<txtOptRobo        ; "ROBO PILOTS"
                ldy #>txtOptRobo
                jsr Print

                lda OPT_NUM
                asl
                clc
                adc #$07                ; OPTION
                sta v_posY

                lda OPT_NUM
                asl
                tax

                lda OptTable,X
                sta ADR2
                lda OptTable+1,X
                sta ADR2+1

                jsr CalcCursorLoc

                ldy #$00
                sty TEMP5
                sty TEMP6

_next1          ldy TEMP5
                lda (ADR2),Y
                beq _1

                cmp #$FF
                beq _2

                ora #$80
                ldy TEMP6
                sta (ADR1),Y

                inc TEMP6
                clc
                adc #$20

_1              ldy TEMP6
                sta (ADR1),Y

                inc TEMP6
                inc TEMP5
                bne _next1              ; [unc]

_2              lda #$1C                ; (28,7)
                sta v_posX
                lda #$07
                sta v_posY

                lda GRAV_SKILL
                asl
                tay

                ldx OptGravityTable,Y   ; "WEAK|NORMAL|STRONG"
                lda OptGravityTable+1,Y
                tay
                jsr Print

                inc v_posY              ; (28,9)
                inc v_posY

                lda PILOT_SKILL
                asl
                tay
                ldx OptPilotTable,Y     ; "NOVICE|PRO|EXPERT"
                lda OptPilotTable+1,Y
                tay
                jsr Print

                inc v_posY              ; (28,11)
                inc v_posY

                lda CHOPS
                asl
                tay
                ldx OptRoboTable,Y      ; "SEVEN|NINE|ELEVEN"
                lda OptRoboTable+1,Y
                tay
                jmp Print

                .endblock
                .endproc


;--------------------------------------
;--------------------------------------

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


;======================================
;
;======================================
MovePods        .proc
                lda #POD_SPEED
_next1          pha

                jsr MovePods1

                pla
                sec
                sbc #$01
                bne _next1

                rts
                .endproc


;======================================
;
;======================================
MovePods1       .proc
                ldx POD_NUM

                lda POD_STATUS,X
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


;======================================
;
;======================================
PodsEnd         .proc
                ldx POD_NUM
                inx
                cpx #MAX_PODS
                bcc _1

                ldx #$00
_1              stx POD_NUM

                rts
                .endproc


;======================================
;
;======================================
GetPodAddr      .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda POD_X,X
                sta TEMP1
                lda POD_Y,X
                sta TEMP2

                jmp ComputeMapAddr

                .endproc


;======================================
;
;======================================
GetPodValue     .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                jsr GetPodAddr

                ldy #$00
                lda (ADR1),Y
                sta TEMP1
                iny
                lda (ADR1),Y
                sta TEMP2

                rts
                .endproc


;======================================
;
;======================================
PutPodValue     .proc
;v_???          .var ADR1
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                jsr GetPodAddr

                ldy #$00
                lda TEMP3
                sta (ADR1),Y
                iny
                lda TEMP4
                sta (ADR1),Y

                rts
                .endproc


;======================================
;
;======================================
PositionPod     .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda POD_X,X
                sta TEMP1
                lda POD_Y,X
                sta TEMP2

                jmp PositionIt

                .endproc


;======================================
;
;======================================
PodBegin        .proc
;v_???          .var ADR1
;---

_next1          lda RANDOM
                cmp #$32
                bcc _next1

                cmp #$100-50
                bcs _next1

                sta POD_X,X

_next2          lda RANDOM
                cmp #$28
                bcs _next2

                sta POD_Y,X

                jsr GetPodAddr

                ldy #$00
                lda (ADR1),Y
                iny
                ora (ADR1),Y
                bne _next1

                lda #ON
                sta POD_STATUS,X
                sta POD_COM

                jsr PodDraw

                lda #$01
                sta POD_DX,X

                jmp PodsEnd

                .endproc


;======================================
;
;======================================
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
                sta POD_STATUS,X

                ldx #$50
                ldy #$00
                jsr IncreaseScore

                sec
                rts
                .endproc


;======================================
;
;======================================
PodErase        .proc
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                jsr PositionPod

                lda POD_TEMP1,X
                sta TEMP3
                lda POD_TEMP2,X
                sta TEMP4

                jmp PutPodValue

                .endproc


;======================================
;
;======================================
PodDraw         .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                jsr PositionPod
                jsr GetPodValue

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

                jmp PutPodValue

                .endproc


;======================================
;
;======================================
PodMove         .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

_next1          lda POD_DX,X
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
                bne _2

                inc POD_X,X
_2              lda POD_X,X
                sta TEMP1
                lda POD_Y,X
                sta TEMP2

                jsr ComputeMapAddr

                ldy #$00
                lda (ADR1),Y
                iny
                ora (ADR1),Y
                bne _3

                lda POD_X,X
                cmp #$32
                bcc _3

                cmp #$100-50
                bcc _4

_3              lda POD_DX,X
                eor #-2
                sta POD_DX,X

                jmp _next1

_4              lda POD_COM
                sta POD_STATUS,X

                rts
                .endproc


;--------------------------------------
;--------------------------------------

POD_CHR         .byte $40,$00
                .byte $5B,$5C
                .byte $5D,$5E
                .byte $00,$5F


;======================================
;
;======================================
MoveCruiseMissiles .proc
                dec MISSILE_SPD
                bne MCE

                lda MISSILE_SPEED
                sta MISSILE_SPD

                ldx #MAX_TANKS-1

; - - - - - - - - - - - - - - - - - - -
M_ST            .block
                lda CM_STATUS,X
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

; - - - - - - - - - - - - - - - - - - -
M_END           .block
                lda TANK_STATUS,X
                cmp #ON
                bne _2

                lda TANK_Y,X
                sec
                sbc CHOP_Y
                bmi _2

                cmp #$0E
                bcs _2

                lda CM_STATUS,X
                cmp #OFF
                bne _2

                lda CHOP_X
                sec
                sbc #$02
                sbc TANK_X,X
                bpl _1

                eor #-2
_1              cmp #$09
                bcs _2

                lda #BEGIN
                sta CM_STATUS,X

_2              dex
                bpl M_ST

                .endblock

; - - - - - - - - - - - - - - - - - - -
MCE             .block
                ldx #MAX_TANKS-1
_next1          lda CM_STATUS,X
                cmp #OFF
                bne _XIT

                dex
                bpl _next1

                lda #$00
                sta AUDC4
                sta SND6_VAL

_XIT            rts
                .endblock
                .endproc


;======================================
;
;======================================
GetMissileAddr  .proc
v_posX          .var TEMP1
v_posY          .var TEMP2
;---

                lda CM_X,X
                sta v_posX
                lda CM_Y,X
                sta v_posY

                jmp ComputeMapAddr

                .endproc


;======================================
;
;======================================
MissileBegin    .proc
                ldy TANK_X,X
                iny
                tya
                sta CM_X,X

                lda TANK_Y,X
                sec
                sbc #$02
                sta CM_Y,X

                ldy #LEFT
                lda CHOP_X
                sec
                sbc TANK_X,X
                bmi _1

                ldy #RIGHT
_1              tya
                sta CM_STATUS,X

                lda #$00
                sta CM_TEMP,X

                lda #$14
                sta CM_TIME,X

                lda #$01
                sta SND6_VAL

                jmp MoveCruiseMissiles.M_END

                .endproc


;======================================
;
;======================================
MissileCollision .proc
;v_???          .var ADR1
v_preserveX     .var TEMP1
;---

                jsr GetMissileAddr

                ldy #$00
                lda (ADR1),Y
                cmp #EXP
                beq M_COL2

                clc
                rts

M_COL2          jsr MissileErase

                lda #$01
                sta SND3_VAL

                lda #OFF
                sta CM_STATUS,X

                lda #-1
                sta CM_TIME,X
                stx v_preserveX

                ldx #$10
                ldy #$00
                jsr IncreaseScore

                ldx v_preserveX

                sec
                rts
                .endproc


;======================================
;
;======================================
MissileErase    .proc
;v_???          .var ADR1
;---

                jsr GetMissileAddr

                lda CM_TEMP,X
                cmp #EXP_WALL
                beq _1

                cmp #$60+128
                bcs _XIT

                cmp #$40
                beq _XIT

                cmp #$5B
                bcc _1

                cmp #$5F+1
                bcc _XIT

_1              ldy #$00
                sta (ADR1),Y

_XIT            rts
                .endproc


;======================================
;
;======================================
MissileMove     .proc
;v_???          .var ADR1
v_distance      .var TEMP1
;---

                lda CM_STATUS,X
                cmp #LEFT
                beq _1

                inc CM_X,X

                jmp _2

_1              dec CM_X,X

_2              lda CM_TIME,X
                bpl _3

_next1          inc CM_Y,X

                jmp _6

_3              lda CHOP_X
                sec
                sbc CM_X,X
                sta v_distance

                lda CM_STATUS,X
                cmp #LEFT
                bne _4

                lda v_distance
                bpl _next1
                bmi _5                  ; [unc]

_4              lda v_distance
                bmi _next1

_5              lda CM_X,X
                cmp #$D8
                bcs _next1

                cmp #$2D
                bcc _next1

                ldy CHOP_Y
                iny
                tya

                sec
                sbc CM_Y,X
                beq _6
                bpl _next2

                dec CM_Y,X

                jmp _6

_next2          inc CM_Y,X

_6              jsr GetMissileAddr

                ldy #$00
                lda (ADR1),Y
                cmp #MISS_LEFT
                beq _next2

                cmp #MISS_RIGHT
                beq _next2

                lda CM_TIME,X
                bmi _XIT

                dec CM_TIME,X

_XIT            rts
                .endproc


;======================================
;
;======================================
MissileDraw     .proc
;v_???          .var ADR1
;---

                jsr GetMissileAddr

                ldy #$00
                lda (ADR1),Y
                sta CM_TEMP,X

                lda #MISS_LEFT
                ldy CM_STATUS,X
                cpy #LEFT
                beq _1

                lda #MISS_RIGHT
_1              ldy #$00
                sta (ADR1),Y

                lda CM_TEMP,X
                jsr CheckChr

                bcc _XIT
                jmp MissileCollision.M_COL2

_XIT            rts
                .endproc


;======================================
;
;======================================
CheckHyperchamber .proc
                lda MODE
                cmp #HYPERSPACE_MODE
                bne _XIT

                lda #STOP_MODE
                sta MODE

                lda #$0F
                sta BAK2_COLOR

                ldx #$02
                jsr WaitFrame

                lda #$00
                sta BAK2_COLOR

                lda RANDOM
                and #$03

                tax
                lda _H_XF,X
                sta SX_F
                lda _H_YF,X
                sta SY_F

                lda _H_X,X
                sta SX
                lda _H_Y,X
                sta SY

                lda _H_CX,X
                sta CHOPPER_X
                lda _H_CY,X
                sta CHOPPER_Y

                lda #$08
                sta CHOPPER_ANGLE

                lda #$00
                sta CHOPPER_COL

                lda #GO_MODE
                sta MODE

_XIT            rts

;--------------------------------------

_H_XF           .byte $DD,$76,$10,$4B
_H_YF           .byte $7A,$7B,$B8,$B8
_H_X            .byte $22,$BC,$55,$87
_H_Y            .byte $0F,$0F,$18,$18
_H_CX           .byte $73,$78,$76,$75
_H_CY           .byte $8C,$89,$AF,$AF

                .endproc


;======================================
;
;======================================
CheckChr        .proc
;v_???          .var ADR2
;---

                ldy #$00
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

                ldy #$07
_next1          lda (ADR2),Y
                bne _XIT

                dey
                bpl _next1

                clc
                rts

_XIT            sec
                rts
                .endproc


;======================================
;
;======================================
PositionTank    .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda TANK_X,X
                sta TEMP1

                ldy TANK_Y,X
                dey
                sty TEMP2

                jsr PositionIt

                lda TANK_Y,X
                sta TEMP2

                rts
                .endproc


;======================================
;
;======================================
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
_next1          lda TANK_Y,X
                sta TEMP2

                lda TANK_STATUS,X
                cmp #OFF
                bne _2
                jmp _9

_2              cmp #BEGIN
                bne _4

                lda #ON
                sta TANK_STATUS,X

                lda TANK_START_X,X
                sta TANK_X,X
                lda TANK_START_Y,X
                sta TANK_Y,X

                lda #-1
                ldy RANDOM
                bpl _3

                lda #$01
_3              sta TANK_DX,X

                jsr PositionTank
                jmp _next4

_4              cmp #CRASH
                bne _5
                jmp _9

;   RESTORE OLD POS
_5              lda TANK_X,X
                sta TEMP1

                jsr ComputeMapAddr
                stx TEMP1

                ldy #$00
                txa
                asl
                adc TEMP1
                tax

_next2          lda (ADR1),Y
                cmp #EXP
                beq _6

                cmp #MISS_LEFT
                beq _6

                cmp #MISS_RIGHT
                bne _7

_6              ldx TEMP1
                lda #CRASH
                sta TANK_STATUS,X

                ldy #$02
                lda #EXP
_next3          sta (ADR1),Y

                dey
                bpl _next3

                lda #$0A
                sta TIM5_VAL

                jmp _9

_7              lda TANK_TEMP,X
                sta (ADR1),Y

                inx
                iny
                cpy #$03
                bne _next2

                ldy #$01
                dec ADR1+1

                lda #$00
                sta (ADR1),Y

;   MOVE X
                ldx TEMP1
_next4          jsr PositionTank

                lda TANK_X,X
                clc
                adc TANK_DX,X
                sta TANK_X,X

;   SAVE NEW POS
                jsr PositionTank

                lda TANK_X,X
                sta TEMP1

                jsr ComputeMapAddr
                stx TEMP1

                ldy #$00
                txa
                asl
                adc TEMP1
                tax

_next5          lda (ADR1),Y
                sta TANK_TEMP,X
                inx

                iny
                cpy #$03
                bne _next5

; check for collision
                ldx TEMP1
                ldy #$00
                jsr CheckTankCollision
                bcs _next4

                ldy #$02
                jsr CheckTankCollision
                bcs _next4

; DRAW TANK
                ldy #$02
_next6          lda TANK_SHAPE,Y
                sta (ADR1),Y

                dey
                bpl _next6

                dec ADR1+1

                ldy #$6F+128            ; 'o'
                lda CHOP_X
                sec
                sbc TANK_X,X
                bpl _8

                ldy #$70+128            ; 'p'
_8              tya
                ldy #$01
                sta (ADR1),Y

_9              dex
                bmi MT2
                jmp _next1

                .endblock

; - - - - - - - - - - - - - - - - - - -
MT2             .block
                dec TIM5_VAL
                bne _XIT

                lda #$0A
                sta TIM5_VAL

                ldx #MAX_TANKS-1
_next1          lda TANK_STATUS,X
                cmp #CRASH
                bne _1

                lda #OFF
                sta TANK_STATUS,X

                lda TANK_X,X
                sta TEMP1
                lda TANK_Y,X
                sta TEMP2

                jsr ComputeMapAddr
                stx TEMP1

                ldy #$00
                txa
                asl
                adc TEMP1
                tax

_next2          lda TANK_TEMP,X
                sta (ADR1),Y
                inx

                iny
                cpy #$03
                bne _next2

                dec ADR1+1

                ldy #$01
                lda #$00
                sta (ADR1),Y

                ldx #$50
                ldy #$02
                jsr IncreaseScore

                ldx TEMP1
                jsr PositionTank

_1              lda TANK_STATUS,X
                cmp #OFF
                bne _2

                lda CHOP_Y
                cmp #$03
                bcc _2

                sec
                sbc #$03
                cmp TANK_START_Y,X
                bcc _2

                lda TANK_START_X,X
                sec
                sbc #$05
                sta TEMP1
                lda TANK_START_Y,X
                sta TEMP2

                jsr ComputeMapAddr

                ldy #$0D-1
_next3          lda (ADR1),Y
                bmi _2

                dey
                bpl _next3

                lda #BEGIN
                sta TANK_STATUS,X

_2              dex
                bpl _next1

_XIT            rts
                .endblock
                .endproc


;======================================
;
;======================================
CheckTankCollision .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;---

                ldx #HIT_LIST2_LEN
_next1          lda (ADR1),Y
                cmp HIT_LIST,X
                beq _1

                dex
                bpl _next1

                ldx TEMP1

                clc
                rts

_1              ldx TEMP1
                lda TANK_DX,X
                eor #-2
                sta TANK_DX,X

                sec
                rts
                .endproc


;======================================
;
;======================================
ScreenOn        .proc
                jsr ScreenOff

                lda #<DSP_LST1
                sta SDLST
                lda #>DSP_LST1
                sta SDLST+1

                rts
                .endproc


;======================================
;
;======================================
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
                lda #$00
_next1          sta CHR_SET1+$200,X

                inx
                bne _next1

_next2          sta CHR_SET1+$300,X
                sta PLAY_SCRN+$000,X
                sta PLAY_SCRN+$100,X
                sta PLAY_SCRN+$200,X

                inx
                bne _next2

;               lda #$00
                sta SND1_1_VAL
                sta SND2_VAL
                sta SND3_VAL
                sta SND4_VAL
                sta SND5_VAL
                sta SND6_VAL
                sta BAK2_COLOR

                lda #$14
                sta SND1_2_VAL

                ldx #MAX_TANKS-1
                stx v_roboExplodeTimer

_next3          lda CM_STATUS,X
                cmp #OFF
                beq _2

                lda #OFF
                sta CM_STATUS,X

                jsr MissileErase

_2              dex
                bpl _next3

                ldx #$02
_next4          lda ROCKET_STATUS,X
                cmp #$07                ; EXP
                bne _3

                lda ROCKET_TEMPX,X
                sta TEMP1
                lda ROCKET_TEMPY,X
                sta TEMP2

                jsr ComputeMapAddr

                ldy #$00
                lda ROCKET_TEMP,X
                sta (ADR1),Y

_3              lda #$00
                sta ROCKET_STATUS,X
                sta ROCKET_X,X

                dex
                bpl _next4

                .endproc

                ;[fall-through]

;======================================
;
;======================================
ClearSounds     .proc
                lda #$00
                sta AUDC1
                sta AUDC2
                sta AUDC3
                sta AUDC4

                rts
                .endproc


;======================================
; Calculates the cursor address within
; PLAY_SCRN based on the provided
; (x, y) coordinates
;--------------------------------------
; on entry:
;   TEMP1       x coordinate
;   TEMP2       y coordinate
; at exit:
;   ADR1        address of (x, y)
; preserved:
;   TEMP1 TEMP2
;======================================
CalcCursorLoc   .proc
;v_???          .var ADR1
v_posX          .var TEMP1
v_posY          .var TEMP2
;---

                lda v_posY              ; preserve
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
                adc v_posY              ; playfield is 256-bytes wide
                sta ADR1+1

                pla                     ; restore
                sta v_posX
                pla
                sta v_posY

                rts
                .endproc


;======================================
; Output characters to the screen
;--------------------------------------
; Numerals and letters have 2-halves
;--------------------------------------
; on entry:
;   TEMP1       output x coordinate
;   TEMP2       output y coordinate
;   (X,Y)       input source address
;======================================
Print           .proc
v_destAddr      .var ADR1
v_sourceAddr    .var ADR2
v_sourceIdx     .var TEMP5
v_destIdx       .var TEMP6
;---

                stx v_sourceAddr
                sty v_sourceAddr+1

                jsr CalcCursorLoc

                ldy #$00
                sty v_sourceIdx
                sty v_destIdx

_nextChar       ldy v_sourceIdx
                lda (v_sourceAddr),Y
                beq _isSpaceChar        ; blank space does not have 2-halves

                cmp #$FF                ; check for termination character
                beq _XIT

                ldy v_destIdx           ; left-half of glyph
                sta (v_destAddr),Y

                inc v_destIdx
                clc
                adc #$20

_isSpaceChar    ldy v_destIdx           ; right-half of glyph
                sta (v_destAddr),Y

                inc v_destIdx
                inc v_sourceIdx
                bne _nextChar           ; [unc]

_XIT            rts
                .endproc


;======================================
;
;======================================
GiveBonus       .proc
                ldx BONUS1
                ldy BONUS2
                jsr IncreaseScore

                lda #$00
                sta BONUS1
                sta BONUS2

                sed
                lda CHOP_LEFT
                clc
                adc #$02
                sta CHOP_LEFT
                cld

                ldx #$02

                .endproc

                ;[fall-through]


;======================================
;
;======================================
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

_2              ldx #$FF                ; reset stack
                txs

                jmp MAIN

                .endproc


;======================================
;
;======================================
ClearInfo       .proc
                ldy #$28-1
                lda #$00
_next1          sta PLAY_SCRN,Y

                dey
                bpl _next1

                rts
                .endproc
