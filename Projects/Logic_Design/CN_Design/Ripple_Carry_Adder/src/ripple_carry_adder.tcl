# Script to create 8-bit ripple carry adder from XUP_LIB components. Set XUP_LIB path below before running
#
# The 8 bit adder is built from two 4-bit carry ripple adders. 
# The 4-bit carry ripple adder is built from four full adders. 
# The full adder is built from two half adders. 
# The hierarchy of the design can be explored by opening or expanding the hierarchical blocks  
#
# Vivado 2014.4
# Basys 3 board
# 1 May 2015
# CMC
# Notes: Set the path below to the XUP_LIB, and run source ripple_carry__adder.tcl to create the design
# It is assumed the pin constraints xdc file (ripple_carry_adder_basys3_pins.xdc) is in the project directory. 
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
set project_name ripple_carry_adder
set constraints_directory $project_directory
set constraints_file ripple_carry_adder_basys3_pins.xdc
set testbench ripple_carry_adder_tb.v
# Create project for Basys 3
create_project -force $project_name ./$project_name -part xc7a35tcpg236-1
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property target_language verilog [current_project]
set_property simulator_language Verilog [current_project]
set_property ip_repo_paths  $basys3_github [current_project]
update_ip_catalog
create_bd_design "$project_name"

# Steps:
# Build Half Adder
# Copy and add OR gate to make full adders
# Copy full adder 4 times to make 4-bit carry ripple adders
# copy 4-bit adder 2 times to make 8-bit adder

# Build Half Adder
# create basic gates
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_xor2:1.0 xor_s
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 and_c
# create HA hierarchical block
group_bd_cells half_adder [get_bd_cells xor_s]  [get_bd_cells and_c]
# create pins on hierarchy block
create_bd_pin -dir I half_adder/a
create_bd_pin -dir I half_adder/b
create_bd_pin -dir O half_adder/s
create_bd_pin -dir O half_adder/c
# connect internal signals to pins
connect_bd_net [get_bd_pins half_adder/a] [get_bd_pins half_adder/and_c/a]
connect_bd_net [get_bd_pins half_adder/b] [get_bd_pins half_adder/and_c/b]
connect_bd_net [get_bd_pins half_adder/a] [get_bd_pins half_adder/xor_s/a]
connect_bd_net [get_bd_pins half_adder/b] [get_bd_pins half_adder/xor_s/b]
connect_bd_net [get_bd_pins half_adder/c] [get_bd_pins half_adder/and_c/y]
connect_bd_net [get_bd_pins half_adder/s] [get_bd_pins half_adder/xor_s/y]

# Create Full adder
# copy half_adder
copy_bd_objs /  [get_bd_cells {half_adder}]
# add OR gate
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or2:1.0 or_carry_out
#create full_adder hierarchical block
group_bd_cells full_adder [get_bd_cells half_adder]  [get_bd_cells half_adder1] [get_bd_cells or_carry_out]
# create full adder pins
create_bd_pin -dir I full_adder/a
create_bd_pin -dir I full_adder/b
create_bd_pin -dir I full_adder/c_in
create_bd_pin -dir O full_adder/s
create_bd_pin -dir O full_adder/c_out
# connect full adder nets
connect_bd_net [get_bd_pins full_adder/a] [get_bd_pins full_adder/half_adder/a]
connect_bd_net [get_bd_pins full_adder/b] [get_bd_pins full_adder/half_adder/b]
connect_bd_net [get_bd_pins full_adder/half_adder/s] [get_bd_pins full_adder/half_adder1/a]
connect_bd_net [get_bd_pins full_adder/c_in] [get_bd_pins full_adder/half_adder1/b]
connect_bd_net [get_bd_pins full_adder/half_adder/c] [get_bd_pins full_adder/or_carry_out/a]
connect_bd_net [get_bd_pins full_adder/half_adder1/c] [get_bd_pins full_adder/or_carry_out/b]
connect_bd_net [get_bd_pins full_adder/or_carry_out/y] [get_bd_pins full_adder/c_out]
connect_bd_net [get_bd_pins full_adder/half_adder1/s] [get_bd_pins full_adder/s]
# Create 4-bit carry ripple adder
# Copy and paste full adder
copy_bd_objs /  [get_bd_cells {full_adder}]
copy_bd_objs /  [get_bd_cells {full_adder}]
copy_bd_objs /  [get_bd_cells {full_adder}]
# Connect carrys
connect_bd_net [get_bd_pins full_adder/c_out] [get_bd_pins full_adder1/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder1/c_out] [get_bd_pins full_adder2/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder2/c_out] [get_bd_pins full_adder3/c_in] -boundary_type upper
# create 4-bit carry ripple adder hierarchical block
group_bd_cells ripple_carry_adder_4_bit [get_bd_cells full_adder]  [get_bd_cells full_adder1] [get_bd_cells full_adder2] [get_bd_cells full_adder3]
# create hierarchical block pins
create_bd_pin -dir I ripple_carry_adder_4_bit/a0
create_bd_pin -dir I ripple_carry_adder_4_bit/a1
create_bd_pin -dir I ripple_carry_adder_4_bit/a2
create_bd_pin -dir I ripple_carry_adder_4_bit/a3
create_bd_pin -dir I ripple_carry_adder_4_bit/b0
create_bd_pin -dir I ripple_carry_adder_4_bit/b1
create_bd_pin -dir I ripple_carry_adder_4_bit/b2
create_bd_pin -dir I ripple_carry_adder_4_bit/b3

