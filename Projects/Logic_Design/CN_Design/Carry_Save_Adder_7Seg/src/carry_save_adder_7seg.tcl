# Script to create an adder capable of adding four 4-bit numbers 
# using 4-bit carry save adder using XUP_LIB components. 
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
# After sourcing this script, run_sim can be executed to drive simulation from proc at bottom of this file
# Once simulation is running (either from the GUI, or from this script) test_pattern can be executed to drive 
# simulation input values defined at the bottom of this file
#
# Four 4-bit inputs (operands), x, y, z and w, are connected to the dip switches (a sw0-3, b sw 4-7, c sw 8-11, d sw 12-15)
# Pressing Center button resets the 7-segment display
# The 6-bit outputs are connected to LEDs 0-5 
# The outputs are also displayed on the 7-segment display in the BCD format
# 
# -------------------------------------------------------------- #
# SET 'basys3_github' PATH TO GITHUB LIBRARY BEFORE RUNNING
# -------------------------------------------------------------- #
set basys3_github {C:/xup/IPI_LIB/XUP_LIB}

set project_directory .
set project_name carry_save_adder_7seg
set constraints_directory $project_directory
set constraints_file carry_save_adder_7seg_basys3_pins.xdc
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
# Copy full adder 4 times to make a 4-bit carry save adder
# Copy and add another instance of the carry save adder
# Using full-adder create a 6-bit ripple carry adder
# Convert the 6-bit binary output to BCD
# Connect the BCD outputs to the 7-segment display

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



# outputs
# create_bd_port -dir O s0
# connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/s0] [get_bd_ports s0]
# create_bd_port -dir O s1
# connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/s1] [get_bd_ports s1]
# create_bd_port -dir O s2
# connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/s2] [get_bd_ports s2]
# create_bd_port -dir O s3
# connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/s3] [get_bd_ports s3]
# create_bd_port -dir O c0
# connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/c0] [get_bd_ports c0]
# create_bd_port -dir O c1
# connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/c1] [get_bd_ports c1]
# create_bd_port -dir O c2
# connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/c2] [get_bd_ports c2]
# create_bd_port -dir O c3
# connect_bd_net [get_bd_pins /carry_save_adder_4_bit1/c3] [get_bd_ports c3]
# create_bd_port -dir O c4
# connect_bd_net [get_bd_pins /carry_save_adder_4_bit/c3] [get_bd_ports c4]


###########################################################################
## Ripple carry adder for last stage
###########################################################################

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

# carry in
#create_bd_pin -dir I /ripple_carry_adder_8_bit/c_in
#connect_bd_net [get_bd_pins /ripple_carry_adder_8_bit/ripple_carry_adder_8_bit/c_in] [get_bd_pins /ripple_carry_adder_8_bit/c_in]
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

## END Ripple Carry Adder


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

# Convert the 6-bit binary output to BCD
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property -dict [list CONFIG.NUM_PORTS {6}] [get_bd_cells xlconcat_0]
connect_bd_net -net [get_bd_nets carry_save_adder_4_bit1_s0] [get_bd_pins xlconcat_0/In0] [get_bd_pins carry_save_adder_4_bit1/s0]
connect_bd_net -net [get_bd_nets ripple_carry_adder_8_bit_o0] [get_bd_pins xlconcat_0/In1] [get_bd_pins ripple_carry_adder_8_bit/o0]
connect_bd_net -net [get_bd_nets ripple_carry_adder_8_bit_o1] [get_bd_pins xlconcat_0/In2] [get_bd_pins ripple_carry_adder_8_bit/o1]
connect_bd_net -net [get_bd_nets ripple_carry_adder_8_bit_o2] [get_bd_pins xlconcat_0/In3] [get_bd_pins ripple_carry_adder_8_bit/o2]
connect_bd_net -net [get_bd_nets ripple_carry_adder_8_bit_o3] [get_bd_pins xlconcat_0/In4] [get_bd_pins ripple_carry_adder_8_bit/o3]
connect_bd_net -net [get_bd_nets ripple_carry_adder_8_bit_o4] [get_bd_pins xlconcat_0/In5] [get_bd_pins ripple_carry_adder_8_bit/o4]
create_bd_cell -type ip -vlnv xilinx.com:XUP:bin2bcd:1.0 bin2bcd_0
set_property -dict [list CONFIG.SIZE {6}] [get_bd_cells bin2bcd_0]
connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins bin2bcd_0/a_in]


# Connect the BCD outputs to the 7-segment display
create_bd_cell -type ip -vlnv xilinx.com:XUP:seg7display:1.0 seg7display_0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property -dict [list CONFIG.CONST_WIDTH {8} CONFIG.CONST_VAL {0}] [get_bd_cells xlconstant_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_0
set_property -dict [list CONFIG.USE_LOCKED {false} CONFIG.USE_RESET {false}] [get_bd_cells clk_wiz_0]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins seg7display_0/clk]
create_bd_port -dir I -type clk sys_clock
connect_bd_net [get_bd_pins /clk_wiz_0/clk_in1] [get_bd_ports sys_clock]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1
set_property -dict [list CONFIG.NUM_PORTS {3}] [get_bd_cells xlconcat_1]
connect_bd_net [get_bd_pins xlconcat_1/In0] [get_bd_pins bin2bcd_0/ones]
connect_bd_net [get_bd_pins xlconcat_1/In1] [get_bd_pins bin2bcd_0/tens]
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins xlconcat_1/In2]
connect_bd_net [get_bd_pins xlconcat_1/dout] [get_bd_pins seg7display_0/x_l]
create_bd_port -dir I -type rst reset
connect_bd_net [get_bd_pins /seg7display_0/reset] [get_bd_ports reset]
create_bd_port -dir O -from 6 -to 0 a_to_g
connect_bd_net [get_bd_pins /seg7display_0/a_to_g] [get_bd_ports a_to_g]
create_bd_port -dir O -from 3 -to 0 an_l
connect_bd_net [get_bd_pins /seg7display_0/an_l] [get_bd_ports an_l]
set_property name seg [get_bd_ports a_to_g]
set_property name an [get_bd_ports an_l]
regenerate_bd_layout
save_bd_design

# Create top HDL wrapper
make_wrapper -files [get_files $project_directory/$project_name/$project_name.srcs/sources_1/bd/$project_name/$project_name.bd] -top
add_files -norecurse $project_directory/$project_name/$project_name.srcs/sources_1/bd/$project_name/hdl/$project_name\_wrapper.v
# Add pin constraints
add_files -fileset constrs_1 -norecurse $constraints_directory/$constraints_file
