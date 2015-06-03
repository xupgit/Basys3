# Script to create a digital clock showing MM:SS using XUP_LIB components. Set XUP_LIB path below before running
#
# The digital clock is built using counters, comparators, concat, # bin2bcd, and 7-segment display IPs available in XUP_LIB and 
# Vivado's standard installation directory. It also uses clocking # wizard to generate 5 MHz clock from on-board 100 MHz clock 
# source. The generated 5 MHz clock is further divided to 
# generate 1 Hz clock signal. There are two counters and two 7-
# segment display instances, one set for seconds and another for 
# the minutes. Since the board only has 4 7-segment displays, 
# hours are not displayed. One can extend the design by 
# displaying hours on LEDs.
#
# Vivado 2014.4
# Basys 3 board
# 29 May 2015
# Notes: Set the path below to the XUP_LIB, and run source digital_clock.tcl to create the design
# It is assumed the pin constraints xdc file (digital_clock_basys3_pins.xdc) is in the project directory. 
# If the constraints file is located somewhere else, modify the constraints_directory path below
#
# The reset is connected to the center button 
# The output is displayed on the four 7-segment module 
# -------------------------------------------------------------- #
# SET 'basys3_github' PATH TO GITHUB LIBRARY BEFORE RUNNING
# -------------------------------------------------------------- #
set basys3_github {C:/xup/IPI_LIB/XUP_LIB}
set project_directory .
set project_name digital_clock
set constraints_directory $project_directory
set constraints_file digital_clock_basys3_pins.xdc
# Create project for Basys 3
create_project -force $project_name ./$project_name -part xc7a35tcpg236-1
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property target_language verilog [current_project]
set_property simulator_language Verilog [current_project]
set_property ip_repo_paths  $basys3_github [current_project]
update_ip_catalog
create_bd_design "$project_name"
# instantiate counter, comparator, and associated logic for the seconds and connect them
create_bd_cell -type ip -vlnv xilinx.com:XUP:counters:1.0 counters_0
set_property -dict [list CONFIG.COUNT_SIZE {6}] [get_bd_cells counters_0]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_range_comparator:1.0 xup_range_comparator_0
set_property -dict [list CONFIG.SIZE {6}] [get_bd_cells xup_range_comparator_0]
connect_bd_net [get_bd_pins counters_0/bin_count] [get_bd_pins xup_range_comparator_0/in1]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property -dict [list CONFIG.CONST_WIDTH {6} CONFIG.CONST_VAL {59}] [get_bd_cells xlconstant_0]
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins xup_range_comparator_0/in2]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells xlconstant_1]
connect_bd_net [get_bd_pins xlconstant_1/dout] [get_bd_pins xup_range_comparator_0/sign]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2
connect_bd_net [get_bd_pins xlconstant_2/dout] [get_bd_pins counters_0/enable]
connect_bd_net -net [get_bd_nets xlconstant_2_dout] [get_bd_pins counters_0/up_dn] [get_bd_pins xlconstant_2/dout]
# instantiate clocking wizard and configure it to generate 5 MHz clock. Connect its input to the input port using the run_connection wizard
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_0
set_property -dict [list CONFIG.CLKOUT2_USED {true} CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {5.000} CONFIG.USE_LOCKED {false} CONFIG.USE_RESET {false} CONFIG.MMCM_CLKFBOUT_MULT_F {6.250} CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.250} CONFIG.MMCM_CLKOUT1_DIVIDE {125} CONFIG.NUM_OUT_CLKS {2} CONFIG.CLKOUT1_JITTER {148.376} CONFIG.CLKOUT1_PHASE_ERROR {128.132} CONFIG.CLKOUT2_JITTER {270.159} CONFIG.CLKOUT2_PHASE_ERROR {128.132}] [get_bd_cells clk_wiz_0]
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "sys_clock" }  [get_bd_pins clk_wiz_0/clk_in1]
# add vivado IPI binary counter as it provides larger size counter. Add comparator and set its value to generate 1 Hz. Add associated logic and connect them
create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0
set_property -dict [list CONFIG.Implementation {DSP48} CONFIG.Output_Width {23} CONFIG.Restrict_Count {true} CONFIG.Final_Count_Value {4C4B40}] [get_bd_cells c_counter_binary_0]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_range_comparator:1.0 xup_range_comparator_1
set_property -dict [list CONFIG.SIZE {23}] [get_bd_cells xup_range_comparator_1]
connect_bd_net [get_bd_pins c_counter_binary_0/Q] [get_bd_pins xup_range_comparator_1/in1]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins c_counter_binary_0/CLK]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3
set_property -dict [list CONFIG.CONST_WIDTH {23} CONFIG.CONST_VAL {5000000}] [get_bd_cells xlconstant_3]
connect_bd_net [get_bd_pins xlconstant_3/dout] [get_bd_pins xup_range_comparator_1/in2]
connect_bd_net -net [get_bd_nets xlconstant_1_dout] [get_bd_pins xup_range_comparator_1/sign] [get_bd_pins xlconstant_1/dout]
connect_bd_net [get_bd_pins xup_range_comparator_1/eq] [get_bd_pins counters_0/clk]
# add a 7-segment display for seconds and wire it up
create_bd_cell -type ip -vlnv xilinx.com:XUP:seg7display:1.0 seg7display_0
set_property -dict [list CONFIG.DP_0 {0} CONFIG.DP_1 {0} CONFIG.DP_3 {0}] [get_bd_cells seg7display_0]
connect_bd_net [get_bd_pins seg7display_0/clk] [get_bd_pins clk_wiz_0/clk_out1]
create_bd_port -dir I -type rst reset
connect_bd_net [get_bd_pins /seg7display_0/reset] [get_bd_ports reset]
create_bd_cell -type ip -vlnv xilinx.com:XUP:bin2bcd:1.0 bin2bcd_0
# set the size
set_property -dict [list CONFIG.SIZE {6}] [get_bd_cells bin2bcd_0]
# add a counter and 7-segment display for the minutes and wire it up
create_bd_cell -type ip -vlnv xilinx.com:XUP:counters:1.0 counters_1
set_property -dict [list CONFIG.COUNT_SIZE {6}] [get_bd_cells counters_1]
create_bd_cell -type ip -vlnv xilinx.com:XUP:bin2bcd:1.0 bin2bcd_1
set_property -dict [list CONFIG.SIZE {6}] [get_bd_cells bin2bcd_1]
connect_bd_net [get_bd_pins counters_0/bin_count] [get_bd_pins bin2bcd_0/a_in]
connect_bd_net [get_bd_pins counters_1/bin_count] [get_bd_pins bin2bcd_1/a_in]
connect_bd_net -net [get_bd_nets xlconstant_2_dout] [get_bd_pins counters_1/up_dn] [get_bd_pins xlconstant_2/dout]
connect_bd_net -net [get_bd_nets xlconstant_2_dout] [get_bd_pins counters_1/enable] [get_bd_pins xlconstant_2/dout]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_range_comparator:1.0 xup_range_comparator_2
set_property -dict [list CONFIG.SIZE {6}] [get_bd_cells xup_range_comparator_2]
connect_bd_net -net [get_bd_nets xlconstant_1_dout] [get_bd_pins xup_range_comparator_2/sign] [get_bd_pins xlconstant_1/dout]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4
set_property -dict [list CONFIG.CONST_WIDTH {6} CONFIG.CONST_VAL {59}] [get_bd_cells xlconstant_4]
connect_bd_net [get_bd_pins xlconstant_4/dout] [get_bd_pins xup_range_comparator_2/in2]
connect_bd_net -net [get_bd_nets counters_1_bin_count] [get_bd_pins xup_range_comparator_2/in1] [get_bd_pins counters_1/bin_count]
# Add concat IP, set it to 4 ports and connect ones and tens of both seconds and minutes bin2bcd instances
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property -dict [list CONFIG.NUM_PORTS {4}] [get_bd_cells xlconcat_0]
connect_bd_net [get_bd_pins bin2bcd_0/ones] [get_bd_pins xlconcat_0/In0]
connect_bd_net [get_bd_pins bin2bcd_0/tens] [get_bd_pins xlconcat_0/In1]
connect_bd_net [get_bd_pins bin2bcd_1/ones] [get_bd_pins xlconcat_0/In2]
connect_bd_net [get_bd_pins bin2bcd_1/tens] [get_bd_pins xlconcat_0/In3]
connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins seg7display_0/x_l]
# create reset for minutes 
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_0
connect_bd_net [get_bd_pins xup_and2_0/a] [get_bd_pins xup_range_comparator_0/eq]
connect_bd_net [get_bd_pins xup_and2_0/b] [get_bd_pins xup_range_comparator_2/eq]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or2:1.0 xup_or2_0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or2:1.0 xup_or2_1
connect_bd_net [get_bd_pins xup_or2_1/y] [get_bd_pins counters_1/clr]
connect_bd_net [get_bd_pins xup_and2_0/y] [get_bd_pins xup_or2_1/a]
connect_bd_net [get_bd_pins xup_or2_0/y] [get_bd_pins counters_0/clr]
connect_bd_net -net [get_bd_nets xup_range_comparator_0_eq] [get_bd_pins xup_or2_0/a] [get_bd_pins xup_range_comparator_0/eq]
connect_bd_net -net [get_bd_nets reset_1] [get_bd_ports reset] [get_bd_pins xup_or2_1/b]
connect_bd_net -net [get_bd_nets reset_1] [get_bd_ports reset] [get_bd_pins xup_or2_0/b]

