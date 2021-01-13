module AudioController(
	input  logic CLK,Reset,go,
	// Flash Memory
	output logic [22:0] FL_ADDR, // Flash memory Address - bit0 is signa to grab lower/upper byte
   input  logic [7:0]  FL_DQ,   
   output logic        FL_OE_N, FL_RST_N, FL_WE_N, FL_CE_N,FL_WP_N,
	// Audio Interface
   output logic        AUD_DACDAT, AUD_XCK, I2C_SCLK,AUD_DACLRCK, AUD_BCLK,
	inout  wire         I2C_SDAT);

logic [3:0] counter; //selecting register address and its corresponding data
logic counting_state,ignition,read_enable; 	
logic [15:0] MUX_input;
logic [22:0] read_counter;
logic [3:0] ROM_output_mux_counter;
logic [4:0] DAC_LR_CLK_counter;
logic [15:0]MusicData, MusicBuffer;
logic finish_flag;

logic test;
assign test = 1'b1;

assign AUD_DACDAT = (test)?MusicData[15-ROM_output_mux_counter]:0;

always_ff @(posedge AUD_BCLK) 
	begin
	if(read_enable)
		begin
		ROM_output_mux_counter <= ROM_output_mux_counter + 1;
		if (DAC_LR_CLK_counter == 1) fast_LR_CLK <= 1;
		else fast_LR_CLK<=0;
		if (DAC_LR_CLK_counter == 31) AUD_DACLRCK <= 1;
		else AUD_DACLRCK <= 0;
		end
	end

	
always_ff @(posedge AUD_BCLK)
	begin
	if(read_enable)
		begin
		DAC_LR_CLK_counter <= DAC_LR_CLK_counter + 1;
		end
	end
	
always_ff @(posedge CLK)
	begin
	if(!Reset) 
		begin
		counting_state <= 0;
		read_enable <= 0;
		end
	else
		begin
		case(counting_state)
		0:
			begin
			ignition <= 1;
			read_enable <= 0;
			if(counter == 8) counting_state <= 1; //was 8
			end
		1:
			begin
			read_enable <= 1;
			ignition <= 0;
			end
		endcase
		end
	end

// Flash Memory Setting
logic [3:0] flashcounter;

assign FL_RST_N= 1'b1;
assign FL_WE_N = 1'b1;
assign FL_CE_N = 1'b0;
assign FL_OE_N = 1'b0;
assign FL_WP_N = 1'b1;

I2C_Protocol I2C_P(.clk(CLK),.reset(Reset),.ignition(ignition),.MUX_input(MUX_input),.SDIN(I2C_SDAT),.finish_flag(finish_flag),.ACK(),.SCLK(I2C_SCLK));

USB_Clock_PLL UCP(.inclk0(CLK),.c0(AUD_XCK),.c1(AUD_BCLK));

always_ff @(posedge AUD_DACLRCK)
	begin
	if(read_enable) 
		begin
			MusicData <= MusicBuffer;
		end
	end

logic fast_LR_CLK;

always_ff @(posedge fast_LR_CLK)
	begin
	if(read_enable) 
        begin
            if (read_counter <= 3900000) read_counter <= read_counter + 1;
            else read_counter <= 0;
        end
	end
	
always_ff @(posedge CLK)
	begin
		flashcounter <= flashcounter +1;
		if (flashcounter == 0)
			begin
				FL_ADDR <= read_counter *2;
			end
		else if (flashcounter == 5)
			begin
				MusicBuffer[15:8] <= FL_DQ;
			end
		else if (flashcounter == 7)
			begin
				FL_ADDR <= read_counter *2 +1;
			end
		else if (flashcounter == 12)
			begin
				MusicBuffer[7:0] <= FL_DQ;
			end
		else if (flashcounter == 14)
			begin
				flashcounter <= 0;
			end
	end
	
// this counter is used to switch between registers
always_ff @(posedge I2C_SCLK)
	begin
		case(counter) //MUX_input[15:9] register address, MUX_input[8:0] register data
		0: MUX_input <= 16'h1201; // activate interface
		1: MUX_input <= 16'h0460; // left headphone out
		2: MUX_input <= 16'h0C00; // power down control
		3: MUX_input <= 16'h0812; // analog audio path control
		4: MUX_input <= 16'h0A00; // digital audio path control
		5: MUX_input <= 16'h102F; // sampling control
		6: MUX_input <= 16'h0E23; // digital audio interface format
		7: MUX_input <= 16'h0660; // right headphone out
		8: MUX_input <= 16'h1E00; // reset device
		endcase
	end
always_ff @(posedge finish_flag)
	begin
	counter <= counter + 1;
	end


endmodule 