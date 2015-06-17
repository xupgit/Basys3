#Pin constraints for XUPLIB 8 bit x 8 bit multiplier design for Basys 3
## Clock signal
set_property PACKAGE_PIN W5 [get_ports sys_clock]					
set_property IOSTANDARD LVCMOS33 [get_ports sys_clock]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports sys_clock]
    
# pushbutton BtnC  
set_property PACKAGE_PIN U18 [get_ports {start}]				
set_property IOSTANDARD LVCMOS33 [get_ports {start}]

## Switches
set_property IOSTANDARD LVCMOS33 [get_ports {multiplicand_in[*]}]
set_property PACKAGE_PIN V17 [get_ports {multiplicand_in[0]}]	
set_property PACKAGE_PIN V16 [get_ports {multiplicand_in[1]}]	
set_property PACKAGE_PIN W16 [get_ports {multiplicand_in[2]}]	
set_property PACKAGE_PIN W17 [get_ports {multiplicand_in[3]}]	
set_property PACKAGE_PIN W15 [get_ports {multiplicand_in[4]}]	
set_property PACKAGE_PIN V15 [get_ports {multiplicand_in[5]}]	
set_property PACKAGE_PIN W14 [get_ports {multiplicand_in[6]}]	
set_property PACKAGE_PIN W13 [get_ports {multiplicand_in[7]}]	

set_property IOSTANDARD LVCMOS33 [get_ports {multiplier_in[*]}]
set_property PACKAGE_PIN V2 [get_ports {multiplier_in[0]}]		
set_property PACKAGE_PIN T3 [get_ports {multiplier_in[1]}]		
set_property PACKAGE_PIN T2 [get_ports {multiplier_in[2]}]		
set_property PACKAGE_PIN R3 [get_ports {multiplier_in[3]}]		
set_property PACKAGE_PIN W2 [get_ports {multiplier_in[4]}]		
set_property PACKAGE_PIN U1 [get_ports {multiplier_in[5]}]		
set_property PACKAGE_PIN T1 [get_ports {multiplier_in[6]}]		
set_property PACKAGE_PIN R2 [get_ports {multiplier_in[7]}]				
    
# LEDs
set_property IOSTANDARD LVCMOS33 [get_ports {result[*]}]
set_property PACKAGE_PIN U16 [get_ports {result[0]}]			
set_property PACKAGE_PIN E19 [get_ports {result[1]}]			
set_property PACKAGE_PIN U19 [get_ports {result[2]}]			
set_property PACKAGE_PIN V19 [get_ports {result[3]}]			
set_property PACKAGE_PIN W18 [get_ports {result[4]}]			
set_property PACKAGE_PIN U15 [get_ports {result[5]}]			
set_property PACKAGE_PIN U14 [get_ports {result[6]}]			
set_property PACKAGE_PIN V14 [get_ports {result[7]}]			
set_property PACKAGE_PIN V13 [get_ports {result[8]}]			
set_property PACKAGE_PIN V3 [get_ports {result[9]}]			
set_property PACKAGE_PIN W3 [get_ports {result[10]}]			
set_property PACKAGE_PIN U3 [get_ports {result[11]}]			
set_property PACKAGE_PIN P3 [get_ports {result[12]}]			
set_property PACKAGE_PIN N3 [get_ports {result[13]}]			
set_property PACKAGE_PIN P1 [get_ports {result[14]}]			
set_property PACKAGE_PIN L1 [get_ports {result[15]}]				
    
