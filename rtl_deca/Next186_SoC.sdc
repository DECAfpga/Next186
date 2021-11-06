#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 [get_ports CLOCK_50]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty


#**************************************************************
# Set sdram_clk
#**************************************************************

set sdram_clk "sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[2]"
                                    

#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -clock [get_clocks $sdram_clk] -reference_pin [get_ports {DRAM_CLK}] -max 6.5ns [get_ports DRAM_DQ[*]]
set_input_delay -clock [get_clocks $sdram_clk] -reference_pin [get_ports {DRAM_CLK}] -min 3.5 [get_ports DRAM_DQ[*]]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock [get_clocks $sdram_clk] -reference_pin [get_ports {DRAM_CLK}] -max 1.5ns [get_ports {DRAM_D* DRAM_A* DRAM_BA* DRAM_CAS_N DRAM_RAS_N DRAM_WE_N }]
set_output_delay -clock [get_clocks $sdram_clk] -reference_pin [get_ports {DRAM_CLK}] -min -0.8ns [get_ports {DRAM_D* DRAM_A* DRAM_BA* DRAM_CAS_N DRAM_RAS_N DRAM_WE_N }]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************
set_false_path  -from  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[1]}]
set_false_path  -from  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[1]}]  -to  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[1]}]
set_false_path  -from  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[3]}]
set_false_path  -from  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[4]}]
set_false_path  -from  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[0]}] -to [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  
set_false_path  -from  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[1]}] -to [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  
set_false_path  -from  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[3]}] -to [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  
set_false_path  -from  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[4]}] -to [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  
set_false_path  -from  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[0]}] -to [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[1]}]  
set_false_path  -from  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[1]}] -to [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[0]}]  
set_false_path -from [get_clocks {CLOCK_50}] -to [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[3]}]
set_false_path -from [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[3]}] -to [get_clocks {CLOCK_50}]

set_false_path -from [get_registers {system:sys_inst|VGA_SC:sc|planarreq}]

#**************************************************************
# Set Multicycle Path
#**************************************************************
set_multicycle_path -from [get_registers {sys_inst|CPUUnit|cpu*}] -setup -start 2
set_multicycle_path -from [get_registers {sys_inst|CPUUnit|cpu*}] -hold -start 1


#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



# How to change the PLL frequency after compilation
# 1 - Locate the PLL in the hierarchy, right click and select <Locate Node>/<Locate in Resource Property Editor>
# 2 - Change the desired parameters (the non grayed ones)
# 3 - In the main menu select <Edit>/<Check and Save all Netlist Changes>
# 4 - Wait for Fitter and Assembler
