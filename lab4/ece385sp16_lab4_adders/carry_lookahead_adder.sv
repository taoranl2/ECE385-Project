module four_bit_adder//When I wrote this, only God and I understand what I was doing.
(
		input [3:0] a,
		input [3:0] b,
		input c_in,
		output [3:0] sum
);	
      logic c0,c1,c2,c3;
		logic G[3:0];
		logic P[3:0];
		assign G[0] = a[0]&b[0];//Calculate every P and G according to the input a and b.
      assign P[0] = a[0]^b[0];
		assign G[1] = a[1]&b[1];
      assign P[1] = a[1]^b[1];
		assign G[2] = a[2]&b[2];
      assign P[2] = a[2]^b[2];
		assign G[3] = a[3]&b[3];
      assign P[3] = a[3]^b[3];
		assign c0 = c_in;
		assign c1 = G[0]|(P[0]&c_in);//Calculate carry-out accoring to P and G.
		assign c2 = G[1]|(P[1]&G[0])|(P[1]&P[0]&c_in);
		assign c3 = G[2]|(P[2]&G[1])|(P[2]&P[1]&G[0])|(P[2]&P[1]&P[0]&c_in);
		assign c_out = G[3]|(P[3]&G[2])|(P[3]&P[2]&G[1])|(P[3]&P[2]&P[1]&G[0])|(P[3]&P[2]&P[1]&P[0]&c_in);	
		assign sum[0] = a[0]^b[0]^c0;//Calculate the result according to input a,b and carry-out.
		assign sum[1] = a[1]^b[1]^c1;
		assign sum[2] = a[2]^b[2]^c2;
		assign sum[3] = a[3]^b[3]^c3;
		assign PG = P[0]&P[1]&P[2]&P[3];
		assign GG = (G[3])|(G[2]&P[3])|(G[1]&P[2]&P[3])|(G[0]&P[1]&P[2]&P[3]);
endmodule

module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);
	 assign c0 = 1'b0;
	 logic c4,c8,c12,PG0,GG0,PG4,GG4,PG8,GG8,PG12,GG12;
	 logic [15:0] P,G;
	 assign G[0] = A[0]&B[0];//Calculate every P and G according to the input a and b.
    assign P[0] = A[0]^B[0];
    assign G[1] = A[1]&B[1];
    assign P[1] = A[1]^B[1];
	 assign G[2] = A[2]&B[2];
    assign P[2] = A[2]^B[2];
	 assign G[3] = A[3]&B[3];
    assign P[3] = A[3]^B[3];
	 assign G[4] = A[4]&B[4];//Calculate every P and G according to the input a and b.
    assign P[4] = A[4]^B[4];
    assign G[5] = A[5]&B[5];
    assign P[5] = A[5]^B[5];
	 assign G[6] = A[6]&B[6];
    assign P[6] = A[6]^B[6];
	 assign G[7] = A[7]&B[7];
    assign P[7] = A[7]^B[7];
	 assign G[8] = A[8]&B[8];//Calculate every P and G according to the input a and b.
    assign P[8] = A[8]^B[8];
    assign G[9] = A[9]&B[9];
    assign P[9] = A[9]^B[9];
	 assign G[10] = A[10]&B[10];
    assign P[10] = A[10]^B[10];
	 assign G[11] = A[11]&B[11];
    assign P[11] = A[11]^B[11];
	 assign G[12] = A[12]&B[12];//Calculate every P and G according to the input a and b.
    assign P[12] = A[12]^B[12];
    assign G[13] = A[13]&B[13];
    assign P[13] = A[13]^B[13];
	 assign G[14] = A[14]&B[14];
    assign P[14] = A[14]^B[14];
	 assign G[15] = A[15]&B[15];
    assign P[15] = A[15]^B[15];
	 assign PG0 = P[0]&P[1]&P[2]&P[3];
	 assign PG4 = P[4]&P[5]&P[6]&P[7];
	 assign PG8 = P[8]&P[9]&P[10]&P[11];
	 assign PG12 = P[12]&P[13]&P[14]&P[15];
	 assign GG0 = G[3]|(G[2]&P[3])|(G[1]&P[3]&P[2])|(G[0]&P[3]&P[2]&P[1]);
	 assign GG4 = G[7]|(G[6]&P[7])|(G[5]&P[7]&P[6])|(G[4]&P[7]&P[6]&P[5]);
	 assign GG8 = G[11]|(G[10]&P[11])|(G[9]&P[11]&P[10])|(G[8]&P[11]&P[10]&P[9]);
	 assign GG12 = G[15]|(G[14]&P[15])|(G[13]&P[15]&P[14])|(G[12]&P[15]&P[14]&P[13]);
	 assign c4 = GG0|(c0&PG0);
	 assign c8 = GG4|(c4&PG4);
	 assign c12 = GG8|(c8&PG8);
	 assign CO = GG12|(c12&PG12);
    four_bit_adder FBA1(.a (A[3:0]), .b (B[3:0]), .c_in (c0), .sum (Sum[3:0]));//We us four 4-bit
	 four_bit_adder FBA2(.a (A[7:4]), .b (B[7:4]), .c_in (c4), .sum (Sum[7:4]));//CLA to make a 
	 four_bit_adder FBA3(.a (A[11:8]), .b (B[11:8]), .c_in (c8), .sum (Sum[11:8]));//16-bit CLA.
	 four_bit_adder FBA4(.a (A[15:12]), .b (B[15:12]), .c_in (c12), .sum (Sum[15:12]));

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
endmodule//Now, only God knows.
