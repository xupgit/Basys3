Tool and version:  Vivado 2014.4 
Target Families: Artix-7, Kintex-7, Virtex-7, and Zynq

Introduction:
This IP is a member of XUP_LIB created by XUP. This IP provides Binary to BCD conversion. The Binary input width is constrained between 3 and 14 bits using SIZE as a configurable parameter. Depending on the width, tens, hundreds, and thousands ports may become visible.  

Setting up the library path:
Create a Vivado project. Click on the Project Settings, then click on the IP block in the left panel, click on the Add Repository... button, browse to the directory where the XUP_LIB directory is located, and click Select. The IP entry should be visible in the IP in the Selected Repository. 

Configurable Paramerter:
SIZE - constrained between 3 and 14. Size of 4, 5, or 6 will make tens port visible. Size of 7, 8 or 9 will make hundreds port visible. Size of 10 or higher will make thousands port visible.
Input:
a_in - Binary input
Output:
ones - ones output
tens - tens output
hundreds - hundreds output

How to use the IP:
Step 1: Create a Vivado project
Step 2: Set the Project Settings to point to the XUP_LIB path
Step 3: Create a block design
Step 4: Add the desired IP on the canvas, connect them, and add external input and output ports
Step 5: Create a HDL wrapper
Step 6: Add constraints file (.xdc)
Step 7: Synthesize, implement, and generate the bitstream
Step 8: Connect the board, download the bitstream, and verify the design


Change log

