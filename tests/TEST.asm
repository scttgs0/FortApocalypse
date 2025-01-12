
                .cpu "65816"

                * = $03_0000
                clc
                xce

;======================================

RunTests        jsr TEST_font           ; test_font.asm

                jsr TEST_joy            ; test_input.asm
                jsr TEST_trigger
                jsr TEST_keybd

;--------------------------------------

                jsr CheckForExit

                bra RunTests

;======================================

PRINT           .proc
_XIT            rts
                .endproc


CheckForExit    .proc
_XIT            rts
                .endproc

                .include "test_input.asm"
