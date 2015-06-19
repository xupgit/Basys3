#Pin constraints for XUPLIB 8 bit x 8 bit divisor design for Basys 3
## Clock signal
set_property PACKAGE_PIN W5 [get_ports sys_clock]					
set_property IOSTANDARD LVCMOS33 [get_ports sys_clock]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports sys_clock]
    
# pushbutton BtnC  
set_property PACKAGE_PIN U18 [get_ports {start}]				
set_property IOSTANDARD LVCMOS33 [get_ports {start}]

# done routed to one of the JB pins  
set_property PACKAGE_PIN A14 [get_ports {done}]				
set_property IOSTANDARD LVCMOS33 [get_ports {done}]

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
    
# LEDs
set_property IOSTANDARD LVCMOS33 [get_ports {Remainder[*]}]
set_property PACKAGE_PIN U16 [get_ports {Remainder[0]}]			
set_property PACKAGE_PIN E19 [get_ports {Remainder[1]}]			
set_property PACKAGE_PIN U19 [get_ports {Remainder[2]}]			
set_property PACKAGE_PIN V19 [get_ports {Remainder[3]}]			
set_property PACKAGE_PIN W18 [get_ports {Remainder[4]}]			
set_property PACKAGE_PIN U15 [get_ports {Remainder[5]}]			
set_property PACKAGE_PIN U14 [get_ports {Remainder[6]}]			
set_property PACKAGE_PIN V14 [get_ports {Remainder[7]}]			
set_property IOSTANDARD LVCMOS33 [get_ports {Quotient[*]}]
set_property PACKAGE_PIN V13 [get_ports {Quotient[0]}]			
set_property PACKAGE_PIN V3 [get_ports {Quotient[1]}]			
set_property PACKAGE_PIN W3 [get_ports {Quotient[2]}]			
set_property PACKAGE_PIN U3 [get_ports {Quotient[3]}]			
set_property PACKAGE_PIN P3 [get_ports {Quotient[4]}]			
set_property PACKAGE_PIN N3 [get_ports {Quotient[5]}]			
set_property PACKAGE_PIN P1 [get_ports {Quotient[6]}]			
set_property PACKAGE_PIN L1 [get_ports {Quotient[7]}]
