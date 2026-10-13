;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ECE 109 Demo Code
; This code subtracts R1 from R2 and stores in R3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		.ORIG x3000
		
		ADD R1, R1, #5	; LOAD INITIAL VALUES INTO REGISTERS
		ADD R2, R2, #7
		
		NOT R1, R1		; CALCULATES -R1
		ADD R1, R1, #1
		
		ADD R3, R2, R1		
				
		HALT
		
		.END