
;--------------------------------------
;--------------------------------------
; FILE: FORT1.ASM
;--------------------------------------
;--------------------------------------

;======================================
;
;======================================
START           ;.proc
                sei
                cld

                ldx #Z2_LEN
_next1          lda Z2,X
                sta RAM2_STUFF,X

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

                lda #<dliLINE1
                sta VDSLST
                lda #>dliLINE1
                sta VDSLST+1

                jsr M_START

                lda #TITLE_MODE
                sta MODE

SET_FONTS       .block
                ldx #0
_next1          lda FNT1,X
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
                bne _next1

;   relocate the display list into RAM
                ldx #Z1_LEN
_next2          lda Z1,X
                sta RAM1_STUFF,X

                dex
                bpl _next2

                lda #$40
                sta NMIEN

                cli
                .endblock
                ;.endproc

                ;[fall-through]


;======================================
; Title Screen handler
;======================================
Title           .proc
c_horzCount     = 40
c_vertCount     = 17
;v_???          .var ADR1
v_audiofreq     .var TEMP1_I
v_posX          .var TEMP1
v_posY          .var TEMP2
v_marqueeGlyph  .var TEMP3
;---

                ldx #$FF                ; reset stack pointer
                txs

                lda #$43                ; reset colors
                sta COLOR0
                lda #$0F
                sta COLOR1
                lda #$83
                sta COLOR2

                jsr ScreenOff

                lda #<DSP_LST3        ; title screen display list
                sta SDLST
                lda #>DSP_LST3
                sta SDLST+1

                lda #$3B                ; start with red marquee dot
                sta v_marqueeGlyph

                ldy #0                  ; start with low tones and increase to higher tones
                sty v_audiofreq

_next1          lda v_marqueeGlyph      ; place a dot
                sta PLAY_SCRN,Y

                jsr CycleGlyph          ; move to next dot

                iny
                cpy #40
                bne _next1              ; loop until end of line

                lda #<PLAY_SCRN+39      ; move to right edge
                sta ADR1
                lda #>PLAY_SCRN+39
                sta ADR1+1

                lda #$3B                ; always start with a red marquee dot
                sta v_marqueeGlyph

                ldx #c_vertCount
                ldy #0
_next2          lda v_marqueeGlyph
                sta (ADR1),Y            ; place a dot
                iny

                jsr CycleGlyph          ; change to the next dot color
                sta (ADR1),Y            ; place a horz adjacent dot
                dey                     ; back up one position

                lda ADR1                ; calculate the vert adjacent dot
                clc
                adc #c_horzCount
                sta ADR1
                lda ADR1+1
                adc #0
                sta ADR1+1

                dex
                bpl _next2

                lda #<irqT2                ; setup the deferred VBI (move the dots)
                sta VVBLKD
                lda #>irqT2
                sta VVBLKD+1

                ldx #5
                stx v_posX
                dex
                stx v_posY

                ldx #<txtTitle1         ; output the first title
                ldy #>txtTitle1
                jsr Print               ; (5, 4) 'Fort Apocalypse'

                inc v_posX
                lda #6
                sta v_posY

                ldx #<txtTitle2         ; output the second title
                ldy #>txtTitle2
                jsr Print               ; (6, 6) 'By Steve Hales'

                lda #10
                sta v_posY

                ldx #<txtTitle3         ; output the third title
                ldy #>txtTitle3
                jsr Print               ; (6, 10) 'Copyright 1982'

                ldx #7
_next3          lda T_5,X
                sta PLAY_SCRN+426,X     ; output the copyright date (1982)

                dex
                bpl _next3

                lda #4
                sta v_posX
                lda #12
                sta v_posY

                ldx #<txtTitle4         ; output the fourth title
                ldy #>txtTitle4
                jsr Print               ; (4, 12) 'Synapse Software'

;   change the text color for each scan line
_endless1       lda VCOUNT              ; current scan line being draw on screen (divided by 2)
                asl                     ; double it to get the real scan line number
                sta WSYNC               ; halt until next horz sync
                sta COLPF3              ; alter the playfield color

                jmp _endless1

                .endproc


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; VBlank Deferred Handler
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
irqT2           .proc
v_audiofreq     .var TEMP1_I
;---

                lda FRAME               ; rotate the marquee dots every 4th frame
                and #3
                bne _1

                lda COLOR2              ; color0 -> color1 -> color2 -> color0...
                pha

                lda COLOR1
                sta COLOR2
                lda COLOR0
                sta COLOR1

                pla
                sta COLOR0

