# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CLK_INPUT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEBOUNCE_TIME" -parent ${Page_0}


}

proc update_PARAM_VALUE.CLK_INPUT { PARAM_VALUE.CLK_INPUT } {
	# Procedure called to update CLK_INPUT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLK_INPUT { PARAM_VALUE.CLK_INPUT } {
	# Procedure called to validate CLK_INPUT
	return true
}

proc update_PARAM_VALUE.DEBOUNCE_TIME { PARAM_VALUE.DEBOUNCE_TIME } {
	# Procedure called to update DEBOUNCE_TIME when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEBOUNCE_TIME { PARAM_VALUE.DEBOUNCE_TIME } {
	# Procedure called to validate DEBOUNCE_TIME
	return true
}


proc update_MODELPARAM_VALUE.DEBOUNCE_TIME { MODELPARAM_VALUE.DEBOUNCE_TIME PARAM_VALUE.DEBOUNCE_TIME } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEBOUNCE_TIME}] ${MODELPARAM_VALUE.DEBOUNCE_TIME}
}

proc update_MODELPARAM_VALUE.CLK_INPUT { MODELPARAM_VALUE.CLK_INPUT PARAM_VALUE.CLK_INPUT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLK_INPUT}] ${MODELPARAM_VALUE.CLK_INPUT}
}

