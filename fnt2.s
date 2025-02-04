
00005 * FILE FNT2.S
00010 FNT2
00020 * CHR $00-$1F BLANK
00030 * CHR $20
00040  .DA #%00000000           ;....
00050  .DA #%00100100           ;.RG.
00060  .DA #%01101110           ;GR#R
00070  .DA #%01111110           ;G##R
00080  .DA #%01001000           ;G.R.
00090  .DA #%00111110           ;.##R
00100  .DA #%00101100           ;.R#.
00110  .DA #%00000000           ;....
00120 * CHR $21
00130  .DA #%01010101           ;....       ; red letters on green background
00140  .DA #%01100101           ;.R..
00150  .DA #%01100101           ;.R..
00160  .DA #%10011001           ;R.R.
00170  .DA #%10011001           ;R.R.
00180  .DA #%10101001           ;RRR.
00190  .DA #%10011001           ;R.R.
00200  .DA #%01010101           ;....
00210 * CHR $22
00220  .DA #%01010101           ;....
00230  .DA #%10100101           ;RR..
00240  .DA #%10011001           ;R.R.
00250  .DA #%10100101           ;RR..
00260  .DA #%10011001           ;R.R.
00270  .DA #%10011001           ;R.R.
00280  .DA #%10100101           ;RR..
00290  .DA #%01010101           ;....
00300 * CHR $23
00310  .DA #%01010101           ;....       [C]
00320  .DA #%01100101           ;.R..
00330  .DA #%10011001           ;R.R.
00340  .DA #%10010101           ;R...
00350  .DA #%10010101           ;R...
00360  .DA #%10011001           ;R.R.
00370  .DA #%01100101           ;.R..
00380  .DA #%01010101           ;....
00390 * CHR $24
00400  .DA #%01010101           ;....
00410  .DA #%10100101           ;RR..
00420  .DA #%10011001           ;R.R.
00430  .DA #%10011001           ;R.R.
00440  .DA #%10011001           ;R.R.
00450  .DA #%10011001           ;R.R.
00460  .DA #%10100101           ;RR..
00470  .DA #%01010101           ;....
00480 * CHR $25
00490  .DA #%01010101           ;....
00500  .DA #%10101001           ;RRR.
00510  .DA #%10010101           ;R...
00520  .DA #%10100101           ;RR..
00530  .DA #%10010101           ;R...
00540  .DA #%10010101           ;R...
00550  .DA #%10101001           ;RRR.
00560  .DA #%01010101           ;....
00570 * CHR $26
00580  .DA #%01010101           ;....       [F]
00590  .DA #%10101001           ;RRR.
00600  .DA #%10010101           ;R...
00610  .DA #%10100101           ;RR..
00620  .DA #%10010101           ;R...
00630  .DA #%10010101           ;R...
00640  .DA #%10010101           ;R...
00650  .DA #%01010101           ;....
00660 * CHR $27
00670  .DA #%01010101           ;....
00680  .DA #%01101001           ;.RR.
00690  .DA #%10010101           ;R...
00700  .DA #%10010101           ;R...
00710  .DA #%10011001           ;R.R.
00720  .DA #%10011001           ;R.R.
00730  .DA #%01101001           ;.RR.
00740  .DA #%01010101           ;....
00750 * CHR $28
00760  .DA #%01010101           ;....
00770  .DA #%10011001           ;R.R.
00780  .DA #%10011001           ;R.R.
00790  .DA #%10101001           ;RRR.
00800  .DA #%10011001           ;R.R.
00810  .DA #%10011001           ;R.R.
00820  .DA #%10011001           ;R.R.
00830  .DA #%01010101           ;....
00840 * CHR $29
00850  .DA #%01010101           ;....       [I]
00860  .DA #%10101001           ;RRR.
00870  .DA #%01100101           ;.R..
00880  .DA #%01100101           ;.R..
00890  .DA #%01100101           ;.R..
00900  .DA #%01100101           ;.R..
00910  .DA #%10101001           ;RRR.
00920  .DA #%01010101           ;....
00930 * CHR $2A
00940  .DA #%01010101           ;....
00950  .DA #%01011001           ;..R.
00960  .DA #%01011001           ;..R.
00970  .DA #%01011001           ;..R.
00980  .DA #%01011001           ;..R.
00990  .DA #%10011001           ;R.R.
01000  .DA #%01100101           ;.R..
01010  .DA #%01010101           ;....
01020 * CHR $2B
01030  .DA #%01010101           ;....
01040  .DA #%10011001           ;R.R.
01050  .DA #%10011001           ;R.R.
01060  .DA #%10100101           ;RR..
01070  .DA #%10100101           ;RR..
01080  .DA #%10011001           ;R.R.
01090  .DA #%10011001           ;R.R.
01100  .DA #%01010101           ;....
01110 * CHR $2C
01120  .DA #%01010101           ;....       [L]
01130  .DA #%10010101           ;R...
01140  .DA #%10010101           ;R...
01150  .DA #%10010101           ;R...
01160  .DA #%10010101           ;R...
01170  .DA #%10010101           ;R...
01180  .DA #%10101001           ;RRR.
01190  .DA #%01010101           ;....
01200 * CHR $2D
01210  .DA #%01010101           ;...
01220  .DA #%10010110           ;R..R
01230  .DA #%10011010           ;R.RR
01240  .DA #%10101010           ;RRRR
01250  .DA #%10100110           ;RR.R
01260  .DA #%10010110           ;R..R
01270  .DA #%10010110           ;R..R
01280  .DA #%01010101           ;....
01290 * CHR $2E
01300  .DA #%01010101           ;....
01310  .DA #%10010110           ;R..R
01320  .DA #%10100110           ;RR.R
01330  .DA #%10100110           ;RR.R
01340  .DA #%10011010           ;R.RR
01350  .DA #%10011010           ;R.RR
01360  .DA #%10010110           ;R..R
01370  .DA #%01010101           ;....
01380 * CHR $2F
01390  .DA #%01010101           ;....       [O]
01400  .DA #%01100101           ;.R..
01410  .DA #%10011001           ;R.R.
01420  .DA #%10011001           ;R.R.
01430  .DA #%10011001           ;R.R.
01440  .DA #%10011001           ;R.R.
01450  .DA #%01100101           ;.R..
01460  .DA #%01010101           ;....
01470 * CHR $30
01480  .DA #%01010101           ;....
01490  .DA #%10100101           ;RR..
01500  .DA #%10011001           ;R.R.
01510  .DA #%10011001           ;R.R.
01520  .DA #%10100101           ;RR..
01530  .DA #%10010101           ;R...
01540  .DA #%10010101           ;R...
01550  .DA #%01010101           ;....
01560 * CHR $31
01570  .DA #%01010101           ;....
01580  .DA #%01100101           ;.R..
01590  .DA #%10011001           ;R.R.
01600  .DA #%10011001           ;R.R.
01610  .DA #%10011001           ;R.R.
01620  .DA #%10011001           ;R.R.
01630  .DA #%01100110           ;.R.R
01640  .DA #%01010101           ;....
01650 * CHR $32
01660  .DA #%01010101           ;....       [R]
01670  .DA #%10100101           ;RR..
01680  .DA #%10011001           ;R.R.
01690  .DA #%10011001           ;R.R.
01700  .DA #%10100101           ;RR..
01710  .DA #%10011001           ;R.R.
01720  .DA #%10011001           ;R.R.
01730  .DA #%01010101           ;....
01740 * CHR $33
01750  .DA #%01010101           ;....
01760  .DA #%01101001           ;.RR.
01770  .DA #%10010101           ;R...
01780  .DA #%01100101           ;.R..
01790  .DA #%01011001           ;..R.
01800  .DA #%01011001           ;..R.
01810  .DA #%10100101           ;RR..
01820  .DA #%01010101           ;....
01830 * CHR $34
01840  .DA #%01010101           ;....
01850  .DA #%10101001           ;RRR.
01860  .DA #%01100101           ;.R..
01870  .DA #%01100101           ;.R..
01880  .DA #%01100101           ;.R..
01890  .DA #%01100101           ;.R..
01900  .DA #%01100101           ;.R..
01910  .DA #%01010101           ;....
01920 * CHR $35
01930  .DA #%01010101           ;....       [U]
01940  .DA #%10011001           ;R.R.
01950  .DA #%10011001           ;R.R.
01960  .DA #%10011001           ;R.R.
01970  .DA #%10011001           ;R.R.
01980  .DA #%10011001           ;R.R.
01990  .DA #%10101001           ;RRR.
02000  .DA #%01010101           ;....
02010 * CHR $36
02020  .DA #%01010101           ;....
02030  .DA #%10011001           ;R.R.
02040  .DA #%10011001           ;R.R.
02050  .DA #%10011001           ;R.R.
02060  .DA #%10011001           ;R.R.
02070  .DA #%10011001           ;R.R.
02080  .DA #%01100101           ;.R..
02090  .DA #%01010101           ;....
02100 * CHR $37
02110  .DA #%01010101           ;....
02120  .DA #%10010110           ;R..R
02130  .DA #%10010110           ;R..R
02140  .DA #%10011010           ;R.RR
02150  .DA #%10101010           ;RRRR
02160  .DA #%10100110           ;RR.R
02170  .DA #%10010110           ;R..R
02180  .DA #%01010101           ;....
02190 * CHR $38
02200  .DA #%01010101           ;....       [X]
02210  .DA #%10011001           ;R.R.
02220  .DA #%10011001           ;R.R.
02230  .DA #%01100101           ;.R..
02240  .DA #%01100101           ;.R..
02250  .DA #%10011001           ;R.R.
02260  .DA #%10011001           ;R.R.
02270  .DA #%01010101           ;....
02280 * CHR $39
02290  .DA #%01010101           ;....
02300  .DA #%10011001           ;R.R.
02310  .DA #%10011001           ;R.R.
02320  .DA #%01100101           ;.R..
02330  .DA #%01100101           ;.R..
02340  .DA #%01100101           ;.R..
02350  .DA #%01100101           ;.R..
02360  .DA #%01010101           ;....
02370 * CHR $3A
02380  .DA #%01010101           ;....
02390  .DA #%10101001           ;RRR.
02400  .DA #%01011001           ;..R.
02410  .DA #%01100101           ;.R..
02420  .DA #%01100101           ;.R..
02430  .DA #%10010101           ;R...
02440  .DA #%10101001           ;RRR.
02450  .DA #%01010101           ;....
02460 * CHR $3B
02470  .DA #%00101000           ;.RR.       ; slave legs
02480  .DA #%00001000           ;..R.
02490  .DA #%00001000           ;..R.
02500  .DA #%10101000           ;RRR.
02510  .DA #%00001000           ;..R.
02520  .DA #%00001000           ;..R.
02530  .DA #%00010100           ;.GG.
02540  .DA #%01010101           ;GGGG
02550 * CHR $3C
02560  .DA #%00101000           ;.RR.
02570  .DA #%00001000           ;..R.
02580  .DA #%00001000           ;..R.
02590  .DA #%00100010           ;.R.R
02600  .DA #%10000010           ;R..R
02610  .DA #%00000010           ;...R
02620  .DA #%00010100           ;.GG.
02630  .DA #%01010101           ;GGGG
02640 * CHR $3D
02650  .DA #%00101000           ;.RR.
02660  .DA #%00100000           ;.R..
02670  .DA #%00100000           ;.R..
02680  .DA #%10001000           ;R.R.
02690  .DA #%10000010           ;R..R
02700  .DA #%10000000           ;R...
02710  .DA #%00010100           ;.GG.
02720  .DA #%01010101           ;GGGG
02730 * CHR $3E
02740  .DA #%00101000           ;.RR.
02750  .DA #%00100000           ;.R..
02760  .DA #%00100000           ;.R..
02770  .DA #%00101010           ;.RRR
02780  .DA #%00100000           ;.R..
02790  .DA #%00100000           ;.R..
02800  .DA #%00010100           ;.GG.
02810  .DA #%01010101           ;GGGG
02820 * CHR $3F
02830  .DA #%00000000           ;....
02840  .DA #%00000000           ;....
02850  .DA #%00000000           ;....
02860  .DA #%00000000           ;....
02870  .DA #%00000000           ;....
02880  .DA #%00000000           ;....
02890  .DA #%11111111           ;####
02900  .DA #%00000000           ;....
02910 * CHR $40
02920  .DA #%00000000           ;....
02930  .DA #%00000000           ;....
02940  .DA #%00001000           ;..R.
02950  .DA #%00101010           ;.RRR
02960  .DA #%00101110           ;.R#R
02970  .DA #%00101010           ;.RRR
02980  .DA #%00001000           ;..R.
02990  .DA #%00100010           ;.R.R
03000 * CHR $41
03010  .DA #%10101010           ;RRRR
03020  .DA #%10101010           ;RRRR
03030  .DA #%10101010           ;RRRR
03040  .DA #%10101010           ;RRRR
03050  .DA #%10101010           ;RRRR
03060  .DA #%10101010           ;RRRR
03070  .DA #%10101010           ;RRRR
03080  .DA #%10101010           ;RRRR
03090 * CHR $42
03100  .DA #%00000000           ;....
03110  .DA #%00000000           ;....
03120  .DA #%10101010           ;RRRR
03130  .DA #%10101010           ;RRRR
03140  .DA #%10101010           ;RRRR
03150  .DA #%10101010           ;RRRR
03160  .DA #%10101010           ;RRRR
03170  .DA #%10101010           ;RRRR
03180 * CHR $43
03190  .DA #%00000000           ;....
03200  .DA #%00000000           ;....
03210  .DA #%00000000           ;....
03220  .DA #%00000000           ;....
03230  .DA #%10101010           ;RRRR
03240  .DA #%10101010           ;RRRR
03250  .DA #%10101010           ;RRRR
03260  .DA #%10101010           ;RRRR
03270 * CHR $44
03280  .DA #%00000000           ;....
03290  .DA #%00000000           ;....
03300  .DA #%00000000           ;....
03310  .DA #%00000000           ;....
03320  .DA #%00000000           ;....
03330  .DA #%00000000           ;....
03340  .DA #%10101010           ;RRRR
03350  .DA #%10101010           ;RRRR
03360 * CHR $45
03370  .DA #%10101010           ;RRRR
03380  .DA #%10101010           ;RRRR
03390  .DA #%10101010           ;RRRR
03400  .DA #%10101010           ;RRRR
03410  .DA #%10101010           ;RRRR
03420  .DA #%10101010           ;RRRR
03430  .DA #%10101010           ;RRRR
03440  .DA #%10101010           ;RRRR
03450 * CHR $46
03460  .DA #%10101010           ;RRRR
03470  .DA #%10101010           ;RRRR
03480  .DA #%10101010           ;RRRR
03490  .DA #%10101010           ;RRRR
03500  .DA #%00000000           ;....
03510  .DA #%00000000           ;....
03520  .DA #%00000000           ;....
03530  .DA #%00000000           ;....
03540 * CHR $47
03550  .DA #%11000000           ;#...
03560  .DA #%11100000           ;#R..
03570  .DA #%01110000           ;G#..
03580  .DA #%00111000           ;.#R.
03590  .DA #%00011100           ;.G#.
03600  .DA #%00001110           ;..#R
03610  .DA #%00000111           ;..G#
03620  .DA #%00000011           ;...#
03630 * CHR $48
03640  .DA #%00000000           ;....       ; slave landing pad
03650  .DA #%00000000           ;....
03660  .DA #%00000000           ;....
03670  .DA #%00000000           ;....
03680  .DA #%00000000           ;....
03690  .DA #%00000000           ;....
03700  .DA #%00010100           ;.GG.
03710  .DA #%01010101           ;GGGG
03720 * CHR $49
03730  .DA #%00000000           ;....       ; slave head right-facing
03740  .DA #%00000000           ;....
03750  .DA #%00000000           ;....
03760  .DA #%00000000           ;....
03770  .DA #%00001000           ;..R.
03780  .DA #%00000000           ;....
03790  .DA #%00101010           ;.RRR
03800  .DA #%00101000           ;.RR.
03810 * CHR $4A
03820  .DA #%00000000           ;....       ; slave head left-facing
03830  .DA #%00000000           ;....
03840  .DA #%00000000           ;....
03850  .DA #%00000000           ;....
03860  .DA #%00100000           ;.R..
03870  .DA #%00000000           ;....
03880  .DA #%10101000           ;RRR.
03890  .DA #%00101000           ;.RR.
03900 * CHR $4B
03910  .DA #%00001111           ;..##
03920  .DA #%00001111           ;..##
03930  .DA #%00001111           ;..##
03940  .DA #%00001111           ;..##
03950  .DA #%00000000           ;....
03960  .DA #%00000000           ;....
03970  .DA #%00000000           ;....
03980  .DA #%00000000           ;....
03990 * CHR $4C
04000  .DA #%00111110           ;.##R
04010  .DA #%00111110           ;.##R
04020  .DA #%11111010           ;##RR
04030  .DA #%11111010           ;##RR
04040  .DA #%11101010           ;#RRR
04050  .DA #%11101010           ;#RRR
04060  .DA #%10101010           ;RRRR
04070  .DA #%10101010           ;RRRR
04080 * CHR $4D
04090  .DA #%10111100           ;R##.
04100  .DA #%10111100           ;R##.
04110  .DA #%10101111           ;RR##
04120  .DA #%10101111           ;RR##
04130  .DA #%10101011           ;RRR#
04140  .DA #%10101011           ;RRR#
04150  .DA #%10101010           ;RRRR
04160  .DA #%10101010           ;RRRR
04170 * CHR $4E
04180  .DA #%10101010           ;RRRR
04190  .DA #%10101010           ;RRRR
04200  .DA #%11101010           ;#RRR
04210  .DA #%11101010           ;#RRR
04220  .DA #%11111010           ;##RR
04230  .DA #%11111010           ;##RR
04240  .DA #%00111110           ;.##R
04250  .DA #%00111110           ;.##R
04260 * CHR $4F
04270  .DA #%10101010           ;RRRR
04280  .DA #%10101010           ;RRRR
04290  .DA #%10101011           ;RRR#
04300  .DA #%10101011           ;RRR#
04310  .DA #%10101111           ;RR##
04320  .DA #%10101111           ;RR##
04330  .DA #%10111100           ;R##.
04340  .DA #%10111100           ;R##.
04350 * CHR $50
04360  .DA #%00000000           ;....
04370  .DA #%00111100           ;.##.
04380  .DA #%00111100           ;.##.
04390  .DA #%11111111           ;####
04400  .DA #%11101011           ;#RR#
04410  .DA #%10101010           ;RRRR
04420  .DA #%10101010           ;RRRR
04430  .DA #%10101010           ;RRRR
04440 * CHR $51
04450  .DA #%10101010           ;RRRR
04460  .DA #%10101010           ;RRRR
04470  .DA #%10101010           ;RRRR
04480  .DA #%11101011           ;#RR#
04490  .DA #%11111111           ;####
04500  .DA #%00111100           ;.##.
04510  .DA #%00111100           ;.##.
04520  .DA #%00000000           ;....
04530 * CHR $52
04540  .DA #%10111100           ;R##.
04550  .DA #%10111100           ;R##.
04560  .DA #%10101111           ;RR##
04570  .DA #%10101111           ;RR##
04580  .DA #%10101111           ;RR##
04590  .DA #%10101111           ;RR##
04600  .DA #%10111100           ;R##.
04610  .DA #%10111100           ;R##.
04620 * CHR $53
04630  .DA #%00111010           ;.#RR
04640  .DA #%00111010           ;.#RR
04650  .DA #%11101010           ;#RRR
04660  .DA #%11101010           ;#RRR
04670  .DA #%11101010           ;#RRR
04680  .DA #%11101010           ;#RRR
04690  .DA #%00111010           ;.#RR
04700  .DA #%00111010           ;.#RR
04710 * CHR $54
04720  .DA #%00101000           ;.RR.
04730  .DA #%00101000           ;.RR.
04740  .DA #%00010100           ;.GG.
04750  .DA #%00101000           ;.RR.
04760  .DA #%00101000           ;.RR.
04770  .DA #%00010100           ;.GG.
04780  .DA #%00101000           ;.RR.
04790  .DA #%00101000           ;.RR.
04800 * CHR $55
04810  .DA #%00101000           ;.RR.
04820  .DA #%00101000           ;.RR.
04830  .DA #%00010100           ;.GG.
04840  .DA #%00101010           ;.RRR
04850  .DA #%00101010           ;.RRR
04860  .DA #%00010100           ;.GG.
04870  .DA #%00101000           ;.RR.
04880  .DA #%00101000           ;.RR.
04890 * CHR $56
04900  .DA #%00101000           ;.RR.
04910  .DA #%00101000           ;.RR.
04920  .DA #%00010100           ;.GG.
04930  .DA #%10101000           ;RRR.
04940  .DA #%10101000           ;RRR.
04950  .DA #%00010100           ;.GG.
04960  .DA #%00101000           ;.RR.
04970  .DA #%00101000           ;.RR.
04980 * CHR $57
04990  .DA #%00000000           ;....
05000  .DA #%00000000           ;....
05010  .DA #%00000000           ;....
05020  .DA #%10101010           ;RRRR
05030  .DA #%10101010           ;RRRR
05040  .DA #%00000000           ;....
05050  .DA #%00000000           ;....
05060  .DA #%00000000           ;....
05070 * CHR $58
05080  .DA #%00111100           ;.##.
05090  .DA #%11111111           ;####
05100  .DA #%11111111           ;####
05110  .DA #%11000011           ;#..#
05120  .DA #%11000011           ;#..#
05130  .DA #%11111111           ;####
05140  .DA #%11111111           ;####
05150  .DA #%00111100           ;.##.
05160 * CHR $59
05170  .DA #%10101010           ;####       ; num-1 on red background
05180  .DA #%10100010           ;##.#
05190  .DA #%10000010           ;#..#
05200  .DA #%10100010           ;##.#
05210  .DA #%10100010           ;##.#
05220  .DA #%10100010           ;##.#
05230  .DA #%10101010           ;####
05240  .DA #%10101010           ;####
05250 * CHR $5A
05260  .DA #%10101010           ;####       ; num-2 on red background
05270  .DA #%10000010           ;#..#
05280  .DA #%10100010           ;##.#
05290  .DA #%10000010           ;#..#
05300  .DA #%10001010           ;#.##
05310  .DA #%10000010           ;#..#
05320  .DA #%10101010           ;####
05330  .DA #%10101010           ;####
05340 * CHR $5B
05350  .DA #%00000000           ;....
05360  .DA #%00000000           ;....
05370  .DA #%00000010           ;...R
05380  .DA #%00001010           ;..RR
05390  .DA #%00001010           ;..RR
05400  .DA #%00001010           ;..RR
05410  .DA #%00000010           ;...R
05420  .DA #%00001000           ;..R.
05430 * CHR $5C
05440  .DA #%00000000           ;....
05450  .DA #%00000000           ;....
05460  .DA #%00000000           ;....
05470  .DA #%10000000           ;R...
05480  .DA #%11000000           ;#...
05490  .DA #%10000000           ;R...
05500  .DA #%00000000           ;....
05510  .DA #%10000000           ;R...
05520 * CHR $5D
05530  .DA #%00000000           ;....
05540  .DA #%00000000           ;....
05550  .DA #%00000000           ;....
05560  .DA #%00000010           ;...R
05570  .DA #%00000010           ;...R
05580  .DA #%00000010           ;...R
05590  .DA #%00000000           ;....
05600  .DA #%00000010           ;...R
05610 * CHR $5E
05620  .DA #%00000000           ;....
05630  .DA #%00000000           ;....
05640  .DA #%10000000           ;R...
05650  .DA #%10100000           ;RR..
05660  .DA #%10100000           ;RR..
05670  .DA #%10100000           ;RR..
05680  .DA #%10000000           ;R...
05690  .DA #%00100000           ;.R..
05700 * CHR $5F
05710  .DA #%00000000           ;....
05720  .DA #%00000000           ;....
05730  .DA #%00100000           ;.R..
05740  .DA #%10101000           ;RRR.
05750  .DA #%11101000           ;#RR.
05760  .DA #%10101000           ;RRR.
05770  .DA #%00100000           ;.R..
05780  .DA #%10001000           ;R.R.
05790 * CHR $60
05800  .DA #%00000000           ;....
05810  .DA #%00011000           ;.GR.
05820  .DA #%00111100           ;.##.
05830  .DA #%01111110           ;G##R
05840  .DA #%01111110           ;G##R
05850  .DA #%00111100           ;.##.
05860  .DA #%00011000           ;.GR.
05870  .DA #%00000000           ;....
05880 * CHR $61
05890  .DA #%01010101           ;GGGG       ; terrain
05900  .DA #%01010101           ;GGGG
05910  .DA #%01010101           ;GGGG
05920  .DA #%01010101           ;GGGG
05930  .DA #%01010101           ;GGGG
05940  .DA #%01010101           ;GGGG
05950  .DA #%01010101           ;GGGG
05960  .DA #%01010101           ;GGGG
05970 * CHR $62
05980  .DA #%00000000           ;....
05990  .DA #%00010000           ;.G..
06000  .DA #%01010001           ;GG.G
06010  .DA #%01010101           ;GGGG
06020  .DA #%01010101           ;GGGG
06030  .DA #%01010101           ;GGGG
06040  .DA #%01010101           ;GGGG
06050  .DA #%01010101           ;GGGG
06060 * CHR $63
06070  .DA #%00000000           ;....
06080  .DA #%00000000           ;....
06090  .DA #%00000000           ;....
06100  .DA #%00000000           ;....
06110  .DA #%00010100           ;.GG.
06120  .DA #%01010100           ;GGG.
06130  .DA #%01010101           ;GGGG
06140  .DA #%01010101           ;GGGG
06150 * CHR $64
06160  .DA #%00000000           ;....
06170  .DA #%00000000           ;....
06180  .DA #%00000000           ;....
06190  .DA #%00000000           ;....
06200  .DA #%00000000           ;....
06210  .DA #%00000100           ;..G.
06220  .DA #%01000101           ;G.GG
06230  .DA #%01010101           ;GGGG
06240 * CHR $65
06250  .DA #%01010101           ;GGGG
06260  .DA #%01010101           ;GGGG
06270  .DA #%01010101           ;GGGG
06280  .DA #%01010101           ;GGGG
06290  .DA #%01010101           ;GGGG
06300  .DA #%01000101           ;G.GG
06310  .DA #%00000100           ;..G.
06320  .DA #%00000000           ;....
06330 * CHR $66
06340  .DA #%01010101           ;GGGG
06350  .DA #%01010101           ;GGGG
06360  .DA #%01010101           ;GGGG
06370  .DA #%01010001           ;GG.G
06380  .DA #%01000000           ;G...
06390  .DA #%00000000           ;....
06400  .DA #%00000000           ;....
06410  .DA #%00000000           ;....
06420 * CHR $67
06430  .DA #%01010101           ;GGGG
06440  .DA #%01010001           ;GG.G
06450  .DA #%00010000           ;.G..
06460  .DA #%00010000           ;.G..
06470  .DA #%00000000           ;....
06480  .DA #%00000000           ;....
06490  .DA #%00000000           ;....
06500  .DA #%00000000           ;....
06510 * CHR $68
06520  .DA #%01000000           ;G...
06530  .DA #%01000000           ;G...
06540  .DA #%01010000           ;GG..
06550  .DA #%01010000           ;GG..
06560  .DA #%01000000           ;G...
06570  .DA #%01010000           ;GG..
06580  .DA #%01010000           ;GG..
06590  .DA #%01000000           ;G...
06600 * CHR $69
06610  .DA #%01010100           ;GGG.
06620  .DA #%01010000           ;GG..
06630  .DA #%01010000           ;GG..
06640  .DA #%01010100           ;GGG.
06650  .DA #%01010000           ;GG..
06660  .DA #%01010100           ;GGG.
06670  .DA #%01010100           ;GGG.
06680  .DA #%01010000           ;GG..
06690 * CHR $6A
06700  .DA #%00000101           ;..GG
06710  .DA #%00000001           ;...G
06720  .DA #%00000001           ;...G
06730  .DA #%00000101           ;..GG
06740  .DA #%00000101           ;..GG
06750  .DA #%00000001           ;...G
06760  .DA #%00000101           ;..GG
06770  .DA #%00000001           ;...G
06780 * CHR $6B
06790  .DA #%00000101           ;..GG
06800  .DA #%00010101           ;.GGG
06810  .DA #%00010101           ;.GGG
06820  .DA #%00000101           ;..GG
06830  .DA #%00010101           ;.GGG
06840  .DA #%00010101           ;.GGG
06850  .DA #%00010101           ;.GGG
06860  .DA #%00000101           ;..GG
06870 * CHR $6C
06880  .DA #%00000000           ;....
06890  .DA #%11000000           ;#...
06900  .DA #%11110000           ;##..
06910  .DA #%11111111           ;####
06920  .DA #%01010101           ;GGGG
06930  .DA #%00100010           ;.R.R
06940  .DA #%00101010           ;.RRR
06950  .DA #%00001000           ;..R.
06960 * CHR $6D
06970  .DA #%00111100           ;.##.
06980  .DA #%11111111           ;####
06990  .DA #%11111111           ;####
07000  .DA #%11111111           ;####
07010  .DA #%01010101           ;GGGG
07020  .DA #%00100010           ;.R.R
07030  .DA #%10101010           ;RRRR
07040  .DA #%10001000           ;R.R.
07050 * CHR $6E
07060  .DA #%00000000           ;....
07070  .DA #%00000000           ;....
07080  .DA #%00000000           ;....
07090  .DA #%11110000           ;##..
07100  .DA #%01010101           ;GGGG
07110  .DA #%00100010           ;.R.R
07120  .DA #%10101010           ;RRRR
07130  .DA #%10001000           ;R.R.
07140 * CHR $6F
07150  .DA #%00000010           ;...R
07160  .DA #%00001010           ;..RR
07170  .DA #%00001000           ;..R.
07180  .DA #%00101000           ;.RR.
07190  .DA #%00101000           ;.RR.
07200  .DA #%10101100           ;RR#.
07210  .DA #%10111100           ;R##.
07220  .DA #%00111100           ;.##.
07230 * CHR $70
07240  .DA #%10000000           ;R...
07250  .DA #%10100000           ;RR..
07260  .DA #%00100000           ;.R..
07270  .DA #%00101000           ;.RR.
07280  .DA #%00101000           ;.RR.
07290  .DA #%00111010           ;.#RR
07300  .DA #%00111110           ;.##R
07310  .DA #%00111100           ;.##.
07320 * CHR $71
07330  .DA #%00000000           ;....
07340  .DA #%00000000           ;....
07350  .DA #%00001010           ;..RR
07360  .DA #%10101111           ;RR##
07370  .DA #%10101111           ;RR##
07380  .DA #%00001010           ;..RR
07390  .DA #%00000000           ;....
07400  .DA #%00000000           ;....
07410 * CHR $72
07420  .DA #%00000000           ;....
07430  .DA #%00000000           ;....
07440  .DA #%10100000           ;RR..
07450  .DA #%11101010           ;#RRR
07460  .DA #%11101010           ;#RRR
07470  .DA #%10100000           ;RR..
07480  .DA #%00000000           ;....
07490  .DA #%00000000           ;....
07500 * CHR $73-$7F BLANK
