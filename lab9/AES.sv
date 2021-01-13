///************************************************************************
//AES Decryption Core Logic
//
//Dong Kai Wang, Fall 2017
//
//For use with ECE 385 Experiment 9
//University of Illinois ECE Department
//************************************************************************/
//
//module AES (
//	input	 logic CLK,
//	input  logic RESET,
//	input  logic AES_START,
//	output logic AES_DONE,
//	input  logic [127:0] AES_KEY,
//	input  logic [127:0] AES_MSG_ENC,
//	output logic [127:0] AES_MSG_DEC
//);
//	logic [1407:0] w;
//	logic [127:0]  state;
//	logic [127:0]  next_state;
//	logic [127:0]  key;
//	logic [127:0]	SHIFTOUT;
//	logic [1407:0] EXPANDOUT;
//	logic [127:0]	SUBOUT;
//	logic [127:0]	ROUNDOUT;
//	logic [31:0]	MIXOUT;
//	logic [31:0]	MIXIN;
//	logic [4:0]    Counter;
//	logic [4:0]    Counter_next;
//	
//	enum logic [4:0]{PREPARE, 
//						  EXPAND,
//						  PREROUND1, 
//						  ROUND1, 
//						  LOOPSHIFT, 
//						  LOOPSUB, 
//						  PRELOOPROUND,
//						  LOOPROUND,
//						  LOOPMIX0,
//						  LOOPMIX1,
//						  LOOPMIX2,
//						  LOOPMIX3,
//						  CHOOSE,
//						  SHIFT,
//						  SUB,
//						  PREROUND2,
//						  ROUND2,
//						  FINISH} AES_STATE, AES_NEXT_STATE;
//	
//	KeyExpansion expansion(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(EXPANDOUT));
//	
//	AddRoundKey(.state(state),.key(key),.out(ROUNDOUT));
//	
//	InvShiftRows shift(.data_in(state),.data_out(SHIFTOUT));
//	
//	InvSubBytes sub0(.clk(CLK), .in(state[7:0]), .out(SUBOUT[7:0]));
//	InvSubBytes sub1(.clk(CLK), .in(state[15:8]), .out(SUBOUT[15:8]));
//	InvSubBytes sub2(.clk(CLK), .in(state[23:16]), .out(SUBOUT[23:16]));
//	InvSubBytes sub3(.clk(CLK), .in(state[31:24]), .out(SUBOUT[31:24]));
//	InvSubBytes sub4(.clk(CLK), .in(state[39:32]), .out(SUBOUT[39:32]));
//	InvSubBytes sub5(.clk(CLK), .in(state[47:40]), .out(SUBOUT[47:40]));
//	InvSubBytes sub6(.clk(CLK), .in(state[55:48]), .out(SUBOUT[55:48]));
//	InvSubBytes sub7(.clk(CLK), .in(state[63:56]), .out(SUBOUT[63:56]));
//	InvSubBytes sub8(.clk(CLK), .in(state[71:64]), .out(SUBOUT[71:64]));
//	InvSubBytes sub9(.clk(CLK), .in(state[79:72]), .out(SUBOUT[79:72]));
//	InvSubBytes sub10(.clk(CLK), .in(state[87:80]), .out(SUBOUT[87:80]));
//	InvSubBytes sub11(.clk(CLK), .in(state[95:88]), .out(SUBOUT[95:88]));
//	InvSubBytes sub12(.clk(CLK), .in(state[103:96]), .out(SUBOUT[103:96]));
//	InvSubBytes sub13(.clk(CLK), .in(state[111:104]), .out(SUBOUT[111:104]));
//	InvSubBytes sub14(.clk(CLK), .in(state[119:112]), .out(SUBOUT[119:112]));
//	InvSubBytes sub15(.clk(CLK), .in(state[127:120]), .out(SUBOUT[127:120]));
//	
//	InvMixColumns mix(.in(MIXIN),.out(MIXOUT));
//	
//	always_ff @(posedge CLK)
//	begin
//		if (RESET) 
//		begin
//			state <= 128'b0;
//			AES_MSG_DEC <= 128'b0;
//			AES_STATE <= PREPARE;
//		end
//		else
//		begin
////			AES_MSG_DEC <= next_state;
//			state <= next_state;
//			AES_STATE <= AES_NEXT_STATE;
//			Counter <= Counter_next;
//		end
//	end
//	
//	always_comb
//	begin
//		Counter_next = Counter;
//		AES_NEXT_STATE = AES_STATE;
//		
//		unique case(AES_STATE)
//			PREPARE:
//			begin
//				if (AES_START == 1'b1)
//				begin
//					AES_NEXT_STATE = EXPAND;
//					Counter_next = 4'b0;
//					next_state = AES_MSG_ENC;
//				end
//				else
//				begin
//					AES_NEXT_STATE = PREPARE;
//				end
//			end
//			EXPAND:
//			begin
//				AES_NEXT_STATE = PREROUND1;
//			end
//			PREROUND1:
//			begin
//				AES_NEXT_STATE = ROUND1;
//			end
//			ROUND1:
//			begin
//				AES_NEXT_STATE = LOOPSHIFT;
//			end
//			LOOPSHIFT:
//			begin
//				AES_NEXT_STATE = LOOPSUB;
//			end
//			LOOPSUB:
//			begin
//				AES_NEXT_STATE = PRELOOPROUND;
//			end
//			PRELOOPROUND:
//			begin
//				AES_NEXT_STATE = LOOPROUND;
//			end
//			LOOPROUND:
//			begin
//				AES_NEXT_STATE = LOOPMIX0;
//			end
//			LOOPMIX0:
//			begin
//				AES_NEXT_STATE = LOOPMIX1;
//			end
//			LOOPMIX1:
//			begin
//				AES_NEXT_STATE = LOOPMIX2;
//			end
//			LOOPMIX2:
//			begin
//				AES_NEXT_STATE = LOOPMIX3;
//			end
//			LOOPMIX3:
//			begin
//				AES_NEXT_STATE = CHOOSE;
//			end
//			CHOOSE:
//			begin
//				if (Counter == 4'd9)
//				begin
//					AES_NEXT_STATE = SHIFT;	
//					Counter_next = 4'd0;
//				end
//				else
//				begin
//					AES_NEXT_STATE = LOOPSHIFT;
//					Counter_next = Counter + 1'b1;
//				end
//			end
//			SHIFT:
//			begin 
//				AES_NEXT_STATE = SUB;
//			end
//			SUB:
//			begin
//				AES_NEXT_STATE = PREROUND2;
//			end
//			PREROUND2:
//			begin
//				AES_NEXT_STATE = ROUND2;
//			end
//			ROUND2:
//			begin
//				AES_NEXT_STATE = FINISH;
//			end
//			FINISH:
//			begin
//				if (AES_START == 1'b0)
//				begin
//					AES_NEXT_STATE = PREPARE;
//				end
//				else
//				begin
//					AES_NEXT_STATE = FINISH;
//				end
//			end
//			default:
//			begin
//				AES_NEXT_STATE = PREPARE;
//			end
//		endcase
//		
//		next_state = state;
//		AES_DONE = 1'b0;
//		//AES_MSG_DEC = 128'b0;
//		key = 128'b0;
//		w = 1408'b0;
//		MIXOUT = 32'b0;
//		MIXIN = 32'b0;
//		case(AES_STATE)
//			PREPARE:
//			begin
//			end
//			EXPAND:
//			begin
//				w = EXPANDOUT;
//			end
//			PREROUND1:
//			begin
//				key = w[127:0];
//			end
//			PRELOOPROUND:
//			begin
//				case (Counter)
//					4'd8:key = w[1279:1152];
//					4'd7:key = w[1151:1024];
//					4'd6:key = w[1023:896];
//					4'd5:key = w[895:768];
//					4'd4:key = w[767:640];
//					4'd3:key = w[639:512];
//					4'd2:key = w[511:384];
//					4'd1:key = w[383:256];
//					4'd0:key = w[255:128];
//					default: key = 128'b0;
//				endcase
//			end
//			PREROUND2:
//			begin
//				key = w[1407:1280];
//			end
//			ROUND1,LOOPROUND,ROUND2:
//			begin
//				next_state = ROUNDOUT;
//			end
//			SHIFT,LOOPSHIFT:
//			begin
//				next_state = SHIFTOUT;
//			end
//			SUB,LOOPSUB:
//			begin
//				next_state = SUBOUT;
//			end	
//			LOOPMIX0:
//			begin
//				MIXIN = state[31:0];
//				next_state[31:0] = MIXOUT;
//			end
//			LOOPMIX1:
//			begin
//				MIXIN = state[63:32];
//				next_state[63:32] = MIXOUT;
//			end
//			LOOPMIX2:
//			begin
//				MIXIN = state[95:64];
//				next_state[95:64] = MIXOUT;
//			end
//			LOOPMIX3:
//			begin
//				MIXIN = state[127:96];
//				next_state[127:96] = MIXOUT;
//			end
//			CHOOSE:
//			begin
//			end
//			FINISH:
//			begin
//				AES_MSG_DEC = next_state;
//				AES_DONE = 1'b1;
//			end
//		endcase
//	end			
//endmodule
/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

