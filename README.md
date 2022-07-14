# Next186 - DECA port 

DECA Top level for NES by Somhic (1/11/21) adapted from Neptuno port by Distwave (https://github.com/neptuno-fpga/Next186_SoC).

**Now compatible with [Deca Retro Cape 2](https://github.com/somhi/DECA_retro_cape_2)** (new location for 3 pins of old SDRAM modules). Otherwise see pinout below to connect everything through GPIOs.

**Features:**

* HDMI video output  (special resolution will not work on all LCD monitors)
* VGA 444 video output is available through GPIO (see pinout below). 
* Audio Line out (3.5 jack green connector) and HDMI audio output
* PWM audio is available through GPIO
* MIDI output and MIDI I2S mixing available though an external mt32-pi synthesizer ([MIDI2SBC](https://github.com/somhi/MIDI_I2S_SBC_Pmod_Edge_Interface))
* Requires an special SD card with BIOS  flashed into it (see notes below)

**Additional hardware required**:

- SDRAM Mister module.
  - Tested with 32 MB SDRAM board for MiSTer (extra slim) XS_2.2 ([see connections](https://github.com/SoCFPGA-learning/DECA/tree/main/Projects/sdram_mister_deca)) (sdram clk at 125 MHz -2.5ns  did not work; at 100 MHz -2ns worked, but other testers reported that only worked the 80 MHz -2ns version)
  - Tested with a dual memory module v1.3 with 3 pins ([see connections](https://github.com/SoCFPGA-learning/DECA/tree/main/Projects/sdram_mister_deca) + [3pins](https://github.com/DECAfpga/DECA_board/blob/main/Sdram_mister_deca/README_3pins.md)) with a memtest of 140 MHz (sdram clk at 100 MHz -1.5 ns worked but after adding Alastair's change in sdram controller to allow 128 MB modules it stopped loading Manhunter 1 game; changed sdram clk to 80MHz -2ns then worked).
  - Tested with a dual memory module v1.3 with 3 pins ([see connections](https://github.com/SoCFPGA-learning/DECA/tree/main/Projects/sdram_mister_deca) + [3pins](https://github.com/DECAfpga/DECA_board/blob/main/Sdram_mister_deca/README_3pins.md)) with a memtest of 120 MHz (sdram clk 100 MHz -1.5ns hanged when loading games but with sdram clk of 100 MHz -2ns worked).
  - If you want to use a 128 MB Mister module, edit rtl/sdram.v, uncomment line 157 and compile the project again.
- PS/2 Keyboard connected to GPIO  (see pinout below)

**Versions**:

- See changelog in rtl_deca/Next186_SoC.v
- current version: 0.4   
  - added line 157 in sdram.v to allow 128 MB modules but left it commented
  - sdram clock at 80 MHz -2ns phase shift, for better compatibility

**Compiling:**

* Load project  rtl_deca/Next186_SoC.qpf
* sof/svf files already included in rtl_deca/output_files/

**Pinout connections:**

![pinout_deca](pinout_deca.png)

UART not connected as diagram. See pins at Next186_SoC.qsf.

MIDI_out is connected to UART_TXD as per diagram above.

Joystick not available.

**Others:**

* Button KEY0 is a reset button



### SD card

This core needs it's own SD card inserted with the BIOS flashed in the last 8 kB and first 64 sectors.

[Freedos.img](Freedos.img) includes FreeDOS and the BIOS needed. Flash it into an SD (SDHC type, 4 GB or more).

### STATUS

* Working fine

* HDMI video outputs special resolution, so does not work in all monitors.

