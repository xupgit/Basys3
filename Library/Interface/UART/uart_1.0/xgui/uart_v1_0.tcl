# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DVSR" -parent ${Page_0}
  set Status_signals_not_required [ipgui::add_param $IPINST -name "Status_signals_not_required" -parent ${Page_0}]
  set_property tooltip {Status signals not required} ${Status_signals_not_required}
  ipgui::add_param $IPINST -name "NO_RESET" -parent ${Page_0}


}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DVSR { PARAM_VALUE.DVSR } {
	# Procedure called to update DVSR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DVSR { PARAM_VALUE.DVSR } {
	# Procedure called to validate DVSR
	return true
}

proc update_PARAM_VALUE.NO_RESET { PARAM_VALUE.NO_RESET } {
	# Procedure called to update NO_RESET when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NO_RESET { PARAM_VALUE.NO_RESET } {
	# Procedure called to validate NO_RESET
	return true
}

proc update_PARAM_VALUE.Status_signals_not_required { PARAM_VALUE.Status_signals_not_required } {
	# Procedure called to update Status_signals_not_required when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Status_signals_not_required { PARAM_VALUE.Status_signals_not_required } {
	# Procedure called to validate Status_signals_not_required
	return true
}


proc update_MODELPARAM_VALUE.DVSR { MODELPARAM_VALUE.DVSR PARAM_VALUE.DVSR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DVSR}] ${MODELPARAM_VALUE.DVSR}
}

proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

