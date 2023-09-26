// Eugene Ngo
// 5/3/23
// EE 469
// Lab 3

// fullAdder takes in 2 bits, a and b, as well as a possible carry in bit and adds them together
// if there is a carry out, we output that bit in cout.
module fullAdder (A,B,cin,sum,cout);
	input logic A,B,cin;
	output logic sum,cout;
	
	assign sum = A ^ B ^ cin;
	assign cout = A & B | cin & (A^B);
endmodule

module fullAdder_testbench();
	logic A,B,cin,sum,cout;
	fullAdder dut (A,B,cin,sum,cout);
	
	integer i;
	initial begin
		for (i = 0; i < 2**3; i++) begin
			{A,B,cin} = i; #10;
		end
	end
	
endmodule
