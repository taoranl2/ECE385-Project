module AddRoundKey(
	input logic  [127:0] state,
	input logic  [127:0] key,
	output logic [127:0] out
);
	always_comb
	begin
		out = state ^ key;
	end
endmodule
