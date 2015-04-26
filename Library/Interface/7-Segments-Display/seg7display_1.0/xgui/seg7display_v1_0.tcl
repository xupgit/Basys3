# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "MODULES" -parent ${Page_0}
  ipgui::add_static_text $IPINST -name "Number of Modules" -parent ${Page_0} -text {Selecting 1 will provide one 16-bit input and one 4-bit anodes output ports. 
Selecting 2 will provide two 16-bit input and two 4-bit anodes output ports.
The IP expects 100 MHz input clock.}


}

proc update_PARAM_VALUE.MODULES { PARAM_VALUE.MODULES } {
	# Procedure called to update MODULES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MODULES { PARAM_VALUE.MODULES } {
	# Procedure called to validate MODULES
	return true
}


proc update_MODELPARAM_VALUE.MODULES { MODELPARAM_VALUE.MODULES PARAM_VALUE.MODULES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MODULES}] ${MODELPARAM_VALUE.MODULES}
}

