# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DELAY" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NBITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SIZE" -parent ${Page_0}
  ipgui::add_static_text $IPINST -name "Optional Ports" -parent ${Page_0} -text {When Shift Type is not checked then logical shift

When Direction is not checked then left shift}
  ipgui::add_param $IPINST -name "TYPE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DIR" -parent ${Page_0}


}

proc update_PARAM_VALUE.DELAY { PARAM_VALUE.DELAY } {
	# Procedure called to update DELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY { PARAM_VALUE.DELAY } {
	# Procedure called to validate DELAY
	return true
}

proc update_PARAM_VALUE.DIR { PARAM_VALUE.DIR } {
	# Procedure called to update DIR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DIR { PARAM_VALUE.DIR } {
	# Procedure called to validate DIR
	return true
}

proc update_PARAM_VALUE.NBITS { PARAM_VALUE.NBITS } {
	# Procedure called to update NBITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NBITS { PARAM_VALUE.NBITS } {
	# Procedure called to validate NBITS
	return true
}

proc update_PARAM_VALUE.SIZE { PARAM_VALUE.SIZE } {
	# Procedure called to update SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIZE { PARAM_VALUE.SIZE } {
	# Procedure called to validate SIZE
	return true
}

proc update_PARAM_VALUE.TYPE { PARAM_VALUE.TYPE } {
	# Procedure called to update TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TYPE { PARAM_VALUE.TYPE } {
	# Procedure called to validate TYPE
	return true
}


proc update_MODELPARAM_VALUE.SIZE { MODELPARAM_VALUE.SIZE PARAM_VALUE.SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIZE}] ${MODELPARAM_VALUE.SIZE}
}

proc update_MODELPARAM_VALUE.DELAY { MODELPARAM_VALUE.DELAY PARAM_VALUE.DELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY}] ${MODELPARAM_VALUE.DELAY}
}

proc update_MODELPARAM_VALUE.NBITS { MODELPARAM_VALUE.NBITS PARAM_VALUE.NBITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NBITS}] ${MODELPARAM_VALUE.NBITS}
}

