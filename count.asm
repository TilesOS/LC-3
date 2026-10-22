; count the number of characters in a string named ETERNALBLISS

.ORIG x3000

AND R1, R1, #0 ; counter
LEA R0, ETERNALBLISS
PUTS

LOOP
    LDR R2, R0, #0 ; gets first character
    BRz DONE
    ADD R1, R1, #1 ; increment counter
    ADD R0, R0, #1 ; increment pointer
BRnzp LOOP

ETERNALBLISS .STRINGZ "ETERNALBLISS"

DONE HALT

.END
