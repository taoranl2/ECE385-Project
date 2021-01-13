module CPUbusMUX (input logic [3:0] In, 
					 input logic [15: 0] A,B,C,D,
					 output logic[15: 0] Out
					 );
	always_comb
	begin
		unique case (In)
			4'b1000	:	Out = A;
			4'b0100	:	Out = B;
			4'b0010	:	Out = C;
			4'b0001	:	Out = D;
			default: Out = 16'h0000;
		endcase
	end
endmodule 


module two_mux #(parameter n = 16)
				(input logic In,
				input logic [n-1:0] A,
				input logic [n-1:0] B,
				output logic [n-1:0] Out);
	always_comb
	begin
		if (In)
			Out = B;
		else
			Out = A;	
	end
endmodule

module four_mux #(parameter n = 16)
			  (input logic [1:0] In,
				input logic [n-1:0] A,
				input logic [n-1:0] B,
				input logic [n-1:0] C,
				input logic [n-1:0] D,
				output logic [n-1:0] Out);
	always_comb
	begin
		case(In)
			2'b00: Out = A;
			2'b01: Out = B;
			2'b10: Out = C;
			2'b11: Out = D;
		endcase
	end
endmodule

