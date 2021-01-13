module lab5_toplevel
(	//All input
	input  logic       Clk,
	input  logic       Reset,
	input  logic       Run,
	input  logic       ClearA_LoadB,
	input  logic [7:0] S,
	//All output are registered
	output logic [6:0] AhexU,
	output logic [6:0] AhexL,
	output logic [6:0] BhexU,
	output logic [6:0] BhexL,
	output logic [7:0] Aval,
	output logic [7:0] Bval,
	output logic       X
);
	logic Clr_Ld, Clr, Add, Sub, Shift, MX;
	logic Reset_SH, ClearA_LoadB_SH, Run_SH;
	logic [8:0] SS;
	logic [7:0] A,B,SW_In;
	assign Aval = A;
	assign Bval = B;
	register_unit	reg_unit (
								.Clk(Clk),
                        .ResetA(Reset_SH|Clr_Ld|Clr),
								.ResetB(Reset_SH),
                        .Ld_A(Add|Sub), 
                        .Ld_B(Clr_Ld),
                        .Shift_En(Shift),
                        .S(SW_In),
								.Sum(SS[7:0]),
                        .A_In(X),
                        .B_out(MX),
                        .A(A),
                        .B(B) 
								);
	ADD_SUB9			ADD_SUB9  (
								.A(A),
                        .B(SW_In),
                        .fn(Sub|0),
								.SS(SS)
								);
	control			control_unit (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .Run(Run_SH),
								.ClearA_LoadB(ClearA_LoadB_SH),
								.Clr_Ld(Clr_Ld),
								.Shift(Shift),
								.Add(Add),
								.Sub(Sub),
								.Clr(Clr),
								.MX(MX)
								);
	Dreg				Dreg (
								.Clk(Clk),
								.Load(Add|Sub),
								.Reset(Reset_SH|Clr_Ld|Clr),
								.D(SS[8]),
								.Q(X)
								);
	HexDriver   	HexAL(
								.In0(Aval[3:0]),
								.Out0(AhexL) );
				
	HexDriver   	HexBL(
								.In0(Bval[3:0]),
								.Out0(BhexL) );

	HexDriver   	HexAU(
								.In0(Aval[7:4]),
								.Out0(AhexU) );

	HexDriver   	HexBU (
								.In0(Bval[7:4]),
								.Out0(BhexU) );
	sync button_[2:0] (Clk,{~Reset, ~ClearA_LoadB, ~Run},{Reset_SH, ClearA_LoadB_SH, Run_SH});
	sync Din_sync[7:0] (Clk,S,SW_In);
endmodule