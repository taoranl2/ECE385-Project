module datapath
(
	input  logic       LD_MAR,LD_MDR,LD_IR,LD_BEN,LD_CC,LD_REG,LD_PC,LD_LED,
	input  logic       GatePC,GateMDR,GateALU,GateMARMUX,
	input  logic [1:0] ALUK,PCMUX,ADDR2MUX,
	input  logic       DRMUX,SR1MUX,SR2MUX,ADDR1MUX,//Mem_OE,//Mem_WE,
	input  logic       Clk,Reset,
	input  logic       MIO_EN,
	input  logic [15:0]MDR_In,
	output logic		 BEN,
	output logic [15:0]MAR,MDR,IR,PC,
	output logic [11:0]LED
);
					 
	logic [15:0]BUS;
	logic	[15:0]IR_OUT;
	logic	[15:0]MDR_OUT;
	logic	[15:0]MAR_OUT; 
	logic	[15:0]PC_OUT;
	logic	[15:0]ALU_OUT;
	logic	[15:0]LD_MDR_OUT;
	logic	[15:0]LD_PC_OUT;	
	logic	[15:0]ADDR2_OUT;
	logic	[15:0]SR1_OUT; 
	logic [15:0]SR2_OUT;
	logic [15:0]ADDR1_OUT;
	logic [2:0]SR1MUX_OUT;
	logic [2:0]DR_OUT;
	logic [15:0]SR2MUX_OUT;
	logic       BEN_OUT;
	//logic	[2:0]NZPin;
	//logic	[2:0]NZP_out;

   two_mux MDRmux(
					.In(MIO_EN), 
					.A(BUS), 
					.B(MDR_In), 
					.Out(LD_MDR_OUT)
					);
										
	two_mux ADDR1mux(
						.In(ADDR1MUX),
						.A(PC_OUT),
						.B(SR1_OUT),
						.Out(ADDR1_OUT)
						  );
						  
   four_mux ADDR2mux(
					.In(ADDR2MUX), 
					.A(16'h0000), 
					.B({{10{IR_OUT[5]}}, IR_OUT[5:0]}), 
					.C({{7{IR_OUT[8]}}, IR_OUT[8:0]}), 
					.D({{5{IR_OUT[10]}}, IR_OUT[10:0]}), 
					.Out(ADDR2_OUT)
					);	 
						
   four_mux PCmux(
					.In(PCMUX), 
					.A(PC_OUT + 1'b1), 
					.B(BUS), 
					.C(ADDR1_OUT + ADDR2_OUT),
					//.C(),
					.D(), 
					.Out(LD_PC_OUT)
					);
						
						
	CPUbusMUX busMUX(
					.In({GateMARMUX,GatePC,GateALU,GateMDR}), 
					.A(ADDR1_OUT + ADDR2_OUT),
					//.A(),
					.B(PC_OUT), 
					.C(ALU_OUT), 
					.D(MDR_OUT), 
					.Out(BUS)
					);

	HexReg  IRR(
				   .Clk(Clk),
				   .Reset(Reset),	
					.Load(LD_IR), 
				   .DIN(BUS), 
			      .DOUT(IR_OUT)
			      );
						
   HexReg  MDRR(
				   .Clk(Clk),
				   .Reset(Reset),	
			      .Load(LD_MDR), 
			      .DIN(LD_MDR_OUT), 
			      .DOUT(MDR_OUT)
			      );
						
   HexReg  MARR(
				   .Clk(Clk),
				   .Reset(Reset),	
			      .Load(LD_MAR), 
			      .DIN(BUS), 
			      .DOUT(MAR_OUT)
			      );
						
   HexReg  PCR(
				   .Clk(Clk),
				   .Reset(Reset),	
			      .Load(LD_PC), 
			      .DIN(LD_PC_OUT), 
			      .DOUT(PC_OUT)
			      );

   ALU  ALU1(
				   .A(SR1_OUT),
				   .B(SR2MUX_OUT),
				   .opt(ALUK),
				   .ans(ALU_OUT)
			    );
	
					
					
	two_mux #(3) SR1mux (
						.In(SR1MUX),
						.A(IR_OUT[8:6]),
						.B(IR_OUT[11:9]),
						.Out(SR1MUX_OUT)
						  );
						 
	two_mux #(3) DRmux(
						.In(DRMUX),
						.A(IR_OUT[11:9]),
						.B(3'b111),
						.Out(DR_OUT)
						  );	
						  
	two_mux SR2mux(
						.In(SR2MUX),
						.A(SR2_OUT),
						.B({{11{IR_OUT[4]}}, IR_OUT[4:0]}),
						.Out(SR2MUX_OUT)
						  );	
					
		
	REGFILE Regfile(
					   .CLK(Clk),
					   .LD_REG(LD_REG),
					   .Reset(Reset),
					   .bus(BUS), 
					   .DR(DR_OUT),
					   .SR1(SR1MUX_OUT),
					   .SR2(IR_OUT[2:0]),
					   .SR1_OUT(SR1_OUT),
					   .SR2_OUT(SR2_OUT)
					   );					
//    NZP  NZP1(
//				  .Clk(Clk),	
//				  .LoadCC(LD_CC), 
//				  .NZPIN(NZPin), 
//				  .NZPOUT(NZP_out)
//	           );
//				  
//    BEN  BEN1(
//				  .Clk(Clk),	
//				  .LDBEN(LD_BEN), 
//				  .IRIN(IR_OUT[11:9]), 
//				  .nzp(NZP_out),
//				  .BEN(BEN)
//	           );
	Ben myBEN(
						.data_in(BUS),
						.LD_CC(LD_CC), 
						.LD_BEN(LD_BEN), 
					   .Clk(Clk), 
					   .Reset(Reset),
					   .IR_in(IR_OUT[11:9]),
					   .BEN_out(BEN_OUT)
					   );     						
    always_comb begin
        MDR = MDR_OUT;
        MAR = MAR_OUT;
		  IR  = IR_OUT;
		  PC  = PC_OUT;
		  BEN = BEN_OUT;
//		  if (BUS==16'h0000)
//		      NZPin = 3'b010;
//		  else if(BUS[15]==1'b1)
//			   NZPin = 3'b100;
//		  else
//			   NZPin = 3'b001;
    end
    always_ff @ (posedge Clk)
	 begin
	
        if (LD_LED)
            LED <= IR[11:0];
		  else	
			   LED <= 12'h0;
	end
endmodule
