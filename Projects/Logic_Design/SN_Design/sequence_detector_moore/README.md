# Sequence Detector Moore Machine
This project is about creating a sequence detector using Moore state machine. You must download the XUP_LIB directory from the GitHub and then set the XUP_LIB path. You must also download Basys3 board files directory from the GitHub and place it in the **\<Vivado_install_directory>\2014.4\data\boards\board_parts\artix7** directory. 

The project source files provide Tcl script, and a Xilinx Design Constraint (xdc) file targeting Basys3 board.

### Design Description:
Design a sequence detector implementing a Moore state machine. The state machine has one input (ain) and one output (detect). The output detect is 1 if and only if the total number of 1s received is divisible by 3 (inclusive of 0). The design is built using counter, concat, d-ffs, slice, or, and other basic logic IPs available in XUP_LIB and Vivado's standard installation directory. It uses switch 15 as the clock input, center button as a reset input, switch 0 as the ain input, and LEDS as the output.

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

**source ./sequence_detector_moore.tcl**

5\. Once the project is created, the resulting block diagram will be displayed. View through the block diagram, its hierarchy and analyze the design

6\. Execute the following command to run the behavioural simulation:

**run_sim**

7\. Analyze the results and notice the output transitioning after the input changes. When satisfied, close the simulator:

**close_sim** 

8\. Generate the bitstream by clicking on the Generate Bitstream under the Program and Debug group. 

9\. When the bitstream generation is completed, connect the board, power ON the board, and use the Open Hardware Manager option to connect to the board

10\. Program the board and verify the functionality

Input : SW15 for the clock input
        SW0 for the ain input
        Center button to reset
Output : LED15 to indicate when the sequence is detected
         LED3-LED0 shows current count of number of ones



