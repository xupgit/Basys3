# Script to create an 8x8 bit array multiplier using XUP_LIB components. 
# Set XUP_LIB path below before running
#
# Vivado 2014.4
# Basys 3 board
# 10 June 2015
# CMC
# Notes: Set the path below to the XUP_LIB, and run source .tcl to create the design
# It is assumed the pin constraints xdc file (array_multiplier_basys3_pins.xdc) is in the project directory. 
# If the constraints file is located somewhere else, modify the constraints_directory path below
#
# After sourcing this script, and building the project in Vivado, run_sim can be executed to run a simulation 
# 
# -------------------------------------------------------------- #
# SET 'basys3_github' PATH TO GITHUB LIBRARY BEFORE RUNNING
# -------------------------------------------------------------- #
set basys3_github {C:/xup/IPI_LIB/}

set project_directory .
set project_name array_multiplier
set constraints_directory $project_directory
set constraints_file array_multiplier_basys3_pins.xdc
set testbench array_multiplier_tb.v
# Create project for Basys 3
create_project -force $project_name ./$project_name -part xc7a35tcpg236-1
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property target_language verilog [current_project]
set_property simulator_language Verilog [current_project]
set_property ip_repo_paths  $basys3_github [current_project]
update_ip_catalog
create_bd_design "$project_name"

# Steps:
# 1. Create the IO ports
# 2. Create a half adder
# 3. Create a full adder
# 4. create the first array of AND gates
# 5. Using the previously created blocks, create the first row of half/full adders for the array multiplier
# 6. After row 0 and row 1 has been connected, steps 4 and 5 to build the rest of the array 
# 7. The design is grouped into hierarchies to make it easier to view and navigate
#    Each HA/FA block is grouped with its AND gate(s) e.g. r_0_0, r0_1 etc
#    Each block is grouped into a row. e.g. r0_(0 - 7) -> r0

# Note, in Row 0, block 0, and block 7 are half adders (and blocks 1-6 are full adders)
# In Rows 1 -> 7, block 0 is a half adder, but blocks 1 - 7 are full adders (block 7 is no longer a half adder)
# e.g. 
# IO  R0 R1 R2 R3 R4 R5 R6 R7
#     HA HA HA HA HA HA HA HA  
#     FA FA FA FA FA FA FA FA
#     FA FA FA FA FA FA FA FA
#     FA FA FA FA FA FA FA FA
#     FA FA FA FA FA FA FA FA
#     FA FA FA FA FA FA FA FA
#     FA FA FA FA FA FA FA FA
#     FA FA FA FA FA FA FA FA
#     HA FA FA FA FA FA FA FA
# As Row 0 contains a HA at the end of the row instead of a FA, the connection of row 0 to row 1 is different to the connecting of all other rows.
# Once row 0 has been connected to row 1, the connection of all the other rows is the same and is carried out in the loop below. 


# Create IO ports

create_bd_port -dir I a0
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z0] [get_bd_ports z0]
create_bd_port -dir I a1
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z1] [get_bd_ports z1]
create_bd_port -dir I a2
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z2] [get_bd_ports z2]
create_bd_port -dir I a3
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z3] [get_bd_ports z3]
create_bd_port -dir I a4
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z0] [get_bd_ports z0]
create_bd_port -dir I a5
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z1] [get_bd_ports z1]
create_bd_port -dir I a6
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z2] [get_bd_ports z2]
create_bd_port -dir I a7
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z3] [get_bd_ports z3]

create_bd_port -dir I b0
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z0] [get_bd_ports z0]
create_bd_port -dir I b1
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z1] [get_bd_ports z1]
create_bd_port -dir I b2
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z2] [get_bd_ports z2]
create_bd_port -dir I b3
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z3] [get_bd_ports z3]
create_bd_port -dir I b4
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z0] [get_bd_ports z0]
create_bd_port -dir I b5
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z1] [get_bd_ports z1]
create_bd_port -dir I b6
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z2] [get_bd_ports z2]
create_bd_port -dir I b7
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z3] [get_bd_ports z3]

