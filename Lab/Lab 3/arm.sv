// Eugene Ngo
// 5/3/23
// EE 469
// Lab 3

/* arm is the spotlight of the show and contains the bulk of the datapath and control logic. This module is split into two parts, the datapath and control. 
*/

// clk - system clock
// rst - system reset
// Instr - incoming 32 bit instruction from imem, contains opcode, condition, addresses and or immediates
// ReadData - data read out of the dmem
// WriteData - data to be written to the dmem
// MemWrite - write enable to allowed WriteData to overwrite an existing dmem word
// PC - the current program count value, goes to imem to fetch instruciton
// ALUResult - Result of the ALU operation, sent as address to the dmem

module arm (
    input  logic        clk, rst,
    input  logic [31:0] InstrF,
    input  logic [31:0] ReadData,
    output logic [31:0] WriteDataM, 
    output logic [31:0] PC, ALUResultM,
    output logic        MemWrite
);

    // datapath buses and signals
    logic [31:0] PCPrime, PCPlus4, PCPlus8, PCF; // pc signals
    logic [ 3:0] RA1, RA2;                  // regfile input addresses
    logic [31:0] RD1E, RD1D, RD2E, RD2D;                  // raw regfile outputs
    logic [ 3:0] ALUFlags;                  // alu combinational flag outputs
	 logic [ 3:0] FlagsReg;						  // Flag output from recent CMP
    logic [31:0] ExtImm, SrcA, SrcB, ExtImmE;        // immediate and alu inputs 
    logic [31:0] ResultW;                    // computed or fetched value to be written into regfile or pc
	 logic [31:0] RA1E, RA2E, SrcAE, SrcBE, InstrD, ALUResultE, ALUOutW, WriteDataE, ReadDataW;

    // control signals
    logic PCSrc, MemToReg, ALUSrc, RegWrite, FlagWrite;
    logic [1:0] RegSrc, ImmSrc, ALUControl;
	 logic PCSrcD, PCSrcE, PCSrcM, PCSrcW;
	 logic RegWriteD, RegWriteE, RegWriteM, RegWriteW;
	 logic MemToRegD, MemToRegE, MemToRegM, MemToRegW;
	 logic MemWriteD, MemWriteE, MemWriteM;
	 logic CondExE;
	 logic [1:0] ALUControlD, ALUControlE;
	 logic BranchD, BranchE;
	 logic ALUSrcD, ALUSrcE;
	 logic StallF, StallD;
	 logic FlushD, FlushE;
	 logic ldrstall;
	 logic PCWrPendingF;
	 logic FlagWriteD, FlagWriteE;
	 logic BranchTakenE;
	 logic [3:0] FlagsE, Flags;
	 logic [3:0] CondE;
	 logic [1:0] ForwardAE, ForwardBE;
	 logic [3:0] WA3E, WA3M, WA3W;


    /* The datapath consists of a PC as well as a series of muxes to make decisions about which data words to pass forward and operate on. It is 
    ** noticeably missing the register file and alu, which you will fill in using the modules made in lab 1. To correctly match up signals to the 
    ** ports of the register file and alu take some time to study and understand the logic and flow of the datapath.
    */
    //-------------------------------------------------------------------------------
    //                                      DATAPATH
    //-------------------------------------------------------------------------------

	// Checks if we are branching and change PC accordingly
	 always_comb begin
		if(BranchTakenE) begin
			PCPrime = ALUResultE - 8;
		end else if(PCSrcW) begin
			PCPrime = ResultW;
		end else begin
			PCPrime = PCPlus4;
		end
	 end
	 
    assign PCPlus4 = PCF + 'd4;                  // default value to access next instruction
    assign PCPlus8 = PCPlus4 + 'd4;             // value read when reading from reg[15]

    // update the PC, at rst initialize to 0
    always_ff @(posedge clk) begin
        if (rst) PC <= '0;
        else     PC <= PCPrime;
    end

    // determine the register addresses based on control signals
    // RegSrc[0] is set if doing a branch instruction
    // RefSrc[1] is set when doing memory instructions
    assign RA1 = RegSrc[0] ? 4'd15        : InstrD[19:16];
    assign RA2 = RegSrc[1] ? InstrD[15:12] : InstrD[ 3: 0];

    // register memory
    // when instructed, we write into the registers the value we want
    // also read out any data that we request via our RA1 and RA2
    reg_file u_reg_file (
        .clk       (!clk), 
        .wr_en     (RegWriteW),
        .write_data(ResultW),
        .write_addr(WA3W),
        .read_addr1(RA1), 
        .read_addr2(RA2),
        .read_data1(RD1D), 
        .read_data2(RD2D)
    );

    // two muxes, put together into an always_comb for clarity
    // determines which set of instruction bits are used for the immediate
    always_comb begin
        if      (ImmSrc == 'b00) ExtImm = {{24{InstrD[7]}},InstrD[7:0]};          // 8 bit immediate - reg operations
        else if (ImmSrc == 'b01) ExtImm = {20'b0, InstrD[11:0]};                 // 12 bit immediate - mem operations
        else                     ExtImm = {{6{InstrD[23]}}, InstrD[23:0], 2'b00}; // 24 bit immediate - branch operation
    end

    assign SrcBE = (ALUSrcE) ? ExtImmE : WriteDataE;
	 
	 

	 //data forwarding
	 // Changes ForwardAE output depending on whether or not
	 // execute stage register matches memory or writeback registers
	 logic MATCH_1E_M, MATCH_2E_M, MATCH_1E_W, MATCH_2E_W;
	 always_comb begin 
		MATCH_1E_M = RA1E == WA3M;
		MATCH_2E_M = RA2E == WA3M;
		MATCH_1E_W = RA1E == WA3W;
		MATCH_2E_W = RA2E == WA3W;
		if(MATCH_1E_M & RegWriteM) begin
			ForwardAE = 2'b10;
		end else if (MATCH_1E_W & RegWriteW) begin
			ForwardAE = 2'b01;
		end else begin
			ForwardAE = 2'b00;
		end
		if(MATCH_2E_M & RegWriteM) begin
			ForwardBE = 2'b10;
		end else if (MATCH_2E_W & RegWriteW) begin
			ForwardBE = 2'b01;
		end else begin
			ForwardBE = 2'b00;
		end
	 end
	 
	//stalling and flushing
	 
	 assign PCSrcD = (RegWriteD & (InstrD[15:12] == 4'b1111));
	 assign ldrstall = (MemToRegE) & ((RA1 == WA3E) | (RA2 == WA3E));
	 assign PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;
	 assign StallF = ldrstall | PCWrPendingF;
	 assign FlushD = PCWrPendingF | PCSrcW | BranchTakenE;
	 assign FlushE = ldrstall | BranchTakenE;
	 assign StallD = ldrstall;
	 
	 // Forward multiplexer
	 always_comb begin
		case(ForwardAE)
		2'b00 : begin
			SrcAE = (RA1E == 'd15) ? PCPlus8 : RD1E;
		end
		2'b01 : begin
			SrcAE = ResultW; //data forward to end
		end
		2'b10 : begin
			SrcAE = ALUResultM; //data forward to previous alu instruction
		end
		default : begin
			SrcAE = 0;
		end
		endcase
		case(ForwardBE) 
		2'b00 : begin
			WriteDataE = (RA2E == 'd15) ? PCPlus8 : RD2E;
		end
		2'b01 : begin
			WriteDataE = ResultW; //data forward to end
		end
		2'b10 : begin
			WriteDataE = ALUResultM; //data forward to previous alu instruction
		end
		default : begin
			WriteDataE = 0; 
		end
		endcase
	 end
	 
    // instruction memory
    // contained machine code instructions which instruct processor on which operations to make
    // effectively a rom because our processor cannot write to it
    alu u_alu (
        .a          (SrcAE), 
        .b          (SrcBE),
        .ALUControl (ALUControlE),
        .Result     (ALUResultE),
        .ALUFlags   (ALUFlags)
    );
	 
	 assign MemWrite = MemWriteM;

	 // register 1
	 always_ff@(posedge clk) begin
			if(rst | FlushD) begin
				InstrD <= 0;
			end else if (StallD) begin
				InstrD <= InstrD;
			end else begin
				InstrD <= InstrF;
			end
			
			if(rst) begin 
				PCF <= 0;
			end else if (StallF) begin
				PCF <= PCF; 
			end else begin
				PCF <= PCPrime;
			end
	 end
	 
	 // register 2
	 always_ff@(posedge clk) begin
			if(rst | FlushE) begin
				PCSrcE <= 0;
				RegWriteE <= 0;
				ALUControlE <= 0; 	
				MemToRegE <= 0;
				MemWriteE <= 0;
				RD1E <= 0;
				RD2E <= 0;
				RA1E <= 0;
				RA2E <= 0;
				FlagWriteE <= 0;
				CondE <= 0;
				BranchE <= 0;
				ALUSrcE <= 0;
				FlagsE <= 0;
				WA3E <= 0;
				ExtImmE <= 0;
			end else begin
				PCSrcE <= PCSrcD;
				RegWriteE <= RegWriteD;
				ALUControlE <= ALUControlD;
				MemToRegE <= MemToRegD;
				MemWriteE <= MemWriteD;
				RD1E <= RD1D;
				RD2E <= RD2D; 
				RA1E <= RA1;
				RA2E <= RA2;
				FlagWriteE <= FlagWriteD; 
				ExtImmE <= ExtImm;
				BranchE <= BranchD;
				ALUSrcE <= ALUSrcD;
				WA3E <=InstrD[15:12];
				CondE <= InstrD[31:28];
				if(FlagWriteE) begin
					FlagsE <= ALUFlags;
				end
			end
	 end
	 
	 // register 3
	 always_ff@(posedge clk) begin
			if(rst) begin
				PCSrcM <= 0;
				WA3M <= 0;
				ALUResultM <= 0;
				WriteDataM <= 0;
				RegWriteM <= 0;
				MemToRegM <= 0;
				MemWriteM <= 0;
			end else begin
				PCSrcM <= PCSrcE & CondExE;
				WA3M <= WA3E;
				ALUResultM <= ALUResultE;
				WriteDataM <= WriteDataE;
				RegWriteM <= RegWriteE & CondExE;
				MemToRegM <= MemToRegE;
				MemWriteM <= MemWriteE & CondExE;
			end
	 end
	 
	 assign BranchTakenE = (BranchE & CondExE);
	 
	 // register 4
	 assign ResultW = (MemToRegW) ? ReadDataW : ALUOutW;
	 always_ff@(posedge clk) begin
		if(rst) begin
			PCSrcW <= 0;
			RegWriteW <= 0;
			MemToRegW <= 0;
			ALUOutW <= 0;
			ReadDataW <= 0;
			WA3W <= 0;
		end else begin
			PCSrcW <= PCSrcM;
			RegWriteW <= RegWriteM;
			MemToRegW <= MemToRegM;
			ALUOutW <= ALUResultM;
			ReadDataW <= ReadData;
			WA3W <= WA3M;
		end
	 end
	 
	 logic V = FlagsE[0];
	 logic C = FlagsE[1];
	 logic Z = FlagsE[2];
	 logic N = FlagsE[3];
	 
	 always_comb begin
	 case(CondE) 
		 4'b0000: begin
			CondExE = Z;
		 end
		 4'b0001: begin
			CondExE = !Z;
		 end
		 4'b0010: begin
			CondExE = C;
		 end
		 4'b0011: begin
			CondExE = !C;
		 end
		 4'b0100: begin
			CondExE = N;
		 end
		 4'b0101: begin
			CondExE = !N;
		 end
		 4'b0110: begin
			CondExE = V;
		 end
		 4'b0111: begin
			CondExE = !V;
		 end
		 4'b1000: begin
			CondExE = !Z&C;
		 end
		 4'b1001: begin
			CondExE = Z | !C;
		 end
		 4'b1010: begin
			CondExE = !(N ^ V);
		 end
		 4'b1011: begin
			CondExE = N ^ V;
		 end
		 4'b1100: begin
			CondExE = !Z & !(N ^ V);
		 end
		 4'b1101: begin
			CondExE = Z | (N ^ V);
		 end
		 4'b1110: begin
			CondExE = 1; 
		 end
		 4'b1111: begin
			CondExE = 1; 
		 end
		 default : begin
			CondExE = 1; 
		 end
		 endcase
	 end
	 
    /* The control conists of a large decoder, which evaluates the top bits of the instruction and produces the control bits 
    ** which become the select bits and write enables of the system. The write enables (RegWrite, MemWrite and PCSrc) are 
    ** especially important because they are representative of your processors current state. 
    */
    //-------------------------------------------------------------------------------
    //                                      CONTROL
    //-------------------------------------------------------------------------------
	 
    
    always_comb begin
        casez (InstrD[31:20])

            // ADD (Imm or Reg)
            12'b111000?01000 : begin   // note that we use wildcard "?" in bit 25. That bit decides whether we use immediate or reg, but regardless we add
                //PCSrcD    = 0;
                MemToRegD = 0; 
                MemWriteD = 0; 
                ALUSrcD   = InstrD[25]; // may use immediate
                RegWriteD = 1;
                RegSrc   = 'b00;
                ImmSrc   = 'b00; 
                ALUControlD = 'b00;
					 FlagWriteD = 0;
					 BranchD = 0;
            end

            // SUB (Imm or Reg)
            12'b111000?00100 : begin   // note that we use wildcard "?" in bit 25. That bit decides whether we use immediate or reg, but regardless we sub
                //PCSrcD    = 0; 
                MemToRegD = 0; 
                MemWriteD = 0; 
                ALUSrcD   = InstrD[25]; // may use immediate
                RegWriteD = 1;
                RegSrc   = 'b00;
                ImmSrc   = 'b00; 
                ALUControlD = 'b01;
					 FlagWriteD = 0;
					 BranchD = 0;
            end
				
				// CMP (Imm or Reg)
            12'B111000?00101 : begin   // note that we use wildcard "?" in bit 25. That bit decides whether we use immediate or reg, but regardless we sub
                //PCSrcD    = 0; 
                MemToRegD = 0; 
                MemWriteD = 0; 
                ALUSrcD   = InstrD[25]; // may use immediate
                RegWriteD = 1;
                RegSrc   = 'b00;
                ImmSrc   = 'b00; 
                ALUControlD = 'b01;
					 FlagWriteD = 1;
					 BranchD = 0;
            end

            // AND
            12'b111000000000 : begin
                //PCSrcD    = 0; 
                MemToRegD = 0; 
                MemWriteD = 0; 
                ALUSrcD   = 0; 
                RegWriteD = 1;
                RegSrc   = 'b00;
                ImmSrc   = 'b00;    // doesn't matter
                ALUControlD = 'b10;
					 FlagWriteD = 0;
					 BranchD = 0;
				end

            // ORR
            12'b111000011000 : begin
                //PCSrcD    = 0; 
                MemToRegD = 0; 
                MemWriteD = 0; 
                ALUSrcD   = 0; 
                RegWriteD = 1;
                RegSrc   = 'b00;
                ImmSrc   = 'b00;    // doesn't matter
                ALUControlD = 'b11;
					 FlagWriteD = 0;
					 BranchD = 0;
            end

            // LDR
            12'b111001011001 : begin
                //PCSrcD    = 0; 
                MemToRegD = 1; 
                MemWriteD = 0; 
                ALUSrcD   = 1;
                RegWriteD = 1;
                RegSrc   = 'b10;    // msb doesn't matter
                ImmSrc   = 'b01; 
                ALUControlD = 'b00;	// do an add
					 FlagWriteD = 0;
					 BranchD = 0;
            end

            // STR
            12'b111001011000 : begin
                //PCSrcD    = 0; 
                MemToRegD = 0; // doesn't matter
                MemWriteD = 1; 
                ALUSrcD   = 1;
                RegWriteD = 0;
                RegSrc   = 'b10;    // msb doesn't matter
                ImmSrc   = 'b01; 
                ALUControlD = 'b00;  // do an add
					 FlagWriteD = 0;
					 BranchD = 0;
            end

            // B
            12'b????1010???? : begin
                   case (InstrD[31:28])
								4'b1110 : begin
									 //PCSrcD    = 1; 
									 MemToRegD = 0;
									 MemWriteD = 0; 
									 ALUSrcD   = 1;
									 RegWriteD = 0;
									 RegSrc   = 'b01;
									 ImmSrc   = 'b10; 
									 ALUControlD = 'b00;  // do an add
									 FlagWriteD = 0;
									 BranchD = 1;
								end
								
								// equal
								4'b0000 : begin
									//PCSrcD    = 1; 
									MemToRegD = 0;
									MemWriteD = 0; 
									ALUSrcD   = 1;
									RegWriteD = 0;
									RegSrc   = 'b01;
									ImmSrc   = 'b10; 
									ALUControlD = 'b00;  
									FlagWriteD = 0;
									BranchD = 1;
								end
								
								// not equal
								4'b0001 : begin
									//PCSrcD    = 1;
									MemToRegD = 0;
									MemWriteD = 0; 
									ALUSrcD   = 1;
									RegWriteD = 0;
									RegSrc   = 'b01;
									ImmSrc   = 'b10; 
									ALUControlD = 'b00;  // do an add
									FlagWriteD = 0;
									BranchD = 1;
								end
								
								// Greater or Equal
								4'b1010 : begin
									//PCSrcD    = 1;
									MemToRegD = 0;
									MemWriteD = 0; 
									ALUSrcD   = 1;
									RegWriteD = 0;
									RegSrc   = 'b01;
									ImmSrc   = 'b10; 
									ALUControlD = 'b00;  // do an add
									FlagWriteD = 0;
									BranchD = 1;
								end
							
								// Greater
								4'b1100 : begin
									//PCSrcD    = 1;
									MemToRegD = 0;
									MemWriteD = 0; 
									ALUSrcD   = 1;
									RegWriteD = 0;
									RegSrc   = 'b01;
									ImmSrc   = 'b10; 
									ALUControlD = 'b00;  // do an add
									FlagWriteD = 0;
									BranchD = 1;
								end
								
								// Less or Equal
								4'b1101 : begin
									//PCSrcD    = 1;
									MemToRegD = 0;
									MemWriteD = 0; 
									ALUSrcD   = 1;
									RegWriteD = 0;
									RegSrc   = 'b01;
									ImmSrc   = 'b10; 
									ALUControlD = 'b00;  // do an add
									FlagWriteD = 0;
									BranchD = 1;
								end
								
								// Less
								4'b1011 : begin
									//PCSrcD    = 1;
									MemToRegD = 0;
									MemWriteD = 0; 
									ALUSrcD   = 1;
									RegWriteD = 0;
									RegSrc   = 'b01;
									ImmSrc   = 'b10; 
									ALUControlD = 'b00;  // do an add
									FlagWriteD = 0;
									BranchD = 1;
								end
								
								default: begin
									//PCSrcD    = 0; 
									MemToRegD = 0; // doesn't matter
									MemWriteD = 0; 
									ALUSrcD   = 0;
									RegWriteD = 0;
									RegSrc   = 'b00;
									ImmSrc   = 'b00; 
									ALUControlD = 'b00;  // do an add
									FlagWriteD = 0;
									BranchD = 0;
								end
						 endcase

              
            end

			default: begin
					//PCSrcD    = 0; 
						MemToRegD = 0; 
						MemWriteD = 0; 
						ALUSrcD   = 0;
						RegWriteD = 0;
						RegSrc   = 'b00;
						ImmSrc   = 'b00; 
						ALUControlD = 'b00;  
						FlagWriteD = 0;
						BranchD = 0;
			end
        endcase
    end


endmodule 