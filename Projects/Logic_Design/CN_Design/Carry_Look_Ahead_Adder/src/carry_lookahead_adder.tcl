# Script to create 8-bit carry lookahead carry adder from XUP_LIB components. Set XUP_LIB path below before running
#
# The 8 bit adder is built from two 4-bit carry lookahead adders. 
# The 4-bit carry lookahead adder is built from four partial full adders and the carry lookahead unit (4-bit).  
# The hierarchy of the design can be explored by opening or expanding the hierarchical blocks  
#
# Vivado 2014.4
# Basys 3 board
# 1 May 2015
# CMC
# Notes: Set the path below to the XUP_LIB, and run source carry_lookahead_adder.tcl to create the design
# It is assumed the pin constraints xdc file (carry_lookahead_adder_basys3_pins.xdc) is in the project directory. 
# If the constraints file is located somewhere else, modify the constraints_directory path below
#
# After sourcing this script, run_sim can be executed to drive simulation from proc at bottom of this file
# Once simulation is running (either from the GUI, or from this script) test_pattern can be executed to drive 
# simulation input values defined a the bottom of this file
#
# Two 8-bit inputs (operands), a and b, are connected to the dip switches (a sw0-7, b sw 8-15)
# The 8-bit output (s) is connected to LEDs 0-7 
# carry in is connected to the centre pushbutton
# carry out is connected to LED 15
# -------------------------------------------------------------- #
# SET 'basys3_github' PATH TO GITHUB LIBRARY BEFORE RUNNING
# -------------------------------------------------------------- #
set basys3_github {C:/xup/IPI_LIB/XUP_LIB}

set project_directory .
set project_name carry_lookahead_adder
set constraints_directory $project_directory
set constraints_file carry_lookahead_adder_basys3_pins.xdc
set testbench carry_lookahead_adder_tb.v
# Create project for Basys 3
create_project -force $project_name ./$project_name -part xc7a35tcpg236-1
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property target_language verilog [current_project]
set_property simulator_language Verilog [current_project]
set_property ip_repo_paths  $basys3_github [current_project]
update_ip_catalog
create_bd_design "$project_name"

# Steps:
# Build Partial adder
# Copy and paste 3 times to generate 4 partial adders in total
# create carry lookahead adder logic (cla)
# Connect to cla to make 4-bit carry ripple adders
# Copy and paste 4-bit adder to make 8-bit adder

# Create Full adder
# add 1st XOR gate for a and b
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_xor2:1.0 xor_ab
# add 2nd XOR gate for s
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_xor2:1.0 xor_s
# add AND gate for Propogate
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or2:1.0 or_propogate
# add AND gate for Generate
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 and_generate

#create partial_full_adder hierarchical block
group_bd_cells partial_full_adder [get_bd_cells xor_ab]  [get_bd_cells xor_s] [get_bd_cells or_propogate] [get_bd_cells and_generate]
# create partial full adder pins
create_bd_pin -dir I partial_full_adder/a
create_bd_pin -dir I partial_full_adder/b
create_bd_pin -dir I partial_full_adder/c_in
create_bd_pin -dir O partial_full_adder/s
create_bd_pin -dir O partial_full_adder/p
create_bd_pin -dir O partial_full_adder/g
# connect partial adder nets
connect_bd_net [get_bd_pins partial_full_adder/a] [get_bd_pins partial_full_adder/xor_ab/a]
connect_bd_net [get_bd_pins partial_full_adder/b] [get_bd_pins partial_full_adder/xor_ab/b]
connect_bd_net [get_bd_pins partial_full_adder/xor_ab/y] [get_bd_pins partial_full_adder/xor_s/a]
connect_bd_net [get_bd_pins partial_full_adder/c_in] [get_bd_pins partial_full_adder/xor_s/b]
connect_bd_net [get_bd_pins partial_full_adder/xor_s/y] [get_bd_pins partial_full_adder/s]

connect_bd_net [get_bd_pins partial_full_adder/a] [get_bd_pins partial_full_adder/or_propogate/a]
connect_bd_net [get_bd_pins partial_full_adder/b] [get_bd_pins partial_full_adder/or_propogate/b]
connect_bd_net [get_bd_pins partial_full_adder/or_propogate/y] [get_bd_pins partial_full_adder/p]

