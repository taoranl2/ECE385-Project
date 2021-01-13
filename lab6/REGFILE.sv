module REGFILE
(
	input  logic         CLK, LD_REG, Reset,
	input  logic [15:0] 	bus,
	input  logic [2:0]	DR, SR1, SR2,
	output logic [15:0]	SR1_OUT, SR2_OUT
);
	logic [15:0] reg0;
	logic [15:0] reg1;
	logic [15:0] reg2;
	logic [15:0] reg3;
	logic [15:0] reg4;
	logic [15:0] reg5;
	logic [15:0] reg6;
	logic [15:0] reg7;
	
	always_ff @ (posedge CLK) begin
		if (Reset) begin
			 reg0 <=	16'h0000;
			 reg1 <=	16'h0000;
			 reg2 <=	16'h0000;
			 reg3 <=	16'h0000;
			 reg4 <=	16'h0000;
			 reg5 <=	16'h0000;
			 reg6 <=	16'h0000;
			 reg7 <=	16'h0000;
		end
		else if (LD_REG) begin
			case(DR)
				3'b000 : reg0 <= bus;
				3'b001 : reg1 <= bus;
				3'b010 : reg2 <= bus;
				3'b011 : reg3 <= bus;
				3'b100 : reg4 <= bus;
				3'b101 : reg5 <= bus;
				3'b110 : reg6 <= bus;
				3'b111 : reg7 <= bus;
				default: ;
			endcase
		end
	end
	
	always_comb begin
		case (SR1)
			3'b000 :	SR1_OUT = reg0;
			3'b001 :	SR1_OUT = reg1;
			3'b010 :	SR1_OUT = reg2;
			3'b011 :	SR1_OUT = reg3;
			3'b100 :	SR1_OUT = reg4;
			3'b101 :	SR1_OUT = reg5;
			3'b110 :	SR1_OUT = reg6;
			3'b111 :	SR1_OUT = reg7;
			default: ;
		endcase

		case (SR2)
			3'b000 : SR2_OUT = reg0;
			3'b001 :	SR2_OUT = reg1;
			3'b010 :	SR2_OUT = reg2;
			3'b011 :	SR2_OUT = reg3;
			3'b100 :	SR2_OUT = reg4;
			3'b101 :	SR2_OUT = reg5;
			3'b110 :	SR2_OUT = reg6;
			3'b111 :	SR2_OUT = reg7;
			default: ;
		endcase
	end
endmodule