create_bd_port -dir O s0
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/s0] [get_bd_ports s0]
create_bd_port -dir O s1
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o0] [get_bd_ports s1]
create_bd_port -dir O s2
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o1] [get_bd_ports s2]
create_bd_port -dir O s3
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o2] [get_bd_ports s3]
create_bd_port -dir O s4
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o3] [get_bd_ports s4]
create_bd_port -dir O s5
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o4] [get_bd_ports s5]
create_bd_port -dir O s6
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o4] [get_bd_ports s5]
create_bd_port -dir O s7
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o4] [get_bd_ports s5]
create_bd_port -dir O s8
#connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/s0] [get_bd_ports s0]
create_bd_port -dir O s9
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o0] [get_bd_ports s1]
create_bd_port -dir O s10
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o1] [get_bd_ports s2]
create_bd_port -dir O s11
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o2] [get_bd_ports s3]
create_bd_port -dir O s12
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o3] [get_bd_ports s4]
create_bd_port -dir O s13
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o4] [get_bd_ports s5]
create_bd_port -dir O s14
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o4] [get_bd_ports s5]
create_bd_port -dir O s15
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o4] [get_bd_ports s5]

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

# 2 half_adders will be used in the full adder. 
# copy half_adder for use in the full adder. This creates half_adder1.
copy_bd_objs /  [get_bd_cells {half_adder}]
# Make another copy of the half_adder for use later. This creates half_adder2.
copy_bd_objs /  [get_bd_cells {half_adder}]

# Create Full adder
# add OR gate
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_or2:1.0 or_carry_out
#create full_adder hierarchical block (use original half_adder, and newly copied half_adder1)
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

# Original half_adder is now inside the full_adder block. Rename half_adder2 back to half_adder
set_property name half_adder [get_bd_cells half_adder2]

