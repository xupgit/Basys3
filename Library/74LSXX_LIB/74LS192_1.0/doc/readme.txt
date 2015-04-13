Tool and version:  Vivado 2014.4 
Target Families: Artix-7, Kintex-7, Virtex-7, and Zynq

Introduction:
This IP is a member of 74LSxx_LIB created by XUP. The 74LSxx_LIB provides the basic IPs having same number and types of gates/functionality that one can find in 74LS IC series. Some of the IP have testbench which can be used to simulated the IP in XSIM. In order to perform the simulation, instantiate the IP in HDL flow and then add the testbech. 

Description of Ports:
Input Ports:
cpu : Count Up Clock Pulse Input
cpd : Count Down Clock Pulse Input
pl_n : Asynchronous Parallel Load (Active LOW) Input
mr : Asynchronous Master Reset (Clear) Input
p3,p2,p1,p0 : Parallel Data Inputs

Output Ports:
q3,q2,q1,q0 : Flip-Flop Outputs
tcu_n : Terminal Count Up (Carry) Output
tcd_n : Terminal Count Down (Borrow) Output

Setting up the library path:
Create a Vivado project. Click on the Project Settings, then click on the IP block in the left panel, click on the Add Repository... button, browse to the directory where the 74LSxx_LIB directory is located, and click Select. The IP entry should be visible in the IP in the Selected Repository. 

How to use the IP:
Step 1: Create a Vivado project
Step 2: Set the Project Settings to point to the 74LSxx_LIB path
Step 3: Create a block design
Step 4: Add the desired IP on the canvas, connect them, and add external input and output ports
Step 5: Create a HDL wrapper
Step 6: Add constraints file (.xdc)
Step 7: Synthesize, implement, and generate the bitstream
Step 8: Connect the board, download the bitstream, and verify the design


Change log

