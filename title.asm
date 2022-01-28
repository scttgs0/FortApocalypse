;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: title.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
; Title Screen handler
;=======================================
Title           .proc
c_horzCount     = 40
c_vertCount     = 17
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

                jsr SCREEN_OFF

                lda #<DSP_LST3          ; title screen display list
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

                lda #<T2                ; setup the deferred VBI (move the dots)
                sta VVBLKD
                lda #>T2
                sta VVBLKD+1

                ldx #5
                stx v_posX
                dex
                stx v_posY
                ldx #<txtTitle1         ; output the first title
                ldy #>txtTitle1
                jsr PRINT               ; (5, 4) 'Fort Apocalypse'

                inc v_posX
                lda #6
                sta v_posY
                ldx #<txtTitle2         ; output the second title
                ldy #>txtTitle2
                jsr PRINT               ; (6, 6) 'By Steve Hales'

                lda #10
                sta v_posY
                ldx #<txtTitle3         ; output the third title
                ldy #>txtTitle3
                jsr PRINT               ; (6, 10) 'Copyright 1982'

                ldx #7
_3              lda T_5,X
                sta PLAY_SCRN+426,X     ; output the copyright date (1982)
                dex
                bpl _3

                lda #4
                sta v_posX
                lda #12
                sta v_posY
                ldx #<txtTitle4         ; output the fourth title
                ldy #>txtTitle4
                jsr PRINT               ; (4, 12) 'Synapse Software'

; change the text color for each scan line
_endless1       lda VCOUNT              ; current scan line being draw on screen (divided by 2)
                asl                     ; double it to get the real scan line number
                sta WSYNC               ; halt until next horz sync
                sta COLPF3              ; alter the playfield color
                bra _endless1

                .endproc


;=======================================
; Deferred VBlank Interrupt
;=======================================
T2              .proc
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
                beq _4

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
_5              stx DEMO_STATUS
                jmp T3

_4              ldx #-1                 ; START DEMO
                bra _5
                .endproc


;=======================================
; Cycle through $3B -> $3D -> $3B...
;---------------------------------------
; marquee dots order: red, white, green
;=======================================
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


;=======================================
;
;=======================================
T3              .proc
                sei

                lda #$0A                ; LASER BLOCK
                sta COLOR1

                lda #$94                ; LASERS,HOUSE
                sta COLOR2

                lda #$9A                ; LETTERS
                sta COLOR3

                lda #<VERTBLKD          ; enable deferred VBI
                sta VVBLKD
                lda #>VERTBLKD
                sta VVBLKD+1

                jsr SCREEN_OFF

_wait1          lda VCOUNT              ; wait for next horz sync
                bne _wait1

                lda #$C0                ; enable VBI & DLI
                sta NMIEN

                cli

                brl MAIN
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