_1              lda FRAME               ; increment v_audiofreq every 8th frame
                and #7
                bne _2
                inc v_audiofreq

_2              lda #$AF                ; set audio channels to full-volume, pure tone
                sta AUDC1
                sta AUDC2

                lda #$FF                ; audio freq increases as v_audiofreq is incremented
                sec
                sbc v_audiofreq
                sta AUDF1               ; this is a divide-by-N circuit - larger numbers are lower freq

                tax
                dex
                stx AUDF2               ; audio channel 2 leads channel 1

                lda v_audiofreq         ; launch demo near the end of the audio scale (avoid the highest notes)
                cmp #$F3
                beq _5

                ldx #START_MODE         ; trigger causes game start
                lda TRIG0
                beq _3

                lda CONSOL              ; START button causes game to start
                cmp #6
                beq _3

                ldx #OPTION_MODE        ; switch to Option screen when SELECT or OPTION is pressed
                cmp #7
                bne _3

                jmp VVBLKD_RET          ; exit VBI

_3              stx MODE

                ldx #0
                stx OPT_NUM

                inx                     ; X=1
_4              stx DEMO_STATUS

                jmp T3

_5              ldx #-1                 ; START DEMO
                bne _4                  ; [unc]

                .endproc


;======================================
; Cycle through $3B -> $3D -> $3B...
;--------------------------------------
; marquee dots order: red, white, green
;======================================
CycleGlyph      .proc
v_marqueeGlyph  .var TEMP3
;---

                inc v_marqueeGlyph
                lda v_marqueeGlyph
                cmp #$3E
                bne _1

                lda #$3B
_1              sta v_marqueeGlyph

                rts
                .endproc


;--------------------------------------
;--------------------------------------

txtTitle1       .byte $A6,$AF,$B2,$B4,$00,$00               ; 'FORT  ' inverse atari-ascii
                .byte $A1,$B0,$AF,$A3,$A1,$AC,$B9,$B0       ; 'APOCALYPSE'
                .byte $B3,$A5
                .byte $FF

txtTitle2       .byte $A2,$B9,$00,$00                       ; 'BY  ' inverse atari-ascii
                .byte $B3,$B4,$A5,$B6,$A5,$00,$00           ; 'STEVE  '
                .byte $A8,$A1,$AC,$A5,$B3                   ; 'HALES'
                .byte $FF

txtTitle3       .byte $A3,$AF,$B0,$B9,$B2,$A9,$A7,$A8       ; 'COPYRIGHT' inverse atari-ascii
                .byte $B4
                .byte $FF

txtTitle4       .byte $B3,$B9,$AE,$A1,$B0,$B3,$A5           ; 'SYNAPSE' inverse atari-ascii
                .byte $00,$00                               ; '  '
                .byte $B3,$AF,$A6,$B4,$B7,$A1,$B2,$A5       ; 'SOFTWARE'
                .byte $FF


;======================================
;
;======================================
T3              .proc
                sei

                lda #$0A                ; LASER BLOCK
                sta COLOR1
                lda #$94                ; LASERS,HOUSE
                sta COLOR2
                lda #$9A                ; LETTERS
                sta COLOR3

                lda #<irqVERTBLKD          ; enable deferred VBI
                sta VVBLKD
                lda #>irqVERTBLKD
                sta VVBLKD+1

                jsr ScreenOff

_wait1          lda VCOUNT              ; wait for next horz sync
                bne _wait1

                lda #$C0                ; enable VBI & DLI
                sta NMIEN

                cli

                .endproc

                ;[fall-through]


;======================================
;
;======================================
MAIN            lda MODE
                cmp #GO_MODE
                beq _2

                lda FRAME
_1              cmp FRAME
                beq _1

_2              lda MODE
                cmp #GO_MODE
                bne _6

                jsr MovePods
                jsr MoveTanks
                jsr MoveCruiseMissiles
                jsr MoveSlaves
                jsr SetScanner
                jsr CheckFuelBase
                jsr CheckFort
                jsr CheckLevel

_6              jsr CheckHyperchamber
                jsr CheckModes
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
                jmp TITLE

_4              JMP MAIN