connect_bd_net [get_bd_pins partial_full_adder/a] [get_bd_pins partial_full_adder/and_generate/a]
connect_bd_net [get_bd_pins partial_full_adder/b] [get_bd_pins partial_full_adder/and_generate/b]
connect_bd_net [get_bd_pins partial_full_adder/and_generate/y] [get_bd_pins partial_full_adder/g]

# Copy and paste partial full adder
copy_bd_objs /  [get_bd_cells {partial_full_adder}]
copy_bd_objs /  [get_bd_cells {partial_full_adder}]
copy_bd_objs /  [get_bd_cells {partial_full_adder}]

# --------------------------------------------------------------------------------#
# Create carry look ahead logic
create_bd_cell -type hier cla_logic 
# create cla pins
create_bd_pin -dir I cla_logic/c0

create_bd_pin -dir I cla_logic/p0
create_bd_pin -dir I cla_logic/g0
create_bd_pin -dir I cla_logic/p1
create_bd_pin -dir I cla_logic/g1
create_bd_pin -dir I cla_logic/p2
create_bd_pin -dir I cla_logic/g2
create_bd_pin -dir I cla_logic/p3
create_bd_pin -dir I cla_logic/g3

create_bd_pin -dir O cla_logic/c1
create_bd_pin -dir O cla_logic/c2
create_bd_pin -dir O cla_logic/c3
create_bd_pin -dir O cla_logic/c4

# create logic for c1
# c1 = g0 +p0c0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or2:1.0 cla_logic/c1_or
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 cla_logic/c1_and
# connect
connect_bd_net [get_bd_pins cla_logic/c0] [get_bd_pins cla_logic/c1_and/a]
connect_bd_net [get_bd_pins cla_logic/p0] [get_bd_pins cla_logic/c1_and/b]

connect_bd_net [get_bd_pins cla_logic/c1_and/y] [get_bd_pins cla_logic/c1_or/a]
connect_bd_net [get_bd_pins cla_logic/g0] [get_bd_pins cla_logic/c1_or/b]
#connect_bd_net [get_bd_pins cla_logic/c1_and/y] [get_bd_pins cla_logic/c1_or/a]
connect_bd_net [get_bd_pins cla_logic/c1_or/y] [get_bd_pins cla_logic/c1]

# c2 = g1 + p1g0 + p1p0c0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 cla_logic/p1g0_and
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and3:1.0 cla_logic/p1p0c0_and
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or3:1.0 cla_logic/c2_or
#connect
connect_bd_net [get_bd_pins cla_logic/p1] [get_bd_pins cla_logic/p1g0_and/a]
connect_bd_net [get_bd_pins cla_logic/g0] [get_bd_pins cla_logic/p1g0_and/b]

connect_bd_net [get_bd_pins cla_logic/p1] [get_bd_pins cla_logic/p1p0c0_and/a]
connect_bd_net [get_bd_pins cla_logic/p0] [get_bd_pins cla_logic/p1p0c0_and/b]
connect_bd_net [get_bd_pins cla_logic/c0] [get_bd_pins cla_logic/p1p0c0_and/c]

connect_bd_net [get_bd_pins cla_logic/g1] [get_bd_pins cla_logic/c2_or/a]
connect_bd_net [get_bd_pins cla_logic/p1g0_and/y] [get_bd_pins cla_logic/c2_or/b]
connect_bd_net [get_bd_pins cla_logic/p1p0c0_and/y] [get_bd_pins cla_logic/c2_or/c]

connect_bd_net [get_bd_pins cla_logic/c2_or/y] [get_bd_pins cla_logic/c2]

#c3 = g2 + p2g1 + p2p1g0 + p2p1p0c0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 cla_logic/p2g1 
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and3:1.0 cla_logic/p2p1g0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and4:1.0 cla_logic/p2p1p0c0

create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or4:1.0 cla_logic/c3_or
# connect
connect_bd_net [get_bd_pins cla_logic/p2] [get_bd_pins cla_logic/p2g1/a]
connect_bd_net [get_bd_pins cla_logic/g1] [get_bd_pins cla_logic/p2g1/b]

connect_bd_net [get_bd_pins cla_logic/p2] [get_bd_pins cla_logic/p2p1g0/a]
connect_bd_net [get_bd_pins cla_logic/p1] [get_bd_pins cla_logic/p2p1g0/b]
connect_bd_net [get_bd_pins cla_logic/g0] [get_bd_pins cla_logic/p2p1g0/c]

