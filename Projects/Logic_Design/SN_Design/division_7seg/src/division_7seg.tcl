# Script to create an 8-bit by 8-bit non-restoring divider using XUP_LIB components. 
# Set XUP_LIB path below before running
#
# Vivado 2014.4
# Basys 3 board
# 19 June 2015
# Notes: Set the path below to the XUP_LIB, and run source division_7seg.tcl to create the design
# It is assumed the pin constraints xdc file (division_7seg_basys3_pins.xdc) is in the project directory. 
# If the constraints file is located somewhere else, modify the constraints_directory path below
#
#
# The 8-bit dividend is input through sw7-sw0 and the 8-bit divisor is input through sw15-sw8.
# The division process starts by pressing BtnC
# The 8-bit quotient in BCD output is displayed on left two 7-segments whereas the 8-bit remainder in BCD is displayed on the right two 7-segments. The done flag is displayed on the LED15
#  
# -------------------------------------------------------------- #
# SET 'basys3_github' PATH TO GITHUB LIBRARY BEFORE RUNNING
# -------------------------------------------------------------- #
set basys3_github {C:/xup/IPI_LIB/XUP_LIB}

set project_directory .
set project_name division_7seg
set constraints_directory $project_directory
set constraints_file division_7seg_basys3_pins.xdc

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
# Create 7-seg display circuit

