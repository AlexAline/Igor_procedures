#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

function init_K2400(instr)
	variable instr
	
	variable/G K2400_VISA_address = instr	
end

function K2400_ON()
	
	variable/G K2400_VISA_address
		
	String variableWrite, variableRead
    
	variableWrite = ":outp on"
   
	VISAWrite K2400_VISA_address, variableWrite
end

function K2400_OFF()
	variable/G K2400_VISA_address
		
	String variableWrite
    
	variableWrite = ":outp off"
   
	VISAWrite K2400_VISA_address, variableWrite
end

function read_current_K2400()
	variable/G K2400_VISA_address
	
	String variableWrite, variableRead
   variable k2400V, k2400I, k2400R, k2400T, k2400S
 
	variableWrite = "sens:func \"CURR\""
	VISAWrite K2400_VISA_address, variableWrite
	wait(0.01)
	
	variableWrite = ":read?"
	VISAWrite K2400_VISA_address, variableWrite
	wait(0.01)
	VISARead/T="\r" K2400_VISA_address, variableRead
	
	sscanf variableRead, "%f,%f,%f,%f,%f", k2400V, k2400I, k2400R, k2400T, k2400S
//	print variableRead, k2400V, k2400I, k2400R, k2400T, k2400S
	
	return k2400I
end

function read_current_K2400_()
	variable/G K2400_VISA_address
	
	String variableWrite, variableRead
   variable k2400V, k2400I, k2400R, k2400T, k2400S
	
	variableWrite = ":read?"
	VISAWrite K2400_VISA_address, variableWrite
	wait(0.01)
	VISARead/T="\r" K2400_VISA_address, variableRead
	
	sscanf variableRead, "%f,%f,%f,%f,%f", k2400V, k2400I, k2400R, k2400T, k2400S
//	print variableRead, k2400V, k2400I, k2400R, k2400T, k2400S
	
	return k2400I
end


function set_voltage_K2400(value_mV)
	variable value_mV
	
	variable/G K2400_VISA_address
	String variableWrite, variableRead
	
	sprintf variableWrite, "SOUR:VOLT:LEV:IMM:AMPL %f", value_mV/1000	
	VISAWrite K2400_VISA_address, variableWrite
end

function set_current_K2400(value_mA)
	variable value_mA
	
	variable/G K2400_VISA_address
	String variableWrite, variableRead

	sprintf variableWrite, "SOUR:CURR:RANGE %f", value_mA/1000
	VISAWrite K2400_VISA_address, variableWrite
	wait(0.01)
	
	sprintf variableWrite, "SOUR:CURR:LEV %f", value_mA/1000
	VISAWrite K2400_VISA_address, variableWrite
end