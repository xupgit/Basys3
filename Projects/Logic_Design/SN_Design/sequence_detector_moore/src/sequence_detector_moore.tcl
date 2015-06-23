# Script to create an 8-bit by 8-bit non-restoring divider using XUP_LIB components. 
# Set XUP_LIB path below before running
#
# Vivado 2014.4
# Basys 3 board
# 19 June 2015
# Notes: Set the path below to the XUP_LIB, and run source sequence_detector_moore.tcl to create the design
# It is assumed the pin constraints xdc file (sequence_detector_moore_basys3_pins.xdc) is in the project directory. 
# If the constraints file is located somewhere else, modify the constraints_directory path below
#
# After sourcing this script, run_sim can be executed to drive simulation from proc at bottom of this file
# Once simulation is running (either from the GUI, or from this script) test_pattern can be executed to drive 
# simulation input values defined at the bottom of this file
#
# The 8-bit dividend is input through sw7-sw0 and the 8-bit divisor is input through sw15-sw8.
# The division process starts by pressing BtnC
# The 8-bit quotient output is displayed on LED15-LED8 and the 8-bit remainder is displayed on LED7-LED0
#  
# -------------------------------------------------------------- #
# SET 'basys3_github' PATH TO GITHUB LIBRARY BEFORE RUNNING
# -------------------------------------------------------------- #
set basys3_github {C:/xup/IPI_LIB/XUP_LIB}

set project_directory .
set project_name sequence_detector_moore
set constraints_directory $project_directory
set constraints_file sequence_detector_moore_basys3_pins.xdc
set testbench sequence_detector_moore_tb.v
# Create project for Basys 3
create_project -force $project_name ./$project_name -part xc7a35tcpg236-1
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property target_language verilog [current_project]
set_property simulator_language Verilog [current_project]
set_property ip_repo_paths  $basys3_github [current_project]
update_ip_catalog
create_bd_design "$project_name"

# Steps:
# Create a control unit
# Add a divisor
# Add an accumulator
# Add dividend
# Form AQ
# Add shift_nbit
# Slice AQ shifter output and connect
# Create A_Sign
# Add Adder/Subtractor
# Create Addsub_sign
# Create dividend input path
# create Quotient_register and connect to Quotient port
# Create restore stage and connect the output to Remainder port
# Create done_flag

