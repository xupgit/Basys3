# Script to create a stop watch showing M.SS.F at a tenth of second resolution using XUP_LIB components. 
# Set XUP_LIB path below before running
#
# The stop watch is built using counters, comparators, concat, 
# bin2bcd, and 7-segment display IPs available in XUP_LIB and IPs available in the  
# Vivado's standard installation directory. It also uses clocking # wizard to generate 5 MHz clock from 
# the on-board 100 MHz clock source. The generated 5 MHz clock is further divided to 
# generate 0.1 Hz clock signal. There are three counters and one # 7-segment display instance, showing M.SS.F 
#
# Vivado 2014.4
# Basys 3 board
# 2 June 2015
# Notes: Set the path below to the XUP_LIB, and run source stop_watch.tcl to create the design
# It is assumed the pin constraints xdc file (stop_watch_basys3_pins.xdc) is in the project directory. 
# If the constraints file is located somewhere else, modify the constraints_directory path below
#
# The reset is connected to the center button 
# The output is displayed on the four 7-segment module 
# -------------------------------------------------------------- #
# SET 'basys3_github' PATH TO GITHUB LIBRARY BEFORE RUNNING
# -------------------------------------------------------------- #
set basys3_github {C:/xup/IPI_LIB/XUP_LIB}
set project_directory .
set project_name stop_watch
set constraints_directory $project_directory
set constraints_file stop_watch_basys3_pins.xdc
# Create project for Basys 3
create_project -force $project_name ./$project_name -part xc7a35tcpg236-1
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property target_language verilog [current_project]
set_property simulator_language Verilog [current_project]
set_property ip_repo_paths  $basys3_github [current_project]
update_ip_catalog
create_bd_design "$project_name"
# instantiate clocking wizard and configure it to generate 5 MHz clock. Connect its input to the input port using the run_connection wizard
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_0
set_property -dict [list CONFIG.CLKOUT2_USED {true} CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {5.000} CONFIG.USE_LOCKED {false} CONFIG.USE_RESET {false} CONFIG.MMCM_CLKFBOUT_MULT_F {6.250} CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.250} CONFIG.MMCM_CLKOUT1_DIVIDE {125} CONFIG.NUM_OUT_CLKS {2} CONFIG.CLKOUT1_JITTER {148.376} CONFIG.CLKOUT1_PHASE_ERROR {128.132} CONFIG.CLKOUT2_JITTER {270.159} CONFIG.CLKOUT2_PHASE_ERROR {128.132}] [get_bd_cells clk_wiz_0]
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "sys_clock" }  [get_bd_pins clk_wiz_0/clk_in1]
# add vivado IPI binary counter as it provides larger size counter. Add comparator and set its value to generate 0.1 Hz. Add associated logic and connect them
create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0
set_property -dict [list CONFIG.Implementation {DSP48} CONFIG.Output_Width {19} CONFIG.Restrict_Count {true} CONFIG.Final_Count_Value {7A120}] [get_bd_cells c_counter_binary_0]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_range_comparator:1.0 tenth_second
set_property -dict [list CONFIG.SIZE {19}] [get_bd_cells tenth_second]
connect_bd_net [get_bd_pins c_counter_binary_0/Q] [get_bd_pins tenth_second/in1]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins c_counter_binary_0/CLK]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_500000
set_property -dict [list CONFIG.CONST_WIDTH {19} CONFIG.CONST_VAL {500000}] [get_bd_cells const_500000]
connect_bd_net [get_bd_pins const_500000/dout] [get_bd_pins tenth_second/in2]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_gnd
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells const_gnd]
connect_bd_net [get_bd_pins const_gnd/dout] [get_bd_pins tenth_second/sign]
# instantiate counter, comparator, and associated logic for the tenth of a second and connect them
create_bd_cell -type ip -vlnv xilinx.com:XUP:counters:1.0 tenth_ctr
set_property -dict [list CONFIG.COUNT_SIZE {4}] [get_bd_cells tenth_ctr]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_range_comparator:1.0 tenth_sec_compare
set_property -dict [list CONFIG.SIZE {4}] [get_bd_cells tenth_sec_compare]
connect_bd_net [get_bd_pins tenth_ctr/bin_count] [get_bd_pins tenth_sec_compare/in1]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_9
set_property -dict [list CONFIG.CONST_WIDTH {4} CONFIG.CONST_VAL {9}] [get_bd_cells const_9]
connect_bd_net [get_bd_pins const_9/dout] [get_bd_pins tenth_sec_compare/in2]
connect_bd_net -net [get_bd_nets const_gnd_dout] [get_bd_pins tenth_sec_compare/sign] [get_bd_pins const_gnd/dout]
connect_bd_net [get_bd_pins tenth_second/eq] [get_bd_pins tenth_ctr/clk]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_1
connect_bd_net [get_bd_pins const_1/dout] [get_bd_pins tenth_ctr/up_dn]
# Generate clr for the tenth of a second counter
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or2:1.0 xup_or2_0
connect_bd_net [get_bd_pins tenth_sec_compare/eq] [get_bd_pins xup_or2_0/a]
connect_bd_net [get_bd_pins xup_or2_0/y] [get_bd_pins tenth_ctr/clr]
# Add a counter and configure it for seconds. Add necessary logic to count it up to 59 and connect it
create_bd_cell -type ip -vlnv xilinx.com:XUP:counters:1.0 seconds_ctr
set_property -dict [list CONFIG.COUNT_SIZE {6}] [get_bd_cells seconds_ctr]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_range_comparator:1.0 seconds_compare
set_property -dict [list CONFIG.SIZE {6}] [get_bd_cells seconds_compare]
connect_bd_net -net [get_bd_nets tenth_second_eq] [get_bd_pins seconds_ctr/clk] [get_bd_pins tenth_second/eq]
connect_bd_net [get_bd_pins seconds_ctr/bin_count] [get_bd_pins seconds_compare/in1]
connect_bd_net -net [get_bd_nets const_gnd_dout] [get_bd_pins seconds_compare/sign] [get_bd_pins const_gnd/dout]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_60
set_property -dict [list CONFIG.CONST_WIDTH {6} CONFIG.CONST_VAL {60}] [get_bd_cells const_60]
connect_bd_net [get_bd_pins const_60/dout] [get_bd_pins seconds_compare/in2]
connect_bd_net -net [get_bd_nets const_1_dout] [get_bd_pins seconds_ctr/up_dn] [get_bd_pins const_1/dout]
# Add a counter and configure it for minutes. Add necessary logic to count it up to 10 and connect it
create_bd_cell -type ip -vlnv xilinx.com:XUP:counters:1.0 minutes_ctr
set_property -dict [list CONFIG.COUNT_SIZE {4}] [get_bd_cells minutes_ctr]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_range_comparator:1.0 minutes_compare
connect_bd_net [get_bd_pins minutes_ctr/bin_count] [get_bd_pins minutes_compare/in1]
connect_bd_net -net [get_bd_nets const_gnd_dout] [get_bd_pins minutes_compare/sign] [get_bd_pins const_gnd/dout]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_10
set_property -dict [list CONFIG.CONST_WIDTH {4} CONFIG.CONST_VAL {10}] [get_bd_cells const_10]
connect_bd_net [get_bd_pins minutes_compare/in2] [get_bd_pins const_10/dout]
connect_bd_net -net [get_bd_nets tenth_second_eq] [get_bd_pins minutes_ctr/clk] [get_bd_pins tenth_second/eq]
connect_bd_net -net [get_bd_nets const_1_dout] [get_bd_pins minutes_ctr/up_dn] [get_bd_pins const_1/dout]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or2:1.0 xup_or2_1
connect_bd_net [get_bd_pins seconds_compare/eq] [get_bd_pins xup_or2_1/a]
connect_bd_net [get_bd_pins xup_or2_1/y] [get_bd_pins seconds_ctr/clr]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or2:1.0 xup_or2_2
connect_bd_net [get_bd_pins minutes_compare/eq] [get_bd_pins xup_or2_2/a]
connect_bd_net [get_bd_pins xup_or2_2/y] [get_bd_pins minutes_ctr/clr]
# add a 7-segment display for seconds and wire it up
# Add concat IP, set it to 4 ports and connect ones and tens of both seconds and minutes bin2bcd instances
create_bd_cell -type ip -vlnv xilinx.com:XUP:bin2bcd:1.0 bin2bcd_0
set_property -dict [list CONFIG.SIZE {6}] [get_bd_cells bin2bcd_0]
connect_bd_net -net [get_bd_nets seconds_ctr_bin_count] [get_bd_pins bin2bcd_0/a_in] [get_bd_pins seconds_ctr/bin_count]
create_bd_cell -type ip -vlnv xilinx.com:XUP:seg7display:1.0 seg7display_0
set_property -dict [list CONFIG.DP_0 {0} CONFIG.DP_2 {0}] [get_bd_cells seg7display_0]
connect_bd_net [get_bd_pins seg7display_0/clk] [get_bd_pins clk_wiz_0/clk_out1]
create_bd_port -dir I -type rst reset
connect_bd_net [get_bd_pins /seg7display_0/reset] [get_bd_ports reset]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property -dict [list CONFIG.NUM_PORTS {4}] [get_bd_cells xlconcat_0]
connect_bd_net -net [get_bd_nets tenth_ctr_bin_count] [get_bd_pins xlconcat_0/In0] [get_bd_pins tenth_ctr/bin_count]
connect_bd_net [get_bd_pins xlconcat_0/In1] [get_bd_pins bin2bcd_0/ones]
connect_bd_net [get_bd_pins xlconcat_0/In2] [get_bd_pins bin2bcd_0/tens]
connect_bd_net -net [get_bd_nets minutes_ctr_bin_count] [get_bd_pins xlconcat_0/In3] [get_bd_pins minutes_ctr/bin_count]
connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins seg7display_0/x_l]

