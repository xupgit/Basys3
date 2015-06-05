# Script to create an adder capable of adding four 4-bit numbers using 4-bit carry save adder using XUP_LIB components. 
# Set XUP_LIB path below before running
#
# The addition of four 4-bit numbers is built from two 4-bit carry save adders and a ripple carry adder. 
# The 4-bit carry save adder is built from four full adders. 
# The full adder is built from two half adders. 
# The hierarchy of the design can be explored by opening or expanding the hierarchical blocks  
#
# Vivado 2014.4
# Basys 3 board
# 28 May 2015
# CMC
# Notes: Set the path below to the XUP_LIB, and run source carry_save__adder.tcl to create the design
# It is assumed the pin constraints xdc file (carry_save_adder_basys3_pins.xdc) is in the project directory. 
# If the constraints file is located somewhere else, modify the constraints_directory path below
#
# After sourcing this script, run_sim can be executed to run a simulation 
#
# Four 4-bit inputs (operands), x, y, z and w, are connected to the dip switches (w sw0-3, x sw 4-7, y sw 8-11, z sw 12-15)
# The 6-bit outputs are connected to LEDs 0-5 
# 
# -------------------------------------------------------------- #
# SET 'basys3_github' PATH TO GITHUB LIBRARY BEFORE RUNNING
# -------------------------------------------------------------- #
set basys3_github {C:/xup/IPI_LIB/XUP_LIB}

set project_directory .
set project_name carry_save_adder
set constraints_directory $project_directory
set constraints_file carry_save_adder_basys3_pins.xdc
set testbench carry_save_adder_tb.v
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
# Copy full adder 4 times to make 4-bit carry save adders
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
# Create 4-bit carry save adder
# Copy and paste full adder
copy_bd_objs /  [get_bd_cells {full_adder}]
copy_bd_objs /  [get_bd_cells {full_adder}]
copy_bd_objs /  [get_bd_cells {full_adder}]

# create 4-bit carry save adder hierarchical block
group_bd_cells carry_save_adder_4_bit [get_bd_cells full_adder]  [get_bd_cells full_adder1] [get_bd_cells full_adder2] [get_bd_cells full_adder3]
# create hierarchical block pins
create_bd_pin -dir I carry_save_adder_4_bit/x0
create_bd_pin -dir I carry_save_adder_4_bit/x1
create_bd_pin -dir I carry_save_adder_4_bit/x2
create_bd_pin -dir I carry_save_adder_4_bit/x3
create_bd_pin -dir I carry_save_adder_4_bit/y0
create_bd_pin -dir I carry_save_adder_4_bit/y1
create_bd_pin -dir I carry_save_adder_4_bit/y2
create_bd_pin -dir I carry_save_adder_4_bit/y3
create_bd_pin -dir I carry_save_adder_4_bit/z0
create_bd_pin -dir I carry_save_adder_4_bit/z1
create_bd_pin -dir I carry_save_adder_4_bit/z2
create_bd_pin -dir I carry_save_adder_4_bit/z3

create_bd_pin -dir O carry_save_adder_4_bit/c0
create_bd_pin -dir O carry_save_adder_4_bit/c1
create_bd_pin -dir O carry_save_adder_4_bit/c2
create_bd_pin -dir O carry_save_adder_4_bit/c3
create_bd_pin -dir O carry_save_adder_4_bit/s0
create_bd_pin -dir O carry_save_adder_4_bit/s1
create_bd_pin -dir O carry_save_adder_4_bit/s2
create_bd_pin -dir O carry_save_adder_4_bit/s3
# connect pins
connect_bd_net [get_bd_pins carry_save_adder_4_bit/x0] [get_bd_pins carry_save_adder_4_bit/full_adder/a]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/x1] [get_bd_pins carry_save_adder_4_bit/full_adder1/a]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/x2] [get_bd_pins carry_save_adder_4_bit/full_adder2/a]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/x3] [get_bd_pins carry_save_adder_4_bit/full_adder3/a]