;======================================
;
;======================================
CheckLevel      .proc
                lda LEVEL
                beq DoLevel1

                cmp #1
                bne _1
                jmp DoLevel2

_1              jmp DoLevel3

                rts                     ; unreachable code
                .endproc


;======================================
;
;======================================
DoLevel1        .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;v_???          .var TEMP2
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                lda CHOPPER_STATUS
                cmp #LAND
                bne _XIT

                lda CHOP_Y
                cmp #35
                bcc _XIT

                lda CHOP_X
                cmp #130
                bcc _XIT

                cmp #130+6+1
                bcs _XIT

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

; - - - - - - - - - - - - - - - - - - -
;   Copy Protection
; - - - - - - - - - - - - - - - - - - -
                dec MAIN+32
; - - - - - - - - - - - - - - - - - - -

                lda #NEW_LEVEL_MODE
                sta MODE

_XIT            rts
                .endproc


;======================================
;
;======================================
PSL             jmp PrintSlavesLeft


;======================================
;
;======================================
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
_next2          lda (ADR2),Y
                sta (ADR1),Y

                dey
                bpl _next2

                dec ADR1+1

                dex
                bpl _next1

                rts
                .endproc


;======================================
;
;======================================
DoLevel2        .proc
                lda FORT_STATUS
                cmp #OFF
                bne _XIT

                lda CHOP_Y
                cmp #2
                bcs _XIT

                lda CHOP_X
                cmp #130
                bcc _XIT

                cmp #130+4+1
                bcs _XIT

                lda SLAVES_LEFT
                bne PSL

                inc LEVEL               ; =2

                jsr GiveBonus

; - - - - - - - - - - - - - - - - - - -
;   Copy Protection
; - - - - - - - - - - - - - - - - - - -
                asl M_NewPlayer
; - - - - - - - - - - - - - - - - - - -

                lda #NEW_LEVEL_MODE
                sta MODE

_XIT            rts
                .endproc


;======================================
;
;======================================
DoLevel3        .proc
                lda CHOPPER_STATUS
                cmp #LAND
                bne _XIT

                lda CHOP_Y
                cmp #13
                bcs _XIT

                lda CHOP_X
                cmp #$17
                bcc _XIT

                cmp #$F4
                bcs _XIT

                jsr GiveBonus

                inc LEVEL               ; =3
                dec M_GameOver

                lda #GAME_OVER_MODE
                sta MODE

_XIT            rts
                .endproc


;======================================
;
;======================================
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

_next2          cmp CHR1,Y
                beq _1

                iny
                cpy #CHR1_L
                bne _next2

_next3          ldx #1
                bne _next5              ; [unc]

_next4          cmp CHR2,Y
                beq _1

                iny
                cpy #CHR2_L
                bne _next4
                beq _next3              ; [unc]

_1              sta TEMP1

                jsr GetByte

                tax
                lda TEMP1
_next5          ldy #0
                sta (ADR2),Y

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


;======================================
;
;======================================
GetByte         .proc
;v_???          .var ADR1
;---

                ldy #0
                lda (ADR1),Y
                inc ADR1
                bne _XIT

                inc ADR1+1

_XIT            rts
                .endproc


;--------------------------------------
;--------------------------------------

CHR1            .byte $00,$61,$0E,$0F,$10,$11,$0A,$0B       ; ' a./01*+' atari-ascii
                .byte $0C,$0D,$03,$07,$1F,$73,$74           ; ',-#'?st'

                .byte $41,$44,$48,$58,$59,$5A,$D8
                .byte $47+128


;--------------------------------------
;--------------------------------------
CHR1_L          = *-CHR1
;--------------------------------------

CHR2            .byte $00,$55,$AA,$FF


;--------------------------------------
;--------------------------------------
CHR2_L          = *-CHR2
;--------------------------------------

PACK_ADR        .addr PACKED_MAP+$000   ; LEVEL_1
                .addr PACKED_MAP+$62B   ; LEVEL_2
                .addr PACKED_MAP+$000   ; LEVEL_1


;======================================
;
;======================================
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

; - - - - - - - - - - - - - - - - - - -
;   Copy Protection
; - - - - - - - - - - - - - - - - - - -
_4              rol CheckModes
; - - - - - - - - - - - - - - - - - - -

                rts
                .endproc


;======================================
;
;======================================
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
                bne _1

                lda #2