# create a control unit
create_bd_port -dir I -type clk sys_clock
set_property CONFIG.FREQ_HZ 100000000 [get_bd_ports sys_clock]
create_bd_port -dir I -from 7 -to 0 -type data divisor_in
create_bd_port -dir I -from 7 -to 0 -type data dividend_in
create_bd_port -dir I -type data start
create_bd_port -dir O -type other done
create_bd_cell -type ip -vlnv xilinx.com:XUP:counters:1.0 counters_0
set_property name div_ctr [get_bd_cells counters_0]
set_property -dict [list CONFIG.COUNT_SIZE {4}] [get_bd_cells div_ctr]
connect_bd_net [get_bd_ports sys_clock] [get_bd_pins div_ctr/clk]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property name logic_1 [get_bd_cells xlconstant_0]
connect_bd_net [get_bd_pins logic_1/dout] [get_bd_pins div_ctr/up_dn]
connect_bd_net [get_bd_ports start] [get_bd_pins div_ctr/clr]
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
connect_bd_net [get_bd_pins count_lt_8/in1] [get_bd_pins div_ctr/bin_count]
connect_bd_net [get_bd_pins count_lt_8/le] [get_bd_pins div_ctr/enable]
group_bd_cells control_unit [get_bd_cells const_7] [get_bd_cells count_lt_8] [get_bd_cells div_ctr]
# Add divisor
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff_en_vector:1.0 xup_dff_en_vector_0
set_property name divisor [get_bd_cells  xup_dff_en_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells divisor ]
connect_bd_net [get_bd_ports divisor_in] [get_bd_pins divisor/d]
connect_bd_net -net [get_bd_nets start_1] [get_bd_ports start] [get_bd_pins divisor/en]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins divisor/clk]
# Add an accumulator
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff_en_reset_vector:1.0 xup_dff_en_reset_vector_0
set_property name accumulator [get_bd_cells xup_dff_en_reset_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells accumulator]
connect_bd_net -net [get_bd_nets start_1] [get_bd_ports start] [get_bd_pins accumulator/reset]
connect_bd_net [get_bd_pins accumulator/en] [get_bd_pins control_unit/count_lt_8/le]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins accumulator/clk]
# Add dividend
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff_en_vector:1.0 xup_dff_en_vector_0
set_property name dividend [get_bd_cells xup_dff_en_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells dividend]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins dividend/clk]
connect_bd_net -net [get_bd_nets control_unit_le] [get_bd_pins dividend/en] [get_bd_pins control_unit/le]
# Form AQ
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property name AQ [get_bd_cells xlconcat_0]
connect_bd_net [get_bd_pins accumulator/q] [get_bd_pins AQ/In1]
connect_bd_net [get_bd_pins dividend/q] [get_bd_pins AQ/In0]
# Add shift_nbit
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_shift_nbit:1.0 xup_shift_nbit_0
set_property name AQ_shift [get_bd_cells xup_shift_nbit_0]
set_property -dict [list  CONFIG.SIZE {16} CONFIG.DIR {true}] [get_bd_cells AQ_shift]
connect_bd_net [get_bd_pins AQ/dout] [get_bd_pins AQ_shift/parallel_in]
connect_bd_net -net [get_bd_nets logic_1_dout] [get_bd_pins AQ_shift/dir] [get_bd_pins logic_1/dout]
# Slice AQ shifter output and connect
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
set_property name AQ_shift_slice_A [get_bd_cells xlslice_0]
set_property -dict [list CONFIG.DIN_WIDTH {16} CONFIG.DIN_TO {8} CONFIG.DIN_FROM {15} CONFIG.DOUT_WIDTH {8}] [get_bd_cells AQ_shift_slice_A]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
set_property name AQ_shift_slice_Q [get_bd_cells xlslice_0]
set_property -dict [list CONFIG.DIN_WIDTH {16} CONFIG.DIN_TO {1} CONFIG.DIN_FROM {7} CONFIG.DOUT_WIDTH {7}] [get_bd_cells AQ_shift_slice_Q]
connect_bd_net [get_bd_pins AQ_shift/parallel_out] [get_bd_pins AQ_shift_slice_Q/Din]
connect_bd_net -net [get_bd_nets AQ_shift_parallel_out] [get_bd_pins AQ_shift_slice_A/Din] [get_bd_pins AQ_shift/parallel_out]
# Create A_Sign
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
set_property name A_sign [get_bd_cells xlslice_0]
set_property -dict [list CONFIG.DIN_WIDTH {8} CONFIG.DIN_TO {7} CONFIG.DIN_FROM {7} CONFIG.DOUT_WIDTH {1}] [get_bd_cells A_sign]
connect_bd_net -net [get_bd_nets accumulator_q] [get_bd_pins A_sign/Din] [get_bd_pins accumulator/q]
# Add Adder/Subtractor
create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0
set_property name addsub [get_bd_cells c_addsub_0]
set_property -dict [list CONFIG.B_Width.VALUE_SRC USER CONFIG.A_Width.VALUE_SRC USER] [get_bd_cells addsub]
set_property -dict [list CONFIG.A_Width {8} CONFIG.B_Width {8} CONFIG.Add_Mode {Add_Subtract} CONFIG.Latency {0} CONFIG.Out_Width {8} CONFIG.B_Value {00000000} CONFIG.CE {false}] [get_bd_cells addsub]
connect_bd_net [get_bd_pins addsub/A] [get_bd_pins AQ_shift_slice_A/Dout]
connect_bd_net [get_bd_pins divisor/q] [get_bd_pins addsub/B]
connect_bd_net [get_bd_pins A_sign/Dout] [get_bd_pins addsub/ADD]
connect_bd_net [get_bd_pins addsub/S] [get_bd_pins accumulator/d]
# Create Addsub_sign
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
set_property name addsub_sign [get_bd_cells xlslice_0]
set_property -dict [list CONFIG.DIN_WIDTH {8} CONFIG.DIN_TO {7} CONFIG.DIN_FROM {7} CONFIG.DOUT_WIDTH {1}] [get_bd_cells addsub_sign]
connect_bd_net -net [get_bd_nets addsub_S] [get_bd_pins addsub_sign/Din] [get_bd_pins addsub/S]
# Create dividend input path
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_inv:1.0 xup_inv_0
connect_bd_net [get_bd_pins addsub_sign/Dout] [get_bd_pins xup_inv_0/a]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property name Q_in [get_bd_cells xlconcat_0]
connect_bd_net [get_bd_pins xup_inv_0/y] [get_bd_pins Q_in/In0]
connect_bd_net [get_bd_pins AQ_shift_slice_Q/Dout] [get_bd_pins Q_in/In1]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_2_to_1_mux_vector:1.0 xup_2_to_1_mux_vector_0
set_property name dividend_data_in [get_bd_cells xup_2_to_1_mux_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells dividend_data_in]
connect_bd_net [get_bd_pins Q_in/dout] [get_bd_pins dividend_data_in/a]
connect_bd_net [get_bd_ports dividend_in] [get_bd_pins dividend_data_in/b]
connect_bd_net -net [get_bd_nets start_1] [get_bd_ports start] [get_bd_pins dividend_data_in/sel]
connect_bd_net [get_bd_pins dividend_data_in/y] [get_bd_pins dividend/d]
# create Quotient_register and connect to Quotient port
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff_en_vector:1.0 xup_dff_en_vector_0
set_property name Quotient_register [get_bd_cells xup_dff_en_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells Quotient_register]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins Quotient_register/clk]
connect_bd_net -net [get_bd_nets dividend_q] [get_bd_pins Quotient_register/d] [get_bd_pins dividend/q]
# Create restore stage and connect the output to Remainder port
create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_1
set_property name restore_stage [get_bd_cells c_addsub_1]
set_property -dict [list CONFIG.B_Width.VALUE_SRC USER CONFIG.A_Width.VALUE_SRC USER] [get_bd_cells restore_stage]
set_property -dict [list CONFIG.A_Width {8} CONFIG.B_Width {8} CONFIG.Add_Mode {Add} CONFIG.Latency {0} CONFIG.Out_Width {8} CONFIG.B_Value {00000000} CONFIG.CE {false}] [get_bd_cells restore_stage]
connect_bd_net -net [get_bd_nets accumulator_q] [get_bd_pins restore_stage/A] [get_bd_pins accumulator/q]
connect_bd_net -net [get_bd_nets divisor_q] [get_bd_pins restore_stage/B] [get_bd_pins divisor/q]
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_2_to_1_mux_vector:1.0 xup_2_to_1_mux_vector_0
set_property name remainder_sel [get_bd_cells xup_2_to_1_mux_vector_0]
set_property -dict [list CONFIG.SIZE {8}] [get_bd_cells remainder_sel]
connect_bd_net -net [get_bd_nets accumulator_q] [get_bd_pins remainder_sel/a] [get_bd_pins accumulator/q]
connect_bd_net [get_bd_pins remainder_sel/b] [get_bd_pins restore_stage/S]
connect_bd_net -net [get_bd_nets A_sign_Dout] [get_bd_pins remainder_sel/sel] [get_bd_pins A_sign/Dout]

