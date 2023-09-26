//Eugene Ngo
//EE 469
//Lab 4
//Task 3

//This part performs floating-point addition.
//The two operands are set in the parameters below and the
//result is stored in R10
leading1Mask: .word 0x800000
operand1: .word 0x3FC00000
operand2: .word 0x40500000
mantissaMask: .word 0x7FFFFF
.global _start
_start:
	LDR R0, operand1			//floating point operand 1
	LDR R1, operand2			//floating point operand 2
	LDR R12, leading1Mask		//for adding leading 1
	LDR R11, mantissaMask		//mantissa mask 23 lower bits
	LSR R4, R0, #23				//get exponent 1 into R4
	AND R4, R4, #0xFF			//last 8 bits are exponent
	SUB R4, R4, #127			//remove bias on exponent 1
	LSR R5, R1, #23 			//get exponent 2 into R5
	AND R5, R5, #0xFF			//last 8 bits are exponent
	SUB R5, R5, #127			//remove bias on exponent 2
	AND R6, R0, R11				//put mant1 into R6
	ORR R6, R6, R12				//leading 1s
	AND R7, R1, R11				//put mant2 into R7
	ORR R7, R7, R12				//leading 1s
	SUBS R9, R4, R5				//store difference in exponent in R9
	BLMI NEG_EXP				//negative exp difference which swaps values in the exp and mant regs and twos complement of exp_diff
	LSR R7, R9					//shift lesser mantissa by exp diff
	ADD R10, R6, R7				//sum mantissas
	ADD R3, R10, #0x1000000		//overflow bit of sum
	CMP R3, #0
	BLGT NORMALIZE				//if overflow then normalize
	ADD R4, R4, #127			//add bias onto exponent
	LSL R4, R4, #23				//shift exponent up 23 bits
	ORR R10, R10, R4			//put exponent into result word
	BIC R10, R10, #0x1000000	//sign bit is 0
	B _start

NORMALIZE:
	LSR R10, #1
	ADD R4, R4, #1				//inc exponent
	MOV PC, LR

//swap registers and do twos complement on difference in exponents
NEG_EXP:
	PUSH {R4}
	MOV R4, R5
	POP {R5}
	PUSH {R6}
	MOV R6, R7
	POP {R7}					//swap registers for mant and expo
	MVN R9, R9					//twos complenent of r9 for expo
	ADD R9, R9, #1
	MOV PC, LR
.end
	