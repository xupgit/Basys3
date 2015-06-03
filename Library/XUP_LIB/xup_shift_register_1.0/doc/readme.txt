Tool and version:  Vivado 2014.4 
Target Families: Artix-7, Kintex-7, Virtex-7, and Zynq

Introduction:
This IP is a member of XUP_LIB created by XUP. The XUP_LIB provides the basic gates/functionality that can be used in digital design.This IP has selectable load, en, dir, parallel_in input ports and parallel_out output ports. When the ports are not selected, load is tied to logic0, en is tied to logic1, dir i stied to logic0 (right-shift), and parallel_in is tied to 0.

The configurable parameters are SIZE and DELAY.  

Input/Output Ports:
Input:
clk - 100 MHz clock, default, but can be different
shift_in - serial data in
parallel_in - vector input port, when not selected it is tied to 0
load - load parallel data, when not selected it is tied to logic0 (no-load)
en - enable shifting, when not selected it is tied to logic1 (always shifting)
dir - direction, 1 means left and 0 means right, when not selected it is tied to logic0

Output:
shift_out - shifted output
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