# create a control unit
create_bd_port -dir I sys_clock
create_bd_port -dir I reset
create_bd_port -dir I ain
create_bd_port -dir O detected
create_bd_port -dir O -from 3 -to 0 count
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff_en_reset_vector:1.0 xup_dff_en_reset_vector_0
set_property name CS [get_bd_cells xup_dff_en_reset_vector_0]
set_property -dict [list CONFIG.SIZE {2}] [get_bd_cells CS]
connect_bd_net [get_bd_ports sys_clock] [get_bd_pins CS/clk]
connect_bd_net [get_bd_ports reset] [get_bd_pins CS/reset]
# create counter
create_bd_cell -type ip -vlnv xilinx.com:XUP:counters:1.0 counters_0
set_property name counter [get_bd_cells counters_0]
set_property -dict [list CONFIG.COUNT_SIZE {4}] [get_bd_cells counter]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins counter/clk]
connect_bd_net -net [get_bd_nets reset_1] [get_bd_ports reset] [get_bd_pins counter/clr]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property name logic_1 [get_bd_cells xlconstant_0]
connect_bd_net [get_bd_pins logic_1/dout] [get_bd_pins counter/up_dn]
connect_bd_net [get_bd_ports count] [get_bd_pins counter/bin_count]
connect_bd_net [get_bd_ports ain] [get_bd_pins counter/enable]
# create next state logic block
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
set_property name cs1 [get_bd_cells xlslice_0]
set_property -dict [list CONFIG.DIN_WIDTH {2} CONFIG.DIN_TO {1} CONFIG.DIN_FROM {1} CONFIG.DOUT_WIDTH {1}] [get_bd_cells cs1]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
set_property name cs0 [get_bd_cells xlslice_0]
set_property -dict [list CONFIG.DIN_WIDTH {2}] [get_bd_cells cs0]
connect_bd_net [get_bd_pins CS/q] [get_bd_pins cs1/Din]
connect_bd_net -net [get_bd_nets CS_q] [get_bd_pins cs0/Din] [get_bd_pins CS/q]
connect_bd_net -net [get_bd_nets logic_1_dout] [get_bd_pins CS/en] [get_bd_pins logic_1/dout]
### Create ain_n, cs1_n, cs0_n
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_inv:1.0 xup_inv_0
set_property name ain_n [get_bd_cells xup_inv_0]
connect_bd_net -net [get_bd_nets ain_1] [get_bd_ports ain] [get_bd_pins ain_n/a]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_inv:1.0 xup_inv_0
set_property name cs1_n [get_bd_cells xup_inv_0]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_inv:1.0 xup_inv_0
set_property name cs0_n [get_bd_cells xup_inv_0]
connect_bd_net [get_bd_pins cs0/Dout] [get_bd_pins cs0_n/a]
connect_bd_net [get_bd_pins cs1/Dout] [get_bd_pins cs1_n/a]
### Create NS1 sub-circuit
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_1
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or2:1.0 xup_or2_0
connect_bd_net [get_bd_pins xup_and2_0/y] [get_bd_pins xup_or2_0/a]
connect_bd_net [get_bd_pins xup_and2_1/y] [get_bd_pins xup_or2_0/b]
connect_bd_net -net [get_bd_nets cs1_Dout] [get_bd_pins xup_and2_0/a] [get_bd_pins cs1/Dout]
connect_bd_net [get_bd_pins xup_and2_0/b] [get_bd_pins ain_n/y]
connect_bd_net -net [get_bd_nets cs0_Dout] [get_bd_pins xup_and2_1/a] [get_bd_pins cs0/Dout]
connect_bd_net -net [get_bd_nets ain_1] [get_bd_ports ain] [get_bd_pins xup_and2_1/b]
group_bd_cells NS1 [get_bd_cells xup_or2_0] [get_bd_cells xup_and2_1] [get_bd_cells xup_and2_0]
### Create NS0 sub-circuit
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and3:1.0 xup_and3_0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or2:1.0 xup_or2_0
connect_bd_net [get_bd_pins xup_and2_0/y] [get_bd_pins xup_or2_0/a]
connect_bd_net [get_bd_pins xup_and3_0/y] [get_bd_pins xup_or2_0/b]
connect_bd_net -net [get_bd_nets cs0_Dout] [get_bd_pins xup_and2_0/a] [get_bd_pins cs0/Dout]
connect_bd_net -net [get_bd_nets ain_n_y] [get_bd_pins xup_and2_0/b] [get_bd_pins ain_n/y]
connect_bd_net [get_bd_pins cs0_n/y] [get_bd_pins xup_and3_0/a]
connect_bd_net [get_bd_pins cs1_n/y] [get_bd_pins xup_and3_0/b]
connect_bd_net -net [get_bd_nets ain_1] [get_bd_ports ain] [get_bd_pins xup_and3_0/c]
group_bd_cells NS0 [get_bd_cells xup_or2_0] [get_bd_cells xup_and3_0] [get_bd_cells xup_and2_0]
### Form NS bus and connect to the state variables input
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property name NS [get_bd_cells xlconcat_0]
connect_bd_net [get_bd_pins NS/dout] [get_bd_pins CS/d]
connect_bd_net [get_bd_pins NS0/xup_or2_0/y] [get_bd_pins NS/In0]
connect_bd_net [get_bd_pins NS1/xup_or2_0/y] [get_bd_pins NS/In1]
### Form output logic and connect to detected port
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_nor2:1.0 xup_nor2_0
connect_bd_net -net [get_bd_nets cs1_Dout] [get_bd_pins xup_nor2_0/a] [get_bd_pins cs1/Dout]
connect_bd_net -net [get_bd_nets cs0_Dout] [get_bd_pins xup_nor2_0/b] [get_bd_pins cs0/Dout]
connect_bd_net [get_bd_ports detected] [get_bd_pins xup_nor2_0/y]
group_bd_cells output_logic [get_bd_cells xup_nor2_0] 
# Regerate the layout and save it
regenerate_bd_layout
save_bd_design
# Create top HDL wrapper
make_wrapper -files [get_files $project_directory/$project_name/$project_name.srcs/sources_1/bd/$project_name/$project_name.bd] -top
add_files -norecurse $project_directory/$project_name/$project_name.srcs/sources_1/bd/$project_name/hdl/$project_name\_wrapper.v
# Add pin constraints
add_files -fileset constrs_1 -norecurse $constraints_directory/$constraints_file
# Add test bench
add_files -fileset sim_1 -norecurse $project_directory/$testbench
set_property -name {xsim.simulate.runtime} -value {500 ns} -objects [current_fileset -simset]
# run simulation with some sample test vectors
proc run_sim {} {
#check if simulation is already open
set sim_value [current_sim]
if {$sim_value != "" } {
puts "Close existing Simulation"
close_sim -force
}
set_property -name {xsim.simulate.xsim.more_options} -value {-view ../../../../sequence_detector_moore_tb_behav.wcfg} -objects [current_fileset -simset]
set_property -name {xsim.simulate.runtime} -value {0 ns} -objects [current_fileset -simset]
launch_simulation
puts "Running Simulation for 1000 ns"
run 1000 ns
puts "Simulation complete"
}

