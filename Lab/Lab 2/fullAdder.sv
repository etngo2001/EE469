// Eugene Ngo
// 4/20/2023
// CSE 469
// Lab 1 Task 3

// A module to implement a fullAdder.
// This file was reused from a given file in EE 371
module fullAdder (a, b, carryIn, Result, carryOut);

	input  logic a, b, carryIn;
	output logic Result, carryOut;
	
	assign  Result = a ^ b ^ carryIn;
	assign carryOut = (a & b) | (carryIn & (a ^ b));

endmodule 