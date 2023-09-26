// Eugene Ngo
// 4/7/2023
// CSE 469
// Lab 1 Task 3

// alu_testbench tests all expected, unexpected, and edgecase behaviors
module alu_testbench();
	logic [31:0] a,b;
	logic [1:0] ALUControl;
	logic [31:0] Result;
	logic [3:0] ALUFlags;
	logic clk;
	logic [103:0] testvectors [1000:0];
	
	alu dut (.a(a), .b(b), .ALUControl(ALUControl), .Result(Result),
				.ALUFlags(ALUFlags));
	
	parameter CLOCK_PERIOD = 100;
	
	initial clk = 1;
	
	always begin
			#(CLOCK_PERIOD/2);
			clk = ~clk;
	end
	
	initial begin
		$readmemh("alu.tv", testvectors);
		
		for (int i = 0; i < 20; i = i + 1) begin
			{ALUControl, a, b, Result, ALUFlags} = testvectors[i];
			@(posedge clk);
		end // end loop
	end // end initial
endmodule