connect_bd_net [get_bd_pins cla_logic/p2] [get_bd_pins cla_logic/p2p1p0c0/a]
connect_bd_net [get_bd_pins cla_logic/p1] [get_bd_pins cla_logic/p2p1p0c0/b]
connect_bd_net [get_bd_pins cla_logic/p0] [get_bd_pins cla_logic/p2p1p0c0/c]
connect_bd_net [get_bd_pins cla_logic/c0] [get_bd_pins cla_logic/p2p1p0c0/d]

connect_bd_net [get_bd_pins cla_logic/g2] [get_bd_pins cla_logic/c3_or/a]
connect_bd_net [get_bd_pins cla_logic/p2g1/y] [get_bd_pins cla_logic/c3_or/b]
connect_bd_net [get_bd_pins cla_logic/p2p1g0/y] [get_bd_pins cla_logic/c3_or/c]
connect_bd_net [get_bd_pins cla_logic/p2p1p0c0/y] [get_bd_pins cla_logic/c3_or/d]

connect_bd_net [get_bd_pins cla_logic/c3_or/y] [get_bd_pins cla_logic/c3]      
      
#c4 = g3 + p3g2 + p3p2g1 + p3p2p1g0 + p3p2p1p0c0
# create gates
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 cla_logic/p3g2 
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and3:1.0 cla_logic/p3p2g1
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and4:1.0 cla_logic/p3p2p1g0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and5:1.0 cla_logic/p3p2p1p0c0

create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or5:1.0 cla_logic/c4_or
# connect
connect_bd_net [get_bd_pins cla_logic/p3] [get_bd_pins cla_logic/p3g2/a]
connect_bd_net [get_bd_pins cla_logic/g2] [get_bd_pins cla_logic/p3g2/b]

connect_bd_net [get_bd_pins cla_logic/p3] [get_bd_pins cla_logic/p3p2g1/a]
connect_bd_net [get_bd_pins cla_logic/p2] [get_bd_pins cla_logic/p3p2g1/b]
connect_bd_net [get_bd_pins cla_logic/g1] [get_bd_pins cla_logic/p3p2g1/c]

connect_bd_net [get_bd_pins cla_logic/p3] [get_bd_pins cla_logic/p3p2p1g0/a]
connect_bd_net [get_bd_pins cla_logic/p2] [get_bd_pins cla_logic/p3p2p1g0/b]
connect_bd_net [get_bd_pins cla_logic/p1] [get_bd_pins cla_logic/p3p2p1g0/c]
connect_bd_net [get_bd_pins cla_logic/g0] [get_bd_pins cla_logic/p3p2p1g0/d]

connect_bd_net [get_bd_pins cla_logic/p3] [get_bd_pins cla_logic/p3p2p1p0c0/a]
connect_bd_net [get_bd_pins cla_logic/p2] [get_bd_pins cla_logic/p3p2p1p0c0/b]
connect_bd_net [get_bd_pins cla_logic/p1] [get_bd_pins cla_logic/p3p2p1p0c0/c]
connect_bd_net [get_bd_pins cla_logic/p0] [get_bd_pins cla_logic/p3p2p1p0c0/d]
connect_bd_net [get_bd_pins cla_logic/c0] [get_bd_pins cla_logic/p3p2p1p0c0/e]

connect_bd_net [get_bd_pins cla_logic/g3] [get_bd_pins cla_logic/c4_or/a]
connect_bd_net [get_bd_pins cla_logic/p3g2/y] [get_bd_pins cla_logic/c4_or/b]
connect_bd_net [get_bd_pins cla_logic/p3p2g1/y] [get_bd_pins cla_logic/c4_or/c]
connect_bd_net [get_bd_pins cla_logic/p3p2p1g0/y] [get_bd_pins cla_logic/c4_or/d]
connect_bd_net [get_bd_pins cla_logic/p3p2p1p0c0/y] [get_bd_pins cla_logic/c4_or/e]

connect_bd_net [get_bd_pins cla_logic/c4_or/y] [get_bd_pins cla_logic/c4]

