# Basys3 Github
This repository provides Digital Design Libraries and Projects for Vivado IP Integrator targeting the [Xilinx University Program (XUP) **Basys3 board** from Digilent](www.digilentinc.com/Products/Detail.cfm?NavPath=2,400,1288&Prod=BASYS3).


The board features an Artix series 7 Xilinx FPGA and is an ideal platform for low cost teaching and student projects.
For questions, please contact the [Xilinx University Program](mailto:xup@xilinx.com).

### How to use these files

Digilient YouTube overview:
http://youtu.be/nJ4LgLWuEcM

<a href="http://www.youtube.com/watch?feature=player_embedded&v=nJ4LgLWuEcM" target="_blank"><img src="http://img.youtube.com/vi/nJ4LgLWuEcM/0.jpg" 
alt="Digilent YouTube guide" width="240" height="180" border="10" /></a>

### Basys3 Board Files
Download the Basys3 board files (basys3.zip) file and extract it here: **\<Vivado_install_directory>\2014.4\data\boards\board_parts\artix7** directory. (This has been tested with Vivado 2014.4 but should work with other versions.) After doing this, the board can be selected when creating a project in Vivado.


### XUP_LIB and 74LSXX
There are two digital libraries for Vivado IP Integrator that include basic logic blocks for schematic entry and teaching basic logic design; XUP_LIB (AND, OR, NOT, XOR etc) and 74LSXX models. 
These libraries include IP blocks are intended for classroom teaching and can be used with the Vivado IP integrator graphical environment to design, simulate and build designs for Xilinx FPGAs using schematics.

## To use the libraries
Create a new Vivado project, and in the *Project settings* (In Vivado, Tools > Project Settings), select the IP tab, and in the *Repository Manager* tab, add the directory of the XUP_LIB and/or 74LSXX folders. You will then be able to add these IP blocks to your designs in IP integrator. 

## To use a project
e.g. Ripple Carry Adder: ./Projects/Logic_Design/CN_Design/Ripple_Carry_Adder
See the readme.md file in the root directory of the project.

The project can be built by opening Vivado, and running the script provided for each project. 

You can open the script, which is commented, to understand how the project is built
