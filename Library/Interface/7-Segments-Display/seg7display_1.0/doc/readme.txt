Tool and version:  Vivado 2014.4 
Target Families: Artix-7, Kintex-7, Virtex-7, and Zynq

Introduction:
This interface IP displays either a 16-bit or 32-bit input, consists of either 4 or 8 nibbles data, on either one or two modules having 4 7-segments displays each. It expects either 16-bit or 32-bit input data, typically driven through GPIO port, 100 MHz clock input, and high-level reset signal. It outputs either 4 or 8 anode controls at approximately 50 Hz. The decimal point on the display is turned ON or OFF based on the configurable parameter of individual segment's decimal point. The section is based on configurable parameter MODULES. If MODULES=0 then it expects 16-bit input and will output 4 anode and time-multiplexed one decimal point signals, otherwise it expects 32-bit input and will output 8 anode and time-multiplexed two decimal point signals.

Input/Output Ports:
Input:
clk - 100 MHz clock
reset - high-level logic
x_l - 16-bit input composed of four nibbles. Bits [3:0] is the least significant whose value is displayed on the right-most module. Bits [31:28] is the most significant whose value is displayed on the left-most segment of the right side module.
x_h - 16-bit input composed of four nibbles. Bits [3:0] is the least significant whose value is displayed on the right-most module. Bits [31:28] is the most significant whose value is displayed on the left-most segment of the left side module.

Output:
a_to_g - 7-bit output controlling 7 segments. The least-significant bit controls segment "a" where as the most-significant bit controls segment "g".
an_l - 4-bit output controlling enabling of four anodes of the right-most module at roughly 50 Hz rate.The least-significant bit controls right-most segment where as the most-significant bit controls left-most segment. 
an_h - 4-bit output controlling enabling of four anodes of the left-most module at roughly 50 Hz rate.The least-significant bit controls right-most segment where as the most-significant bit controls left-most segment. 
dp_l - controls whether the corresponding decimal point to be turned ON or not. This will be to control right-most module
dp_h - controls whether the corresponding decimal point to be turned ON or not. This will be to control left-most module

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
