# Booth_Multiplier_7Seg
This project is about creating an 8-bit x 8-bit multiplier using Booth's algorithm and displaying the result on the 7-segment modules using XUP_LIB components. You must download the XUP_LIB directory from the GitHub and then set the XUP_LIB path. You must also download Basys3 board files directory from the GitHub and place it in the **\<Vivado_install_directory>\2014.4\data\boards\board_parts\artix7** directory. 

The project source files provide Tcl script, and a Xilinx Design Constraint (xdc) file targeting Basys3 board.

### Design Description:
The design is built using counter, comparators, concat, adder/subtractor, d-ffs, slice, or, xor, shift, multiplexors, bin2bcd, and 7-segment display IPs available in XUP_LIB and Vivado's standard installation directory. It on-board 100 MHz clock source. The unsigned result is displayed on the 7-segment modules and the sign of the result is indicated on the LED15.

### Tools and other requirements:
* Vivado 2014.4
* XUP_LIB from GitHub
* Basys3 board files from GitHub
  
### Procedure:
Execute the commands **in bold** in the tcl console

1\. Start Vivado in a GUI mode

2\. Set the path *basys3_github* to the XUP_LIB using command like in the Vivado Tcl Console. Note the path uses "/" instead of "\". Substiture the path where you have stored the XUP_LIB library.

**set basys3_github {C:/xup/IPI_LIB/XUP_LIB}**

3\. Change to the *src* directory of this project directory using the cd command, keeping in mind to use "/" instead of "\" in the directory

**cd \<path to this project directory>**

4\. Next, execute the following command to run the script

**source ./booth_multiplier_7seg.tcl**

5\. Once the project is created, the resulting block diagram will be displayed. View through the block diagram, its hierarchy and analyze the design

6\. Generate the bitstream by clicking on the Generate Bitstream under the Program and Debug group. 

7\. When the bitstream generation is completed, connect the board, power ON the board, and use the Open Hardware Manager option to connect to the board

8\. Program the board and verify the functionality

Input : SW15-SW8 for the multiplier
        SW7-SW0 for the multiplicand
        Center button to start the computation. 
Output : 4 7-segments module showing unsigned result
         LED15 showing the sign of the result

