#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

function init_SMS(device)
	variable device
	
	set_SMS_port(device)
	set_SMS_heater(1)
	set_SMS_Tesla(1)
	set_SMS_midVal(0)
	set_SMS_toMid()
end

Function set_SMS_port(device)
	variable device
	
	execute "VDTOperationsPort2 COM"+num2str(device) // Sets the operations port
	execute "VDT2 killio"	//halts any pending IO and clears input buffer.

	VDT2 baud=9600, stopbits=1, databits=8, parity=0, in=0, out=0, echo=1	//Set protocol
	
	variable/G IPS_VISA_address
	IPS_VISA_address = 1
End

function deinit_SMS(device)
	variable device
	
	execute "VDTClosePort2 COM"+num2str(device) // Close the operations port
	
	variable/G IPS_VISA_address
	IPS_VISA_address = 0
end


function set_SMS_heater(state)
	variable state
		
	VDTWrite2 "H"+num2str(state)+"\r"
end

function set_SMS_Tesla(state)
	variable state
	
	VDTWrite2 "T"+num2str(state)+"\r"
end

Function set_SMS_midVal(value)
	variable value

	string cmd
	
	if(abs(value)<=9)	
	
		if(value<0)
			VDTWrite2 "D -\r"
		else
			VDTWrite2 "D +\r"
		endif

		Sprintf cmd, "S%% %f\r", value
		VDTWrite2 cmd
	else
		print "ERROR: set field value is too large"
	endif
End

function set_SMS_toZero()
	VDTWrite2 "R0\r"
end

function set_SMS_toMid()
	VDTWrite2 "R%%\r"
end