connect_bd_net [get_bd_pins carry_save_adder_4_bit/y0] [get_bd_pins carry_save_adder_4_bit/full_adder/b]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/y1] [get_bd_pins carry_save_adder_4_bit/full_adder1/b]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/y2] [get_bd_pins carry_save_adder_4_bit/full_adder2/b]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/y3] [get_bd_pins carry_save_adder_4_bit/full_adder3/b]

connect_bd_net [get_bd_pins carry_save_adder_4_bit/z0] [get_bd_pins carry_save_adder_4_bit/full_adder/c_in]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/z1] [get_bd_pins carry_save_adder_4_bit/full_adder1/c_in]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/z2] [get_bd_pins carry_save_adder_4_bit/full_adder2/c_in]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/z3] [get_bd_pins carry_save_adder_4_bit/full_adder3/c_in]

connect_bd_net [get_bd_pins carry_save_adder_4_bit/s0] [get_bd_pins carry_save_adder_4_bit/full_adder/s]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/s1] [get_bd_pins carry_save_adder_4_bit/full_adder1/s]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/s2] [get_bd_pins carry_save_adder_4_bit/full_adder2/s]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/s3] [get_bd_pins carry_save_adder_4_bit/full_adder3/s]

connect_bd_net [get_bd_pins carry_save_adder_4_bit/c0] [get_bd_pins carry_save_adder_4_bit/full_adder/c_out]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/c1] [get_bd_pins carry_save_adder_4_bit/full_adder1/c_out]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/c2] [get_bd_pins carry_save_adder_4_bit/full_adder2/c_out]
connect_bd_net [get_bd_pins carry_save_adder_4_bit/c3] [get_bd_pins carry_save_adder_4_bit/full_adder3/c_out]

# Create 8-bit carry save adder
copy_bd_objs /  [get_bd_cells {carry_save_adder_4_bit}]


#Create top level i/o ports and connect to 4 bit adders
# w
create_bd_port -dir I w0
connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/x0] [get_bd_ports w0]
create_bd_port -dir I w1
connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/x1] [get_bd_ports w1]
create_bd_port -dir I w2
connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/x2] [get_bd_ports w2]
create_bd_port -dir I w3
connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/x3] [get_bd_ports w3]
# x
create_bd_port -dir I x0
connect_bd_net [get_bd_pins /carry_save_adder_4_bit/x0] [get_bd_ports x0]
create_bd_port -dir I x1
connect_bd_net [get_bd_pins /carry_save_adder_4_bit/x1] [get_bd_ports x1]
create_bd_port -dir I x2
connect_bd_net [get_bd_pins /carry_save_adder_4_bit/x2] [get_bd_ports x2]
create_bd_port -dir I x3
connect_bd_net [get_bd_pins /carry_save_adder_4_bit/x3] [get_bd_ports x3]
# y
create_bd_port -dir I y0
connect_bd_net [get_bd_pins /carry_save_adder_4_bit/y0] [get_bd_ports y0]
create_bd_port -dir I y1
connect_bd_net [get_bd_pins /carry_save_adder_4_bit/y1] [get_bd_ports y1]
create_bd_port -dir I y2
connect_bd_net [get_bd_pins /carry_save_adder_4_bit/y2] [get_bd_ports y2]
create_bd_port -dir I y3
connect_bd_net [get_bd_pins /carry_save_adder_4_bit/y3] [get_bd_ports y3]
#z
create_bd_port -dir I z0
connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z0] [get_bd_ports z0]
create_bd_port -dir I z1
connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z1] [get_bd_ports z1]
create_bd_port -dir I z2
connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z2] [get_bd_ports z2]
create_bd_port -dir I z3
connect_bd_net [get_bd_pins /carry_save_adder_4_bit/z3] [get_bd_ports z3]


connect_bd_net [get_bd_pins carry_save_adder_4_bit/c0] [get_bd_pins carry_save_adder_4_bit1/z1] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit/c1] [get_bd_pins carry_save_adder_4_bit1/z2] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit/c2] [get_bd_pins carry_save_adder_4_bit1/z3] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit/s0] [get_bd_pins carry_save_adder_4_bit1/y0] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit/s1] [get_bd_pins carry_save_adder_4_bit1/y1] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit/s2] [get_bd_pins carry_save_adder_4_bit1/y2] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit/s3] [get_bd_pins carry_save_adder_4_bit1/y3] -boundary_type upper

