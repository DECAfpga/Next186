// DECA port by Somhic & Shaeon (03/11/21) -- https://github.com/DECAfpga/Next186
// Next186 SoC NeptUNO port by DistWave -- https://github.com/neptuno-fpga/Next186_SoC
//
// v0.1 initial release, just vga and no naudio
// v0.2 added I2S sound to line out and hdmi. Added HDMI output
// v0.3 clearing and reorganization of files, sdram clock at 100 MHz -1.5ns phase shift
// v0.4 added line 157 in sdram.v to allow 128 MB modules but left commented. Uncomment it if you need to use a 128 MB module.
//      sdram clock at 80 MHz -2ns phase shift, for better compatibility
//

module Next186_SoC(

	input 	CLOCK_50,

	output	[12:0]DRAM_ADDR,
	output	[1:0]DRAM_BA,
	output	DRAM_CAS_N,
	output	DRAM_CKE,
	output	DRAM_CLK,
	output	DRAM_CS_N,
	inout	[15:0]DRAM_DQ,
	output	[1:0]DRAM_DQM,
	output	DRAM_RAS_N,
	output	DRAM_WE_N,

	output [3:0]VGA_R,
	output [3:0]VGA_G,
	output [3:0]VGA_B,
	output VGA_VSYNC,
	output VGA_HSYNC,

	output SDLED,

	input BTN_SOUTH,
	input BTN_WEST,

	inout PS2_CLKA,
	inout PS2_DATA,
	inout PS2_CLKB,
	inout PS2_DATB,

	output AUDIO_L,
	output AUDIO_R,

	output SD_nCS,
	input  SD_DO,
	output SD_CK,
	output SD_DI,
	//
	output	SD_SEL,
	output	SD_CMD_DIR,
	output	SD_D0_DIR,
	output	SD_D123_DIR,
	//
	input  RX_EXT,
	output TX_EXT,

//	output MIDI_OUT,
//	input CLKBD,
//	input WSBD,
//	input DABD,
	
	// Audio DAC DECA
	output wire i2sMck,			//AUDIO_MCLK
	output wire i2sSck,			//AUDIO_BCLK
	output wire i2sLr,			//AUDIO_WCLK
	output wire i2sD,			//AUDIO_DIN_MFP1
	inout  wire	AUDIO_GPIO_MFP5,
	input  wire	AUDIO_MISO_MFP4,
	inout  wire	AUDIO_RESET_n,
	output wire AUDIO_SCLK_MFP3,
	output wire AUDIO_SCL_SS_n,
	inout  wire	AUDIO_SDA_MOSI,
	output wire AUDIO_SPI_SELECT,

	// HDMI-TX  DECA 
	inout 		  	HDMI_I2C_SCL,
	inout 		  	HDMI_I2C_SDA,
	inout 	[3:0]	HDMI_I2S,
	inout 		 	HDMI_LRCLK,
	inout 		 	HDMI_MCLK,
	inout 		  	HDMI_SCLK,
	output		  	HDMI_TX_CLK,
	output	[23:0]	HDMI_TX_D,
	output		    HDMI_TX_DE,    
	output		    HDMI_TX_HS,
	input 		    HDMI_TX_INT,
	output		    HDMI_TX_VS
);

	// VGA 666 to 333 
	wire [5:0] VGA_R_out;
	wire [5:0] VGA_G_out;
	wire [5:0] VGA_B_out;
	assign VGA_R = VGA_R_out[5:2];
	assign VGA_G = VGA_G_out[5:2];
	assign VGA_B = VGA_B_out[5:2];

	// MicroSD Card 
	assign SD_SEL = 1'b0;   //0 = 3.3V at sdcard		
	assign SD_CMD_DIR = 1'b1;  // MOSI FPGA output	
	assign SD_D0_DIR = 1'b0;   // MISO FPGA input	
	assign SD_D123_DIR = 1'b1; // CS FPGA output	

	// AUDIO CODEC
	wire   RESET_DELAY_n;
	assign RESET_DELAY_n = BTN_SOUTH;

	// Audio DAC DECA Output assignments
	assign AUDIO_GPIO_MFP5  = 1'b1;  // GPIO
	assign AUDIO_SPI_SELECT = 1'b1;  // SPI mode
	assign AUDIO_RESET_n    = RESET_DELAY_n;    

	// AUDIO CODEC SPI CONFIG
	// I2S mode; fs = 48khz; MCLK = 24.567Mhz x 2
	AUDIO_SPI_CTL_RD u1 (
		.iRESET_n	(RESET_DELAY_n  ), 	
		.iCLK_50	(CLOCK_50       ), 	//50Mhz clock
		.oCS_n		(AUDIO_SCL_SS_n ),  //SPI interface mode chip-select signal
		.oSCLK		(AUDIO_SCLK_MFP3),  //SPI serial clock
		.oDIN		(AUDIO_SDA_MOSI ),  //SPI Serial data output
		.iDOUT		(AUDIO_MISO_MFP4)   //SPI serial data input
	);
		
	
	//  HDMI I2C CONFIG
	I2C_HDMI_Config u_I2C_HDMI_Config (
	.iCLK		(CLOCK_50),
	.iRST_N		(RESET_DELAY_n),		
	.I2C_SCLK	(HDMI_I2C_SCL ),
	.I2C_SDAT	(HDMI_I2C_SDA ),
	.HDMI_TX_INT(HDMI_TX_INT  )
	);

	//  HDMI VIDEO
	wire VGA_DE;
	wire CLOCK_HDMI;
	assign HDMI_TX_CLK = CLOCK_HDMI;    
	assign HDMI_TX_DE = VGA_DE;
	assign HDMI_TX_HS = !VGA_HSYNC;   
	assign HDMI_TX_VS = !VGA_VSYNC;   
	assign HDMI_TX_D  = {VGA_R_out, VGA_R_out[5:4], VGA_G_out, VGA_G_out[5:4], VGA_B_out, VGA_B_out[5:4]};  	
	
	//  HDMI AUDIO
	assign HDMI_MCLK   = i2sMck;
	assign HDMI_SCLK   = i2sSck;
	assign HDMI_LRCLK  = i2sLr;
	assign HDMI_I2S[0] = i2sD;


	//////////

	wire [7:0]LEDS;
	assign DRAM_CKE = 1'b1;
	
	assign SDLED = ~LEDS[1];

	system sys_inst
	(
		.CLK_50MHZ(CLOCK_50),
		.VGA_R(VGA_R_out),
		.VGA_G(VGA_G_out),
		.VGA_B(VGA_B_out),
		.frame_on(),
		.VGA_HSYNC(VGA_HSYNC),
		.VGA_VSYNC(VGA_VSYNC),
//		.sdr_CLK_out(SDR_CLK),
		.sdr_CLK_out(DRAM_CLK),
		.sdr_n_CS_WE_RAS_CAS({DRAM_CS_N, DRAM_WE_N, DRAM_RAS_N, DRAM_CAS_N}),
		.sdr_BA(DRAM_BA),
		.sdr_ADDR(DRAM_ADDR),
		.sdr_DATA(DRAM_DQ),
		.sdr_DQM({DRAM_DQM}),
		.LED(LEDS),
		.BTN_RESET(~BTN_SOUTH),
		.BTN_NMI(~BTN_WEST),
		.RS232_DCE_RXD(RX_EXT),
		.RS232_DCE_TXD(TX_EXT),
		.RS232_EXT_RXD(),
		.RS232_EXT_TXD(),
		.SD_n_CS(SD_nCS),
		.SD_DI(SD_DI),
		.SD_CK(SD_CK),
		.SD_DO(SD_DO),
		.AUD_L(AUDIO_L),
		.AUD_R(AUDIO_R),
	 	.PS2_CLK1(PS2_CLKA),
		.PS2_CLK2(PS2_CLKB),
		.PS2_DATA1(PS2_DATA),
		.PS2_DATA2(PS2_DATB),
		.RS232_HOST_RXD(),
		.RS232_HOST_TXD(),
		.RS232_HOST_RST(),
		.GPIO(),
		.I2C_SCL(),
		.I2C_SDA(),
		.I2S_LRCLK(i2sLr),
		.I2S_SDIN(i2sD),
		.I2S_SCLK(i2sSck),
		.I2S_MCLK(i2sMck),
		// .MIDI_OUT(MIDI_OUT),
		// .CLKBD(CLKBD),
		// .WSBD(WSBD),
		// .DABD(DABD),

		.VGA_DE (VGA_DE),
		.CLK_PIX (CLOCK_HDMI)
	);
	
endmodule