create_bd_pin -dir I ripple_carry_adder_4_bit/c_in

create_bd_pin -dir O ripple_carry_adder_4_bit/s0
create_bd_pin -dir O ripple_carry_adder_4_bit/s1
create_bd_pin -dir O ripple_carry_adder_4_bit/s2
create_bd_pin -dir O ripple_carry_adder_4_bit/s3

create_bd_pin -dir O ripple_carry_adder_4_bit/c_out
# connect pins
connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/a0] [get_bd_pins ripple_carry_adder_4_bit/full_adder/a]
connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/a1] [get_bd_pins ripple_carry_adder_4_bit/full_adder1/a]
connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/a2] [get_bd_pins ripple_carry_adder_4_bit/full_adder2/a]
connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/a3] [get_bd_pins ripple_carry_adder_4_bit/full_adder3/a]

connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/b0] [get_bd_pins ripple_carry_adder_4_bit/full_adder/b]
connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/b1] [get_bd_pins ripple_carry_adder_4_bit/full_adder1/b]
connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/b2] [get_bd_pins ripple_carry_adder_4_bit/full_adder2/b]
connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/b3] [get_bd_pins ripple_carry_adder_4_bit/full_adder3/b]

connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/c_in] [get_bd_pins ripple_carry_adder_4_bit/full_adder/c_in]

connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/s0] [get_bd_pins ripple_carry_adder_4_bit/full_adder/s]
connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/s1] [get_bd_pins ripple_carry_adder_4_bit/full_adder1/s]
connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/s2] [get_bd_pins ripple_carry_adder_4_bit/full_adder2/s]
connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/s3] [get_bd_pins ripple_carry_adder_4_bit/full_adder3/s]

connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/c_out] [get_bd_pins ripple_carry_adder_4_bit/full_adder3/c_out]

# Create 8-bit carry ripple adder
copy_bd_objs /  [get_bd_cells {ripple_carry_adder_4_bit}]
connect_bd_net [get_bd_pins ripple_carry_adder_4_bit/c_out] [get_bd_pins ripple_carry_adder_4_bit1/c_in] 

