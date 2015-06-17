Tool and version:  Vivado 2014.4 
Target Families: Artix-7, Kintex-7, Virtex-7, and Zynq

Introduction:
This IP is a member of XUP_LIB created by XUP. The XUP_LIB provides the basic gates/functionality that can be used in digital design.This IP has selectable dir and shift_type input ports. When the ports are not selected, dir is tied to logic0 (right shift) and shift_type is tied to logic0 (logical shift). 

The configurable parameters are SIZE, DELAY, and NBITS.  The SIZE is the size of parallel_in and parallel_out ports, and NBITS is the number of bits to be shifted.

Input/Output Ports:
Input:
parallel_in - vector input port
shift_type - type of shift, when not selected it is tied to logic0 (logical)
dir - direction, 1 means left and 0 means right, when not selected it is tied to logic0

Output:
parallel_out - vectored output, selectable 

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
