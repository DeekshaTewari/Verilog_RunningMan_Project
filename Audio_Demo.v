module Audio_Demo (

	// Inputs

	CLOCK_50,

	KEY,

	AUD_ADCDAT,

	// Bidirectionals

	AUD_BCLK,

	AUD_ADCLRCK,

	AUD_DACLRCK,

	FPGA_I2C_SDAT,

	// Outputs

	AUD_XCK,

	AUD_DACDAT,

	FPGA_I2C_SCLK,

	SW,

	enableSound,

	ramOut

);




/*****************************************************************************

 *                           Parameter Declarations                          *

 *****************************************************************************/



/*****************************************************************************

 *                             Port Declarations                             *

 *****************************************************************************/

// Inputs

input				CLOCK_50;

input		[3:0]	KEY;

input		[3:0]	SW;

input				AUD_ADCDAT;

// Bidirectionals

inout				AUD_BCLK;

inout				AUD_ADCLRCK;

inout				AUD_DACLRCK;

inout				FPGA_I2C_SDAT;

// Outputs

output				AUD_XCK;

output				AUD_DACDAT;

output				FPGA_I2C_SCLK;




/*****************************************************************************

 *                 Internal Wires and Registers Declarations                 *

 *****************************************************************************/

// Internal Wires

wire					audio_in_available;

wire		[31:0]	left_channel_audio_in;

wire		[31:0]	right_channel_audio_in;

wire					read_audio_in;

wire					audio_out_allowed;

wire		[31:0]	left_channel_audio_out;

wire		[31:0]	right_channel_audio_out;

wire					write_audio_out;



//for the ram 

  reg [19:0]addr; //can reg be sent like this? 

  wire [19:0] address;
  
  output reg [7:0] ramOut; 

  wire [5:0] Rout; 

  wire readRam;

  assign ramOUt = {2'b0,Rout}; 

songRAM SR1 (.address(addr), .clock(CLOCK_50), .data(6'b0), .wren (1'b0), .q(Rout));


// Internal Registers

reg [10:0] count; 

//change to input 

input enableSound; 


/*****************************************************************************

 *                             Sequential Logic                              *

 *****************************************************************************/

 

always @ (posedge CLOCK_50)

begin

	if (count == 11'd1042) begin 
		count <= 11'b0;
		addr <= addr + 1'b1; 

	end
	else begin
		count <= count + 1'b1; 
	end 
	if (addr == 20'd633867)
		addr <= 20'b0;
	else
		addr <= addr;
	
end 


assign address = addr; 


/*****************************************************************************

 *                            Combinational Logic                            *

 *****************************************************************************/
wire [31:0] sound = (enableSound == 1'b0)? 32'b0: {26'b0, Rout[5:0]}; //this generates a square wave 


assign read_audio_in				= audio_in_available & audio_out_allowed;
assign left_channel_audio_out	= sound;
assign right_channel_audio_out= sound;
assign write_audio_out			= audio_in_available & audio_out_allowed;




/*****************************************************************************

 *                              Internal Modules                             *

 *****************************************************************************/




Audio_Controller Audio_Controller (

	// Inputs

	.CLOCK_50						(CLOCK_50),

	.reset							(~KEY[0]),

	.clear_audio_in_memory		(),

	.read_audio_in					(read_audio_in),

	.clear_audio_out_memory		(),

	.left_channel_audio_out		(left_channel_audio_out),

	.right_channel_audio_out	(right_channel_audio_out),

	.write_audio_out				(write_audio_out),

	.AUD_ADCDAT					(AUD_ADCDAT),


	// Bidirectionals

	.AUD_BCLK					(AUD_BCLK),

	.AUD_ADCLRCK				(AUD_ADCLRCK),

	.AUD_DACLRCK				(AUD_DACLRCK),


	// Outputs

	.audio_in_available			(audio_in_available),

	.left_channel_audio_in		(left_channel_audio_in),

	.right_channel_audio_in		(right_channel_audio_in),


	.audio_out_allowed			(audio_out_allowed),


	.AUD_XCK							(AUD_XCK),

	.AUD_DACDAT						(AUD_DACDAT)

);




avconf #(.USE_MIC_INPUT(1)) avc (

	.FPGA_I2C_SCLK					(FPGA_I2C_SCLK),

	.FPGA_I2C_SDAT					(FPGA_I2C_SDAT),

	.CLOCK_50					(CLOCK_50),

	.reset						(~KEY[0])

);


endmodule 