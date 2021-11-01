# Next186 - DECA port 

DECA Top level for NES by Somhic (1/11/21) adapted from Neptuno port by Distwave (https://github.com/neptuno-fpga/Next186_SoC)

**Features:**

* HDMI video output
* VGA 444 video output is available through GPIO (see pinout below). 
  * Tested with PS2 & R2R VGA adapter (333)  https://www.waveshare.com/vga-ps2-board.htm
* Line out (3.5 jack green connector) and HDMI audio output
* ~~PWM audio is available through GPIO (see pinout below)~~  

  

**Additional hardware required**:

- SDRAM Mister module (old version with 3 pins). ([see connections](https://github.com/SoCFPGA-learning/DECA/tree/main/Projects/sdram_mister_deca) + [3pins](https://github.com/DECAfpga/DECA_board/blob/main/Sdram_mister_deca/README_3pins.md))
- PS/2 Keyboard connected to GPIO  (see pinout below)

**Versions**:

- current version: 0.2
- ~~see changelog in top level file deca/nes_deca.sv~~

**Compiling:**

* Load project  Next186_SoC.qpf
* sof/svf files already included in output_files/

**Pinout connections:**

![pinout_deca](pinout_deca.png)

Audio not connected as the diagram because of the 3 pins memory change.

**Others:**

* Button KEY0 is a reset button

### STATUS

* Working fine

* HDMI video outputs special resolution, so does not work in all monitors.

