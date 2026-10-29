; ECE 109 Program 1: xor.asm
; Tyler McClure
; Spec details are followed as sections of the code

; Register usage for self reference:
; R0 - character I/O
; R1 - scratch, current bit value
; R2 - scratch, then XOR result during printing
; R3 - accumulated 4-bit value, scratch
; R4 - bit counter
; R5 - print mask
; R7 - never holds data

.ORIG x3000

; STEP 1: Newline, then the first prompt

STEP1
LD   R0, NEWLINE
OUT
LEA  R0, PROMPT1
PUTS

; STEP 2: Read first number (echo every key, keep only '0'/'1'), then store at x4000

AND  R3, R3, #0           ; clear 
LD   R4, COUNT            ; complete when 4 valid bits
GET_FIRST
GETC                      
OUT                       

LD   R1, NEG_Q
ADD  R1, R0, R1
BRz  QUIT                 ; quit on 'q'

LD   R1, NEG_ZERO
ADD  R1, R0, R1           ; R1 = key - '0'
BRn  GET_FIRST            ; below '0': ignore
ADD  R2, R1, #-1          ; R2 = key - '1'
BRp  GET_FIRST            ; above '1': ignore

ADD  R3, R3, R3           ; shift accumulator left
ADD  R3, R3, R1           ; add the new bit (0 or 1)
ADD  R4, R4, #-1
BRp  GET_FIRST

STI  R3, ADDR1            ; store first number at x4000

; STEP 3: Newline, then the second prompt

LD   R0, NEWLINE
OUT
LEA  R0, PROMPT2
PUTS

; STEP 4: Read second number (same as Step 2), store it at x4001

AND  R3, R3, #0           ; clear accumulator
LD   R4, COUNT            ; need 4 valid bits
GET_SECOND
GETC                      ; R0 = key
OUT                       ; echo every key, valid or not

LD   R1, NEG_Q
ADD  R1, R0, R1
BRz  QUIT                 ; 'q' -> Step 5

LD   R1, NEG_ZERO
ADD  R1, R0, R1           ; R1 = key - '0'
BRn  GET_SECOND           ; below '0': ignore
ADD  R2, R1, #-1          ; R2 = key - '1'
BRp  GET_SECOND           ; above '1': ignore

ADD  R3, R3, R3           ; shift accumulator left
ADD  R3, R3, R1           ; add the new bit (0 or 1)
ADD  R4, R4, #-1
BRp  GET_SECOND

STI  R3, ADDR2            ; store second number at x4001

; (STEP 5, the 'q' handler, is at the end: it is only reached by a
;  branch from Steps 2 and 4, so it sits outside the main flow.)

;

; STEP 6: XOR the stored numbers, store result at x4002
;         A XOR B = (A OR B) AND NOT(A AND B)

LDI  R1, ADDR1            ; R1 = A
LDI  R2, ADDR2            ; R2 = B

NOT  R3, R1               ; R3 = NOT A
NOT  R4, R2               ; R4 = NOT B
AND  R3, R3, R4           ; R3 = NOT A AND NOT B
NOT  R3, R3               ; R3 = A OR B
AND  R4, R1, R2           ; R4 = A AND B
NOT  R4, R4               ; R4 = NOT(A AND B)
AND  R2, R3, R4           ; R2 = A XOR B

STI  R2, ADDR3            ; store result at x4002

; STEP 7: Newline, result message, 4 ASCII bits (bit 3 first), newline

LD   R0, NEWLINE
OUT
LEA  R0, RESULT_MSG
PUTS

LD   R4, COUNT            ; 4 bits to print
LD   R5, MASK_BIT3        ; mask = x0008
PRINT_BITS
LD   R0, ASCII_ZERO       ; assume '0'
AND  R3, R2, R5           ; test bit 3
BRz  PRINT_ONE_BIT
ADD  R0, R0, #1           ; bit is 1: '0' -> '1'
PRINT_ONE_BIT
OUT
ADD  R2, R2, R2           ; shift next bit into position 3
ADD  R4, R4, #-1
BRp  PRINT_BITS

LD   R0, NEWLINE          ; newline at end of result line
OUT

; STEP 8: Repeat from Step 1

BRnzp STEP1

; STEP 5: 'q' typed (already echoed) -> newline, goodbye, halt

QUIT
LD   R0, NEWLINE
OUT
LEA  R0, QUIT_MSG
PUTS
HALT

; CONSTANTS

ADDR1           .FILL x4000
ADDR2           .FILL x4001
ADDR3           .FILL x4002

COUNT           .FILL #4
MASK_BIT3       .FILL x0008

NEWLINE         .FILL x000A     ; ASCII '\n'
ASCII_ZERO      .FILL x0030     ; ASCII '0'

NEG_Q           .FILL #-113     ; -('q')
NEG_ZERO        .FILL #-48      ; -('0')

PROMPT1         .STRINGZ "Enter First Number (4 binary digits): "
PROMPT2         .STRINGZ "Enter Second Number (4 binary digits): "
RESULT_MSG      .STRINGZ "The XOR function of the two numbers is: "
QUIT_MSG        .STRINGZ "Thank you for playing!"

.END
