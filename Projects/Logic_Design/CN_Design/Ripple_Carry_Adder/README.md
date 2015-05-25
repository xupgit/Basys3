# Ripple-Carry Adder
This project creates an 8-bit ripple-carry adder using XUP_LIB components. You must download the XUP_LIB directory from the GitHub and then set the XUP_LIB path. You must also download the Basys3 board files directory from the GitHub and place it in the **\<Vivado_install_directory>\2014.4\data\boards\board_parts\artix7** directory. 

The project source files include a Tcl script, Xilinx Design Constraint (xdc) file targeting Basys3 board, testbench, and a wave configuration (wcfg) file.

### Design Description:
The 8-bit adder is built from two 4-bit ripple-carry adders. The 4-bit ripple-carry adder is built from four full adders. The full adder is built from two half adders. The hierarchy of the design can be explored by opening or expanding the hierarchical blocks.

### Tools and requirements:
* Vivado 2014.4
* XUP_LIB from GitHub
* Basys3 board files from GitHub
  
### Procedure:
Execute the commands **in bold** in the tcl console

1\. Start Vivado 

2\. Set a variable *basys3_github* to the XUP_LIB path in the Vivado Tcl Console. Note the path uses "/" instead of "\". Substitute the path to where you have saved the XUP_LIB library:

**set basys3_github {C:/xup/IPI_LIB/XUP_LIB}**

3\. Change to the *src* directory of this project using the *cd* command:

**cd \<path to this project directory>**

4\. Execute the following command to run the script:

**source ./ripple_carry_adder.tcl**

5\. Once the project is created, the resulting block diagram will be displayed. View the block diagram, double click or expand blocks to navigate the hierarchy and analyze the design
6\. Execute the following command to run the behavioral simulation:

**run_sim**

7\. Analyze the results and notice the output transitioning after the input changes. When satisfied, close the simulator:

**close_sim** 

8\. Generate the bitstream by clicking on the *Generate Bitstream* under the *Program and Debug* group

9\. When the bitstream generation is completed, connect the board, power ON the board, and use the *Open Hardware Manager* option to connect to the board

10\. *Program* the board and verify the functionality 

Input 1		: Dipswitches 0-7

Input 2		: Dipswitches 8-15

Result 		: Leds 0-7

Carry In	: Centre pushbutton

Carry Out	: Led 15