# ######################################################################################
# # Ripple carry adder for last stage
# # The ripple carry adder is also available as a standalone project from the XUP github
# ######################################################################################

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

group_bd_cells ripple_carry_adder_8_bit [get_bd_cells ripple_carry_adder_4_bit1] [get_bd_cells ripple_carry_adder_4_bit]

#Create top level i/o ports and connect to 4 bit adders
# a
create_bd_pin -dir I /ripple_carry_adder_8_bit/a0
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/a0] [get_bd_pins /ripple_carry_adder_8_bit/a0]
create_bd_pin -dir I /ripple_carry_adder_8_bit/a1
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/a1] [get_bd_pins /ripple_carry_adder_8_bit/a1]
create_bd_pin -dir I /ripple_carry_adder_8_bit/a2
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/a2] [get_bd_pins /ripple_carry_adder_8_bit/a2]
create_bd_pin -dir I /ripple_carry_adder_8_bit/a3
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/a3] [get_bd_pins /ripple_carry_adder_8_bit/a3]
create_bd_pin -dir I /ripple_carry_adder_8_bit/a4
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/a0] [get_bd_pins /ripple_carry_adder_8_bit/a4]
create_bd_pin -dir I /ripple_carry_adder_8_bit/a5
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/a1] [get_bd_pins /ripple_carry_adder_8_bit/a5]
create_bd_pin -dir I /ripple_carry_adder_8_bit/a6
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/a2] [get_bd_pins /ripple_carry_adder_8_bit/a6]
create_bd_pin -dir I /ripple_carry_adder_8_bit/a7
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/a3] [get_bd_pins /ripple_carry_adder_8_bit/a7]
# b
create_bd_pin -dir I /ripple_carry_adder_8_bit/b0
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/b0] [get_bd_pins /ripple_carry_adder_8_bit/b0]
create_bd_pin -dir I /ripple_carry_adder_8_bit/b1
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/b1] [get_bd_pins /ripple_carry_adder_8_bit/b1]
create_bd_pin -dir I /ripple_carry_adder_8_bit/b2
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/b2] [get_bd_pins /ripple_carry_adder_8_bit/b2]
create_bd_pin -dir I /ripple_carry_adder_8_bit/b3
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/b3] [get_bd_pins /ripple_carry_adder_8_bit/b3]
create_bd_pin -dir I /ripple_carry_adder_8_bit/b4
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/b0] [get_bd_pins /ripple_carry_adder_8_bit/b4]
create_bd_pin -dir I /ripple_carry_adder_8_bit/b5
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/b1] [get_bd_pins /ripple_carry_adder_8_bit/b5]
create_bd_pin -dir I /ripple_carry_adder_8_bit/b6
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/b2] [get_bd_pins /ripple_carry_adder_8_bit/b6]
create_bd_pin -dir I /ripple_carry_adder_8_bit/b7
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/b3] [get_bd_pins /ripple_carry_adder_8_bit/b7]


# outputs
create_bd_pin -dir O /ripple_carry_adder_8_bit/o0
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/s0] [get_bd_pins /ripple_carry_adder_8_bit/o0]
create_bd_pin -dir O /ripple_carry_adder_8_bit/o1
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/s1] [get_bd_pins /ripple_carry_adder_8_bit/o1]
create_bd_pin -dir O /ripple_carry_adder_8_bit/o2
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/s2] [get_bd_pins /ripple_carry_adder_8_bit/o2]
create_bd_pin -dir O /ripple_carry_adder_8_bit/o3
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/s3] [get_bd_pins /ripple_carry_adder_8_bit/o3]
create_bd_pin -dir O /ripple_carry_adder_8_bit/o4
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/s0] [get_bd_pins /ripple_carry_adder_8_bit/o4]
create_bd_pin -dir O /ripple_carry_adder_8_bit/o5
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/s1] [get_bd_pins /ripple_carry_adder_8_bit/o5]
create_bd_pin -dir O /ripple_carry_adder_8_bit/o6
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/s2] [get_bd_pins /ripple_carry_adder_8_bit/o6]
create_bd_pin -dir O /ripple_carry_adder_8_bit/o7
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/s3] [get_bd_pins /ripple_carry_adder_8_bit/o7]
# carry out
create_bd_pin -dir O /ripple_carry_adder_8_bit/c_out
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_4_bit1/c_out] [get_bd_pins /ripple_carry_adder_8_bit/c_out]
# ##########################################################################
# # END Ripple Carry Adder
# ##########################################################################

