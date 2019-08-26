#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

//--------DMM--------------------
function read_dc(instr_ID)
	variable instr_ID
	
	variable/G value_red
	value_red = readdmm(instr_ID)
end

//--------Lock-in----------------
function read_loM(instr_ID)
	variable instr_ID
	
	variable/G value_red
	value_red = Lockin_M_VISA(instr_ID)
end

function read_loPh(instr_ID)
	variable instr_ID
	
	variable/G value_red
	value_red = Lockin_Ph_VISA(instr_ID)
end

//--------AVS-------------------
function read_R1K(instr_ID)
	variable instr_ID
	
	variable/G value_red
	
	setChannel_AVS_VISA(instr_ID,0)
	wait(0.01)
	wait(10)
	value_red = readRes_AVS_VISA(instr_ID)
end


function read_Rstil(instr_ID)
	variable instr_ID
	
	variable/G value_red
	
	setChannel_AVS_VISA(instr_ID,1)
	wait(0.01)
	wait(10)
	value_red = readRes_AVS_VISA(instr_ID)
end

function read_Rmc(instr_ID)
	variable instr_ID
	
	variable/G value_red
	
	setChannel_AVS_VISA(instr_ID,2)
	wait(0.01)
	wait(10)
	value_red = readRes_AVS_VISA(instr_ID)
end

//--------AVS-------------------
function read_PIVC(instr_ID)
	variable instr_ID

	variable/G value_red
	
	value_red = read_pressure(1)
end

function read_PSTIL(instr_ID)
	variable instr_ID
	
	variable/G value_red
	
	value_red = read_pressure(2)
end