enum logic [4:0] {
WAIT, 				
DONE, 				
KEY, 		
INVSHIFTROWS, 		
INVSUBBYTES,		
ADDROUNDKEY, 		
INVMIXCOLUMNS1, 	
INVMIXCOLUMNS2, 	
INVMIXCOLUMNS3,	
INVMIXCOLUMNS4, 	
INVMIXCOLUMNSDONE, 	
INVSHIFTROWSDONE, 	
INVSUBBYTESDONE, 	
ADDROUNDKEYLR, 	
ADDROUNDKEYINIT	
} STATE, NEXT_STATE;
						
logic [3:0] counter;
logic [3:0] next_counter;
logic [127:0] state;
logic [127:0] next_state;
logic [1407:0] KeySchedule;
logic [127:0] current_key;
logic [127:0] next_current_key;
logic [31:0] ColumnToUse;
logic [31:0] NextcolumnToUse;

logic [127:0] AddRoundKeyOut;
logic [127:0] InvShiftRowsOut;
logic [127:0] SubBytesOut;
logic [31:0] InvMixColumnsOut;

KeyExpansion KE(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(KeySchedule));
AddRoundKey ARK(.state(state), .key(current_key), .out(AddRoundKeyOut));
InvShiftRows ISR(.data_in(state), .data_out(InvShiftRowsOut));
InvMixColumns IMC(.in(ColumnToUse), .out(InvMixColumnsOut));