; - - - - - - - - - - - - - - - - - - -
;   Copy Protection
; - - - - - - - - - - - - - - - - - - -
_1              sta MAIN
; - - - - - - - - - - - - - - - - - - -

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
_next1          sta WINDOW_1,X
                sta WINDOW_2,X

                dex
                bpl _next1

                ldx #7
                lda #$55
                ldy RANDOM
                bmi _next3

_next2          sta WINDOW_1,X

                dex
                bpl _next2
                bmi _2                  ; [unc]

_next3          sta WINDOW_2,X

                dex
                bpl _next3

_2              lda #NEW_LEVEL_MODE
                sta MODE

                rts
                .endproc


;--------------------------------------
;--------------------------------------

GRAV_TAB        .byte $F,7
ROBOT_TAB       .byte 3,1,0
CHOP_TAB        .byte $7,$9,$11
LASER_TAB       .byte 4,8,16
POD_TAB         .byte 13-1,26-1,MAX_PODS-1
TANK_TAB        .byte 4
MISSILE_TAB     .byte 3,2,1
ELEVATOR_TAB    .byte 37+25,37+10,37+0


;======================================
;
;======================================
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
                cmp #EMPTY
                bne _2

; - - - - - - - - - - - - - - - - - - -
;   Copy Protection
; - - - - - - - - - - - - - - - - - - -
                dec UpdateChopper
; - - - - - - - - - - - - - - - - - - -

                lda #FULL
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

                lda #BEGIN
                sta CHOPPER_STATUS

                lda #GO_MODE
                sta MODE

                rts
                .endproc


;--------------------------------------
;--------------------------------------

txtPilot1       .byte $A7,$A5,$B4,$00,$00                   ; 'GET  ' atari-ascii
                .byte $B2,$A5,$A1,$A4,$B9,$00,$00           ; 'READY  '
                .byte $B0,$A9,$AC,$AF,$B4                   ; 'PILOT'
                .byte $FF
txtPilot2       .byte $B0,$A9,$AC,$AF,$B4,$B3,$00,$00       ; 'PILOTS  '
                .byte $AC,$A5,$A6,$B4                       ; 'LEFT'
                .byte $FF


;======================================
;
;======================================
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

                lda TANK_START_X_L1,X
                sta TANK_START_X,X
                lda TANK_START_Y_L1,X
                bne _5                  ; [unc]

_4              lda TANK_START_X_L2,X
                sta TANK_START_X,X
                lda TANK_START_Y_L2,X
_5              sta TANK_START_Y,X

                lda #BEGIN
                sta TANK_STATUS,X

                lda #OFF
                sta CM_STATUS,X

                dex
                bpl _next1

                sta R_STATUS

                ldx #MAX_PODS-1
_next2          sta POD_STATUS,X

                dex
                bpl _next2

                ldx START_PODS
                lda #BEGIN
_next3          sta POD_STATUS,X

                dex
                bpl _next3

                lda #0
                sta POD_NUM
                sta SLAVE_NUM

                lda LEVEL
                asl                     ; *2 (word)
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

                jsr Unpack

MAKE_CONTURE    .block
                lda #<MAP
                sta ADR1
                lda #>MAP
                sta ADR1+1

                ldy #0
_next1          lda (ADR1),Y
                cmp #$73                ; 's'
                bne _1

_next2          lda RANDOM
                and #3
                beq _next2

                clc
                adc #$62-1
                bne _2                  ; [unc]

_1              cmp #$74                ; 't'
                bne _2

_next3          lda RANDOM
                and #3
                beq _next3

                clc
                adc #$65-1
_2              sta (ADR1),Y

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
_next5          lda (ADR1),Y
                sta (ADR2),Y

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
_next7          sta (ADR1),Y

                dey
                bpl _next7

                inc ADR1+1

                dex
                bpl _next6

_3              lda LEVEL
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
_next9          lda (ADR1),Y
                sta (ADR2),Y

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

; - - - - - - - - - - - - - - - - - - -
;   Copy Protection
; - - - - - - - - - - - - - - - - - - -
                inc MAIN
; - - - - - - - - - - - - - - - - - - -

                .endblock


S_BEGIN         .block
                ldx #8
                stx SLAVES_LEFT
                dex                     ; X=7

                lda #OFF
