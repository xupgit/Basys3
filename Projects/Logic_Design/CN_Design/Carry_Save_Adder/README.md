# Carry-Save Adder
This project creates an 8-bit Carry-Save adder using XUP_LIB components. You must download the XUP_LIB directory from the GitHub and then set the XUP_LIB path. You must also download the Basys3 board files directory from the GitHub and place it in the **\<Vivado_install_directory>\2014.4\data\boards\board_parts\artix7** directory. 

The project source files include a Tcl script, Xilinx Design Constraint (xdc) file targeting Basys3 board, verilog testbench, and a wave configuration (wcfg) file.

### Design Description:
This is a 4x 4-bit input adder, and the output is 6-bits. The adder is built from two 4-bit carry-save adders and an 8 bit ripple-carry adder. The ripple carry-adder is available as a separate project as part of this repository. 
The 4-bit carry save adder is built from four full adders. 
The full adder is built from two half adders. 
The hierarchy of the design can be explored by opening or expanding the hierarchical blocks  

### Tools and requirements:
* Vivado 2014.4
* XUP_LIB from GitHub
* Basys3 board files from GitHub
  
### Procedure:
Execute the commands **in bold** in the tcl console

1\. Start Vivado 

2\. At the tcl command line, set a variable *basys3_github* to the XUP_LIB path. Note the path uses "/" instead of "\". Substitute the path to where you have saved the XUP_LIB library:

**set basys3_github {C:/xup/IPI_LIB/XUP_LIB}**

3\. Change to the *src* directory of this project using the *cd* command:

**cd \<path to this project directory>**

4\. Execute the following command to run the script:

**source ./carry_save_adder.tcl**

5\. Once the project is created, the resulting block diagram will be displayed. View the block diagram, double click or expand blocks to navigate the hierarchy and analyze the design
6\. Execute the following command to run the behavioural simulation:

**run_sim**

7\. Analyze the results and notice the output transitioning after the input changes. When satisfied, close the simulator:

**close_sim** 

8\. Generate the bitstream by clicking on the *Generate Bitstream* under the *Program and Debug* group

9\. When the bitstream generation is completed, connect the board, power ON the board, and use the *Open Hardware Manager* option to connect to the board

10\. *Program* the board and verify the functionality 

Input 1		: Dipswitches 0-3

Input 2		: Dipswitches 4-7

Input 3		: Dipswitches 8-11

Input 4		: Dipswitches 12-15

Result 		: Leds 0-5



