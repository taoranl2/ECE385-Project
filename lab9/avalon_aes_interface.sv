/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

logic [15:0][31:0] REG;   
logic [127:0]	MSG_DE;	
logic  AES_DONE;
					
assign EXPORT_DATA = {REG[0][31:16],REG[3][15:0]};

always_comb
	begin
		if (AVL_READ)
			AVL_READDATA = REG[AVL_ADDR];
		else
			AVL_READDATA = 0;
			
	end

 
				
always_ff @ (posedge CLK)
	begin
		if (RESET) 
		begin
			REG[0]  = 0;
			REG[1]  = 0;
			REG[2]  = 0;
			REG[3]  = 0;
			REG[4]  = 0;
			REG[5]  = 0;
			REG[6]  = 0;
			REG[7]  = 0;
			REG[8]  = 0;
			REG[9]  = 0;
			REG[10] = 0;
			REG[11] = 0;
			REG[12] = 0;
			REG[13] = 0;
		end
				
		else if(AVL_WRITE && AVL_CS) 
		begin
			case(AVL_BYTE_EN)
				4'b1111:
					REG[AVL_ADDR] <= AVL_WRITEDATA;
				4'b1100:
					REG[AVL_ADDR][31:16] <= AVL_WRITEDATA[31:16];
				4'b0011:
					REG[AVL_ADDR][15:0] <= AVL_WRITEDATA[15:0];
				4'b1000:
					REG[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
				4'b0100:
					REG[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
				4'b0010:
					REG[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
				4'b0001:
					REG[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];
			endcase
		end
		else if (AES_DONE && AVL_CS)
		begin
			REG[15][0] = AES_DONE;
			REG[11:8] = MSG_DE;
		end
	end
	AES aes_inst(.CLK(CLK),.RESET(RESET),.AES_START(REG[14][0]),.AES_DONE(AES_DONE), .AES_KEY(REG[3:0]), .AES_MSG_ENC(REG[7:4]), .AES_MSG_DEC(MSG_DE));
						 		 
endmodule
