#Pin constraints for XUPLIB sequence_detector_moore design for Basys 3
## Clock signal
## SW15 as Clock signal
set_property PACKAGE_PIN R2 [get_ports sys_clock]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets sys_clock_IBUF]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clock]

# pushbutton BtnC
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# SW0
set_property PACKAGE_PIN V17 [get_ports ain]
set_property IOSTANDARD LVCMOS33 [get_ports ain]

# LEDs
set_property IOSTANDARD LVCMOS33 [get_ports {count[*]}]
set_property PACKAGE_PIN U16 [get_ports {count[0]}]
set_property PACKAGE_PIN E19 [get_ports {count[1]}]
set_property PACKAGE_PIN U19 [get_ports {count[2]}]
set_property PACKAGE_PIN V19 [get_ports {count[3]}]

# LED15
set_property PACKAGE_PIN L1 [get_ports detected]
set_property IOSTANDARD LVCMOS33 [get_ports detected]

