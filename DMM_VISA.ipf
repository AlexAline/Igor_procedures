#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

function readDMM(instr)
	Variable instr
		
	String variableWrite, variableRead
    
	variableWrite = "read?"
    
	VISAWrite instr, variableWrite
	VISARead/T="\r" instr, variableRead
//	Printf "V_flag: %d, V_status: %d\r", V_flag,V_status
//	Print str2num(variableRead)

	return str2num(variableRead)*1000
End