# connect partial adders and CLA logic
connect_bd_net [get_bd_pins partial_full_adder/p] [get_bd_pins cla_logic/p0]
connect_bd_net [get_bd_pins partial_full_adder1/p] [get_bd_pins cla_logic/p1]
connect_bd_net [get_bd_pins partial_full_adder2/p] [get_bd_pins cla_logic/p2]
connect_bd_net [get_bd_pins partial_full_adder3/p] [get_bd_pins cla_logic/p3]
connect_bd_net [get_bd_pins partial_full_adder/g] [get_bd_pins cla_logic/g0]
connect_bd_net [get_bd_pins partial_full_adder1/g] [get_bd_pins cla_logic/g1]
connect_bd_net [get_bd_pins partial_full_adder2/g] [get_bd_pins cla_logic/g2]
connect_bd_net [get_bd_pins partial_full_adder3/g] [get_bd_pins cla_logic/g3]
connect_bd_net [get_bd_pins cla_logic/c1] [get_bd_pins partial_full_adder1/c_in]
connect_bd_net [get_bd_pins cla_logic/c2] [get_bd_pins partial_full_adder2/c_in]
connect_bd_net [get_bd_pins cla_logic/c3] [get_bd_pins partial_full_adder3/c_in]
# CLA block completed
# --------------------------------------------------------------------------------#

#create full_adder hierarchical block
group_bd_cells carry_lookahead_adder_4_bit [get_bd_cells partial_full_adder] [get_bd_cells partial_full_adder1] [get_bd_cells partial_full_adder2] [get_bd_cells partial_full_adder3] [get_bd_cells cla_logic]  
# create full adder pins
create_bd_pin -dir I carry_lookahead_adder_4_bit/a0
create_bd_pin -dir I carry_lookahead_adder_4_bit/a1
create_bd_pin -dir I carry_lookahead_adder_4_bit/a2
create_bd_pin -dir I carry_lookahead_adder_4_bit/a3
create_bd_pin -dir I carry_lookahead_adder_4_bit/b0
create_bd_pin -dir I carry_lookahead_adder_4_bit/b1
create_bd_pin -dir I carry_lookahead_adder_4_bit/b2
create_bd_pin -dir I carry_lookahead_adder_4_bit/b3
create_bd_pin -dir I carry_lookahead_adder_4_bit/c_in
create_bd_pin -dir O carry_lookahead_adder_4_bit/s0
create_bd_pin -dir O carry_lookahead_adder_4_bit/s1
create_bd_pin -dir O carry_lookahead_adder_4_bit/s2
create_bd_pin -dir O carry_lookahead_adder_4_bit/s3
create_bd_pin -dir O carry_lookahead_adder_4_bit/c_out

# connect internal ports to hierarchy pins
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/a0] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder/a]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/a1] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder1/a]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/a2] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder2/a]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/a3] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder3/a]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/b0] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder/b]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/b1] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder1/b]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/b2] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder2/b]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/b3] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder3/b]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/c_in] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder/c_in]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/c_in] [get_bd_pins carry_lookahead_adder_4_bit/cla_logic/c0]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/s0] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder/s]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/s1] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder1/s]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/s2] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder2/s]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/s3] [get_bd_pins carry_lookahead_adder_4_bit/partial_full_adder3/s]
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/c_out] [get_bd_pins carry_lookahead_adder_4_bit/cla_logic/c4]
# copy and paste 4-bit adder
copy_bd_objs /  [get_bd_cells {carry_lookahead_adder_4_bit}]
#connect carrys
connect_bd_net [get_bd_pins carry_lookahead_adder_4_bit/c_out] [get_bd_pins carry_lookahead_adder_4_bit1/c_in] -boundary_type upper
#Create top level i/o ports and connect to 4 bit adders
# a
create_bd_port -dir I a0
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/a0] [get_bd_ports a0]
create_bd_port -dir I a1
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/a1] [get_bd_ports a1]
create_bd_port -dir I a2
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/a2] [get_bd_ports a2]
create_bd_port -dir I a3
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/a3] [get_bd_ports a3]
create_bd_port -dir I a4
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/a0] [get_bd_ports a4]
create_bd_port -dir I a5
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/a1] [get_bd_ports a5]
create_bd_port -dir I a6
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/a2] [get_bd_ports a6]
create_bd_port -dir I a7
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/a3] [get_bd_ports a7]
# b
create_bd_port -dir I b0
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/b0] [get_bd_ports b0]
create_bd_port -dir I b2
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/b2] [get_bd_ports b2]
create_bd_port -dir I b1
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/b1] [get_bd_ports b1]
create_bd_port -dir I b3
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/b3] [get_bd_ports b3]
create_bd_port -dir I b4
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/b0] [get_bd_ports b4]
create_bd_port -dir I b5
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/b1] [get_bd_ports b5]
create_bd_port -dir I b6
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/b2] [get_bd_ports b6]
create_bd_port -dir I b7
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/b3] [get_bd_ports b7]
create_bd_port -dir O s0
# carry in
create_bd_port -dir I c_in
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/c_in] [get_bd_ports c_in]
# outputs
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/s0] [get_bd_ports s0]
create_bd_port -dir O s1
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/s1] [get_bd_ports s1]
create_bd_port -dir O s2
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/s2] [get_bd_ports s2]
create_bd_port -dir O s3
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit/s3] [get_bd_ports s3]
create_bd_port -dir O s4
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/s0] [get_bd_ports s4]
create_bd_port -dir O s5
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/s1] [get_bd_ports s5]
create_bd_port -dir O s6
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/s2] [get_bd_ports s6]
create_bd_port -dir O s7
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/s3] [get_bd_ports s7]
# carry out
create_bd_port -dir O c_out
connect_bd_net [get_bd_pins /carry_lookahead_adder_4_bit1/c_out] [get_bd_ports c_out]