create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff:1.0 xup_dff_0
connect_bd_net -net [get_bd_nets xup_range_comparator_0_eq] [get_bd_pins xup_dff_0/d] [get_bd_pins xup_range_comparator_0/eq]
connect_bd_net -net [get_bd_nets xup_range_comparator_1_eq] [get_bd_pins xup_dff_0/clk] [get_bd_pins xup_range_comparator_1/eq]
connect_bd_net [get_bd_pins xup_dff_0/q] [get_bd_pins counters_1/clk]
create_bd_port -dir O -from 6 -to 0 a_to_g
connect_bd_net [get_bd_pins /seg7display_0/a_to_g] [get_bd_ports a_to_g]
create_bd_port -dir O -from 3 -to 0 an_l
connect_bd_net [get_bd_pins /seg7display_0/an_l] [get_bd_ports an_l]
create_bd_port -dir O dp_l
connect_bd_net [get_bd_pins /seg7display_0/dp_l] [get_bd_ports dp_l]
set_property name seg [get_bd_ports a_to_g]
set_property name an [get_bd_ports an_l]
set_property name dp [get_bd_ports dp_l]
validate_bd_design
save_bd_design
make_wrapper -files [get_files $project_directory/$project_name/$project_name.srcs/sources_1/bd/$project_name/$project_name.bd] -top
add_files -norecurse $project_directory/$project_name/$project_name.srcs/sources_1/bd/$project_name/hdl/$project_name\_wrapper.v
# Add pin constraints
add_files -fileset constrs_1 -norecurse $constraints_directory/$constraints_file
