//Eugene Ngo
//EE 469
//Lab 4
//Task 2

//This part counts the number of bits that are set within a 32-bit
//operand stored in R0 and the output is stored in R2
.global _start
_start:
	MOV R0, #0xFF000000
	MOV R1, #0				//count of 1s
	MOV R2, #32				//loop index, will break the loop when R2 == 0
LOOP:
	CMP R2, #0
	BEQ END					//end loops if R2 is 0, else decrement
	SUB R2, R2, #1
	BIC R3, R0, #0xFFFFFF	//clear all but last bit
	LSR R0, #1				//shifts all bits right by 1
	CMP R2, #0				//determines if last bit is 0 or 1
	BLNE INCREMENT			//then increment
	B LOOP;					//continue loop
INCREMENT:
	ADD R1, R1, #1
	MOV PC, LR;				//go back
	
END:
	NOP
.end
	