# #####################################################################
# Start creating the Array multiplier
# 
# The naming of the AND gate (e.g. xup_and2_a0_b0) indicates which 
# inputs should be connected 
# For the adder array, r{X}, X indicates the row (0->7) 
# e.g. full_adder_r0_5 is the 5th block in row 0
# #####################################################################
# Create AND a(x)_b(0->7)
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a0_b0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a0_b1
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a0_b2
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a0_b3
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a0_b4
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a0_b5
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a0_b6
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a0_b7
# Create FA/HA 
copy_bd_objs /  [get_bd_cells {half_adder}]
set_property name half_adder_r0_0 [get_bd_cells half_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r0_1 [get_bd_cells full_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r0_2 [get_bd_cells full_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r0_3 [get_bd_cells full_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r0_4 [get_bd_cells full_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r0_5 [get_bd_cells full_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r0_6 [get_bd_cells full_adder1]
copy_bd_objs /  [get_bd_cells {half_adder}]
set_property name half_adder_r0_7 [get_bd_cells half_adder1]
# Connect a(x) to AND
connect_bd_net [get_bd_ports a0] [get_bd_pins xup_and2_a0_b0/a]
connect_bd_net -net [get_bd_nets a0_1] [get_bd_ports a0] [get_bd_pins xup_and2_a0_b1/a]
connect_bd_net -net [get_bd_nets a0_1] [get_bd_ports a0] [get_bd_pins xup_and2_a0_b2/a]
connect_bd_net -net [get_bd_nets a0_1] [get_bd_ports a0] [get_bd_pins xup_and2_a0_b3/a]
connect_bd_net -net [get_bd_nets a0_1] [get_bd_ports a0] [get_bd_pins xup_and2_a0_b4/a]
connect_bd_net -net [get_bd_nets a0_1] [get_bd_ports a0] [get_bd_pins xup_and2_a0_b5/a]
connect_bd_net -net [get_bd_nets a0_1] [get_bd_ports a0] [get_bd_pins xup_and2_a0_b6/a]
connect_bd_net -net [get_bd_nets a0_1] [get_bd_ports a0] [get_bd_pins xup_and2_a0_b7/a]
# connect b(0->7) to AND
connect_bd_net [get_bd_ports b0] [get_bd_pins xup_and2_a0_b0/b]
connect_bd_net [get_bd_ports b1] [get_bd_pins xup_and2_a0_b1/b]
connect_bd_net [get_bd_ports b2] [get_bd_pins xup_and2_a0_b2/b]
connect_bd_net [get_bd_ports b3] [get_bd_pins xup_and2_a0_b3/b]
connect_bd_net [get_bd_ports b4] [get_bd_pins xup_and2_a0_b4/b]
connect_bd_net [get_bd_ports b5] [get_bd_pins xup_and2_a0_b5/b]
connect_bd_net [get_bd_ports b6] [get_bd_pins xup_and2_a0_b6/b]
connect_bd_net [get_bd_ports b7] [get_bd_pins xup_and2_a0_b7/b]
# Connect s(x) to and_x_0 
connect_bd_net [get_bd_ports s0] [get_bd_pins xup_and2_a0_b0/y]
# Connect to HA/FA 
connect_bd_net [get_bd_pins xup_and2_a0_b1/y] [get_bd_pins half_adder_r0_0/a]
connect_bd_net [get_bd_pins xup_and2_a0_b2/y] [get_bd_pins full_adder_r0_1/a]
connect_bd_net [get_bd_pins xup_and2_a0_b3/y] [get_bd_pins full_adder_r0_2/a]
connect_bd_net [get_bd_pins xup_and2_a0_b4/y] [get_bd_pins full_adder_r0_3/a]
connect_bd_net [get_bd_pins xup_and2_a0_b5/y] [get_bd_pins full_adder_r0_4/a]
connect_bd_net [get_bd_pins xup_and2_a0_b6/y] [get_bd_pins full_adder_r0_5/a]
connect_bd_net [get_bd_pins xup_and2_a0_b7/y] [get_bd_pins full_adder_r0_6/a]
# Create AND (X)
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a1_b0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a1_b1
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a1_b2
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a1_b3
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a1_b4
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a1_b5
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a1_b6
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a1_b7
#Connect a(x) to AND
connect_bd_net [get_bd_ports a1] [get_bd_pins xup_and2_a1_b0/a]
connect_bd_net -net [get_bd_nets a1_1] [get_bd_ports a1] [get_bd_pins xup_and2_a1_b1/a]
connect_bd_net -net [get_bd_nets a1_1] [get_bd_ports a1] [get_bd_pins xup_and2_a1_b2/a]
connect_bd_net -net [get_bd_nets a1_1] [get_bd_ports a1] [get_bd_pins xup_and2_a1_b3/a]
connect_bd_net -net [get_bd_nets a1_1] [get_bd_ports a1] [get_bd_pins xup_and2_a1_b4/a]
connect_bd_net -net [get_bd_nets a1_1] [get_bd_ports a1] [get_bd_pins xup_and2_a1_b5/a]
connect_bd_net -net [get_bd_nets a1_1] [get_bd_ports a1] [get_bd_pins xup_and2_a1_b6/a]
connect_bd_net -net [get_bd_nets a1_1] [get_bd_ports a1] [get_bd_pins xup_and2_a1_b7/a]
# connect b(0->7) to AND
connect_bd_net [get_bd_ports b0] [get_bd_pins xup_and2_a1_b0/b]
connect_bd_net [get_bd_ports b1] [get_bd_pins xup_and2_a1_b1/b]
connect_bd_net [get_bd_ports b2] [get_bd_pins xup_and2_a1_b2/b]
connect_bd_net [get_bd_ports b3] [get_bd_pins xup_and2_a1_b3/b]
connect_bd_net [get_bd_ports b4] [get_bd_pins xup_and2_a1_b4/b]
connect_bd_net [get_bd_ports b5] [get_bd_pins xup_and2_a1_b5/b]
connect_bd_net [get_bd_ports b6] [get_bd_pins xup_and2_a1_b6/b]
connect_bd_net [get_bd_ports b7] [get_bd_pins xup_and2_a1_b7/b]
# Connect to HA/FA 
connect_bd_net [get_bd_pins xup_and2_a1_b0/y] [get_bd_pins half_adder_r0_0/b]
connect_bd_net [get_bd_pins xup_and2_a1_b1/y] [get_bd_pins full_adder_r0_1/b]
connect_bd_net [get_bd_pins xup_and2_a1_b2/y] [get_bd_pins full_adder_r0_2/b]
connect_bd_net [get_bd_pins xup_and2_a1_b3/y] [get_bd_pins full_adder_r0_3/b]
connect_bd_net [get_bd_pins xup_and2_a1_b4/y] [get_bd_pins full_adder_r0_4/b]
connect_bd_net [get_bd_pins xup_and2_a1_b5/y] [get_bd_pins full_adder_r0_5/b]
connect_bd_net [get_bd_pins xup_and2_a1_b6/y] [get_bd_pins full_adder_r0_6/b]
connect_bd_net [get_bd_pins xup_and2_a1_b7/y] [get_bd_pins half_adder_r0_7/b]
# Connect carries
connect_bd_net [get_bd_pins half_adder_r0_0/c]     [get_bd_pins full_adder_r0_1/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r0_1/c_out] [get_bd_pins full_adder_r0_2/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r0_2/c_out] [get_bd_pins full_adder_r0_3/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r0_3/c_out] [get_bd_pins full_adder_r0_4/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r0_4/c_out] [get_bd_pins full_adder_r0_5/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r0_5/c_out] [get_bd_pins full_adder_r0_6/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r0_6/c_out] [get_bd_pins half_adder_r0_7/a] -boundary_type upper
# Connect half_adder to s(x)
connect_bd_net [get_bd_ports s1] [get_bd_pins half_adder_r0_0/s]
# #################################

# Row 1
# (As described above, connecting Row 1 to row 0 is different to connecting other rows and needs to be done separately
# Create AND a(x)_b(0->7)
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a2_b0
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a2_b1
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a2_b2
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a2_b3
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a2_b4
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a2_b5
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a2_b6
create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a2_b7
# Create FA/HA R(x-1)
copy_bd_objs /  [get_bd_cells {half_adder}]
set_property name half_adder_r1_0 [get_bd_cells half_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r1_1 [get_bd_cells full_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r1_2 [get_bd_cells full_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r1_3 [get_bd_cells full_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r1_4 [get_bd_cells full_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r1_5 [get_bd_cells full_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r1_6 [get_bd_cells full_adder1]
copy_bd_objs /  [get_bd_cells {full_adder}]
set_property name full_adder_r1_7 [get_bd_cells full_adder1]
#Connect a(x) to AND (x)
connect_bd_net [get_bd_ports a2] [get_bd_pins xup_and2_a2_b0/a]
connect_bd_net -net [get_bd_nets a2_1] [get_bd_ports a2] [get_bd_pins xup_and2_a2_b1/a]
connect_bd_net -net [get_bd_nets a2_1] [get_bd_ports a2] [get_bd_pins xup_and2_a2_b2/a]
connect_bd_net -net [get_bd_nets a2_1] [get_bd_ports a2] [get_bd_pins xup_and2_a2_b3/a]
connect_bd_net -net [get_bd_nets a2_1] [get_bd_ports a2] [get_bd_pins xup_and2_a2_b4/a]
connect_bd_net -net [get_bd_nets a2_1] [get_bd_ports a2] [get_bd_pins xup_and2_a2_b5/a]
connect_bd_net -net [get_bd_nets a2_1] [get_bd_ports a2] [get_bd_pins xup_and2_a2_b6/a]
connect_bd_net -net [get_bd_nets a2_1] [get_bd_ports a2] [get_bd_pins xup_and2_a2_b7/a]
# connect b(0->7) to AND (x)
connect_bd_net [get_bd_ports b0] [get_bd_pins xup_and2_a2_b0/b]
connect_bd_net [get_bd_ports b1] [get_bd_pins xup_and2_a2_b1/b]
connect_bd_net [get_bd_ports b2] [get_bd_pins xup_and2_a2_b2/b]
connect_bd_net [get_bd_ports b3] [get_bd_pins xup_and2_a2_b3/b]
connect_bd_net [get_bd_ports b4] [get_bd_pins xup_and2_a2_b4/b]
connect_bd_net [get_bd_ports b5] [get_bd_pins xup_and2_a2_b5/b]
connect_bd_net [get_bd_ports b6] [get_bd_pins xup_and2_a2_b6/b]
connect_bd_net [get_bd_ports b7] [get_bd_pins xup_and2_a2_b7/b]
# Connect to HA/FA AND(x) to r(x-1)
connect_bd_net [get_bd_pins xup_and2_a2_b0/y] [get_bd_pins half_adder_r1_0/a]
connect_bd_net [get_bd_pins xup_and2_a2_b1/y] [get_bd_pins full_adder_r1_1/a]
connect_bd_net [get_bd_pins xup_and2_a2_b2/y] [get_bd_pins full_adder_r1_2/a]
connect_bd_net [get_bd_pins xup_and2_a2_b3/y] [get_bd_pins full_adder_r1_3/a]
connect_bd_net [get_bd_pins xup_and2_a2_b4/y] [get_bd_pins full_adder_r1_4/a]
connect_bd_net [get_bd_pins xup_and2_a2_b5/y] [get_bd_pins full_adder_r1_5/a]
connect_bd_net [get_bd_pins xup_and2_a2_b6/y] [get_bd_pins full_adder_r1_6/a]
connect_bd_net [get_bd_pins xup_and2_a2_b7/y] [get_bd_pins full_adder_r1_7/a]
# connect r(x-2) to r(x-1)
connect_bd_net [get_bd_pins full_adder_r0_1/s] [get_bd_pins half_adder_r1_0/b] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r0_2/s] [get_bd_pins full_adder_r1_1/b] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r0_3/s] [get_bd_pins full_adder_r1_2/b] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r0_4/s] [get_bd_pins full_adder_r1_3/b] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r0_5/s] [get_bd_pins full_adder_r1_4/b] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r0_6/s] [get_bd_pins full_adder_r1_5/b] -boundary_type upper
connect_bd_net [get_bd_pins half_adder_r0_7/s] [get_bd_pins full_adder_r1_6/b] -boundary_type upper
# Connect carries r(x-1)
connect_bd_net [get_bd_pins half_adder_r1_0/c]     [get_bd_pins full_adder_r1_1/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r1_1/c_out] [get_bd_pins full_adder_r1_2/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r1_2/c_out] [get_bd_pins full_adder_r1_3/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r1_3/c_out] [get_bd_pins full_adder_r1_4/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r1_4/c_out] [get_bd_pins full_adder_r1_5/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r1_5/c_out] [get_bd_pins full_adder_r1_6/c_in] -boundary_type upper
connect_bd_net [get_bd_pins full_adder_r1_6/c_out] [get_bd_pins full_adder_r1_7/c_in] -boundary_type upper
# carry from previous row
connect_bd_net [get_bd_pins half_adder_r0_7/c] [get_bd_pins full_adder_r1_7/b] -boundary_type upper
# Output s(x) from r(x-1)
connect_bd_net [get_bd_ports s2] [get_bd_pins half_adder_r1_0/s]

# #################################
# Connect rows 2-7 to the previous row
for {
        set i 3
        set j 2
        set k 1
    } {
        $i < 8
    } {
        incr i 
        incr j
        incr k
    } {

    # Create AND a(x)_b(0->7)
    create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a${i}_b0
    create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a${i}_b1
    create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a${i}_b2
    create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a${i}_b3
    create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a${i}_b4
    create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a${i}_b5
    create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a${i}_b6
    create_bd_cell -type ip -vlnv xilinx.com:XUP:xup_and2:1.0 xup_and2_a${i}_b7
    # Create FA/HA R(x-1)
    copy_bd_objs /  [get_bd_cells {half_adder}]
    set_property name half_adder_r${j}_0 [get_bd_cells half_adder1]
    copy_bd_objs /  [get_bd_cells {full_adder}]
    set_property name full_adder_r${j}_1 [get_bd_cells full_adder1]
    copy_bd_objs /  [get_bd_cells {full_adder}]
    set_property name full_adder_r${j}_2 [get_bd_cells full_adder1]
    copy_bd_objs /  [get_bd_cells {full_adder}]
    set_property name full_adder_r${j}_3 [get_bd_cells full_adder1]
    copy_bd_objs /  [get_bd_cells {full_adder}]
    set_property name full_adder_r${j}_4 [get_bd_cells full_adder1]
    copy_bd_objs /  [get_bd_cells {full_adder}]
    set_property name full_adder_r${j}_5 [get_bd_cells full_adder1]
    copy_bd_objs /  [get_bd_cells {full_adder}]
    set_property name full_adder_r${j}_6 [get_bd_cells full_adder1]
    copy_bd_objs /  [get_bd_cells {full_adder}]
    set_property name full_adder_r${j}_7 [get_bd_cells full_adder1]
    #Connect a(x) to AND (x)
    connect_bd_net [get_bd_ports a${i}] [get_bd_pins xup_and2_a${i}_b0/a]
    connect_bd_net -net [get_bd_nets a${i}_1] [get_bd_ports a${i}] [get_bd_pins xup_and2_a${i}_b1/a]
    connect_bd_net -net [get_bd_nets a${i}_1] [get_bd_ports a${i}] [get_bd_pins xup_and2_a${i}_b2/a]
    connect_bd_net -net [get_bd_nets a${i}_1] [get_bd_ports a${i}] [get_bd_pins xup_and2_a${i}_b3/a]
    connect_bd_net -net [get_bd_nets a${i}_1] [get_bd_ports a${i}] [get_bd_pins xup_and2_a${i}_b4/a]
    connect_bd_net -net [get_bd_nets a${i}_1] [get_bd_ports a${i}] [get_bd_pins xup_and2_a${i}_b5/a]
    connect_bd_net -net [get_bd_nets a${i}_1] [get_bd_ports a${i}] [get_bd_pins xup_and2_a${i}_b6/a]
    connect_bd_net -net [get_bd_nets a${i}_1] [get_bd_ports a${i}] [get_bd_pins xup_and2_a${i}_b7/a]
    # connect b(0->7) to AND (x)
    connect_bd_net [get_bd_ports b0] [get_bd_pins xup_and2_a${i}_b0/b]
    connect_bd_net [get_bd_ports b1] [get_bd_pins xup_and2_a${i}_b1/b]
    connect_bd_net [get_bd_ports b2] [get_bd_pins xup_and2_a${i}_b2/b]
    connect_bd_net [get_bd_ports b3] [get_bd_pins xup_and2_a${i}_b3/b]
    connect_bd_net [get_bd_ports b4] [get_bd_pins xup_and2_a${i}_b4/b]
    connect_bd_net [get_bd_ports b5] [get_bd_pins xup_and2_a${i}_b5/b]
    connect_bd_net [get_bd_ports b6] [get_bd_pins xup_and2_a${i}_b6/b]
    connect_bd_net [get_bd_ports b7] [get_bd_pins xup_and2_a${i}_b7/b]
    # Connect to HA/FA AND(x) to r(x-1)
    connect_bd_net [get_bd_pins xup_and2_a${i}_b0/y] [get_bd_pins half_adder_r${j}_0/a]
    connect_bd_net [get_bd_pins xup_and2_a${i}_b1/y] [get_bd_pins full_adder_r${j}_1/a]
    connect_bd_net [get_bd_pins xup_and2_a${i}_b2/y] [get_bd_pins full_adder_r${j}_2/a]
    connect_bd_net [get_bd_pins xup_and2_a${i}_b3/y] [get_bd_pins full_adder_r${j}_3/a]
    connect_bd_net [get_bd_pins xup_and2_a${i}_b4/y] [get_bd_pins full_adder_r${j}_4/a]
    connect_bd_net [get_bd_pins xup_and2_a${i}_b5/y] [get_bd_pins full_adder_r${j}_5/a]
    connect_bd_net [get_bd_pins xup_and2_a${i}_b6/y] [get_bd_pins full_adder_r${j}_6/a]
    connect_bd_net [get_bd_pins xup_and2_a${i}_b7/y] [get_bd_pins full_adder_r${j}_7/a]
    # connect r(x-2) to r(x-1)
    connect_bd_net [get_bd_pins full_adder_r${k}_1/s] [get_bd_pins half_adder_r${j}_0/b] -boundary_type upper
    connect_bd_net [get_bd_pins full_adder_r${k}_2/s] [get_bd_pins full_adder_r${j}_1/b] -boundary_type upper
    connect_bd_net [get_bd_pins full_adder_r${k}_3/s] [get_bd_pins full_adder_r${j}_2/b] -boundary_type upper
    connect_bd_net [get_bd_pins full_adder_r${k}_4/s] [get_bd_pins full_adder_r${j}_3/b] -boundary_type upper
    connect_bd_net [get_bd_pins full_adder_r${k}_5/s] [get_bd_pins full_adder_r${j}_4/b] -boundary_type upper
    connect_bd_net [get_bd_pins full_adder_r${k}_6/s] [get_bd_pins full_adder_r${j}_5/b] -boundary_type upper
    connect_bd_net [get_bd_pins full_adder_r${k}_7/s] [get_bd_pins full_adder_r${j}_6/b] -boundary_type upper
    # Connect carries r(x-1)
    connect_bd_net [get_bd_pins half_adder_r${j}_0/c]     [get_bd_pins full_adder_r${j}_1/c_in] -boundary_type upper
    connect_bd_net [get_bd_pins full_adder_r${j}_1/c_out] [get_bd_pins full_adder_r${j}_2/c_in] -boundary_type upper
    connect_bd_net [get_bd_pins full_adder_r${j}_2/c_out] [get_bd_pins full_adder_r${j}_3/c_in] -boundary_type upper
    connect_bd_net [get_bd_pins full_adder_r${j}_3/c_out] [get_bd_pins full_adder_r${j}_4/c_in] -boundary_type upper
    connect_bd_net [get_bd_pins full_adder_r${j}_4/c_out] [get_bd_pins full_adder_r${j}_5/c_in] -boundary_type upper
    connect_bd_net [get_bd_pins full_adder_r${j}_5/c_out] [get_bd_pins full_adder_r${j}_6/c_in] -boundary_type upper
    connect_bd_net [get_bd_pins full_adder_r${j}_6/c_out] [get_bd_pins full_adder_r${j}_7/c_in] -boundary_type upper
    # carry from previous row
    connect_bd_net [get_bd_pins full_adder_r${k}_7/c_out] [get_bd_pins full_adder_r${j}_7/b] -boundary_type upper
    # Output s(x) from r(x-1)
    connect_bd_net [get_bd_ports s${i}] [get_bd_pins half_adder_r${j}_0/s]

}

# connect final outputs
connect_bd_net [get_bd_ports s8] [get_bd_pins full_adder_r6_1/s]
connect_bd_net [get_bd_ports s9] [get_bd_pins full_adder_r6_2/s]
connect_bd_net [get_bd_ports s10] [get_bd_pins full_adder_r6_3/s]
connect_bd_net [get_bd_ports s11] [get_bd_pins full_adder_r6_4/s]
connect_bd_net [get_bd_ports s12] [get_bd_pins full_adder_r6_5/s]
connect_bd_net [get_bd_ports s13] [get_bd_pins full_adder_r6_6/s]
connect_bd_net [get_bd_ports s14] [get_bd_pins full_adder_r6_7/s]
connect_bd_net [get_bd_ports s15] [get_bd_pins full_adder_r6_7/c_out]
# clean up original half/full adders that were used to create (copy) all other adders in the design
delete_bd_objs [get_bd_cells half_adder] [get_bd_cells full_adder]

# Create Hierarchy
# half adder 0_0
group_bd_cells r0_0 [get_bd_cells xup_and2_a0_b1] [get_bd_cells xup_and2_a1_b0] [get_bd_cells half_adder_r0_0]
# row 0
for {
        set j 1
        set k 2
    } {
        $j < 7
    } {
        incr j
        incr k
    } {
    group_bd_cells r0_${j} [get_bd_cells xup_and2_a0_b${k}] [get_bd_cells xup_and2_a1_b${j}] [get_bd_cells full_adder_r0_${j}]
}
# half adder 0_7
group_bd_cells r0_7 [get_bd_cells xup_and2_a1_b7] [get_bd_cells half_adder_r0_7]

# rows 1 - 7
for {
        set i 1
        set j 2
    } {
        $i < 7
    } {
        incr i
        incr j
    } {
    # half adder 0
    group_bd_cells r${i}_0 [get_bd_cells xup_and2_a${j}_b0] [get_bd_cells half_adder_r${i}_0]
    for {
            set k 1        
        } {
            $k < 8
        } {
            incr k
        } {
    # full adders 1 - 7
        group_bd_cells r${i}_${k} [get_bd_cells xup_and2_a${j}_b${k}] [get_bd_cells full_adder_r${i}_${k}]
    }
}
        set i 7
        set j 8

#Group blocks into rows
for {
        set i 0
    } {
        $i < 8
    } {
        incr i
    } {
    group_bd_cells r${i} [get_bd_cells r${i}_0] [get_bd_cells r${i}_1] [get_bd_cells r${i}_2] [get_bd_cells r${i}_3] [get_bd_cells r${i}_4] [get_bd_cells r${i}_5] [get_bd_cells r${i}_6] [get_bd_cells r${i}_7]
}
# Move last AND gate for s0 into block r0
move_bd_cells [get_bd_cells r0] [get_bd_cells xup_and2_a0_b0]

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
close_sim -force
}
set_property -name {xsim.simulate.xsim.more_options} -value {-view ../../../../$project_name\_tb_behav.wcfg} -objects [current_fileset -simset]
set_property -name {xsim.simulate.runtime} -value {0 ns} -objects [current_fileset -simset]
launch_simulation
puts "Running Simulation for 3276800 ns"
puts "The testbench will increment each input from 0-256 covering all input possibilities"
run 9830400 ns
puts "Simulation complete"


}