# Create done_flag
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_dff_en_reset:1.0 xup_dff_en_reset_0
set_property name done_f [get_bd_cells xup_dff_en_reset_0]
connect_bd_net [get_bd_pins done_f/q] [get_bd_pins Quotient_register/en]
connect_bd_net -net [get_bd_nets done_f_q] [get_bd_ports done] [get_bd_pins done_f/q]
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins done_f/clk]
connect_bd_net -net [get_bd_nets logic_1_dout] [get_bd_pins done_f/d] [get_bd_pins logic_1/dout]
connect_bd_net [get_bd_pins done_f/en] [get_bd_pins control_unit/count_lt_8/eq]
connect_bd_net -net [get_bd_nets start_1] [get_bd_ports start] [get_bd_pins done_f/reset]
# Create 7-seg display circuit
create_bd_cell -type ip -vlnv xilinx.com:XUP:bin2bcd:1.0 bin2bcd_0
set_property name Quotient_bcd [get_bd_cells bin2bcd_0]
create_bd_cell -type ip -vlnv xilinx.com:XUP:bin2bcd:1.0 bin2bcd_0
set_property name Remainder_bcd [get_bd_cells bin2bcd_0]
connect_bd_net [get_bd_pins Quotient_register/q] [get_bd_pins Quotient_bcd/a_in]
connect_bd_net [get_bd_pins remainder_sel/y] [get_bd_pins Remainder_bcd/a_in]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property -dict [list CONFIG.NUM_PORTS {4}] [get_bd_cells xlconcat_0]
connect_bd_net [get_bd_pins Quotient_bcd/ones] [get_bd_pins xlconcat_0/In2]
connect_bd_net [get_bd_pins Quotient_bcd/tens] [get_bd_pins xlconcat_0/In3]
connect_bd_net [get_bd_pins Remainder_bcd/ones] [get_bd_pins xlconcat_0/In0]
connect_bd_net [get_bd_pins Remainder_bcd/tens] [get_bd_pins xlconcat_0/In1]
create_bd_cell -type ip -vlnv xilinx.com:XUP:seg7display:1.0 seg7display_0
connect_bd_net -net [get_bd_nets sys_clock_1] [get_bd_ports sys_clock] [get_bd_pins seg7display_0/clk]
connect_bd_net [get_bd_pins seg7display_0/x_l] [get_bd_pins xlconcat_0/dout]
connect_bd_net -net [get_bd_nets start_1] [get_bd_ports start] [get_bd_pins seg7display_0/reset]
set_property -dict [list CONFIG.DP_0 {0} CONFIG.DP_1 {0} CONFIG.DP_2 {0} CONFIG.DP_3 {0}] [get_bd_cells seg7display_0]
create_bd_port -dir O -from 6 -to 0 a_to_g
connect_bd_net [get_bd_pins /seg7display_0/a_to_g] [get_bd_ports a_to_g]
create_bd_port -dir O -from 3 -to 0 an_l
connect_bd_net [get_bd_pins /seg7display_0/an_l] [get_bd_ports an_l]
set_property name seg [get_bd_ports a_to_g]
set_property name an [get_bd_ports an_l]

# Regerate the layout and save it
regenerate_bd_layout
save_bd_design
# Create top HDL wrapper
make_wrapper -files [get_files $project_directory/$project_name/$project_name.srcs/sources_1/bd/$project_name/$project_name.bd] -top
add_files -norecurse $project_directory/$project_name/$project_name.srcs/sources_1/bd/$project_name/hdl/$project_name\_wrapper.v
# Add pin constraints
add_files -fileset constrs_1 -norecurse $constraints_directory/$constraints_file

