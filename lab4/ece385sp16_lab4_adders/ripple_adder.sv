module full_adder//This is a full-adder of one bit used in the CRA.
(
	  input x, y, z,
	  output logic s, c
);
	
	  assign s = x^y^z;
	  assign c = (x&y)|(y&z)|(x&z);
	
endmodule

module ripple_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	
     logic c_in,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14;//This is the carry-out of every full_adder
	  assign c_in = 1'b0;
	  full_adder	FA0 (.x (A[0]), .y (B[0]), .z (c_in), .s (Sum[0]), .c (c0));//We calculate every bit 
	  full_adder	FA1 (.x (A[1]), .y (B[1]), .z (c0), .s (Sum[1]), .c (c1));  //and the carry-out in sequence. 
	  full_adder	FA2 (.x (A[2]), .y (B[2]), .z (c1), .s (Sum[2]), .c (c2)); 
	  full_adder	FA3 (.x (A[3]), .y (B[3]), .z (c2), .s (Sum[3]), .c (c3));
	  full_adder	FA4 (.x (A[4]), .y (B[4]), .z (c3), .s (Sum[4]), .c (c4));
	  full_adder	FA5 (.x (A[5]), .y (B[5]), .z (c4), .s (Sum[5]), .c (c5));
	  full_adder	FA6 (.x (A[6]), .y (B[6]), .z (c5), .s (Sum[6]), .c (c6));
	  full_adder	FA7 (.x (A[7]), .y (B[7]), .z (c6), .s (Sum[7]), .c (c7));
	  full_adder	FA8 (.x (A[8]), .y (B[8]), .z (c7), .s (Sum[8]), .c (c8));
	  full_adder	FA9 (.x (A[9]), .y (B[9]), .z (c8), .s (Sum[9]), .c (c9));
	  full_adder	FA10 (.x (A[10]), .y (B[10]), .z (c9), .s (Sum[10]), .c (c10));
	  full_adder	FA11 (.x (A[11]), .y (B[11]), .z (c10), .s (Sum[11]), .c (c11));
	  full_adder	FA12 (.x (A[12]), .y (B[12]), .z (c11), .s (Sum[12]), .c (c12));
	  full_adder	FA13 (.x (A[13]), .y (B[13]), .z (c12), .s (Sum[13]), .c (c13));
	  full_adder	FA14 (.x (A[14]), .y (B[14]), .z (c13), .s (Sum[14]), .c (c14));
	  full_adder	FA15 (.x (A[15]), .y (B[15]), .z (c14), .s (Sum[15]), .c (CO));
	  
endmodule


	
