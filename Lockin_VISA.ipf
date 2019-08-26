#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

function Lockin_Ph_VISA(instr)
	Variable instr
		
	String variableWrite, variableRead
    
	variableWrite = "PHA."

	VISAWrite instr, variableWrite
	VISARead/T="\n" instr, variableRead
//	Printf "V_flag: %d, V_status: %d\r", V_flag,V_status
//	Print variableRead

	return str2num(variableRead)
end

function Lockin_M_VISA(instr)
	Variable instr
		
	String variableWrite, variableRead
    
	variableWrite = "MAG."

	VISAWrite instr, variableWrite
	VISARead/T="\n" instr, variableRead
//	Printf "V_flag: %d, V_status: %d\r", V_flag,V_status
//	Print variableRead

	return str2num(variableRead)
end

function Lockin_read_cmd_VISA(instr, cmd)
	Variable instr
	string cmd
	
	String variableWrite, variableRead
    
	variableWrite = cmd

	VISAWrite instr, variableWrite
	VISARead/T="\n" instr, variableRead
//	Printf "V_flag: %d, V_status: %d\r", V_flag,V_status
	Print variableRead

//	return str2num(variableRead)
end

function Lockin_write_cmd_VISA(instr, cmd, val)
	Variable instr
	string cmd
	variable val
	
	String variableWrite, variableRead
    
	variableWrite = cmd + " " + num2str(val)

	VISAWrite instr, variableWrite
//	VISARead/T="\n" instr, variableRead
//	Printf "V_flag: %d, V_status: %d\r", V_flag,V_status
//	Print variableRead

//	return str2num(variableRead)
end
