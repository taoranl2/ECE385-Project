module Ben
(
	input  logic [15:0] data_in,
	input  logic        LD_CC, LD_BEN, Clk, Reset,
	input  logic [2:0]  IR_in,
	output logic        BEN_out
);
	logic n, z, p, nc, zc, pc;
		
	always_ff @ (posedge Clk) begin
		if (Reset) begin
			BEN_out <= 1'b0;
		end
		else if (LD_BEN) begin
			BEN_out <= (nc&IR_in[2])|(zc&IR_in[1])|(pc&IR_in[0]);
		end
		if (LD_CC) begin
			nc <= n;
			zc <= z;
			pc <= p;			
		end
	end
	
	always_comb begin
		if (data_in == 16'b0) begin
			n = 1'b0;
			z = 1'b1;
			p = 1'b0;
		end
		else if (data_in[15] == 1'b1) begin
			n = 1'b1;
			z = 1'b0;
			p = 1'b0;
		end
		else if (data_in[15] == 1'b0 & data_in != 16'b0) begin 
			n = 1'b0;
			z = 1'b0;
			p = 1'b1;
		end
		else begin
			n = 1'bz;
			z = 1'bz;
			p = 1'bz;
		end
	end

endmodule
