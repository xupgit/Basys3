# Digital Clock
This project is about creating a digital clock showing MM.SS using XUP_LIB components. You must download the XUP_LIB directory from the GitHub and then set the XUP_LIB path. You must also download Basys3 board files directory from the GitHub and place it in the **\<Vivado_install_directory>\2014.4\data\boards\board_parts\artix7** directory. 

The project source files provide Tcl script, and a Xilinx Design Constraint (xdc) file targeting Basys3 board.

### Design Description:
The digital clock is built using counters, comparators, concat, bin2bcd, and 7-segment display IPs available in XUP_LIB and Vivado's standard installation directory. It also uses clocking wizard to generate 5 MHz clock from on-board 100 MHz clock source. The generated 5 MHz clock is further divided to generate 1 Hz clock signal. There are two counters and two 7-segment display instances, one set for seconds and another for the minutes. Since the board only has 4 7-segment displays, hours are not displayed. One can extend the design by displaying hours on LEDs.

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

**source ./digital_clock.tcl**

5\. Once the project is created, the resulting block diagram will be displayed. View through the block diagram, its hierarchy and analyze the design

6\. Generate the bitstream by clicking on the Generate Bitstream under the Program and Debug group. A warning message box will appear. Click OK to ignore it

7\. When the bitstream generation is completed, connect the board, power ON the board, and use the Open Hardware Manager option to connect to the board

8\. Program the board and verify the functionality

Input : Center button to reset the clock. Keep it pressed for about 1 second
Output : 4 7-segments module
