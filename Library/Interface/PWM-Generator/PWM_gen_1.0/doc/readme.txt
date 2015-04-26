Tool and version:  Vivado 2014.4 
Target Families: Artix-7, Kintex-7, Virtex-7, and Zynq

Introduction:
This interface IP generates a pulse width modulated output. It expects 100 MHz clock input and produces the output whose frequency is configurable in Hz and varying duty cycle based on the 10-bit duty cycle input. The duty cycle resolution is about 0.1 percent.   

Input/Output Ports:
Input:
clk - 100 MHz clock
reset - high-level logic
duty - 10-bit input providing about 0.1 percent resolution.

Output:
PWM - Pulse Width Modulated output 

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