regenerate_bd_layout
save_bd_design

# Create top HDL wrapper
make_wrapper -files [get_files $project_directory/$project_name/$project_name.srcs/sources_1/bd/$project_name/$project_name.bd] -top
add_files -norecurse $project_directory/$project_name/$project_name.srcs/sources_1/bd/$project_name/hdl/$project_name\_wrapper.v
# Add pin constraints
add_files -fileset constrs_1 -norecurse $constraints_directory/$constraints_file
set_property -name {xsim.simulate.runtime} -value {0} -objects [current_fileset -simset]
# Add test bench
add_files -fileset sim_1 -norecurse $project_directory/$testbench
set_property -name {xsim.simulate.runtime} -value {500 ns} -objects [current_fileset -simset]


# run simulation with some sample test vectors
proc run_sim {} {
#check if simulation is already open
set sim_value [current_sim]
if {$sim_value != "" } {
puts "Close existing Simulation"
close_sim
}
set_property -name {xsim.simulate.xsim.more_options} -value {-view ../../../../carry_lookahead_adder_tb_behav.wcfg} -objects [current_fileset -simset]
set_property -name {xsim.simulate.runtime} -value {0 ns} -objects [current_fileset -simset]
launch_simulation


# Set initial input values
add_force {/carry_lookahead_adder_tb/a} -radix hex {0 0ns}
add_force {/carry_lookahead_adder_tb/b} -radix hex {0 0ns}
add_force {/carry_lookahead_adder_tb/c_in} -radix unsigned {0 0ns}

test_pattern

}

# run simulation with some sample test vectors
proc test_pattern {} {

add_force {/carry_lookahead_adder_tb/c_in} -radix unsigned {0 0ns}

add_force {/carry_lookahead_adder_tb/a} -radix hex {0 0ns}
add_force {/carry_lookahead_adder_tb/b} -radix hex {0 0ns}
run 50 ns

add_force {/carry_lookahead_adder_tb/a} -radix hex {0x05 0ns}
add_force {/carry_lookahead_adder_tb/b} -radix hex {0x03 0ns}
run 50 ns

add_force {/carry_lookahead_adder_tb/a} -radix hex {0x02 0ns}
add_force {/carry_lookahead_adder_tb/b} -radix hex {0x07 0ns}
run 50 ns

# set carry in
add_force {/carry_lookahead_adder_tb/a} -radix hex {0x0a 0ns}
add_force {/carry_lookahead_adder_tb/b} -radix hex {0x04 0ns}
add_force {/carry_lookahead_adder_tb/c_in} -radix unsigned {1 0ns}
run 50 ns

add_force {/carry_lookahead_adder_tb/a} -radix hex {0x80 0ns}
add_force {/carry_lookahead_adder_tb/b} -radix hex {0x38 0ns}
run 50 ns

add_force {/carry_lookahead_adder_tb/a} -radix hex {0x8c 0ns}
add_force {/carry_lookahead_adder_tb/b} -radix hex {0x96 0ns}
run 50 ns

add_force {/carry_lookahead_adder_tb/c_in} -radix unsigned {0 0ns}
add_force {/carry_lookahead_adder_tb/a} -radix hex {0xc8 0ns}
add_force {/carry_lookahead_adder_tb/b} -radix hex {0x96 0ns}
run 50 ns

# reset input values
add_force {/carry_lookahead_adder_tb/a} -radix hex {0 0ns}
add_force {/carry_lookahead_adder_tb/b} -radix hex {0 0ns}
add_force {/carry_lookahead_adder_tb/c_in} -radix unsigned {0 0ns}


}

