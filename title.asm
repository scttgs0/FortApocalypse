;=======================================
; 
;=======================================

Title           .proc
                ldx #$FF
                txs

                lda #$43
                sta COLOR0

                lda #$0F
                sta COLOR1

                lda #$83
                sta COLOR2

                jsr SCREEN_OFF

                lda #<DSP_LST3
                sta SDLST
                lda #>DSP_LST3
                sta SDLST+1

                lda #$3B
                sta TEMP3

                ldy #0
                sty TEMP1_I
_next1          lda TEMP3
                sta PLAY_SCRN,Y
                jsr INC_CHR

                iny
                cpy #40
                bne _next1

                lda #<PLAY_SCRN+39
                sta ADR1
                lda #>PLAY_SCRN+39
                sta ADR1+1

                lda #$3B
                sta TEMP3

                ldx #17
                ldy #0
_next2          lda TEMP3
                sta (ADR1),Y
                iny
                jsr INC_CHR

                sta (ADR1),Y
                dey
                lda ADR1
                clc
                adc #40
                sta ADR1
                lda ADR1+1
                adc #0
                sta ADR1+1
                dex
                bpl _next2

                lda #<T2
                sta VVBLKD
                lda #>T2
                sta VVBLKD+1

                ldx #5
                stx TEMP1
                dex                     ; X=4
                stx TEMP2

                ldx #<txtTitle1
                ldy #>txtTitle1
                jsr PRINT

                inc TEMP1               ; =6

                lda #6
                sta TEMP2
                ldx #<txtTitle2
                ldy #>txtTitle2
                jsr PRINT

                lda #10
                sta TEMP2
                ldx #<txtTitle3
                ldy #>txtTitle3
                jsr PRINT

                ldx #7
_3              lda T_5,X
                sta PLAY_SCRN+426,X
                dex
                bpl _3

                lda #4
                sta TEMP1
                lda #12
                sta TEMP2
                ldx #<txtTitle4
                ldy #>txtTitle4
                jsr PRINT

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

_1              lda FRAME               ; increment TEMP1_I every 8th frame
                and #7
                bne _2
                inc TEMP1_I

_2              lda #$AF                ; set audio channels to full-volume, pure tone
                sta AUDC1
                sta AUDC2

                lda #$FF                ; audio freq increases as TEMP1_I is incremented
                sec
                sbc TEMP1_I
                sta AUDF1               ; this is a divide-by-N circuit - larger numbers are lower freq
                tax
                dex
                stx AUDF2               ; audio channel 2 leads channel 1

                lda TEMP1_I             ; launch demo near the end of the audio scale (avoid the highest notes)
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
                bne _5                  ; FORCED
                .endproc

INC_CHR         .proc
                inc TEMP3
                lda TEMP3
                cmp #$3E
                bne _1
                lda #$3B
_1              sta TEMP3
                rts
                .endproc


;=======================================
;
;=======================================
T3              .proc
                sei

                lda #$A                 ; LASER BLOCK
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
