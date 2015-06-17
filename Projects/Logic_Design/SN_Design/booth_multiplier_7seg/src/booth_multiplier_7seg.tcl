# Script to create an 8-bit x 8-bit Booth multiplier using XUP_LIB components. 
# Set XUP_LIB path below before running
#
# Vivado 2014.4
# Basys 3 board
# 16 June 2015
# Notes: Set the path below to the XUP_LIB, and run source booth_multiplier_7seg.tcl to create the design
# It is assumed the pin constraints xdc file (booth_multiplier_7seg_basys3_pins.xdc) is in the project directory. 
# If the constraints file is located somewhere else, modify the constraints_directory path below
#
# After sourcing this script, run_sim can be executed to drive simulation from proc at bottom of this file
# Once simulation is running (either from the GUI, or from this script) test_pattern can be executed to drive 
# simulation input values defined at the bottom of this file
#
# The 8-bit multiplcand is input through sw7-sw0 and the 8-bit multiplier is input through sw15-sw8.
# The multiplcation process starts by pressing BtnC
# The multiplication result (unsigned) is output on the 7-segment modules
# The sign of the result is output on LED15
#  
# -------------------------------------------------------------- #
# SET 'basys3_github' PATH TO GITHUB LIBRARY BEFORE RUNNING
# -------------------------------------------------------------- #
set basys3_github {C:/xup/IPI_LIB/XUP_LIB}

set project_directory .
set project_name booth_multiplier_7seg
set constraints_directory $project_directory
set constraints_file booth_multiplier_7seg_basys3_pins.xdc
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
# Add a multiplicand
# Add an accumulator
# Add multiplier
# Create Q0
# Add Q_1
# Form Q0_Q_1
# Create_compare_lt_2
# Add Adder/Subtractor
# Shifter input either from Add/Sub or straight from Accumulator
# Form AQ
# Add AQ_shifter
# Form Q and A slices and connect them as input to the accumulator and multiplier
# Latch output results
# Concat output results
# Add 7-segment result display

