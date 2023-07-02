
; SPDX-FileName: TEXT.inc
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


                .enc "atari-screen-inverse"
txtTitle1           .text "FORT  APOCALYPSE",$FF
txtTitle2           .text "BY  STEVE  HALES",$FF
txtTitle3           .text "COPYRIGHT",$FF
txtTitle4           .text "SYNAPSE  SOFTWARE",$FF

txtPilot1           .text "GET  READY  PILOT",$FF
txtPilot2           .text "PILOTS  LEFT",$FF

txtEnter            .text "ENTERING",$FF
txtEnterL1          .text "VAULTS  OF  DRACONIS",$FF
txtEnterL2          .text "CRYSTALLINE  CAVES",$FF

;--------------------------------------

                .enc "atari-screen"
txtGmOvrMission     .text "MISSION",$FF
txtGmOvrAbort       .text "ABORTED",$FF
txtGmOvrComplete    .text "COMPLETED",$FF
txtGmOvrRank        .text "YOUR  RANK  IS",$FF

;--------------------------------------

                .enc "atari-screen-inverse"
txtGmOvrClass       .text "CLASS",$FF

txtGmOvrRating      .addr txtGmOvrRating1,txtGmOvrRating2
                    .addr txtGmOvrRating3,txtGmOvrRating4

txtGmOvrRating1     .text "SPARROW",$FF
txtGmOvrRating2     .text "CONDOR",$FF
txtGmOvrRating3     .text "HAWK",$FF
txtGmOvrRating4     .text "EAGLE",$FF

txtHighScore        .text "HIGH  SCORE",$FF

;--------------------------------------

                .enc "atari-screen"
txtOptTitle1        .text "OPTIONS",$FF
txtOptTitle2        .text "OPTION",$FF
txtOptTitle3        .text "SELECT",$FF

txtOptGravity       .text "GRAVITY SKILL",$FF
txtOptGravity1      .text "WEAK    ",$FF
txtOptGravity2      .text "NORMAL",$FF
txtOptGravity3      .text "STRONG",$FF

txtOptPilot         .text "PILOT SKILL",$FF
txtOptPilot1        .text "NOVICE",$FF
txtOptPilot2        .text "PRO      ",$FF
txtOptPilot3        .text "EXPERT",$FF

txtOptRobo          .text "ROBO PILOTS",$FF
txtOptRobo1         .text "SEVEN   ",$FF
txtOptRobo2         .text "NINE    ",$FF
txtOptRobo3         .text "ELEVEN",$FF

;--------------------------------------

OptGravityTable     .addr txtOptGravity1,txtOptGravity2,txtOptGravity3
OptPilotTable       .addr txtOptPilot1,txtOptPilot2,txtOptPilot3
OptRoboTable        .addr txtOptRobo1,txtOptRobo2,txtOptRobo3

OptTable            .addr txtOptGravity,txtOptPilot,txtOptRobo

;--------------------------------------

                .enc "atari-screen-inverse"
txtMenRemain        .text "MEN  TO  RESCUE",$FF

txtLowOnFuel        .text "LOW  ON  FUEL",$FF
                .enc "none"
