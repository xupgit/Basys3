#Pin constraints for XUPLIB 8 bit x 8 bit divisor design for Basys 3
## Clock signal
set_property PACKAGE_PIN W5 [get_ports sys_clock]					
set_property IOSTANDARD LVCMOS33 [get_ports sys_clock]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports sys_clock]
    
# pushbutton BtnC  
set_property PACKAGE_PIN U18 [get_ports {start}]				
set_property IOSTANDARD LVCMOS33 [get_ports {start}]

# LED15
set_property IOSTANDARD LVCMOS33 [get_ports {done}]
set_property PACKAGE_PIN L1 [get_ports {done}]				

## Switches
set_property IOSTANDARD LVCMOS33 [get_ports {dividend_in[*]}]
set_property PACKAGE_PIN V17 [get_ports {dividend_in[0]}]	
set_property PACKAGE_PIN V16 [get_ports {dividend_in[1]}]	
set_property PACKAGE_PIN W16 [get_ports {dividend_in[2]}]	
set_property PACKAGE_PIN W17 [get_ports {dividend_in[3]}]	
set_property PACKAGE_PIN W15 [get_ports {dividend_in[4]}]	
set_property PACKAGE_PIN V15 [get_ports {dividend_in[5]}]	
set_property PACKAGE_PIN W14 [get_ports {dividend_in[6]}]	
set_property PACKAGE_PIN W13 [get_ports {dividend_in[7]}]	

set_property IOSTANDARD LVCMOS33 [get_ports {divisor_in[*]}]
set_property PACKAGE_PIN V2 [get_ports {divisor_in[0]}]		
set_property PACKAGE_PIN T3 [get_ports {divisor_in[1]}]		
set_property PACKAGE_PIN T2 [get_ports {divisor_in[2]}]		
set_property PACKAGE_PIN R3 [get_ports {divisor_in[3]}]		
set_property PACKAGE_PIN W2 [get_ports {divisor_in[4]}]		
set_property PACKAGE_PIN U1 [get_ports {divisor_in[5]}]		
set_property PACKAGE_PIN T1 [get_ports {divisor_in[6]}]		
set_property PACKAGE_PIN R2 [get_ports {divisor_in[7]}]				
    
# 7-seg display
##7 segment display
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


