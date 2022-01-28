

TEST_joy        .proc
                jsr ReadJoystick
_XIT            rts
                .endproc

TEST_trigger    .proc
                jsr ReadTrigger
_XIT            rts
                .endproc

TEST_keybd      .proc
                jsr ReadKeyboard
_XIT            rts
                .endproc

                .include "../input.asm"
