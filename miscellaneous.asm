
; SPDX-FileName: miscellaneous.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;======================================
;
;======================================
INIT_OS         ;.proc
                ldx #$25
_next1          lda $E480,X             ; PUPDIV
                ;!! sta VDSLST,X
                dex
                bpl _next1

                lda #$40
                ;!! sta NMIEN

                ldx #$3B
                ;!! stx PACTL
                ;!! stx PBCTL

                lda #$00
                ;!! sta PORTA
                ;!! sta PORTB

                inx
                ;!! stx PACTL
                ;!! stx PBCTL

                rts
                ;.endproc


;======================================
;
;======================================
ScreenOn        .proc
                jsr ScreenOff

                ; lda #<DSP_LST1
                ; sta SDLST
                ; lda #>DSP_LST1
                ; sta SDLST+1
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

                ; lda #<DSP_LST2
                ; sta SDLST
                ; lda #>DSP_LST2
                ; sta SDLST+1

                lda #kOFF
                sta CHOPPER_STATUS
                sta ROBOT_STATUS

                ldx R_STATUS
                cpx #kCRASH
                bne _1

                sta R_STATUS
_1              ldx #$E0
                lda #0
_next1          sta CHR_SET1+$200,X
                inx
                bne _next1

_next2          sta CHR_SET1+$300,X
                sta PLAY_SCRN+$000,X
                sta PLAY_SCRN+$100,X
                sta PLAY_SCRN+$200,X
                inx
                bne _next2

                stz SND1_1_VAL
                stz SND2_VAL
                stz SND3_VAL
                stz SND4_VAL
                stz SND5_VAL
                stz SND6_VAL
                stz BAK2_COLOR

                lda #20
                sta SND1_2_VAL
                ldx #MAX_TANKS-1
                stx v_roboExplodeTimer
_next3          lda CM_STATUS,X
                cmp #kOFF
                beq _2

                lda #kOFF
                sta CM_STATUS,X
                jsr MissileErase
_2              dex
                bpl _next3

                ldx #2
_next4          lda ROCKET_STATUS,X
                cmp #7                  ; EXP
                bne _3

                lda ROCKET_TEMPX,X
                sta TEMP1
                lda ROCKET_TEMPY,X
                sta TEMP2
                jsr ComputeMapAddr

                ldy #0
                lda ROCKET_TEMP,X
                sta (ADR1),Y
_3              lda #0
                sta ROCKET_STATUS,X
                sta ROCKET_X,X
                dex
                bpl _next4

                jmp ClearSounds
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

                ldy #0
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
                adc #32
_isSpaceChar    ldy v_destIdx           ; right-half of glyph
                sta (v_destAddr),Y
                inc v_destIdx
                inc v_sourceIdx
                bra _nextChar

_XIT            rts
                .endproc


;======================================
;
;======================================
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

_2              ldx #$FF
                txs
                jmp MAIN
                .endproc


;======================================
;
;======================================
ClearInfo       .proc
                ldy #40-1
                lda #0
_next1          sta PLAY_SCRN,Y
                dey
                bpl _next1

                rts
                .endproc


;======================================
;
;======================================
DoChecksum2    .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;---

                ldy #0
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
                and #7
                tax
                ldy #0
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

                ;cmp #$0
                cmp #$90
                beq _XIT

                .byte $12

_XIT            rts
                .endproc
