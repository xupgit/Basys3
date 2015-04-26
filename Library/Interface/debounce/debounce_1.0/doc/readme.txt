Tool and version:  Vivado 2014.4 
Target Families: Artix-7, Kintex-7, Virtex-7, and Zynq

Introduction:
This interface IP debounces input typically coming from a push-button and output. It expects a clock, by default 100 MHz, an input from a button, and a high level reset input.It outputs a debounced output. The default debounce time is 10 ms. 
The configurable parameters are clock input frequency in MHz and the debounce time in second.  

Input/Output Ports:
Input:
clk - 100 MHz clock, default, but can be different
reset - high-level logic
i - an input which needs to be debounced.

Output:
o - debounced output 

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
