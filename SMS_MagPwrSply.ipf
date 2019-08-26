
#pragma rtGlobals=1		// Use modern global access method.

//Raphael
//04/02/2009
//
//remote control of magnet powersupplies via com port using VDT XOP
//
//******************************************************************************
//******************************************************************************
//******************************************************************************
//****************************PANEL*****************************************
//******************************************************************************
//******************************************************************************
//******************************************************************************

Window MagPanel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(604,74,1245,204) as "SMS Panel"
	ModifyPanel cbRGB=(32768,40704,65280)
	SetDrawLayer UserBack
	DrawText 11,25,"ON/OFF"
	DrawText 75,24,"Pause"
	DrawLine 71,6,71,90
	DrawText 116,24,"Heater"
	DrawText 158,24,"RR[mT/s]"
	DrawText 215,24,"Mid[T]"
	DrawText 258,24,"Max[T]"
	DrawLine 388,9,388,93
	DrawText 392,22,"Tesla"
	DrawText 440,23,"TpA"
	DrawText 306,24,"Zero"
	DrawText 337,25,"Mid"
	DrawText 362,24,"Max"
	DrawLine 487,9,487,93
	DrawLine 506,9,506,93
	DrawText 512,23,"init field direction"
	CheckBox chkT0,pos={401,26},size={16,14},disable=2,proc=chktesla,title=""
	CheckBox chkT0,variable= TeslaOn0
	CheckBox chkT1,pos={401,48},size={16,14},disable=2,proc=chktesla,title=""
	CheckBox chkT1,variable= TeslaOn1
	CheckBox chkT2,pos={401,72},size={16,14},disable=2,proc=chktesla,title=""
	CheckBox chkT2,variable= TeslaOn2
	CheckBox lok,pos={401,102},size={46,14},proc=lock,title="LOCK",variable= locked
	CheckBox sil,pos={112,104},size={186,14},proc=silenced,title="Quiet! (no status output on console)"
	CheckBox sil,help={"no output in console"},variable= silence
	CheckBox chk0,pos={7,29},size={59,14},proc=chkonoff,title="Solenoid"
	CheckBox chk0,help={"checked=ON"},variable= OnOff0
	CheckBox chk1,pos={7,51},size={58,14},proc=chkonoff,title="Coils 1-2"
	CheckBox chk1,help={"checked=ON"},variable= OnOff1
	CheckBox chk2,pos={7,75},size={58,14},proc=chkonoff,title="Coils 3-4"
	CheckBox chk2,help={"checked=ON"},variable= OnOff2
	Button Initialize,pos={9,101},size={100,20},proc=initSMSall,title="Initialize/Reset"
	Button Initialize,help={"Initialize the selected powersupplies"}
	Button Initialize,fColor=(26112,0,20736)
	CheckBox ramp0,pos={85,28},size={16,14},disable=2,proc=chkramp,title=""
	CheckBox ramp0,variable= ramp0
	CheckBox ramp1,pos={85,50},size={16,14},disable=2,proc=chkramp,title=""
	CheckBox ramp1,variable= ramp1
	CheckBox ramp2,pos={85,74},size={16,14},disable=2,proc=chkramp,title=""
	CheckBox ramp2,variable= ramp2
	CheckBox heat0,pos={126,29},size={16,14},disable=2,proc=chkheater,title=""
	CheckBox heat0,variable= heater0
	CheckBox heat1,pos={126,51},size={16,14},disable=2,proc=chkheater,title=""
	CheckBox heat1,variable= heater1
	CheckBox heat2,pos={126,75},size={16,14},disable=2,proc=chkheater,title=""
	CheckBox heat2,variable= heater2
	SetVariable chktpa0,pos={425,26},size={60,16},disable=2,proc=chktpa,title=" "
	SetVariable chktpa0,limits={0,1,0},value= tpa0
	SetVariable chktpa1,pos={425,48},size={60,16},disable=2,proc=chktpa,title=" "
	SetVariable chktpa1,limits={0,1,0},value= tpa1
	SetVariable chktpa2,pos={425,72},size={60,16},disable=2,proc=chktpa,title=" "
	SetVariable chktpa2,limits={0,1,0},value= tpa2
	SetVariable rr0,pos={168,27},size={35,16},disable=2,proc=readramp,title=" "
	SetVariable rr0,format="%3.2f",limits={0,40,0},value= ramprate0
	SetVariable rr1,pos={168,49},size={35,16},disable=2,proc=readramp,title=" "
	SetVariable rr1,format="%3.2f",limits={0,40,0},value= ramprate1
	SetVariable rr2,pos={168,73},size={35,16},disable=2,proc=readramp,title=" "
	SetVariable rr2,format="%3.2f",limits={0,40,0},value= ramprate2
	SetVariable mid0,pos={207,26},size={45,16},disable=2,proc=readmid,title=" "
	SetVariable mid0,format="%2.4f",limits={-9,9,0},value= midfield0
	SetVariable mid1,pos={207,48},size={45,16},disable=2,proc=readmid,title=" "
	SetVariable mid1,format="%2.4f",limits={-4,4,0},value= midfield1
	SetVariable mid2,pos={207,72},size={45,16},disable=2,proc=readmid,title=" "
	SetVariable mid2,format="%2.4f",limits={-4,4,0},value= midfield2
	SetVariable max0,pos={254,26},size={45,16},disable=2,proc=readmax,title=" "
	SetVariable max0,format="%2.4f",limits={0,9,0},value= maxfield0
	SetVariable max1,pos={254,48},size={45,16},disable=2,proc=readmax,title=" "
	SetVariable max1,format="%2.4f",limits={0,4,0},value= maxfield1
	SetVariable max2,pos={254,72},size={45,16},disable=2,proc=readmax,title=" "
	SetVariable max2,format="%2.4f",limits={0,4,0},value= maxfield2
	CheckBox rampzero0,pos={311,26},size={16,14},disable=2,proc=rampzero,title=""
	CheckBox rampzero0,variable= rampZ0,mode=1
	CheckBox rampzero1,pos={311,50},size={16,14},disable=2,proc=rampzero,title=""
	CheckBox rampzero1,variable= rampZ1,mode=1
	CheckBox rampzero2,pos={311,74},size={16,14},disable=2,proc=rampzero,title=""
	CheckBox rampzero2,variable= rampZ2,mode=1
	CheckBox rampmid0,pos={340,26},size={16,14},disable=2,proc=rampmid,title=""
	CheckBox rampmid0,variable= rampMi0,mode=1
	CheckBox rampmid1,pos={340,51},size={16,14},disable=2,proc=rampmid,title=""
	CheckBox rampmid1,variable= rampMi1,mode=1
	CheckBox rampmid2,pos={339,74},size={16,14},disable=2,proc=rampmid,title=""
	CheckBox rampmid2,variable= rampMi2,mode=1
	CheckBox rampmax0,pos={367,26},size={16,14},disable=2,proc=rampmax,title=""
	CheckBox rampmax0,variable= rampMa0,mode=1
	CheckBox rampmax1,pos={367,50},size={16,14},disable=2,proc=rampmax,title=""
	CheckBox rampmax1,variable= rampMa1,mode=1
	CheckBox rampmax2,pos={367,74},size={16,14},disable=2,proc=rampmax,title=""
	CheckBox rampmax2,variable= rampMa2,mode=1
	Button status0,pos={490,26},size={15,16},disable=2,proc=checkstatus,title="?"
	Button status0,fColor=(0,0,65535)
	Button status1,pos={490,50},size={15,16},disable=2,proc=checkstatus,title="?"
	Button status1,fColor=(0,0,65535)
	Button status2,pos={490,74},size={15,16},disable=2,proc=checkstatus,title="?"
	Button status2,fColor=(0,0,65535)
	SetVariable sign0,pos={515,27},size={26,16},title=" ",value= fieldsign0
	SetVariable sign1,pos={515,49},size={25,16},title=" ",value= fieldsign1
	SetVariable sign2,pos={514,73},size={26,16},title=" ",value= fieldsign2