_next1          sta SLAVE_STATUS,X

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
_next3          lda (ADR1),Y
                cmp #$48                ; '^H'
                bne _1

                iny
                lda (ADR1),Y
                dey
                cmp #$48
                bne _1

                dec ADR1+1

                lda (ADR1),Y
                inc ADR1+1
                cmp #$1F                ; '?'
                bne _1

                lda RANDOM
                cmp #10
                bcc _1

                cmp #50
                bcs _1

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


;--------------------------------------
;--------------------------------------

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

txtEnter        .byte $A5,$AE,$B4,$A5,$B2,$A9,$AE,$A7       ; 'ENTERING' atari-ascii
                .byte $FF
txtEnterL1      .byte $B6,$A1,$B5,$AC,$B4,$B3,$00,$00       ; 'VAULTS  '
                .byte $AF,$A6,$00,$00                       ; 'OF  '
                .byte $A4,$B2,$A1,$A3,$AF,$AE,$A9,$B3       ; 'DRACONIS'
                .byte $FF
txtEnterL2      .byte $A3,$B2,$B9,$B3,$B4,$A1,$AC,$AC       ; 'CRYSTALLINE  '
                .byte $A9,$AE,$A5,$00,$00
                .byte $A3,$A1,$B6,$A5,$B3                   ; 'CAVES'
                .byte $FF


;======================================
;
;======================================
IncreaseGamePoints .proc
                clc
                adc GAME_POINTS
                sta GAME_POINTS

                rts
                .endproc


;--------------------------------------
;--------------------------------------

M_TAB           .char -2,-1,0


;======================================
;
;======================================
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
                cmp #OFF
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
                lda M_TAB,X
                jsr IncreaseGamePoints

                lda #2
                clc
                sbc CHOPS
                eor #-1
                jsr IncreaseGamePoints

                ldx PILOT_SKILL
                lda M_TAB,X
                jsr IncreaseGamePoints

                lda GAME_POINTS
                bpl _3

                lda #0
_3              cmp #16
                bcc _4

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
                bcc _6

_next1          lda SCORE1
                sta HI1
                lda SCORE2
                sta HI2
                lda SCORE3
                sta HI3

                jmp _6

_5              bcs _next1

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
                sta (ADR1),Y

                cmp #$10+128
                bne _8

                lda #$A+128
_8              iny
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
                jsr Print

                lda #-1
                sta TIM6_VAL

; - - - - - - - - - - - - - - - - - - -
;   Copy Protection
; - - - - - - - - - - - - - - - - - - -
                ror ScreenOff
; - - - - - - - - - - - - - - - - - - -

                lda #TITLE_MODE
                sta MODE
                sta DEMO_STATUS

                rts
                .endproc


;--------------------------------------
;--------------------------------------

txtGmOvrMission .byte $2D,$29,$33,$33,$29,$2F,$2E           ; 'MISSION' atari-ascii
                .byte $FF
txtGmOvrAbort   .byte $21,$22,$2F,$32,$34,$25,$24           ; 'ABORTED'
                .byte $FF
txtGmOvrComplete .byte $23,$2F,$2D,$30,$2C,$25,$34,$25      ; 'COMPLETED'
                .byte $24
                .byte $FF
txtGmOvrRank    .byte $39,$2F,$35,$32,$00,$00               ; 'YOUR  '
                .byte $32,$21,$2E,$2B,$00,$00,$29,$33       ; 'RANK  IS'
                .byte $FF

txtGmOvrClass   .byte $A3,$AC,$A1,$B3,$B3                   ; 'CLASS'
                .byte $FF

txtGmOvrRating  .addr txtGmOvrRating1,txtGmOvrRating2
                .addr txtGmOvrRating3,txtGmOvrRating4

txtGmOvrRating1 .byte $B3,$B0,$A1,$B2,$B2,$AF,$B7           ; 'SPARROW'
                .byte $FF
txtGmOvrRating2 .byte $A3,$AF,$AE,$A4,$AF,$B2               ; 'CONDOR'
                .byte $FF
txtGmOvrRating3 .byte $A8,$A1,$B7,$AB                       ; 'HAWK'
                .byte $FF
txtGmOvrRating4 .byte $A5,$A1,$A7,$AC,$A5                   ; 'EAGLE'
                .byte $FF

txtHighScore    .byte $A8,$A9,$A7,$A8,$00,$00               ; 'HIGH  '
                .byte $B3,$A3,$AF,$B2,$A5                   ; 'SCORE'
                .byte $FF