# Connect reset port to the clr port logic
connect_bd_net -net [get_bd_nets reset_1] [get_bd_ports reset] [get_bd_pins xup_or2_1/b]
connect_bd_net -net [get_bd_nets reset_1] [get_bd_ports reset] [get_bd_pins xup_or2_0/b]
connect_bd_net -net [get_bd_nets reset_1] [get_bd_ports reset] [get_bd_pins xup_or2_2/b]
# Create an enable port and generate enable signals for the counters
create_bd_port -dir I enable
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_inv:1.0 xup_inv_0
connect_bd_net [get_bd_ports enable] [get_bd_pins xup_inv_0/a]
connect_bd_net [get_bd_pins tenth_ctr/enable] [get_bd_pins xup_inv_0/y]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_1
connect_bd_net -net [get_bd_nets xup_inv_0_y] [get_bd_pins xup_and2_1/b] [get_bd_pins xup_inv_0/y]
connect_bd_net -net [get_bd_nets xup_inv_0_y] [get_bd_pins xup_and2_0/b] [get_bd_pins xup_inv_0/y]
connect_bd_net -net [get_bd_nets tenth_sec_compare_eq] [get_bd_pins xup_and2_1/a] [get_bd_pins tenth_sec_compare/eq]
connect_bd_net [get_bd_pins xup_and2_1/y] [get_bd_pins seconds_ctr/enable]
connect_bd_net -net [get_bd_nets seconds_compare_eq] [get_bd_pins xup_and2_0/a] [get_bd_pins seconds_compare/eq]
connect_bd_net [get_bd_pins xup_and2_0/y] [get_bd_pins minutes_ctr/enable]
# Create output ports and connect them
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