InvSubBytes sb0 (.clk(CLK), .in(state[7:0]    ), .out(SubBytesOut[7:0]    ));
InvSubBytes sb1 (.clk(CLK), .in(state[15:8]   ), .out(SubBytesOut[15:8]   ));
InvSubBytes sb2 (.clk(CLK), .in(state[23:16]  ), .out(SubBytesOut[23:16]  ));
InvSubBytes sb3 (.clk(CLK), .in(state[31:24]  ), .out(SubBytesOut[31:24]  ));
InvSubBytes sb4 (.clk(CLK), .in(state[39:32]  ), .out(SubBytesOut[39:32]  ));
InvSubBytes sb5 (.clk(CLK), .in(state[47:40]  ), .out(SubBytesOut[47:40]  ));
InvSubBytes sb6 (.clk(CLK), .in(state[55:48]  ), .out(SubBytesOut[55:48]  ));
InvSubBytes sb7 (.clk(CLK), .in(state[63:56]  ), .out(SubBytesOut[63:56]  ));
InvSubBytes sb8 (.clk(CLK), .in(state[71:64]  ), .out(SubBytesOut[71:64]  ));
InvSubBytes sb9 (.clk(CLK), .in(state[79:72]  ), .out(SubBytesOut[79:72]  ));
InvSubBytes sbA (.clk(CLK), .in(state[87:80]  ), .out(SubBytesOut[87:80]  ));
InvSubBytes sbB (.clk(CLK), .in(state[95:88]  ), .out(SubBytesOut[95:88]  ));
InvSubBytes sbC (.clk(CLK), .in(state[103:96] ), .out(SubBytesOut[103:96] ));
InvSubBytes sbD (.clk(CLK), .in(state[111:104]), .out(SubBytesOut[111:104]));
InvSubBytes sbE (.clk(CLK), .in(state[119:112]), .out(SubBytesOut[119:112]));
InvSubBytes sbF (.clk(CLK), .in(state[127:120]), .out(SubBytesOut[127:120]));

always_ff @ (posedge CLK) begin

	if(RESET) begin
		state = 128'b0;
		STATE = WAIT;
		counter = 4'b0;
	end
		
	else begin
		STATE = NEXT_STATE;
		state = next_state;
		counter = next_counter;
		current_key = next_current_key;
		ColumnToUse = NextcolumnToUse;
	end
	
end


