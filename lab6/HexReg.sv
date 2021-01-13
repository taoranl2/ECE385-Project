module HexReg(	
				input logic Clk, Reset, Load,
				input logic [15:0] DIN,
				output logic [15:0] DOUT
			  );
	always_ff @ (posedge Clk)
	begin
		if(~Reset)
			DOUT <= 16'h0000;
		else if (Load)
			DOUT <= DIN;
	end
endmodule