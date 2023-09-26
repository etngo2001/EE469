.equ PUSHBUTTON, 4280287312
.equ LED, 4280287232
start:
	movia r2,PUSHBUTTON
	ldwio r3,(r2) # Read in buttons - active high
	movia r2,LED
	stwio r3,0(r2) # Write to LEDs
	br start