always_comb begin

	next_counter = counter;
	next_state = state;
	AES_DONE = 1'b0;
	next_current_key = current_key;
	NextcolumnToUse = ColumnToUse;
	AES_MSG_DEC = 128'b0;

	case(STATE)
	
		WAIT: begin
		
			next_counter = 4'd10;
			next_state = 128'b0;
			AES_DONE = 1'b0;
			next_state = AES_MSG_ENC;
			AES_MSG_DEC = AES_MSG_DEC;
		
			if(AES_START == 0)
				NEXT_STATE = WAIT;
			else
				NEXT_STATE = KEY;

		end
		
		KEY: begin
				
			next_counter = counter - 4'd1;
			if(counter == 4'd0) begin
				next_current_key = KeySchedule[127:0];
				NEXT_STATE = ADDROUNDKEYINIT;
			end
			else
				NEXT_STATE = KEY;
		
		end
		
		ADDROUNDKEYINIT: begin
		
			next_counter = 4'd9;
			NEXT_STATE = INVSHIFTROWS;
			next_state = AddRoundKeyOut;
		
		end
		
		INVSHIFTROWS: begin
		
			if(counter == 0)
				NEXT_STATE = INVSHIFTROWSDONE;
			else begin
				NEXT_STATE = INVSUBBYTES;
				next_state = InvShiftRowsOut;
				
				case(counter)
					4'd1: next_current_key = KeySchedule[1279:1152];
					4'd2: next_current_key = KeySchedule[1151:1024];
					4'd3: next_current_key = KeySchedule[1023:896];
					4'd4: next_current_key = KeySchedule[895:768];
					4'd5: next_current_key = KeySchedule[767:640];
					4'd6: next_current_key = KeySchedule[639:512];
					4'd7: next_current_key = KeySchedule[511:384];
					4'd8: next_current_key = KeySchedule[383:256];
					4'd9: next_current_key = KeySchedule[255:128];
					default: next_current_key = 127'b0;
				endcase
				
			end
			
		end
		
		INVSUBBYTES: begin
			NEXT_STATE = ADDROUNDKEY;
			next_state = SubBytesOut;
		end
		
		ADDROUNDKEY: begin
			NEXT_STATE = INVMIXCOLUMNS1;
			next_state = AddRoundKeyOut;
		end

		INVMIXCOLUMNS1: begin
			next_counter = counter - 4'd1;
			
			NextcolumnToUse = state[31:0];
			NEXT_STATE = INVMIXCOLUMNS2;
		end
		
		INVMIXCOLUMNS2: begin
			NextcolumnToUse = state[63:32];
			next_state[31:0] = InvMixColumnsOut;
			next_state[127:32] = state[127:32];
			NEXT_STATE = INVMIXCOLUMNS3;
		end
		
		INVMIXCOLUMNS3: begin
			NextcolumnToUse = state[95:64];
			next_state[31:0] = state[31:0];
			next_state[63:32] = InvMixColumnsOut;
			next_state[127:64] = state[127:64];
			NEXT_STATE = INVMIXCOLUMNS4;
		end
		
		INVMIXCOLUMNS4: begin
			NextcolumnToUse = state[127:96];
			next_state[63:0] = state[63:0];
			next_state[95:64] = InvMixColumnsOut;
			next_state[127:96] = state[127:96];
			NEXT_STATE = INVMIXCOLUMNSDONE;
		end
		
		INVMIXCOLUMNSDONE: begin
			next_state[95:0] = state[95:0];
			next_state[127:96] = InvMixColumnsOut;
			NEXT_STATE = INVSHIFTROWS;
		end
		
		INVSHIFTROWSDONE: begin
			next_current_key = KeySchedule[1407:1280];
			next_state = InvShiftRowsOut;
			NEXT_STATE = INVSUBBYTESDONE;
		end
		
		INVSUBBYTESDONE: begin
			NEXT_STATE = ADDROUNDKEYLR;
			next_state = SubBytesOut;
		end
		
		ADDROUNDKEYLR: begin
			NEXT_STATE = DONE;
			next_state = AddRoundKeyOut;
		end
		
		DONE: begin
			AES_MSG_DEC = state;
			AES_DONE = 1'b1;
			
			if(AES_START == 1)
				NEXT_STATE = DONE;
			else
				NEXT_STATE = WAIT;
				
		end
		
		default: begin
			NEXT_STATE = WAIT;
		end
	
	endcase
end

endmodule

