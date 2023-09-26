// Eugene Ngo
// 5/3/23
// EE 469
// Lab 3

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