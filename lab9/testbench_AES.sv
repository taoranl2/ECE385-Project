module testbench_AES();
	timeunit 10ns;
	timeprecision 1ns;
	
	// Internal Variables
	logic CLK;
	logic RESET;
	logic AES_START;
	logic AES_DONE;
	logic [127:0] AES_KEY;
	logic [127:0] AES_MSG_ENC;
	logic [127:0] AES_MSG_DEC;
	
	// Instantiate the Toplevel Entity to be Tested
	AES AES_inst(.*);
	
	// Generate the Clock
	always begin: CLOCK_GENERATION
		#1 CLK = ~CLK;
	end
	
	initial begin: CLOCK_INITIALIZATION
		CLK = 0;
	end
	
	// Begin the Test
	initial begin: TEST
		RESET = 1'b1;
		AES_START = 1'b0;
		AES_KEY = 128'h0;
		AES_MSG_ENC = 128'h0;
		
		#2 RESET = 1'b0;
		
		#2 AES_KEY  = 128'h000102030405060708090a0b0c0d0e0f;
		AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;
		
		#2 AES_START = 1'b1;
	end
	
endmodule