#Create top level i/o ports and connect to 4 bit adders
# a
create_bd_port -dir I a0
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/a0] [get_bd_ports a0]
create_bd_port -dir I a1
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/a1] [get_bd_ports a1]
create_bd_port -dir I a2
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/a2] [get_bd_ports a2]
create_bd_port -dir I a3
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/a3] [get_bd_ports a3]
create_bd_port -dir I a4
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/a0] [get_bd_ports a4]
create_bd_port -dir I a5
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/a1] [get_bd_ports a5]
create_bd_port -dir I a6
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/a2] [get_bd_ports a6]
create_bd_port -dir I a7
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/a3] [get_bd_ports a7]
# b
create_bd_port -dir I b0
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/b0] [get_bd_ports b0]
create_bd_port -dir I b2
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/b2] [get_bd_ports b2]
create_bd_port -dir I b1
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/b1] [get_bd_ports b1]
create_bd_port -dir I b3
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/b3] [get_bd_ports b3]
create_bd_port -dir I b4
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/b0] [get_bd_ports b4]
create_bd_port -dir I b5
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/b1] [get_bd_ports b5]
create_bd_port -dir I b6
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/b2] [get_bd_ports b6]
create_bd_port -dir I b7
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/b3] [get_bd_ports b7]
create_bd_port -dir O s0
# carry in
create_bd_port -dir I c_in
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/c_in] [get_bd_ports c_in]
# outputs
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/s0] [get_bd_ports s0]
create_bd_port -dir O s1
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/s1] [get_bd_ports s1]
create_bd_port -dir O s2
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/s2] [get_bd_ports s2]
create_bd_port -dir O s3
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit/s3] [get_bd_ports s3]
create_bd_port -dir O s4
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/s0] [get_bd_ports s4]
create_bd_port -dir O s5
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/s1] [get_bd_ports s5]
create_bd_port -dir O s6
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/s2] [get_bd_ports s6]
create_bd_port -dir O s7
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/s3] [get_bd_ports s7]
# carry out
create_bd_port -dir O c_out
connect_bd_net [get_bd_pins /ripple_carry_adder_4_bit1/c_out] [get_bd_ports c_out]

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
set_property -name {xsim.simulate.xsim.more_options} -value {-view ../../../../ripple_carry_adder_tb_behav.wcfg} -objects [current_fileset -simset]
set_property -name {xsim.simulate.runtime} -value {0 ns} -objects [current_fileset -simset]
launch_simulation


# Set initial input values
add_force {/ripple_carry_adder_tb/a} -radix unsigned {0 0ns}
add_force {/ripple_carry_adder_tb/b} -radix unsigned {0 0ns}
add_force {/ripple_carry_adder_tb/c_in} -radix unsigned {0 0ns}

test_pattern

}

# run simulation with some sample test vectors
proc test_pattern {} {

add_force {/ripple_carry_adder_tb/c_in} -radix unsigned {0 0ns}

add_force {/ripple_carry_adder_tb/a} -radix unsigned {0 0ns}
add_force {/ripple_carry_adder_tb/b} -radix unsigned {0 0ns}
run 50 ns

add_force {/ripple_carry_adder_tb/a} -radix unsigned {5 0ns}
add_force {/ripple_carry_adder_tb/b} -radix unsigned {3 0ns}
run 50 ns

add_force {/ripple_carry_adder_tb/a} -radix unsigned {2 0ns}
add_force {/ripple_carry_adder_tb/b} -radix unsigned {7 0ns}
run 50 ns

# set carry in
add_force {/ripple_carry_adder_tb/a} -radix unsigned {10 0ns}
add_force {/ripple_carry_adder_tb/b} -radix unsigned {4 0ns}
add_force {/ripple_carry_adder_tb/c_in} -radix unsigned {1 0ns}
run 50 ns

add_force {/ripple_carry_adder_tb/a} -radix unsigned {128 0ns}
add_force {/ripple_carry_adder_tb/b} -radix unsigned {56 0ns}
run 50 ns

add_force {/ripple_carry_adder_tb/a} -radix unsigned {140 0ns}
add_force {/ripple_carry_adder_tb/b} -radix unsigned {150 0ns}
run 50 ns

add_force {/ripple_carry_adder_tb/c_in} -radix unsigned {0 0ns}
add_force {/ripple_carry_adder_tb/a} -radix unsigned {200 0ns}
add_force {/ripple_carry_adder_tb/b} -radix unsigned {150 0ns}
run 50 ns

# reset input values
add_force {/ripple_carry_adder_tb/a} -radix unsigned {0 0ns}
add_force {/ripple_carry_adder_tb/b} -radix unsigned {0 0ns}
add_force {/ripple_carry_adder_tb/c_in} -radix unsigned {0 0ns}


}