# create a control unit
create_bd_port -dir I -type clk sys_clock
set_property CONFIG.FREQ_HZ 100000000 [get_bd_ports sys_clock]
create_bd_port -dir I -from 7 -to 0 -type data multiplicand_in
create_bd_port -dir I -from 7 -to 0 -type data multiplier_in
create_bd_port -dir I -type data start
# create_bd_port -dir O -from 15 -to 0 result
create_bd_cell -type ip -vlnv xilinx.com:XUP:counters:1.0 counters_0
set_property name mul_ctr [get_bd_cells counters_0]
set_property -dict [list CONFIG.COUNT_SIZE {4}] [get_bd_cells mul_ctr]
connect_bd_net [get_bd_ports sys_clock] [get_bd_pins mul_ctr/clk]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property name logic_1 [get_bd_cells xlconstant_0]
connect_bd_net [get_bd_pins logic_1/dout] [get_bd_pins mul_ctr/up_dn]
connect_bd_net [get_bd_ports start] [get_bd_pins mul_ctr/clr]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_range_comparator:1.0 xup_range_comparator_0
set_property name count_lt_8 [get_bd_cells xup_range_comparator_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property name logic_0 [get_bd_cells xlconstant_0]
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells logic_0]
connect_bd_net [get_bd_pins logic_0/dout] [get_bd_pins count_lt_8/sign]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property name const_7 [get_bd_cells xlconstant_0]
set_property -dict [list CONFIG.CONST_WIDTH {4} CONFIG.CONST_VAL {7}] [get_bd_cells const_7]
connect_bd_net [get_bd_pins const_7/dout] [get_bd_pins count_lt_8/in2]
connect_bd_net [get_bd_pins count_lt_8/in1] [get_bd_pins mul_ctr/bin_count]
connect_bd_net [get_bd_pins count_lt_8/le] [get_bd_pins mul_ctr/enable]
group_bd_cells control_unit [get_bd_cells const_7] [get_bd_cells count_lt_8] [get_bd_cells mul_ctr]
# Add multiplicand
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff_en_vector:1.0 xup_dff_en_vector_0
set_property name multiplicand [get_bd_cells  xup_dff_en_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells multiplicand ]
connect_bd_net [get_bd_ports multiplicand_in] [get_bd_pins multiplicand/d]
connect_bd_net -net [get_bd_nets start_1] [get_bd_ports start] [get_bd_pins multiplicand/en]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins multiplicand/clk]
# Add an accumulator
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff_en_reset_vector:1.0 xup_dff_en_reset_vector_0
set_property name accumulator [get_bd_cells xup_dff_en_reset_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells accumulator]
connect_bd_net -net [get_bd_nets start_1] [get_bd_ports start] [get_bd_pins accumulator/reset]
connect_bd_net [get_bd_pins accumulator/en] [get_bd_pins control_unit/count_lt_8/le]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins accumulator/clk]
# Add multiplier
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff_en_vector:1.0 xup_dff_en_vector_0
set_property name multiplier [get_bd_cells xup_dff_en_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells multiplier]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins multiplier/clk]
connect_bd_net -net [get_bd_nets control_unit_le] [get_bd_pins multiplier/en] [get_bd_pins control_unit/le]
# Create Q0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
set_property name Q0 [get_bd_cells xlslice_0]
set_property -dict [list CONFIG.DIN_WIDTH {8}] [get_bd_cells Q0]
connect_bd_net [get_bd_pins multiplier/q] [get_bd_pins Q0/Din]
# Add Q_1
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff_en_reset:1.0 xup_dff_en_reset_0
set_property name Q_1 [get_bd_cells xup_dff_en_reset_0]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins Q_1/clk]
connect_bd_net -net [get_bd_nets start_1] [get_bd_ports start] [get_bd_pins Q_1/reset]
connect_bd_net -net [get_bd_nets control_unit_le] [get_bd_pins Q_1/en] [get_bd_pins control_unit/le]
connect_bd_net [get_bd_pins Q0/Dout] [get_bd_pins Q_1/d]
# Form Q0_Q_1
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property name Q0_Q_1 [get_bd_cells xlconcat_0]
connect_bd_net [get_bd_pins Q0_Q_1/In0] [get_bd_pins Q_1/q]
connect_bd_net -net [get_bd_nets Q0_Dout] [get_bd_pins Q0_Q_1/In1] [get_bd_pins Q0/Dout]
# Create_compare_lt_2
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_range_comparator:1.0 xup_range_comparator_0
set_property name comp_lt_2 [get_bd_cells xup_range_comparator_0]
set_property -dict [list CONFIG.SIZE {2}] [get_bd_cells comp_lt_2]
connect_bd_net [get_bd_pins Q0_Q_1/dout] [get_bd_pins comp_lt_2/in1]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property name const_2 [get_bd_cells xlconstant_0]
set_property -dict [list CONFIG.CONST_WIDTH {2} CONFIG.CONST_VAL {2}] [get_bd_cells const_2]
connect_bd_net [get_bd_pins const_2/dout] [get_bd_pins comp_lt_2/in2]
connect_bd_net -net [get_bd_nets logic_0_dout] [get_bd_pins comp_lt_2/sign] [get_bd_pins logic_0/dout]
# Add Adder/Subtractor
create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0
set_property name addsub [get_bd_cells c_addsub_0]
set_property -dict [list CONFIG.B_Width.VALUE_SRC USER CONFIG.A_Width.VALUE_SRC USER] [get_bd_cells addsub]
set_property -dict [list CONFIG.A_Width {8} CONFIG.B_Width {8} CONFIG.Add_Mode {Add_Subtract} CONFIG.Latency {0} CONFIG.Out_Width {8} CONFIG.B_Value {00000000} CONFIG.CE {false}] [get_bd_cells addsub]
connect_bd_net [get_bd_pins accumulator/q] [get_bd_pins addsub/A]
connect_bd_net [get_bd_pins multiplicand/q] [get_bd_pins addsub/B]
connect_bd_net [get_bd_pins comp_lt_2/lt] [get_bd_pins addsub/ADD]
# Add Q0_Eq_Q_1 circuit
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_xor2:1.0 xup_xor2_0
set_property name Q0_Eq_Q_1 [get_bd_cells xup_xor2_0]
connect_bd_net -net [get_bd_nets Q0_Dout] [get_bd_pins Q0_Eq_Q_1/a] [get_bd_pins Q0/Dout]
connect_bd_net -net [get_bd_nets Q_1_q] [get_bd_pins Q0_Eq_Q_1/b] [get_bd_pins Q_1/q]
# Shifter input either from Add/Sub or straight from Accumulator
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_2_to_1_mux_vector:1.0 xup_2_to_1_mux_vector_0
set_property name shifter_in_sel [get_bd_cells xup_2_to_1_mux_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells shifter_in_sel]
connect_bd_net -net [get_bd_nets accumulator_q] [get_bd_pins shifter_in_sel/a] [get_bd_pins accumulator/q]
connect_bd_net [get_bd_pins shifter_in_sel/b] [get_bd_pins addsub/S]
connect_bd_net [get_bd_pins Q0_Eq_Q_1/y] [get_bd_pins shifter_in_sel/sel]
# Form AQ
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property name AQ [get_bd_cells xlconcat_0]
connect_bd_net -net [get_bd_nets multiplier_q] [get_bd_pins AQ/In0] [get_bd_pins multiplier/q]
connect_bd_net [get_bd_pins AQ/In1] [get_bd_pins shifter_in_sel/y]
# Add AQ shifter
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_shift_nbit:1.0 xup_shift_nbit_0
set_property name AQ_shifter [get_bd_cells xup_shift_nbit_0]
set_property -dict [list CONFIG.SIZE {16} CONFIG.DIR {true} CONFIG.TYPE {true}] [get_bd_cells AQ_shifter]
connect_bd_net [get_bd_pins AQ/dout] [get_bd_pins AQ_shifter/parallel_in]
connect_bd_net -net [get_bd_nets logic_0_dout] [get_bd_pins AQ_shifter/dir] [get_bd_pins logic_0/dout]
connect_bd_net -net [get_bd_nets logic_1_dout] [get_bd_pins AQ_shifter/shift_type] [get_bd_pins logic_1/dout]
# Form Q and A slices and connect them as input to the accumulator and multiplier
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
set_property name ASR_AQ_Slice_Q [get_bd_cells xlslice_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
set_property name ASR_AQ_Slice_A [get_bd_cells xlslice_0]
set_property -dict [list CONFIG.DIN_WIDTH {16} CONFIG.DIN_FROM {7} CONFIG.DOUT_WIDTH {8}] [get_bd_cells ASR_AQ_Slice_Q]
set_property -dict [list CONFIG.DIN_WIDTH {16} CONFIG.DIN_TO {8} CONFIG.DIN_FROM {15} CONFIG.DOUT_WIDTH {8}] [get_bd_cells ASR_AQ_Slice_A]
connect_bd_net [get_bd_pins AQ_shifter/parallel_out] [get_bd_pins ASR_AQ_Slice_Q/Din]
connect_bd_net -net [get_bd_nets AQ_shifter_parallel_out] [get_bd_pins ASR_AQ_Slice_A/Din] [get_bd_pins AQ_shifter/parallel_out]
connect_bd_net [get_bd_pins ASR_AQ_Slice_A/Dout] [get_bd_pins accumulator/d]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_2_to_1_mux_vector:1.0 xup_2_to_1_mux_vector_0
set_property name multiplier_input [get_bd_cells xup_2_to_1_mux_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells multiplier_input]
connect_bd_net -net [get_bd_nets start_1] [get_bd_ports start] [get_bd_pins multiplier_input/sel]
connect_bd_net [get_bd_ports multiplier_in] [get_bd_pins multiplier_input/b]
connect_bd_net [get_bd_pins multiplier_input/a] [get_bd_pins ASR_AQ_Slice_Q/Dout]
connect_bd_net [get_bd_pins multiplier_input/y] [get_bd_pins multiplier/d]
# Latch output results
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff_en_reset_vector:1.0 xup_dff_en_reset_vector_0
set_property name result_h [get_bd_cells xup_dff_en_reset_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells result_h]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff_en_reset_vector:1.0 xup_dff_en_reset_vector_0
set_property name result_l [get_bd_cells xup_dff_en_reset_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells result_l]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins result_l/clk]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins result_h/clk]
connect_bd_net [get_bd_pins control_unit/count_lt_8/eq] [get_bd_pins result_l/en]
connect_bd_net -net [get_bd_nets control_unit_eq] [get_bd_pins result_h/en] [get_bd_pins control_unit/eq]
connect_bd_net -net [get_bd_nets start_1] [get_bd_ports start] [get_bd_pins result_l/reset]
connect_bd_net -net [get_bd_nets start_1] [get_bd_ports start] [get_bd_pins result_h/reset]
connect_bd_net -net [get_bd_nets ASR_AQ_Slice_A_Dout] [get_bd_pins result_h/d] [get_bd_pins ASR_AQ_Slice_A/Dout]
connect_bd_net -net [get_bd_nets ASR_AQ_Slice_Q_Dout] [get_bd_pins result_l/d] [get_bd_pins ASR_AQ_Slice_Q/Dout]
# Concat output results
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property name results [get_bd_cells xlconcat_0]
connect_bd_net [get_bd_pins result_l/q] [get_bd_pins results/In0]
connect_bd_net [get_bd_pins result_h/q] [get_bd_pins results/In1]
# Add 7-segment result display
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
set_property name result_sign [get_bd_cells xlslice_0]
set_property -dict [list CONFIG.DIN_WIDTH {8} CONFIG.DIN_TO {7} CONFIG.DIN_FROM {7} CONFIG.DOUT_WIDTH {1}] [get_bd_cells result_sign]
connect_bd_net -net [get_bd_nets result_h_q] [get_bd_pins result_sign/Din] [get_bd_pins result_h/q]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
set_property name mul_result [get_bd_cells xlslice_0]
set_property -dict [list CONFIG.DIN_WIDTH {16} CONFIG.DIN_FROM {13} CONFIG.DOUT_WIDTH {14}] [get_bd_cells mul_result]
create_bd_cell -type ip -vlnv xilinx.com:XUP:bin2bcd:1.0 bin2bcd_0
set_property -dict [list CONFIG.SIZE {14}] [get_bd_cells bin2bcd_0]
connect_bd_net [get_bd_pins results/dout] [get_bd_pins mul_result/Din]
create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_1
set_property name unsigned_result [get_bd_cells c_addsub_1]
set_property -dict [list CONFIG.B_Width.VALUE_SRC USER CONFIG.A_Width.VALUE_SRC USER] [get_bd_cells unsigned_result]
set_property -dict [list CONFIG.A_Width {14} CONFIG.B_Width {14} CONFIG.Add_Mode {Add_Subtract} CONFIG.Latency {0} CONFIG.Out_Width {14} CONFIG.B_Value {00000000000000} CONFIG.CE {false}] [get_bd_cells unsigned_result]
connect_bd_net [get_bd_pins unsigned_result/S] [get_bd_pins bin2bcd_0/a_in]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_inv:1.0 xup_inv_0
connect_bd_net [get_bd_pins result_sign/Dout] [get_bd_pins xup_inv_0/a]
connect_bd_net [get_bd_pins xup_inv_0/y] [get_bd_pins unsigned_result/ADD]
connect_bd_net [get_bd_pins mul_result/Dout] [get_bd_pins unsigned_result/B]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property name cons_14bit_0 [get_bd_cells xlconstant_0]
set_property -dict [list CONFIG.CONST_WIDTH {14} CONFIG.CONST_VAL {0}] [get_bd_cells cons_14bit_0]
connect_bd_net [get_bd_pins cons_14bit_0/dout] [get_bd_pins unsigned_result/A]
create_bd_cell -type ip -vlnv xilinx.com:XUP:seg7display:1.0 seg7display_0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property -dict [list CONFIG.NUM_PORTS {4}] [get_bd_cells xlconcat_0]
connect_bd_net [get_bd_pins bin2bcd_0/ones] [get_bd_pins xlconcat_0/In0]
connect_bd_net [get_bd_pins bin2bcd_0/tens] [get_bd_pins xlconcat_0/In1]
connect_bd_net [get_bd_pins bin2bcd_0/hundreds] [get_bd_pins xlconcat_0/In2]
connect_bd_net [get_bd_pins bin2bcd_0/thousands] [get_bd_pins xlconcat_0/In3]
connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins seg7display_0/x_l]
create_bd_port -dir O -from 6 -to 0 a_to_g
connect_bd_net [get_bd_pins /seg7display_0/a_to_g] [get_bd_ports a_to_g]
set_property name seg [get_bd_ports a_to_g]
set_property -dict [list CONFIG.DP_0 {0} CONFIG.DP_1 {0} CONFIG.DP_2 {0} CONFIG.DP_3 {0}] [get_bd_cells seg7display_0]
create_bd_port -dir O -from 3 -to 0 an_l
connect_bd_net [get_bd_pins /seg7display_0/an_l] [get_bd_ports an_l]
set_property name an [get_bd_ports an_l]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins seg7display_0/clk]
connect_bd_net -net [get_bd_nets start_1] [get_bd_ports start] [get_bd_pins seg7display_0/reset]
create_bd_port -dir O sign
connect_bd_net -net [get_bd_nets result_sign_Dout] [get_bd_ports sign] [get_bd_pins result_sign/Dout]
# Regerate the layout and save it
regenerate_bd_layout
save_bd_design
# Create top HDL wrapper
make_wrapper -files [get_files $project_directory/$project_name/$project_name.srcs/sources_1/bd/$project_name/$project_name.bd] -top
add_files -norecurse $project_directory/$project_name/$project_name.srcs/sources_1/bd/$project_name/hdl/$project_name\_wrapper.v
# Add pin constraints
add_files -fileset constrs_1 -norecurse $constraints_directory/$constraints_file

