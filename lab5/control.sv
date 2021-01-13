module control
(
	input  logic Reset,
	input  logic Clk,
	input  logic Run,
	input  logic ClearA_LoadB,
	input  logic MX,
	output logic Clr_Ld,
	output logic Shift,
	output logic Add,
	output logic Sub,
	output logic Clr
);
	enum logic [4:0] {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U}   curr_state, next_state; 
	always_ff @ (posedge Clk)  
   begin
		if (Reset)
			curr_state <= A;
		else 
			curr_state <= next_state;
    end

	always_comb
	begin
		next_state  = curr_state;	
      unique case (curr_state) 

			A :   if (ClearA_LoadB)
						next_state = B;
					else if (Run)
						next_state = D;
         B :   next_state = C;
         C :    if (Run)
						next_state = E;
         D :   next_state = E;
         E :   next_state = F;
			F :   next_state = G;	 
			G :   next_state = H;
			H :   next_state = I;
			I :   next_state = J;
			J :   next_state = K;
			K :   next_state = L;
			L :   next_state = M;
			M :   next_state = N;
			N :   next_state = O;
			O :   next_state = P;
			P :   next_state = Q;
			Q :   next_state = R;
			R :   next_state = S;
			S :   next_state = T;
			T :  	next_state = U;
			U :   if (~Run) 
						next_state = A;

		endcase
   

      case (curr_state) 
			A: 
	      begin
				Clr_Ld = 0;
				Shift = 0;
				Add = 0;
				Sub = 0;
				Clr = 0;
		   end
	   	B: 
		   begin
				Clr_Ld = 1;
				Shift = 0;
				Add = 0;
				Sub = 0;
				Clr = 0;
		   end
	   	C: 
		   begin
				Clr_Ld = 0;
				Shift = 0;
				Add = 0;
				Sub = 0;
				Clr = 0;
		   end			
			D:
		   begin
				Clr_Ld = 0;
				Shift = 0;
				Add = 0;
				Sub = 0;
				Clr = 1;
		   end
			E, G, I, K, M, O, Q:
		   begin
				Clr_Ld = 0;
				Shift = 0;
				Add = MX;
				Sub = 0;
				Clr = 0;
		   end
			S:
		   begin
				Clr_Ld = 0;
				Shift = 0;
				Add = 0;
				Sub = MX;
				Clr = 0;
			end
			U:
		   begin
				Clr_Ld = 0;
				Shift = 0;
				Add = 0;
				Sub = 0;
				Clr = 0;
		   end
	   	default:  
		   begin 
				Clr_Ld = 0;
				Shift = 1;
				Add = 0;
				Sub = 0;
				Clr = 0;
		   end
		endcase
	end

endmodule