connect_bd_net [get_bd_pins carry_save_adder_4_bit1/s1] [get_bd_pins ripple_carry_adder_8_bit/b0] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit1/s2] [get_bd_pins ripple_carry_adder_8_bit/b1] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit1/s3] [get_bd_pins ripple_carry_adder_8_bit/b2] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit1/c0] [get_bd_pins ripple_carry_adder_8_bit/a0] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit1/c1] [get_bd_pins ripple_carry_adder_8_bit/a1] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit1/c2] [get_bd_pins ripple_carry_adder_8_bit/a2] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit/c3] [get_bd_pins ripple_carry_adder_8_bit/b3] -boundary_type upper
connect_bd_net [get_bd_pins carry_save_adder_4_bit1/c3] [get_bd_pins ripple_carry_adder_8_bit/a3] -boundary_type upper

create_bd_port -dir O s0
connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/s0] [get_bd_ports s0]
create_bd_port -dir O s1
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o0] [get_bd_ports s1]
create_bd_port -dir O s2
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o1] [get_bd_ports s2]
create_bd_port -dir O s3
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o2] [get_bd_ports s3]
create_bd_port -dir O s4
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o3] [get_bd_ports s4]
create_bd_port -dir O s5
connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/o4] [get_bd_ports s5]

regenerate_bd_layout
save_bd_design

# Ground all unused signals.
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells gnd]
connect_bd_net [get_bd_pins gnd/dout] [get_bd_pins ripple_carry_adder_8_bit/b4]
connect_bd_net -net [get_bd_nets gnd_dout] [get_bd_pins ripple_carry_adder_8_bit/b5] 
connect_bd_net -net [get_bd_nets gnd_dout] [get_bd_pins ripple_carry_adder_8_bit/b6] 
connect_bd_net -net [get_bd_nets gnd_dout] [get_bd_pins ripple_carry_adder_8_bit/b7] 
connect_bd_net -net [get_bd_nets gnd_dout] [get_bd_pins ripple_carry_adder_8_bit/a4] 
connect_bd_net -net [get_bd_nets gnd_dout] [get_bd_pins ripple_carry_adder_8_bit/a5] 
connect_bd_net -net [get_bd_nets gnd_dout] [get_bd_pins ripple_carry_adder_8_bit/a6] 
connect_bd_net -net [get_bd_nets gnd_dout] [get_bd_pins ripple_carry_adder_8_bit/a7] 
connect_bd_net -net [get_bd_nets gnd_dout] [get_bd_pins carry_save_adder_4_bit1/z0] 

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ripple_carry_adder_8_bit/gnd
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells ripple_carry_adder_8_bit/gnd]
connect_bd_net [get_bd_pins ripple_carry_adder_8_bit/gnd/dout] [get_bd_pins ripple_carry_adder_8_bit/ripple_carry_adder_4_bit/c_in]


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
set_property -name {xsim.simulate.xsim.more_options} -value {-view ../../../../carry_save_adder_tb_behav.wcfg} -objects [current_fileset -simset]
set_property -name {xsim.simulate.runtime} -value {0 ns} -objects [current_fileset -simset]
launch_simulation
puts "Running Simulation for 3276800 ns"
puts "The testbench will increment each input from 0-16 covering all input possibilities"
run 3276800 ns
puts "Simulation complete"


}
