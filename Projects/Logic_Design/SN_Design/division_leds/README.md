# Division_leds
This project is about creating an 8-bit by 8-bit unsigned divider using non-restoring algorithm and displaying the result on the LEDs using XUP_LIB components. You must download the XUP_LIB directory from the GitHub and then set the XUP_LIB path. You must also download Basys3 board files directory from the GitHub and place it in the **\<Vivado_install_directory>\2014.4\data\boards\board_parts\artix7** directory. 

The project source files provide Tcl script, and a Xilinx Design Constraint (xdc) file targeting Basys3 board.

### Design Description:
The design is built using counter, comparators, concat, adder/subtractor, d-ffs, slice, or, xor, shift, and multiplexor IPs available in XUP_LIB and Vivado's standard installation directory. It uses on-board 100 MHz clock source. The result is displayed on LEDs.

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

**source ./division_leds.tcl**

5\. Once the project is created, the resulting block diagram will be displayed. View through the block diagram, its hierarchy and analyze the design

6\. Execute the following command to run the behavioural simulation:

**run_sim**

7\. Analyze the results and notice the output transitioning after the input changes. When satisfied, close the simulator:

**close_sim** 

8\. Generate the bitstream by clicking on the Generate Bitstream under the Program and Debug group. 

9\. When the bitstream generation is completed, connect the board, power ON the board, and use the Open Hardware Manager option to connect to the board

10\. Program the board and verify the functionality

Input : SW15-SW8 for the divisor
        SW7-SW0 for the dividend
        Center button to start the computation 
Output : LED15-LED8 shows quotient, LED7-LED0 shows remainder


