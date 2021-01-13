module Dreg 
(
	input Clk, Load, Reset, D,
	output logic Q 
);
	always_ff @ (posedge Clk)
	begin
		if (Reset)
			Q <= 1'b0;
		else
			if (Load)
				Q <= D;
			else //in most cases this is redundant, maintaining Q inferred
				Q <= Q;
	end
endmodule