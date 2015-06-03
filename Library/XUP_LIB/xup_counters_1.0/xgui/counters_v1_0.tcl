# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "COUNT_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TYPE" -parent ${Page_0} -layout horizontal


}

proc update_PARAM_VALUE.COUNT_SIZE { PARAM_VALUE.COUNT_SIZE } {
	# Procedure called to update COUNT_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COUNT_SIZE { PARAM_VALUE.COUNT_SIZE } {
	# Procedure called to validate COUNT_SIZE
	return true
}

proc update_PARAM_VALUE.TYPE { PARAM_VALUE.TYPE } {
	# Procedure called to update TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TYPE { PARAM_VALUE.TYPE } {
	# Procedure called to validate TYPE
	return true
}


proc update_MODELPARAM_VALUE.COUNT_SIZE { MODELPARAM_VALUE.COUNT_SIZE PARAM_VALUE.COUNT_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COUNT_SIZE}] ${MODELPARAM_VALUE.COUNT_SIZE}
}

