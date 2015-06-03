# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DELAY" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PARALLEL_IN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "EN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LOAD" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DIR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PARALLEL_OUT" -parent ${Page_0}
  ipgui::add_static_text $IPINST -name "Selectable Options" -parent ${Page_0} -text {parallel_in - When not selected it is tied to 0
load - When not selected it is tied to logic0 (no parallel load)
en - When not selected it is tied to logic1 (always shifting)
dir - When not selected it is tied to logic0 (right shift)

parallel_out - Selectable 

}


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

proc update_PARAM_VALUE.EN { PARAM_VALUE.EN } {
	# Procedure called to update EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EN { PARAM_VALUE.EN } {
	# Procedure called to validate EN
	return true
}

proc update_PARAM_VALUE.LOAD { PARAM_VALUE.LOAD } {
	# Procedure called to update LOAD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LOAD { PARAM_VALUE.LOAD } {
	# Procedure called to validate LOAD
	return true
}

proc update_PARAM_VALUE.PARALLEL_IN { PARAM_VALUE.PARALLEL_IN } {
	# Procedure called to update PARALLEL_IN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PARALLEL_IN { PARAM_VALUE.PARALLEL_IN } {
	# Procedure called to validate PARALLEL_IN
	return true
}

proc update_PARAM_VALUE.PARALLEL_OUT { PARAM_VALUE.PARALLEL_OUT } {
	# Procedure called to update PARALLEL_OUT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PARALLEL_OUT { PARAM_VALUE.PARALLEL_OUT } {
	# Procedure called to validate PARALLEL_OUT
	return true
}

proc update_PARAM_VALUE.SIZE { PARAM_VALUE.SIZE } {
	# Procedure called to update SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIZE { PARAM_VALUE.SIZE } {
	# Procedure called to validate SIZE
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

proc update_MODELPARAM_VALUE.PARALLEL_IN { MODELPARAM_VALUE.PARALLEL_IN PARAM_VALUE.PARALLEL_IN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PARALLEL_IN}] ${MODELPARAM_VALUE.PARALLEL_IN}
}

proc update_MODELPARAM_VALUE.EN { MODELPARAM_VALUE.EN PARAM_VALUE.EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EN}] ${MODELPARAM_VALUE.EN}
}

proc update_MODELPARAM_VALUE.LOAD { MODELPARAM_VALUE.LOAD PARAM_VALUE.LOAD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LOAD}] ${MODELPARAM_VALUE.LOAD}
}

proc update_MODELPARAM_VALUE.DIR { MODELPARAM_VALUE.DIR PARAM_VALUE.DIR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DIR}] ${MODELPARAM_VALUE.DIR}
}

proc update_MODELPARAM_VALUE.PARALLEL_OUT { MODELPARAM_VALUE.PARALLEL_OUT PARAM_VALUE.PARALLEL_OUT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PARALLEL_OUT}] ${MODELPARAM_VALUE.PARALLEL_OUT}
}

