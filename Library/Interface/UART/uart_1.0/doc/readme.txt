Tool and version:  Vivado 2014.4 
Target Families: Artix-7, Kintex-7, Virtex-7, and Zynq

Introduction:
This interface IP provides serial communication using 100 MHz input clock. It supports 9600, 19200, 38400, 57600, and 115200 baud rates selected through configuration.


Input/Output Ports:
Input:
clk - 100 MHz clock
reset - high-level logic
rx - serial data input
send - a pulse to start transmitting the data
data-in - parallel data to be serially transmitted

Output:
data-out - parallel data received
rx_done - status signal indicating data is received
tx_done - status signal indicating data transmission is completed
tx - serial data output

Setting up the library path:
Create a Vivado project. Click on the Project Settings, then click on the IP block in the left panel, click on the Add Repository... button, browse to the directory where this IP directory is located, and click Select. The IP entry should be visible in the IP in the Selected Repository. 

How to use the IP:
Step 1: Create a Vivado project
Step 2: Set the Project Settings to point to the IP path
Step 3: Create a block design
Step 4: Add the desired IP on the canvas, connect them, and add external input and output ports
Step 5: Create a HDL wrapper
Step 6: Add constraints file (.xdc)
Step 7: Synthesize, implement, and generate the bitstream
Step 8: Connect the board, download the bitstream, and varify the design
