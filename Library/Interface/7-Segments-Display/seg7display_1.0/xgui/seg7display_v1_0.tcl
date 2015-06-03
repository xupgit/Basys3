# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "MODULES" -parent ${Page_0}
  ipgui::add_static_text $IPINST -name "Number of Modules" -parent ${Page_0} -text {Selecting 1 will provide one 16-bit input and one 4-bit anodes output ports. 
Selecting 2 will provide two 16-bit input and two 4-bit anodes output ports.
The IP expects 100 MHz input clock.

Please select Decimal Points display in the other two tabs}

  #Adding Page
  set Module_1_Related_Decimal_Points [ipgui::add_page $IPINST -name "Module 1 Related Decimal Points"]
  ipgui::add_param $IPINST -name "DP_0" -parent ${Module_1_Related_Decimal_Points} -widget comboBox
  ipgui::add_param $IPINST -name "DP_1" -parent ${Module_1_Related_Decimal_Points} -widget comboBox
  ipgui::add_param $IPINST -name "DP_2" -parent ${Module_1_Related_Decimal_Points} -widget comboBox
  ipgui::add_param $IPINST -name "DP_3" -parent ${Module_1_Related_Decimal_Points} -widget comboBox

  #Adding Page
  set Module_2_Related_Decimal_Points [ipgui::add_page $IPINST -name "Module 2 Related Decimal Points"]
  ipgui::add_param $IPINST -name "DP_4" -parent ${Module_2_Related_Decimal_Points} -widget comboBox
  ipgui::add_param $IPINST -name "DP_5" -parent ${Module_2_Related_Decimal_Points} -widget comboBox
  ipgui::add_param $IPINST -name "DP_6" -parent ${Module_2_Related_Decimal_Points} -widget comboBox
  ipgui::add_param $IPINST -name "DP_7" -parent ${Module_2_Related_Decimal_Points} -widget comboBox


}

proc update_PARAM_VALUE.DP_0 { PARAM_VALUE.DP_0 } {
	# Procedure called to update DP_0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DP_0 { PARAM_VALUE.DP_0 } {
	# Procedure called to validate DP_0
	return true
}

proc update_PARAM_VALUE.DP_1 { PARAM_VALUE.DP_1 } {
	# Procedure called to update DP_1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DP_1 { PARAM_VALUE.DP_1 } {
	# Procedure called to validate DP_1
	return true
}

proc update_PARAM_VALUE.DP_2 { PARAM_VALUE.DP_2 } {
	# Procedure called to update DP_2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DP_2 { PARAM_VALUE.DP_2 } {
	# Procedure called to validate DP_2
	return true
}

proc update_PARAM_VALUE.DP_3 { PARAM_VALUE.DP_3 } {
	# Procedure called to update DP_3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DP_3 { PARAM_VALUE.DP_3 } {
	# Procedure called to validate DP_3
	return true
}

proc update_PARAM_VALUE.DP_4 { PARAM_VALUE.DP_4 } {
	# Procedure called to update DP_4 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DP_4 { PARAM_VALUE.DP_4 } {
	# Procedure called to validate DP_4
	return true
}

proc update_PARAM_VALUE.DP_5 { PARAM_VALUE.DP_5 } {
	# Procedure called to update DP_5 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DP_5 { PARAM_VALUE.DP_5 } {
	# Procedure called to validate DP_5
	return true
}

proc update_PARAM_VALUE.DP_6 { PARAM_VALUE.DP_6 } {
	# Procedure called to update DP_6 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DP_6 { PARAM_VALUE.DP_6 } {
	# Procedure called to validate DP_6
	return true
}

proc update_PARAM_VALUE.DP_7 { PARAM_VALUE.DP_7 } {
	# Procedure called to update DP_7 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DP_7 { PARAM_VALUE.DP_7 } {
	# Procedure called to validate DP_7
	return true
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

proc update_MODELPARAM_VALUE.DP_0 { MODELPARAM_VALUE.DP_0 PARAM_VALUE.DP_0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DP_0}] ${MODELPARAM_VALUE.DP_0}
}

proc update_MODELPARAM_VALUE.DP_1 { MODELPARAM_VALUE.DP_1 PARAM_VALUE.DP_1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DP_1}] ${MODELPARAM_VALUE.DP_1}
}

proc update_MODELPARAM_VALUE.DP_2 { MODELPARAM_VALUE.DP_2 PARAM_VALUE.DP_2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DP_2}] ${MODELPARAM_VALUE.DP_2}
}

proc update_MODELPARAM_VALUE.DP_3 { MODELPARAM_VALUE.DP_3 PARAM_VALUE.DP_3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DP_3}] ${MODELPARAM_VALUE.DP_3}
}

proc update_MODELPARAM_VALUE.DP_4 { MODELPARAM_VALUE.DP_4 PARAM_VALUE.DP_4 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DP_4}] ${MODELPARAM_VALUE.DP_4}
}

proc update_MODELPARAM_VALUE.DP_5 { MODELPARAM_VALUE.DP_5 PARAM_VALUE.DP_5 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DP_5}] ${MODELPARAM_VALUE.DP_5}
}

proc update_MODELPARAM_VALUE.DP_6 { MODELPARAM_VALUE.DP_6 PARAM_VALUE.DP_6 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DP_6}] ${MODELPARAM_VALUE.DP_6}
}

proc update_MODELPARAM_VALUE.DP_7 { MODELPARAM_VALUE.DP_7 PARAM_VALUE.DP_7 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DP_7}] ${MODELPARAM_VALUE.DP_7}
}