EndMacro


//******************************************************************************
//******************************************************************************
//******************************************************************************
//****************************PANEL FUNCTIONS**************************
//******************************************************************************
//******************************************************************************
//******************************************************************************

Function lock (ctrlName, checked) : CheckBoxControl  /////////////////////////////////
string ctrlName
variable checked
variable/G locked, silence

if(locked==1)
	if(silence==0)
	print "locked"
	endif
	locker()

else
	if(silence==0)
	print "unlocked"
	endif
	SetVariable chktpa0,disable=0
	SetVariable chktpa1,disable=0
	SetVariable chktpa2,disable=0
	CheckBox chkT0, disable=0
	CheckBox chkT1, disable=0
	CheckBox chkT2, disable=0

endif

End

Function checkstatus (ctrlName) : ButtonControl
	String ctrlName
	
	if(stringmatch(ctrlName,"status0"))
		getsmsstatus(0)
	
	elseif(stringmatch(ctrlName,"status1"))
		getsmsstatus(1)
	
	elseif(stringmatch(ctrlName,"status2"))
		getsmsstatus(2)
	
	endif
End



Function silenced (ctrlName, checked) : CheckBoxControl	 /////////////////////////////////
string ctrlName
variable checked
variable/G silence

if(silence==1)
	print "nothing to say..."
else
	print "will tell you quite everything..."
endif

End

Function chktesla (ctrlName, checked) : CheckBoxControl		//////////////////////////////////////
string ctrlName
variable checked
variable/G TeslaOn0,TeslaOn1,TeslaOn2,silence
variable/G OnOff0, OnOff1, OnOff2

	if(OnOff0==1 && stringmatch(ctrlName, "chkT0"))
	
		if(checked==1)
			SMSSetTesla(1,0)
		else
			SMSSetTesla(0,0)
		endif
	
	elseif(OnOff1==1 && stringmatch(ctrlName, "chkT1"))
		
		if(checked==1)
			SMSSetTesla(1,1)
		else
			SMSSetTesla(0,1)
		endif
		
	elseif(OnOff2==1 && stringmatch(ctrlName, "chkT2"))
	
		if(checked==1)
			SMSSetTesla(1,2)
		else
			SMSSetTesla(0,2)
		endif
			
	endif
	
		
End


Function chktpa (ctrlName,varNum,varStr,varName) : SetVariableControl		////////////////////////////////////////
	String ctrlName
	Variable varNum	// value of variable as number
	String varStr
	String varName
	variable/G tpa0,tpa1,tpa2,silence	
	variable/G OnOff0, OnOff1, OnOff2
	variable/G limitmaxfield0,limitmaxfield1,limitmaxfield2	
	
	
	if(stringmatch(ctrlName,"chktpa0"))
	
		if(OnOff0==1)
			SMSSetTPA(varNum,0)
		endif
		limitmaxfield0=120*tpa0
	elseif(stringmatch(ctrlName,"chktpa1"))
	
		if(OnOff1==1)
			SMSSetTPA(varNum,1)
		endif	
		limitmaxfield1=60*tpa1
	elseif(stringmatch(ctrlName,"chktpa2"))
	
		if(OnOff2==1)
			SMSSetTPA(varNum,2)
		endif	
		 limitmaxfield2=60*tpa2
	endif

		
End



Function readmax (ctrlName,varNum,varStr,varName) : SetVariableControl	///////////////////////////////////////////////
	String ctrlName
	Variable varNum	// value of variable as number
	String varStr
	String varName
	Variable/G maxfield0, maxfield1, maxfield2, silence
	variable/G OnOff0, OnOff1, OnOff2
	
	if(stringmatch(ctrlName,"max0"))
		SMSSetMaxField(varNum,0)
	elseif(stringmatch(ctrlName,"max1"))
		SMSSetMaxField(varNum,1)
	elseif(stringmatch(ctrlName,"max2"))
		SMSSetMaxField(varNum,2)
	endif
		
End

Function readmid (ctrlName,varNum,varStr,varName) : SetVariableControl	//////////////////////////////////////////
	String ctrlName
	Variable varNum	// value of variable as number
	String varStr
	String varName
	Variable/G midfield0, midfield1, midfield2, silence
	variable/G OnOff0, OnOff1, OnOff2	
	
	if(stringmatch(ctrlName,"mid0"))
		SMSramp2mid(varNum,0)
	elseif(stringmatch(ctrlName,"mid1"))
		SMSramp2mid(varNum,1)
	elseif(stringmatch(ctrlName,"mid2"))
		SMSramp2mid(varNum,2)
	endif
	
End


Function readramp (ctrlName,varNum,varStr,varName) : SetVariableControl	////////////////////////////////////////
	String ctrlName
	Variable varNum	// value of variable as number
	String varStr
	String varName
	Variable/G ramprate0, ramprate1, ramprate2,silence
	variable/G OnOff0, OnOff1, OnOff2
	
	if(stringmatch(ctrlName,"rr0"))
		SMSSetRampRate(varNum,0)
	elseif(stringmatch(ctrlName,"rr1"))
		SMSSetRampRate(varNum,1)
	elseif(stringmatch(ctrlName,"rr2"))
		SMSSetRampRate(varNum,2)
	endif	

End

