### Carry Save Adder
This project is about creating an adder which adds four 4-bit operands using carry save adders and ripple carry adder. The inputs are from 16 switches grouped into four 4-bit input. The outputs are displayed in binary format on the six LEDs and in BCD format on the 7-segment display module. The design is created using XUP_LIB components. You must download the XUP_LIB directory from the GitHub and then set the XUP_LIB path. You must also download Basys3 board files directory from the GitHub and place it in the **\<Vivado_install_directory>\2014.4\data\boards\board_parts\artix7** directory. 

The project source files provide Tcl script, and a Xilinx Design Constraint (xdc) file targeting Basys3 board.

### Design Description:
Ripple carry adders are inherently slow. To speed up the addition operation of multiple operands carry save adder topology may be used. The design is built using basic gates, concat, bin2bcd, and 7-segment display IPs available in XUP_LIB. It also uses clocking wizard to provide 100 MHz clock to the 7-segment display IP to refresh the output at approximately 250 Hz.

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

**source ./carry_save_adder_7seg.tcl**

5\. Once the project is created, the resulting block diagram will be displayed. View through the block diagram, its hierarchy and analyze the design

6\. Generate the bitstream by clicking on the Generate Bitstream under the Program and Debug group. A warning message box will appear. Click OK to ignore it

7\. When the bitstream generation is completed, connect the board, power ON the board, and use the Open Hardware Manager option to connect to the board

8\. Program the board and verify the functionality

Input : Center button to reset the 7-segment display
Input : 16 switches to input four 4-bit operands
Output : 4 7-segments module displaying BCD equivalent result on the right-most two 7-segments
Output : Six LEDs displaying binary equivalent result

