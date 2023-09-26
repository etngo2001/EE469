// Eugene Ngo
// 5/3/23
// EE 469
// Lab 3

// alu is a module capable of adding, subtracting, anding and oring
// depending on what the control input says,
// and reports any flags that may appear
`timescale 1ns/10ps
module alu(input  logic [31:0] a, b, 
           input  logic [1:0]  ALUControl,
           output logic [31:0] Result, 
           output logic [3:0]  ALUFlags);
	logic [31:0] ADD, AND, OR, c0, b1;
	assign AND = a & b;
	assign OR = a | b;
	
	// converts to negative if we are subtracting
	always_comb begin
		if (ALUControl[0] == 0) begin
			b1 <= b;
		end else begin
			b1 <= ~b;
		end
	end
	
	// Adder for all bits
   // does our subtraction or addition for every bit in
   // out A and B
	fullAdder firstbit (.A(a[0]),.B(b1[0]),.cin(ALUControl[0]),.sum(ADD[0]),.cout(c0[0]));
	genvar i;
	generate
		for (i = 1; i < 32; i++) begin : gen
			fullAdder otherbits(.A(a[i]),.B(b1[i]),.cin(c0[i-1]),.sum(ADD[i]),.cout(c0[i]));
		end
	endgenerate
	
	// determines output based on our ALUControl
	always_comb begin
		if (ALUControl == 2'b11) begin
			Result <= OR;
		end else if (ALUControl == 2'b10) begin
			Result <= AND;
		end else begin
			Result <= ADD;
		end
	end
	
	// Sets all our flags for our computation
	assign ALUFlags[3] = Result[31];
	assign ALUFlags[2] = (Result == 0);
	assign ALUFlags[1] = c0[31] & !ALUControl[1];
	assign ALUFlags[0] = !(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ ADD[31]) & !ALUControl[1];
endmodule

// alu_testbench tests a variety of different inputs and ouputs
// pulled from the alu.tv file.
module alu_testbench();
	logic [31:0] a, b;
   logic [1:0]  ALUControl;
   logic [31:0] Result;
   logic [3:0]  ALUFlags;
	logic clk;
	logic [103:0] testvectors [1000:0];
	
	alu dut (.a,.b,.ALUControl,.Result,.ALUFlags);
	
	parameter CLOCK_PERIOD=100;
	
	initial clk = 1;
	always begin
		#(CLOCK_PERIOD/2);
		clk <= ~clk;
	end
	

	initial begin 
		$readmemh("alu.tv", testvectors);
		for (int i = 0; i < 20; i = i + 1) begin
			{ALUControl,a,b,Result,ALUFlags} = testvectors[i]; @(posedge clk);
		end
	end
endmodule 