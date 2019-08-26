#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

// Shift+Esc to abort

// before using IPS do:
init_IPS(VISA_address)
	// goes remote
	// hold
	// toSetPoint
	// heater On
// after using IPS use:
deinit_IPS(VISA_address)
	// clamp
	// heater Off
	// local
read_param_IPS_VISA(instr,val)
// interesting par's are: (also see page 33, IPS120-10 manual)
	//	0	:	output current 				Amp
	//	1	:	measured output voltage		Volt
	//	5	:	set point 						Amp
	//	6	: 	sweep rate						Amps/min
	//	7	:	output field					Tesla
	//	8	:	set point						Tesla
	//	9	:	sweep rate						Tesla/min
	//	21	:	safe current limit (neg)	Amp
	//	22	:	safe current limit (pos)	Amp
	// 23	:	lead resistance				milli Ohm
	//	24	:	magnet inductance				Henry

inc_nextwave()
remote_AVS_VISA(25)
local_AVS_VISA(25)
hide("g")		// hide("l")


init_K2400(VISA_address)
