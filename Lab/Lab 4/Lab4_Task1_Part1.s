//Eugene Ngo
//EE 469
//Lab 4
//Task 1 Part 1

.global _start
_start:
	mov r0, #4
	mov r1, #5
	add r2, r0, r1
	add r3, r2, r0
	add r3, r3, r1
	sub r3, r3, #3
	mov r4, #39
	mul r4, r4, r0
	str r3, [r4]
S:
	B S
.end
	