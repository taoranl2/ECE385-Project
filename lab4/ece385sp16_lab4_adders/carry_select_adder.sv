
module Sel 
(
	  input logic chx, cx0, cx1,
	  input logic [3:0] ch0,ch1,
     output logic [3:0] Sumout,
	  output logic c_out
);
	always_comb begin
		if (chx == 1'b1)begin
			Sumout = ch1;
			c_out = cx1;
		end	
		else begin
			Sumout = ch0;
			c_out = cx0;
		end	
   end
endmodule

module ripper4
(
     input [3:0] ax,bx,
	  input c_inx,
	  output logic [3:0] Sx,
	  output logic c_outx
);

	  assign c_in = 1'b0;
	  full_adder	FA0 (.x (ax[0]), .y (bx[0]), .z (c_inx), .s (Sx[0]), .c (c0));
	  full_adder	FA1 (.x (ax[1]), .y (bx[1]), .z (c0), .s (Sx[1]), .c (c1));  
	  full_adder	FA2 (.x (ax[2]), .y (bx[2]), .z (c1), .s (Sx[2]), .c (c2)); 
	  full_adder	FA3 (.x (ax[3]), .y (bx[3]), .z (c2), .s (Sx[3]), .c (c_outx));
endmodule

module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    assign c00 = 1'b0;
	 assign c01 = 1'b1;
	 logic [3:0] Sumx20,Sumx21,Sumx30,Sumx31,Sum40,Sum41;
	 logic c1,c2,c3,c20,c21,c30,c31,c40,c41;
	 ripper4 ripper41(.ax(A[3:0]), .bx(B[3:0]), .c_inx(c00), .Sx(Sum[3:0]), .c_outx(c1));
	 ripper4 ripper42(.ax(A[7:4]), .bx(B[7:4]), .c_inx(c00), .Sx(Sumx20), .c_outx(c20)); 
	 ripper4 ripper43(.ax(A[7:4]), .bx(B[7:4]), .c_inx(c01), .Sx(Sumx21), .c_outx(c21));
	 ripper4 ripper44(.ax(A[11:8]), .bx(B[11:8]), .c_inx(c00), .Sx(Sumx30), .c_outx(c30));
	 ripper4 ripper45(.ax(A[11:8]), .bx(B[11:8]), .c_inx(c01), .Sx(Sumx31), .c_outx(c31));
	 ripper4 ripper46(.ax(A[15:12]), .bx(B[15:12]), .c_inx(c00), .Sx(Sumx40), .c_outx(c40));    
	 ripper4 ripper47(.ax(A[15:12]), .bx(B[15:12]), .c_inx(c01), .Sx(Sumx41), .c_outx(c41));
	 Sel Sel2 ( .chx(c1), .cx0(c20), .cx1(c21), .ch0(Sumx20), .ch1(Sumx21), .Sumout(Sum[7:4]), .c_out(c2));
	 Sel Sel3 ( .chx(c2), .cx0(c30), .cx1(c31), .ch0(Sumx30), .ch1(Sumx31), .Sumout(Sum[11:8]), .c_out(c3));
	 Sel Sel4 ( .chx(c3), .cx0(c40), .cx1(c41), .ch0(Sumx40), .ch1(Sumx41), .Sumout(Sum[15:12]), .c_out(CO));	 
endmodule
