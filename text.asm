;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: text.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

;---------------------------------------

txtPilot1       .byte $A7,$A5,$B4,$00,$00                   ; 'GET  ' atari-ascii
                .byte $B2,$A5,$A1,$A4,$B9,$00,$00           ; 'READY  '
                .byte $B0,$A9,$AC,$AF,$B4                   ; 'PILOT'
                .byte $FF
txtPilot2       .byte $B0,$A9,$AC,$AF,$B4,$B3,$00,$00       ; 'PILOTS  '
                .byte $AC,$A5,$A6,$B4                       ; 'LEFT'
                .byte $FF

;---------------------------------------

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

;---------------------------------------

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
txtOptGravity1  .byte $37,$25,$21,$2B,$00,$00,$00,$00       ; 'WEAK    '
                .byte $FF
txtOptGravity2  .byte $2E,$2F,$32,$2D,$21,$2C               ; 'NORMAL'
                .byte $FF
txtOptGravity3  .byte $33,$34,$32,$2F,$2E,$27               ; 'STRONG'
                .byte $FF


txtOptPilot     .byte $30,$29,$2C,$2F,$34,$00               ; 'PILOT '
                .byte $33,$2B,$29,$2C,$2C                   ; 'SKILL'
                .byte $FF
txtOptPilot1    .byte $2E,$2F,$36,$29,$23,$25               ; 'NOVICE'
                .byte $FF
txtOptPilot2    .byte $30,$32,$2F,$00,$00,$00,$00,$00       ; 'PRO      '
                .byte $00
                .byte $FF
txtOptPilot3    .byte $25,$38,$30,$25,$32,$34               ; 'EXPERT'
                .byte $FF


txtOptRobo      .byte $32,$2F,$22,$2F,$00                   ; 'ROBO '
                .byte $30,$29,$2C,$2F,$34,$33               ; 'PILOTS'
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

;---------------------------------------

txtMenRemain    .byte $AD,$A5,$AE,$00,$00                   ; 'MEN  ' atari-ascii
                .byte $B4,$AF,$00,$00                       ; 'TO  '
                .byte $B2,$A5,$B3,$A3,$B5,$A5               ; 'RESCUE'
                .byte $FF

txtLowOnFuel    .byte $AC,$AF,$B7,$00,$00                   ; 'LOW  ' atari-ascii
                .byte $AF,$AE,$00,$00                       ; 'ON  '
                .byte $A6,$B5,$A5,$AC                       ; 'FUEL'
                .byte $FF

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
