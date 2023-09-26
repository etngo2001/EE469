// Eugene Ngo
// 4/7/2023
// CSE 469
// Lab 1 Task 3

// singleALU implements ALU logic for single bits which can be combined to
// make up large ALUs.
module singleALU (a, b, carryIn, ALUControl, Result, carryOut);
	input logic a, b, carryIn;
	input logic [1:0] ALUControl;
	output logic Result, carryOut;
	
	
	logic [2:0] outputs;
	
	and andValue (outputs[1], b, a);
	or  orValue  (outputs[2], b, a);
	
	// Selecting B (Addition = A+B+0, Subtraction = A+(~B)+1)
	// logic subtractSelector = ALUControl[0];
	
	// MUX to select B (ALUControl[0] == 1 = select ~B)
	wire middleValues[1:0];
	and selectB (middleValues[0], ~ALUControl[0], b);
	and selectNotB (middleValues[1], ALUControl[0], ~b);
	
	logic selectedB;
	or selectedBValue (selectedB, middleValues[0], middleValues[1]);	

	fullAdder fullAddedValue (.a(a), .b(selectedB), .carryIn(carryIn),
									  .Result(outputs[0]), .carryOut(carryOut));
	
	// MUX to select between computed values (add, sub, and, or)
	
	always_comb begin
		case (ALUControl)
			2'b00: Result = outputs[0];
			2'b01: Result = outputs[0];
			2'b10: Result = outputs[1];
			2'b11: Result = outputs[2];
			default: Result = 1'bX;
		endcase // end case statements
	end // end comb block
	// End of module
	
endmodule
