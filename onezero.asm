; LD/ST/LDR/STR/LEA demo

.ORIG x3000

    LEA R0, A
    LD  R1, ZERO
    LD  R2, ONE
    
    STR R2, R0, #0
    STR R1, R0, #1
    STR R2, R0, #2
    STR R2, R0, #3

    LDR R3, R0, #0

    BRnzp SKIP

A    .BLKW 4
ZERO .FILL x0030
ONE  .FILL x0031
    
SKIP HALT

.END