Function rampzero (ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked			// 1 if selelcted, 0 if not
	Variable/G rampZ0,rampZ1,rampZ2
	Variable/G rampMi0,rampMi1,rampMi2
	Variable/G rampMa0,rampMa1,rampMa2
	
	if(stringmatch(ctrlName,"rampzero0"))
		SMSrampzero(0)
		rampMi0=0
		rampMa0=0
	elseif(stringmatch(ctrlName,"rampzero1"))
		SMSrampzero(1)
		rampMi1=0
		rampMa1=0
	elseif(stringmatch(ctrlName,"rampzero2"))
		SMSrampzero(2)
		rampMi2=0
		rampMa2=0
	endif
End

Function rampmid (ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked			// 1 if selelcted, 0 if not
	Variable/G rampZ0,rampZ1,rampZ2
	Variable/G rampMi0,rampMi1,rampMi2
	Variable/G rampMa0,rampMa1,rampMa2
	
	if(stringmatch(ctrlName,"rampmid0"))
		rampZ0=0
		rampMa0=0
		SMSrampmid(0)
	elseif(stringmatch(ctrlName,"rampmid1"))		
		rampZ1=0
		rampMa1=0
		SMSrampmid(1)
	elseif(stringmatch(ctrlName,"rampmid2"))
		rampZ2=0
		rampMa2=0
		SMSrampmid(2)
	endif
End

Function rampmax (ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked			// 1 if selelcted, 0 if not
	Variable/G rampZ0,rampZ1,rampZ2
	Variable/G rampMi0,rampMi1,rampMi2
	Variable/G rampMa0,rampMa1,rampMa2
	
	if(stringmatch(ctrlName,"rampmax0"))
		SMSrampmax(0)
		rampZ0=0
		rampMi0=0
	elseif(stringmatch(ctrlName,"rampmax1"))
		SMSrampmax(1)
		rampZ1=0
		rampMi1=0
	elseif(stringmatch(ctrlName,"rampmax2"))
		SMSrampmax(2)
		rampZ2=0
		rampMi2=0
	endif
End


Function chkheater (ctrlName, checked) : CheckBoxControl		//////////////////////////////////////////////////
	string ctrlName
	variable checked
	variable/G heater0, heater1, heater2,silence
	string dummystr
	variable/G OnOff0, OnOff1, OnOff2	
	
	if(OnOff0==1 && stringmatch(ctrlName, "heat0"))
		
		if(checked==1)
			SMSSetHeater(1,0)
		else
			SMSSetHeater(0,0)
		endif
		
	elseif(OnOff1==1 && stringmatch(ctrlName, "heat1"))
		
		if(checked==1)
			SMSSetHeater(1,1)
		else
			SMSSetHeater(0,1)
		endif
		
	elseif(OnOff2==1 && stringmatch(ctrlName, "heat2"))
	
		if(checked==1)
			SMSSetHeater(1,2)
		else
			SMSSetHeater(0,2)
		endif
		
	endif
		
End

Function chkramp(ctrlName, checked) : CheckBoxControl	/////////////////////////////////////////
	string ctrlName
	variable checked
	variable/G ramp0, ramp1, ramp2,silence
	string dummystr	
	variable/G OnOff0, OnOff1, OnOff2
	
	if(checked==1)	
	
		if(OnOff0==1 && stringmatch(ctrlName, "ramp0"))
	
			SMSSetPause(1,0)
	
		elseif(OnOff1==1 && stringmatch(ctrlName, "ramp1"))
		
			SMSSetPause(1,1)
	
		elseif(OnOff2==1 && stringmatch(ctrlName, "ramp2"))
	
			SMSSetPause(1,2)
		
		endif
	else
	
		if(OnOff0==1 && stringmatch(ctrlName, "ramp0"))
	
			SMSSetPause(0,0)
	
		elseif(OnOff1==1 && stringmatch(ctrlName, "ramp1"))
		
			SMSSetPause(0,1)
	
		elseif(OnOff2==1 && stringmatch(ctrlName, "ramp2"))
	
			SMSSetPause(0,2)
		
		endif	
	
	endif
	
End


Function chkonoff (ctrlName, checked) : CheckBoxControl  ///////////////////////////////////////
	string ctrlName
	variable checked //1 if selected, 0 if not
	variable/G OnOff0, OnOff1, OnOff2,silence
	string dummystr
	
	if(checked==0)
		dummystr="OFF"
	else
		dummystr="ON"
	endif
		
	if(stringmatch(ctrlName,"chk0"))
		if(silence==0)
		print "Solenoid:", dummystr
		endif
	
		CheckBox ramp0, disable=(2-OnOff0*2)
		CheckBox heat0,disable=(2-OnOff0*2)
		SetVariable rr0,disable=(2-OnOff0*2)
		SetVariable mid0,disable=(2-OnOff0*2)
		SetVariable max0,disable=(2-OnOff0*2)
		CheckBox rampmax0, disable=(2-OnOff0*2)
		CheckBox rampmid0, disable=(2-OnOff0*2)
		CheckBox rampzero0, disable=(2-OnOff0*2)
		Button status0, disable=(2-OnOff0*2)
	

	elseif(stringmatch(ctrlName,"chk1"))
		if(silence==0)
		print "Coil1-2:", dummystr
		endif
		CheckBox ramp1,disable=(2-OnOff1*2)
		CheckBox heat1,disable=(2-OnOff1*2)
		SetVariable rr1,disable=(2-OnOff1*2)
		SetVariable mid1,disable=(2-OnOff1*2)
		SetVariable max1,disable=(2-OnOff1*2)
		CheckBox rampmax1, disable=(2-OnOff1*2)
		CheckBox rampzero1, disable=(2-OnOff1*2)
		CheckBox rampmid1, disable=(2-OnOff1*2)
		Button status1, disable=(2-OnOff1*2)


	elseif(stringmatch(ctrlName,"chk2"))
		if(silence==0)
		print "Coil3-4:", dummystr
		endif
		CheckBox ramp2,disable=(2-OnOff2*2)
		CheckBox heat2,disable=(2-OnOff2*2)
		SetVariable rr2,disable=(2-OnOff2*2)
		SetVariable mid2,disable=(2-OnOff2*2)
		SetVariable max2,disable=(2-OnOff2*2)
		CheckBox rampmax2, disable=(2-OnOff2*2)
		CheckBox rampmid2, disable=(2-OnOff2*2)
		CheckBox rampzero2, disable=(2-OnOff2*2)
		Button status2, disable=(2-OnOff2*2)

	endif
	
	
End

Function initSMSall (ctrlName) : ButtonControl //looks stupid but with this method you can use InitSMS3() also without the panel
	String ctrlName
		
	InitSMS3()
	
End


Function InitSMS3()	//initialize all selected powersupplies

	variable/G ramprate0=0, ramprate1=0, ramprate2=0
	variable/G tpa0=0.0265551, tpa1=0.0215, tpa2=0.0221
//	variable/G midfield0=0, midfield1=0,midfield2=0,maxfield0=9,maxfield1=0.9,maxfield2=0.9
	variable/G midfield0=0, midfield1=0,midfield2=0,maxfield0=4.0,maxfield1=1,maxfield2=1
	variable/G OnOff0, OnOff1, OnOff2, TeslaOn0, TeslaOn1,TeslaOn2
	variable/G limitramp=40, limitmaxfield0=120*tpa0, limitmaxfield1=60*tpa1, limitmaxfield2=60*tpa2
	variable/G ramprate0old=0, ramprate1old=0, ramprate2old=0
	variable/G midfield0old=0, midfield1old=0, midfield2old=0
	variable/G maxfield0old=1, maxfield1old=1, maxfield2old=1
	variable/G lock0=0, lock1=0, lock2=0
	variable/G sweeplimit0=7, sweeplimit1=7, sweeplimit2=7		//limit sweep voltage
	variable/G sweeplimit0old=7, sweeplimit1old=7, sweeplimit2old=7
	variable/G limitsweeplimit0=9.9, limitsweeplimit1=9.9, limitsweeplimit2=9.9	//limit of limit sweep voltage ... yes this variablenames sucks, but this is the absolut limit where your sweepvoltage can go.
	variable/G heatervoltage0=3.5, heatervoltage1=5, heatervoltage2=5 //heater voltage of solenoid increased from 2 to 4
	variable/G heatervoltage0old=1.7, heatervoltage1old=5, heatervoltage2old=5
	variable/G limitheatervoltage0=8, limitheatervoltage1=8, limitheatervoltage2=8
	Variable/G rampZ0=0,rampZ1=0,rampZ2=0
	Variable/G rampMi0=1,rampMi1=1,rampMi2=1
	Variable/G rampMa0=0,rampMa1=0,rampMa2=0

	if(OnOff0==1)
	clearIObuffer(0)
	SMSSetTesla(1,0)
	SMSSetTPA(tpa0,0)	
	SMSSetPause(0,0)
	wait(2)
	SMSSetLimitSweepV(sweeplimit0,0)
	SMSSetHeaterVoltage(heatervoltage0,0)
	SMSLockFrontPanel(0,0)
	wait(2)
	SMSSetMaxField(maxfield0,4)
	SMSSetMidField(midfield0,4)
	SMSSetRampRate(ramprate0,0)
	SMSramp2mid(midfield0,0)	//sends R%=in ramping mode (mid)
	wait(1)
	endif
	
	if(OnOff1==1)	
	clearIObuffer(1)
	SMSSetTesla(1,1)	
	SMSSetTPA(tpa1,1)
	SMSSetPause(0,1)
	wait(2)	
	SMSSetLimitSweepV(sweeplimit1,1)
	SMSSetHeaterVoltage(heatervoltage1,1)	
	SMSLockFrontPanel(0,1)
	wait(2)
	SMSSetMaxField(maxfield1,1)
	SMSSetMidField(midfield1,1)
	SMSSetRampRate(ramprate1,1)
	SMSramp2mid(midfield1,1)	//sends R%=in ramping mode (mid)
	wait(1)
	endif
	
	if(OnOff2==1)	
	clearIObuffer(2)	
	SMSSetTesla(1,2)
	SMSSetTPA(tpa2,2)
	SMSSetPause(0,2)
	SMSSetPause(0,2)
	wait(2)
	SMSSetLimitSweepV(sweeplimit2,2)
	SMSSetHeaterVoltage(heatervoltage2,2)
	SMSLockFrontPanel(0,2)
	wait(2)
	SMSSetMaxField(maxfield2,2)
	SMSSetMidField(midfield2,2)
	SMSSetRampRate(ramprate2,2)
	SMSramp2mid(midfield2,2)	//sends R%=in ramping mode (mid)
	wait(1)
	endif
			
End

Function InitSMS3_4()		//initialize powersupply 3-4

	variable/G ramprate0=0, ramprate1=0, ramprate2=0
	variable/G tpa0=0.026551, tpa1=0.0215, tpa2=0.0221
//	variable/G midfield0=0, midfield1=0,midfield2=0,maxfield0=9,maxfield1=0.9,maxfield2=0.9
	variable/G midfield0=4.0, midfield1=0,midfield2=0,maxfield0=9,maxfield1=9,maxfield2=9
	variable/G OnOff0, OnOff1, OnOff2, TeslaOn0, TeslaOn1,TeslaOn2
	variable/G limitramp=40, limitmaxfield0=9, limitmaxfield1=60*tpa1, limitmaxfield2=60*tpa2
	variable/G ramprate0old=0, ramprate1old=0, ramprate2old=0
	variable/G midfield0old=4.0, midfield1old=0, midfield2old=0
	variable/G maxfield0old=9, maxfield1old=4, maxfield2old=4
	variable/G lock0=0, lock1=0, lock2=0
	variable/G sweeplimit0=7, sweeplimit1=7, sweeplimit2=7		//limit sweep voltage
	variable/G sweeplimit0old=7, sweeplimit1old=7, sweeplimit2old=7
	variable/G limitsweeplimit0=9.9, limitsweeplimit1=9.9, limitsweeplimit2=9.9	//limit of limit sweep voltage ... yes this variablenames sucks, but this is the absolut limit where your sweepvoltage can go.
	variable/G heatervoltage0=1.7, heatervoltage1=5, heatervoltage2=5
	variable/G heatervoltage0old=1.7, heatervoltage1old=5, heatervoltage2old=5
	variable/G limitheatervoltage0=8, limitheatervoltage1=8, limitheatervoltage2=8
	Variable/G rampZ0=0,rampZ1=0,rampZ2=0
	Variable/G rampMi0=1,rampMi1=1,rampMi2=1
	Variable/G rampMa0=0,rampMa1=0,rampMa2=0

		
	if(OnOff2==1)	
	clearIObuffer(2)	
	SMSSetTesla(1,2)
	SMSSetTPA(tpa2,2)
	SMSSetPause(0,2)
	SMSSetPause(0,2)
	wait(2)
	SMSSetLimitSweepV(sweeplimit2,2)
	SMSSetHeaterVoltage(heatervoltage2,2)
	SMSLockFrontPanel(0,2)
	wait(2)
	SMSSetMaxField(maxfield2,2)
	SMSSetMidField(midfield2,2)
	SMSSetRampRate(ramprate2,2)
	SMSramp2mid(midfield2,2)	//sends R%=in ramping mode (mid)
	wait(1)
	endif
			
End


Function SMSstartall()	//starts ramping with selected parameters
	variable/G OnOff0, OnOff1, OnOff2
	Variable/G maxfield0, maxfield1, maxfield2
	Variable/G midfield0, midfield1, midfield2
	Variable/G ramprate0, ramprate1, ramprate2
	string cmd

		if(OnOff0==1)
			SMSSetMaxField(maxfield0,0)
			SMSSetRampRate(ramprate0,0)
			SMSramp2mid(midfield0,0)
		endif
		
		if(OnOff1==1)
			SMSSetMaxField(maxfield1,1)
			SMSSetRampRate(ramprate1,1)
			SMSramp2mid(midfield1,1)		
		endif
		
		if(OnOff2==1)
			SMSSetMaxField(maxfield2,2)	
			SMSSetRampRate(ramprate2,2)
			SMSramp2mid(midfield2,2)
		endif
	
End

//******************************************************************************
//******************************************************************************
//******************************************************************************
//***************************LOW LEVEL PROCEDURES*****************
//******************************************************************************
//******************************************************************************
//******************************************************************************



Function SetPort0()
	string/G port="COM4"
	
	execute "VDTOperationsPort COM4"	// Sets the operations port
	execute "VDT killio"	//halts any pending IO and clears input buffer.
	
End

Function SetPort1()
	string/G port="COM7"

	execute "VDTOperationsPort COM7" // Sets the operations port
	execute "VDT killio"	//halts any pending IO and clears input buffer.

End

Function SetPort2()
	string/G port="COM6"

	execute "VDTOperationsPort COM6" // Sets the operations port
	execute "VDT killio"	//halts any pending IO and clears input buffer.

End


Function clearIObuffer(pws)
	variable pws
	
	if(pws==0)
		SetPort0()
	elseif(pws==1)
		SetPort1()
	elseif(pws==2)
		SetPort2()
	endif
	
	execute "VDT killio"	//halts any pending IO and clears input buffer.
	
End


Function SMSSetHeater(onoff,pws)
	variable onoff,pws
	variable/G silence
	string cmd
	string/G port
	variable/G heater0, heater1, heater2
	nvar v_vdt
	
	v_vdt=0
	
	
	if(pws==0)
		SetPort0()
	elseif(pws==1)
		SetPort1()
	elseif(pws==2)
		SetPort2()
	endif
	
	if(onoff==0)
		sprintf cmd, "VDTWrite \"H0\""
		execute cmd
		if(v_vdt>0)
			if(pws==0)
				heater0=0
			elseif(pws==1)
				heater1=0
			elseif(pws==2)
				heater2=0
			endif
		endif
		
	else
		sprintf cmd, "VDTWrite \"H1\""	
		execute cmd
		if(v_vdt>0)
			if(pws==0)
				heater0=1
			elseif(pws==1)
				heater1=1
			elseif(pws==2)
				heater2=1
			endif
		endif
	endif
	
	if(silence==0)
		if(v_vdt>0)
			print "command "+cmd+" send successful"
		else	
			print "command "+cmd+" send time-out! port: "+port
		endif
	endif
	execute "VDTOperationsPort COM1"
End

Function SMSSetRampRate(value,pws)		//value in [mT/s] !!
	variable value,pws
	variable/G silence
	string cmd
	string/G port
	variable/G ramprate0, ramprate1, ramprate2, tpa0, tpa1, tpa2,limitramp
	variable/G ramprate0old, ramprate1old, ramprate2old	
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
		if(value<=limitramp)		//some sort of limit for ramprate, see initsms3()
			sprintf cmd, "VDTWrite \"SR %f\"", value/1000/tpa0
			execute cmd
			if(v_vdt>0)
				ramprate0=value
				ramprate0old=value
				if(silence==0)
					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "ramprate>"+num2str(limitramp)+" not allowed on port "+port
			ramprate0=ramprate0old
		endif
		
	elseif(pws==1)
		SetPort1()
		if(value<=limitramp)		//some sort of limit for ramprate, see initsms3()
			sprintf cmd, "VDTWrite \"SR %f\"", value/1000/tpa1
			execute cmd
			if(v_vdt>0)
				ramprate1=value
				ramprate1old=value
				if(silence==0)
					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "ramprate>"+num2str(limitramp)+" not allowed on port "+port
			ramprate1=ramprate1old
		endif
		
	elseif(pws==2)
		SetPort2()
		if(value<=limitramp)		//some sort of limit for ramprate, see initsms3()
			sprintf cmd, "VDTWrite \"SR %f\"", value/1000/tpa2
			execute cmd
			if(v_vdt>0)
				ramprate2=value
				ramprate2old=value
				if(silence==0)
					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "ramprate>"+num2str(limitramp)+" not allowed on port "+port
			ramprate2=ramprate2old
		endif
		
	endif
End



Function SMSSetMidField(value,pws)
	variable value,pws
	variable/G silence
	string cmd
	string/G port
	variable/G midfield0, midfield1, midfield2, maxfield0, maxfield1, maxfield2
	variable/G midfield0old, midfield1old, midfield2old
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
		if(value<0)
			sprintf cmd, "VDTWrite \"D -\""
		else
			sprintf cmd, "VDTWrite \"D +\""
		endif
		execute cmd
		if(abs(value)<=maxfield0)	
			sprintf cmd, "VDTWrite \"S%% %f\"", value
			execute cmd
			if(v_vdt>0)
				midfield0=value
				midfield0old=value
				if(silence==0)
//					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "midfield>"+num2str(maxfield0)+" (maxfield0) not allowed on port "+port
			midfield0=midfield0old
		endif
		
	elseif(pws==1)
		SetPort1()
		if(value<0)
			sprintf cmd, "VDTWrite \"D -\""
		else
			sprintf cmd, "VDTWrite \"D +\""
		endif
		execute cmd
		if(abs(value)<=maxfield1)	
			sprintf cmd, "VDTWrite \"S%% %f\"", value
			execute cmd
			if(v_vdt>0)
				midfield1=value
				midfield1old=value
				if(silence==0)
//					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "midfield>"+num2str(maxfield1)+" (maxfield0) not allowed on port "+port
			midfield1=midfield1old
		endif
		
	elseif(pws==2)
		SetPort2()
		if(abs(value)<=maxfield2)	
			sprintf cmd, "VDTWrite \"S%% %f\"", value
			execute cmd
			if(v_vdt>0)
				midfield2=value
				midfield2old=value
				if(silence==0)
				//	print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "midfield>"+num2str(maxfield2)+" (maxfield0) not allowed on port "+port
			midfield2=midfield2old
		endif
		
	endif
End


Function SMSSetMaxField(value,pws)
	variable value,pws
	variable/G silence
	string cmd
	string/G port
	variable/G maxfield0, maxfield1, maxfield2
	variable/G maxfield0old, maxfield1old, maxfield2old
	variable/G limitmaxfield0, limitmaxfield1, limitmaxfield2
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
		if(value<=limitmaxfield0)	
			sprintf cmd, "VDTWrite \"S! %f\"", value
			execute cmd
			if(v_vdt>0)
				maxfield0=value
				maxfield0old=value
				if(silence==0)
					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "maxfield>"+num2str(limitmaxfield0)+" (maxfield0) not allowed on port "+port
			maxfield0=maxfield0old
		endif
		
	elseif(pws==1)
		SetPort1()
		if(value<=limitmaxfield1)	
			sprintf cmd, "VDTWrite \"S! %f\"", value
			execute cmd
			if(v_vdt>0)
				maxfield1=value
				maxfield1old=value
				if(silence==0)
					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "maxfield>"+num2str(limitmaxfield1)+" (maxfield0) not allowed on port "+port
			maxfield1=maxfield1old
		endif
		
	elseif(pws==2)
		SetPort2()
		if(value<=limitmaxfield2)	
			sprintf cmd, "VDTWrite \"S! %f\"", value
			execute cmd
			if(v_vdt>0)
				maxfield2=value
				maxfield2old=value
				if(silence==0)
					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "maxfield>"+num2str(limitmaxfield2)+" (maxfield0) not allowed on port "+port
			maxfield2=maxfield2old
		endif
		
	endif	
	
End

Function SMSSetTesla(onoff,pws)
	variable onoff,pws
	variable/G silence
	string cmd
	string/G port
	variable/G TeslaOn0, TeslaOn1, TeslaOn2
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
	elseif(pws==1)
		SetPort1()
	elseif(pws==2)
		SetPort2()
	endif
	
	if(onoff==0)
		sprintf cmd, "VDTWrite \"T0\""
		execute cmd
		if(v_vdt>0)
			if(pws==0)
				TeslaOn0=0
			elseif(pws==1)
				TeslaOn1=0
			elseif(pws==2)
				TeslaOn2=0
			endif
		endif
		
	else
		sprintf cmd, "VDTWrite \"T1\""	
		execute cmd
		if(v_vdt>0)
			if(pws==0)
				TeslaOn0=1
			elseif(pws==1)
				TeslaOn1=1
			elseif(pws==2)
				TeslaOn2=1
			endif
		endif
	endif
	
	if(silence==0)
		if(v_vdt>0)
			print "command "+cmd+" send successful"
		else	
			print "command "+cmd+" send time-out! port: "+port
		endif
	endif
End

Function SMSSetTPA(value,pws)
	variable value,pws
	variable/G silence
	string cmd
	string/G port
	variable/G tpa0, tpa1, tpa2
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
		sprintf cmd, "VDTWrite \"ST %f\"", value
		execute cmd
		if(v_vdt>0)
			tpa0=value
			if(silence==0)
				print "command "+cmd+" send successful"
			endif
		else	
			if(silence==0)
			print "command "+cmd+" send time-out! port: "+port
			endif
		endif
		
	elseif(pws==1)
		SetPort1()
		sprintf cmd, "VDTWrite \"ST %f\"", value
		execute cmd
		if(v_vdt>0)
			tpa1=value
			if(silence==0)
				print "command "+cmd+" send successful"
			endif
		else	
			if(silence==0)
			print "command "+cmd+" send time-out! port: "+port
			endif
		endif
		
	elseif(pws==2)
		SetPort2()
		sprintf cmd, "VDTWrite \"ST %f\"", value
		execute cmd
		if(v_vdt>0)
			tpa2=value
			if(silence==0)
				print "command "+cmd+" send successful"
			endif
		else	
			if(silence==0)
			print "command "+cmd+" send time-out! port: "+port
			endif
		endif
		
	endif	
	
End

Function SMSSetPause(onoff,pws)
	variable onoff,pws
	variable/G silence
	string cmd
	string/G port
	variable/G ramp0, ramp1, ramp2		//ramp0=1 ->pause is ON
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
	elseif(pws==1)
		SetPort1()
	elseif(pws==2)
		SetPort2()
	endif
	
	if(onoff==0)
		sprintf cmd, "VDTWrite \"P0\""
		execute cmd
		if(v_vdt>0)
			if(pws==0)
				ramp0=0
			elseif(pws==1)
				ramp1=0
			elseif(pws==2)
				ramp2=0
			endif
		endif
		
	else
		sprintf cmd, "VDTWrite \"P1\""	
		execute cmd
		if(v_vdt>0)
			if(pws==0)
				ramp0=1
			elseif(pws==1)
				ramp1=1
			elseif(pws==2)
				ramp2=1
			endif
		endif
	endif
	
	if(silence==0)
		if(v_vdt>0)
			print "command "+cmd+" send successful"
		else	
			print "command "+cmd+" send time-out! port: "+port
		endif
	endif
	
End

Function SMSSetLimitSweepV(value,pws)
	variable value,pws
	variable/G silence
	string cmd
	string/G port
	variable/G sweeplimit0, sweeplimit1, sweeplimit2
	variable/G sweeplimit0old, sweeplimit1old, sweeplimit2old
	variable/G limitsweeplimit0, limitsweeplimit1, limitsweeplimit2
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
		if(value<=limitsweeplimit0)	
			sprintf cmd, "VDTWrite \"SSL %f\"", value
			execute cmd
			if(v_vdt>0)
				sweeplimit0=value
				sweeplimit0old=value
				if(silence==0)
					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "maxfield>"+num2str(limitsweeplimit0)+" (maxfield0) not allowed on port "+port
			sweeplimit0=sweeplimit0old
		endif
		
	elseif(pws==1)
		SetPort1()
		if(value<=limitsweeplimit1)	
			sprintf cmd, "VDTWrite \"SSL %f\"", value
			execute cmd
			if(v_vdt>0)
				sweeplimit1=value
				sweeplimit1old=value
				if(silence==0)
					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "maxfield>"+num2str(limitsweeplimit1)+" (maxfield0) not allowed on port "+port
			sweeplimit1=sweeplimit1old
		endif
		
	elseif(pws==2)
		SetPort2()
		if(value<=limitsweeplimit2)	
			sprintf cmd, "VDTWrite \"SSL %f\"", value
			execute cmd
			if(v_vdt>0)
				sweeplimit2=value
				sweeplimit2old=value
				if(silence==0)
					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "maxfield>"+num2str(limitsweeplimit2)+" (maxfield0) not allowed on port "+port
			sweeplimit2=sweeplimit2old
		endif
		
	endif	
	
	

End

Function SMSSetHeaterVoltage(value,pws)
	variable value,pws
	variable/G silence
	string cmd
	string/G port
	variable/G heatervoltage0, heatervoltage1, heatervoltage2
	variable/G heatervoltage0old, heatervoltage1old, heatervoltage2old
	variable/G limitheatervoltage0, limitheatervoltage1, limitheatervoltage2
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
		if(value<=limitheatervoltage0)	
			sprintf cmd, "VDTWrite \"SSH %f\"", value
			execute cmd
			if(v_vdt>0)
				heatervoltage0=value
				heatervoltage0old=value
				if(silence==0)
					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "maxfield>"+num2str(limitheatervoltage0)+" (maxfield0) not allowed on port "+port
			heatervoltage0=heatervoltage0old
		endif
		
	elseif(pws==1)
		SetPort1()
		if(value<=limitheatervoltage1)	
			sprintf cmd, "VDTWrite \"SSH %f\"", value
			execute cmd
			if(v_vdt>0)
				heatervoltage1=value
				heatervoltage1old=value
				if(silence==0)
					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "maxfield>"+num2str(limitheatervoltage1)+" (maxfield0) not allowed on port "+port
			heatervoltage1=heatervoltage1old
		endif
		
	elseif(pws==2)
		SetPort2()
		if(value<=limitheatervoltage2)	
			sprintf cmd, "VDTWrite \"SSH %f\"", value
			execute cmd
			if(v_vdt>0)
				heatervoltage2=value
				heatervoltage2old=value
				if(silence==0)
					print "command "+cmd+" send successful"
				endif
			else	
				if(silence==0)
				print "command "+cmd+" send time-out! port: "+port
				endif
			endif	
		else
			print "maxfield>"+num2str(limitheatervoltage2)+" (maxfield0) not allowed on port "+port
			heatervoltage2=heatervoltage2old
		endif
		
	endif	
	
End

Function SMSLockFrontPanel(onoff,pws	)
	variable onoff,pws
	variable/G silence
	string cmd
	string/G port
	variable/G lock0, lock1, lock2		//lock0=1 locks frontpanel of powersupply #0
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
	elseif(pws==1)
		SetPort1()
	elseif(pws==2)
		SetPort2()
	endif
	
	if(onoff==0)
		sprintf cmd, "VDTWrite \"L0\""
		execute cmd
		if(v_vdt>0)
			if(pws==0)
				lock0=0
			elseif(pws==1)
				lock1=0
			elseif(pws==2)
				lock2=0
			endif
		endif
		
	else
		sprintf cmd, "VDTWrite \"L1\""	
		execute cmd
		if(v_vdt>0)
			if(pws==0)
				lock0=1
			elseif(pws==1)
				lock1=1
			elseif(pws==2)
				lock2=1
			endif
		endif
	endif
	
	if(silence==0)
		if(v_vdt>0)
			print "command "+cmd+" send successful"
		else	
			print "command "+cmd+" send time-out! port: "+port
		endif
	endif
	
End

Function SMSrampzero(pws)	///////////////////////////////////////////////////
	variable pws
	string cmd
	string/G port
	variable/G silence
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
	elseif(pws==1)
		SetPort1()
	elseif(pws==2)
		SetPort2()
	endif
	
	sprintf cmd, "VDTWrite \"R0\""
	execute cmd
	
		if(v_vdt>0)
			if(silence==0)
				print "command "+cmd+" send successful"
			endif
		else	
			print "command "+cmd+" send time-out! port: "+port
		endif
End


Function SMSrampmid(pws)	///////////////////////////////////////////////////
	variable pws
	string cmd
	variable field
	variable/G midfield0,midfield1,midfield2
	variable/G silence
	string/G port
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
		field=midfield0
	elseif(pws==1)
		SetPort1()
		field=midfield1
	elseif(pws==2)
		SetPort2()
		field=midfield2
	endif
	
	SMSramp2mid(field,pws)
	
End

Function SMSrampmax(pws)	///////////////////////////////////////////////////
	variable pws
	string cmd
	variable/G silence
	string/G port
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
	elseif(pws==1)
		SetPort1()
	elseif(pws==2)
		SetPort2()
	endif
	
	sprintf cmd, "VDTWrite \"R!\""
	execute cmd
	

		if(v_vdt>0)
			if(silence==0)
				print "command "+cmd+" send successful"
			endif
		else	
			print "command "+cmd+" send time-out! port: "+port
		endif
	
End


Function SMSramp2mid(value,pws)	///////////////////////////////////////////////////
	variable pws,value
	variable/G silence, midfield0, midfield1, midfield2, maxfield0, maxfield1, maxfield2
	variable/G midfield0old, midfield1old, midfield2old
	Variable/G rampZ0,rampZ1,rampZ2
	Variable/G rampMi0,rampMi1,rampMi2
	Variable/G rampMa0,rampMa1,rampMa2
	variable rampfield, realfield
	string cmd
	string/G port
	nvar v_vdt
	
	v_vdt=0
	
	if(pws==0)
		SetPort0()
		midfield0=value
		if(rampZ0==1||rampMa0==1)
		
			SMSSetMidField(value,pws)
			if(silence==0)
				print "will ramp to mid next time you select MID!"
			endif
		else	
			execute "VDT killio"
			wait(2)
			execute "VDTWrite \"R%%\""
		
			SMSSetdirection(value,pws)		//selects right direction	
			SMSSetMidField(value,pws)
			
		endif
	elseif(pws==1)
		SetPort1()
		midfield1=value
		if(rampZ1==1 || rampMa1==1)
		
			SMSSetMidField(value,pws)
			if(silence==0)
				print "will ramp to mid next time you select MID!"
			endif
		else
			wait(1)	
			execute "VDT killio"
			execute "VDTWrite \"R%%\""
		
			SMSSetdirection(value,pws)		//selects right direction	
			SMSSetMidField(value,pws)
			
		endif

	elseif(pws==2)
		SetPort2()
		midfield2=value
		if(rampZ2==1||rampMa2==1)
		
			SMSSetMidField(value,pws)
			if(silence==0)
				print "will ramp to mid next time you select MID!"
			endif
		else
			wait(1)	
			execute "VDT killio"
			execute "VDTWrite \"R%%\""
			
			SMSSetdirection(value,pws)		//selects right direction	
			SMSSetMidField(value,pws)
			
		endif
	endif		
		
End


//Function SMSramp2mid(value,pws)	///////////////////////////////////////////////////
//	variable pws,value
//	variable/G silence, midfield0, midfield1, midfield2, maxfield0, maxfield1, maxfield2
//	variable/G midfield0old, midfield1old, midfield2old
//	Variable/G rampZ0,rampZ1,rampZ2
//	Variable/G rampMi0,rampMi1,rampMi2
//	Variable/G rampMa0,rampMa1,rampMa2
//	variable rampfield
//	string cmd
//	string/G port
//	nvar v_vdt
//	
//	v_vdt=0
//	
//	if(pws==0)
//		SetPort0()
//		midfield0=value
//		if(rampZ0==1||rampMa0==1)
//		
//			SMSSetMidField(value,pws)
//			if(silence==0)
//				print "will ramp to mid next time you select MID!"
//			endif
//		else	
//			execute "VDT killio"
//			wait(2)
//			execute "VDTWrite \"R%%\""
//		
//			SMSSetdirection(value)		//selects right direction - only necessary, if one uses both (pos./neg.) field-directions	
//			SMSSetMidField(value,pws)
//			
//		endif
//	elseif(pws==1)
//		SetPort1()
//		midfield1=value
//		if(rampZ1==1 || rampMa1==1)
//		
//			SMSSetMidField(value,pws)
//			if(silence==0)
//				print "will ramp to mid next time you select MID!"
//			endif
//		else
//			wait(1)	
//			execute "VDT killio"
//			execute "VDTWrite \"R%%\""
//		
//			SMSSetdirection(value)		//selects right direction	
//			SMSSetMidField(value,pws)
//			
//		endif
//
//	elseif(pws==2)
//		SetPort2()
//		midfield2=value
//		if(rampZ2==1||rampMa2==1)
//		
//			SMSSetMidField(value,pws)
//			if(silence==0)
//				print "will ramp to mid next time you select MID!"
//			endif
//		else
//			wait(1)	
//			execute "VDT killio"
//			execute "VDTWrite \"R%%\""
//
//			SMSSetdirection(value)		//selects right direction	
//			SMSSetMidField(value,pws)
//			
//		endif
//	endif		
//		
//End

Function SMSSetdirection(field,pws)	// checks for direction and sets right D+/D- command, you have to specify the vdtoperationsport com# first!!
	variable field,pws
	variable fieldOld, fieldsignNew
	variable currentfield
	string/G SMSstatus, dummystr, cmd, signNew, currentsign, fieldsign0, fieldsign1, fieldsign2
	nvar v_vdt
	string/G port
	variable/G silence
	
	if(pws==0)
		currentsign=fieldsign0
	elseif(pws==1)
		currentsign=fieldsign1
	elseif(pws==2)
		currentsign=fieldsign2
	endif
	
	v_vdt=0
	
//	wait(1)
//	execute "VDT killio"
//	execute "VDTWrite \"GO\" "
//	wait(1)
//	execute "VDTRead/Q/O=5 SMSstatus"

//	print SMSstatus
	
//	currentfield=str2num(SMSstatus[17,24])
	
//	currentsign=SMSstatus[17]

	dummystr=num2str(field)
	if(stringmatch(dummystr[0],"-"))
		signNew=dummystr[0]
	else
		signNew="+"
	endif
	
	if(stringmatch(currentsign,"-"))
		fieldOld=-1
	else
		fieldOld=1
	endif
	
	if(stringmatch(signNew,"-"))
		fieldsignNew=-1
	else
		fieldsignNew=1
	endif
	
	
	if(fieldsignNew>fieldOld)
	
		sprintf cmd, "VDTWrite \"D +\""
		execute cmd
		
		if(silence==0)
			if(v_vdt>0)
//				print "command "+cmd+" send successful"
			else	
				print "command "+cmd+" send time-out! port: "+port
			endif
		endif
	endif
	
	if(fieldsignNew<fieldOld)
	
		sprintf cmd, "VDTWrite \"D -\""
		execute cmd
		
		
		if(silence==0)
			if(v_vdt>0)
//				print "command "+cmd+" send successful"
			else	
				print "command "+cmd+" send time-out! port: "+port
			endif
		endif
	endif
	
	if(fieldsignNew==fieldOld && fieldsignNew==1)
	
		sprintf cmd, "VDTWrite \"D +\""
		execute cmd
		
		if(silence==0)
			if(v_vdt>0)
//				print "command "+cmd+" send successful"
			else	
				print "command "+cmd+" send time-out! port: "+port
			endif
		endif
	endif
	
	if(fieldsignNew==fieldOld && fieldsignNew==-1)
	
		sprintf cmd, "VDTWrite \"D -\""
		execute cmd
		
		if(silence==0)
			if(v_vdt>0)
//				print "command "+cmd+" send successful"
			else	
				print "command "+cmd+" send time-out! port: "+port
			endif
		endif
	endif
			
	execute "VDT killio"
	
	if(pws==0)
		fieldsign0=signNew
	elseif(pws==1)
		fieldsign1=signNew
	elseif(pws==2)
		fieldsign2=signNew
	endif

End


//Function SMSSetdirection(field)	// checks for direction and sets right D+/D- command, you have to specify the vdtoperationsport com# first!!
//	variable field
//	variable fieldOld, fieldsignNew
//	variable currentfield
//	string/G SMSstatus, dummystr, cmd, signNew, currentsign
//	nvar v_vdt
//	string/G port
//	variable/G silence
//	
//	v_vdt=0
//	
//	wait(1)
//	execute "VDT killio"
//	execute "VDTWrite \"GO\" "
//	wait(1)
//	execute "VDTRead/Q/O=5 SMSstatus"
//
////	print SMSstatus
//	
//	currentfield=str2num(SMSstatus[17,24])
//	
//	currentsign=SMSstatus[17]
//	dummystr=num2str(field)
//	signNew=dummystr[0]
//	
//	if(stringmatch(currentsign,"-"))
//		fieldOld=-1
//	else
//		fieldOld=1
//	endif
//	
//	if(stringmatch(signNew,"-"))
//		fieldsignNew=-1
//	else
//		fieldsignNew=1
//	endif
//	
//	
//	if(fieldsignNew>fieldOld)
//	
//		sprintf cmd, "VDTWrite \"D +\""
//		execute cmd
//		
//		if(silence==0)
//			if(v_vdt>0)
////				print "command "+cmd+" send successful"
//			else	
//				print "command "+cmd+" send time-out! port: "+port
//			endif
//		endif
//	endif
//	
//	if(fieldsignNew<fieldOld)
//	
//		sprintf cmd, "VDTWrite \"D -\""
//		execute cmd
//		
//		if(silence==0)
//			if(v_vdt>0)
////				print "command "+cmd+" send successful"
//			else	
//				print "command "+cmd+" send time-out! port: "+port
//			endif
//		endif
//	endif
//	
//	if(fieldsignNew==fieldOld && fieldsignNew==1)
//	
//		sprintf cmd, "VDTWrite \"D +\""
//		execute cmd
//		
//		if(silence==0)
//			if(v_vdt>0)
////				print "command "+cmd+" send successful"
//			else	
//				print "command "+cmd+" send time-out! port: "+port
//			endif
//		endif
//	endif
//	
//	if(fieldsignNew==fieldOld && fieldsignNew==-1)
//	
//		sprintf cmd, "VDTWrite \"D -\""
//		execute cmd
//		
//		if(silence==0)
//			if(v_vdt>0)
////				print "command "+cmd+" send successful"
//			else	
//				print "command "+cmd+" send time-out! port: "+port
//			endif
//		endif
//	endif
//			
//	execute "VDT killio"
//
//End
Function getfield(pws)
	variable pws
	variable/G field		 
      string/G statussms

	
	if(pws==0)
		SetPort0()
		getsmsstatus(0)
		
	elseif(pws==1)
		SetPort1()
		getsmsstatus(1)
	
	elseif(pws==2)
		SetPort2()
		getsmsstatus(2)
	endif
	
	field=str2num(statussms[17,23])
	
	return field
End


Function getsmsstatus(pws)
	variable pws
	string port
	string/G statussms
	
	if(pws==0)
		SetPort0()
		port="Solenoid status: "
		
	elseif(pws==1)
		SetPort1()
		port="Coils 1-2 status: "
	elseif(pws==2)
		SetPort2()
		port="Coils 3-4 status: "
	endif
	
	wait(1)
	execute "VDT killio"
	execute "VDTWrite \"GO\" "
	wait(1)
	execute "VDTRead/Q/O=5 statussms"
	
	//print port+statussms
End



//Function getsmsstatus(pws)
//	variable pws
//	string port
//	string/G statussms
//	
//	if(pws==0)
//		SetPort0()
//		port="Solenoid status: "
//		
//	elseif(pws==1)
//		SetPort1()
//		port="Coils 1-2 status: "
//	elseif(pws==2)
//		SetPort2()
//		port="Coils 3-4 status: "
//	endif
//	
//	wait(1)
//	execute "VDT killio"
//	execute "VDTWrite \"GO\" "
//	wait(1)
//	execute "VDTRead/Q/O=5 statussms"
//	
//	print port+statussms
//End





//******************************************************************************
//******************************************************************************
//******************************************************************************
//***************************BLA**********************************************
//******************************************************************************
//******************************************************************************
//******************************************************************************

Function locker()
	variable/G locked,OnOff0, OnOff1, OnOff2
	
	locked=1
	OnOff0=0
	OnOff1=0
	OnOff2=0
	
	SetVariable chktpa0,disable=2
	SetVariable chktpa1,disable=2
	SetVariable chktpa2,disable=2
	CheckBox chkT0, disable=2
	CheckBox chkT1, disable=2
	CheckBox chkT2, disable=2
	
	Button status0, disable=2
	Button status1, disable=2
	Button status2, disable=2
	
	CheckBox ramp0, disable=(2-OnOff0*2)
	CheckBox heat0,disable=(2-OnOff0*2)
	SetVariable rr0,disable=(2-OnOff0*2)
	SetVariable mid0,disable=(2-OnOff0*2)
	SetVariable max0,disable=(2-OnOff0*2)
	
	CheckBox ramp1,disable=(2-OnOff1*2)
	CheckBox heat1,disable=(2-OnOff1*2)
	SetVariable rr1,disable=(2-OnOff1*2)
	SetVariable mid1,disable=(2-OnOff1*2)
	SetVariable max1,disable=(2-OnOff1*2)
	
	CheckBox ramp2,disable=(2-OnOff2*2)
	CheckBox heat2,disable=(2-OnOff2*2)
	SetVariable rr2,disable=(2-OnOff2*2)
	SetVariable mid2,disable=(2-OnOff2*2)
	SetVariable max2,disable=(2-OnOff2*2)
	
	CheckBox rampmax0, disable=(2-OnOff0*2)
	CheckBox rampmax1, disable=(2-OnOff1*2)
	CheckBox rampmax2, disable=(2-OnOff2*2)
	
	CheckBox rampmid0, disable=(2-OnOff0*2)
	CheckBox rampmid1, disable=(2-OnOff1*2)
	CheckBox rampmid2, disable=(2-OnOff2*2)
	
	CheckBox rampzero0, disable=(2-OnOff0*2)
	CheckBox rampzero1, disable=(2-OnOff1*2)
	CheckBox rampzero2, disable=(2-OnOff2*2)
	

End