#pragma rtGlobals=1		// Use modern global access method.
 
// Wave management routines: saving, logging, displaying with automatic formatting and labeling
// Alex Johnson 3/02
// Modified 9/02

// The first function (getlabel) defines the naming convention, which should be followed by any routine that
// makes new waves in order that they can be displayed properly
// the basic form of wave names is:
//		<datatype><xaxistype>[<yaxistype>]_<num>
// example: 	condtimec4_113 is conductance data as a function of time (x axis) and DAC channel 4 (y axis)
//			vdragperp_114 is drag voltage data as a function of perpendicular field
// with unique identification # 113
// You could then display this data by any of the following commands:
//		showwaves("condtimec4_113")
//		shownum(113)				(this will show all waves numbered 113 - some routines generate multiple waves at once)
//		showdata("timec4")			(shows all waves with time as x-axis and c4 as y-axis)
//		showrange(113,115)			(same as shownum(113);shownum(114);shownum(115) )
// Other routines in this file:
//		appendnum(num)				appends waves with id# num to the top graph
//		logwave(wavestr)				records the conditions under which a wave was taken in a log file named by today's date
//		nextwave()					returns the next unused wave number
//		keepg(idstr),keepg2(idstr)		duplicate and log g or g2 as cond<idstr>_<nextwave>
//		keepwave(wavestr)			add the next sequential number to a wave named wavestr and log this wave
//		savewaves(list)				saves all waves in list to separate files
//		savenum(num)				saves all waves with id# num
//		saverange(num1,num2)		saves all waves in a number range
//		wavenum(wavestr)			extract the number from a wave name
//		hlog(wavestr)					log the beginning of data taking for wavestr in the history

function/S getlabel(wavestr,axis)
	// returns graph labels for waves following my naming conventions (which this function defines)
	// NOTE: this is the only place you need to put new label types, other than the data-taking routines
	
	// if axis=0, returns the data label (y axis for 1d waves, colorscale for 2d waves)
	// if axis=1, returns the x axis label
	// if axis=2, returns the y axis label (only for 2d waves)
	
	string wavestr
	variable axis
	
	string labelstr,cropstr,chanstr
	variable nextpos,paramnum
	cropstr=wavestr
	
	// data type labels - axis=0 (y axis or colorscale label)
	if(stringmatch(cropstr[0,4],"sdev_"))
		nextpos=6
		labelstr="sdev (\\uV)"// assumes this string is going in a command to be executed, hence the double slash
	
	elseif(stringmatch(cropstr[0,5],"vdc_d1"))
		nextpos=6
		labelstr="vdc_d1 (\\umV)"
	elseif(stringmatch(cropstr[0,5],"vdc_d2"))
		nextpos=6
		labelstr="vdc_d2 (\\umV)"	
	elseif(stringmatch(cropstr[0,4],"vdc_d"))
		nextpos=5
		labelstr="vdc_d (\\umV)"
	elseif(stringmatch(cropstr[0,4],"vdc_s"))
		nextpos=5
		labelstr="vdc_s (\\umV)"
	elseif(stringmatch(cropstr[0,7],"vdc_both"))
		nextpos=8
		labelstr="vdc_both (\\umV)"
		
	elseif(stringmatch(cropstr[0,2],"pna"))
		nextpos=3
		labelstr="center_freq on PNA (\\uGHz)"

	elseif(stringmatch(cropstr[0,5],"data_"))
		nextpos=6
		labelstr="data (\\V)"	
	elseif(stringmatch(cropstr[0,5],"gdrive"))
		labelstr="Drive-side Conductance (\\ue\\S2\\M/h)"
		nextpos=6	
	elseif(stringmatch(cropstr[0,5],"condxx"))
		nextpos=6
		labelstr="g (\\ue\\S2\\M/h)"		
	elseif(stringmatch(cropstr[0,4],"cond2"))
		nextpos=5
		labelstr="g (\\ue\\S2\\M/h)"		
	
	elseif(stringmatch(cropstr[0,7],"b_sp_sol"))
		nextpos=8
		labelstr="B\\Bsp+sol (\\u T )"
	
	elseif(stringmatch(cropstr[0,4],"b_all"))
		nextpos=5
		labelstr="B\\Bsplit (Bsol also present) (\\u T )"
	
	elseif(stringmatch(cropstr[0,7],"log_cond"))
		nextpos=8
		labelstr="g (\\u e\\S2\\M/h )"

	elseif(stringmatch(cropstr[0,5],"lo_v_M"))
		nextpos=6
		labelstr="V (\\u V )"
	elseif(stringmatch(cropstr[0,6],"lo_v_Ph"))
		nextpos=7
		labelstr="V_Ph (\\u Grad )"
	elseif(stringmatch(cropstr[0,6],"lo_v2_M"))
		nextpos=7
		labelstr="V (\\u V )"
	elseif(stringmatch(cropstr[0,7],"lo_v2_Ph"))
		nextpos=8
		labelstr="V_Ph (\\u Grad )"

	elseif(stringmatch(cropstr[0,5],"lo_i_M"))
		nextpos=6
		labelstr="I_M (\\u A )"
	elseif(stringmatch(cropstr[0,6],"lo_i_Ph"))
		nextpos=7
		labelstr="I_Ph (\\u Grad )"
	elseif(stringmatch(cropstr[0,6],"lo_i2_M"))
		nextpos=7
		labelstr="I2_M (\\u A )"
	elseif(stringmatch(cropstr[0,7],"lo_i2_Ph"))
		nextpos=8
		labelstr="I2_Ph (\\u Grad )"

	elseif(stringmatch(cropstr[0,2],"Res"))
		nextpos=3
		labelstr="Res (\\u Om )"

	elseif(stringmatch(cropstr[0,10],"time"))
		labelstr="time (\\u AU)"
		nextpos=4		
	elseif(stringmatch(cropstr[0,10],"lo1_ac_freq"))
		nextpos=11
		labelstr="lock-in1 freq(\\u Hz)"
	elseif(stringmatch(cropstr[0,10],"lo2_ac_freq"))
		nextpos=11
		labelstr="lock-in2 freq(\\u Hz)"

		
	elseif(stringmatch(cropstr[0,8],"LStmpRes2"))
		nextpos=9
		labelstr="Res (\\u Om )"

	elseif(stringmatch(cropstr[0,8],"LStmpRes1"))
		nextpos=9
		labelstr="Res (\\u Om )"
		
	elseif(stringmatch(cropstr[0,7],"LStmpRes"))
		nextpos=8
		labelstr="Res (\\u Om )"
		
	elseif(stringmatch(cropstr[0,3],"I_dc"))
		nextpos=4
		labelstr="I\\Bdc\\M (\\u A )"
	elseif(stringmatch(cropstr[0,4],"I2_dc"))
		nextpos=5
		labelstr="I2\\Bdc\\M (\\u A )"
		
	elseif(stringmatch(cropstr[0,4],"V_dc2"))
		nextpos=4
		labelstr="V\\Bdc\\M (\\u V )"
	elseif(stringmatch(cropstr[0,3],"V_dc"))
		nextpos=4
		labelstr="V\\Bdc\\M (\\u V )"
		
	elseif(stringmatch(cropstr[0,4],"avg_"))
		nextpos=5
		labelstr="sdev (\\V)"	
	elseif(stringmatch(cropstr[0,4],"cond3"))
		nextpos=5
		labelstr="g (\\ue\\S2\\M/h)"
	elseif(stringmatch(cropstr[0,4],"gdrag"))
		nextpos=5
		labelstr="Drag-side Conductance (\\ue\\S2\\M/h)"
	elseif(stringmatch(cropstr[0,4],"vdrag"))
		nextpos=5
		labelstr="Drag Voltage (\\uV)"
	elseif(stringmatch(cropstr[0,4],"ileak"))
		nextpos=5
		labelstr="Leak Current (\\uA)"		
	elseif(stringmatch(cropstr[0,4],"idrag"))
		nextpos=5
		labelstr="Drag Current (\\uA)"
	elseif(stringmatch(cropstr[0,4],"phase"))
		//labelstr="Phase (\\uRadians)"
		labelstr="Phase (\\uDegree)"
		nextpos=5
	elseif(stringmatch(cropstr[0,4],"ddrag"))
		labelstr="DC drag (\\uV)"
		nextpos=5	
	elseif(stringmatch(cropstr[0,4],"power"))
		labelstr="RF power (\\udBm)"
		nextpos=5	
	
	elseif(stringmatch(cropstr[0,4],"P_IVC"))
		labelstr="P IVC (\\umbar)"
		nextpos=5	
	elseif(stringmatch(cropstr[0,5],"P_STIL"))
		labelstr="P STIL (\\umbar)"
		nextpos=6	
	

	elseif(stringmatch(cropstr[0,3],"cond"))
		nextpos=4
		labelstr="g (\\ue\\S2\\M/h)"
	elseif(stringmatch(cropstr[0,3],"Rxx2"))
		nextpos=4
		labelstr="R\\BXX2\\M (\\F'Symbol'W\\F'Arial')"
	elseif(stringmatch(cropstr[0,3],"norm"))
		nextpos=4
		labelstr="Normalized signal"
	elseif(stringmatch(cropstr[0,3],"freq"))
		nextpos=4
		labelstr="Frequency (\\uHz)"
	elseif(stringmatch(cropstr[0,3],"vdop"))
		nextpos=4
		labelstr="Out-of-phase Drag Voltage (\\uV)"
	elseif(stringmatch(cropstr[0,3],"idop"))
		nextpos=4
		labelstr="Out-of-phase Drag Current (\\uA)"
	elseif(stringmatch(cropstr[0,3],"gdop"))
		nextpos=4
		labelstr="Out-of-phase Drag-side Conductance (\\ue\\S2\\M/h)"
				
	elseif(stringmatch(cropstr[0,2],"Rd2"))
		nextpos=3
		labelstr="R\\Bd2\\M (e²/h)"	
	elseif(stringmatch(cropstr[0,2],"IDC"))
		nextpos=3
		labelstr="I\\BDC\\M (A)"			
	elseif(stringmatch(cropstr[0,2],"Rxy"))
		nextpos=3
//		labelstr="R\\BXY\\M(h/e²)"
		labelstr="R\\BXY\\M (\u\\F'Symbol'W\\F'Arial')"
	elseif(stringmatch(cropstr[0,2],"Rxx"))
		nextpos=3
		labelstr="R\\BXX\\M (\u\\F'Symbol'W\\F'Arial')"
	elseif(stringmatch(cropstr[0,2],"bmt"))
		nextpos=3
		labelstr="Measured Field (\\umT)"
	elseif(stringmatch(cropstr[0,2],"vdc"))
		labelstr="Measured DC voltage (\\uV)"
		nextpos=3			
		
	elseif(stringmatch(cropstr[0,7],"RF_power"))
		labelstr="RF_power (\\udB)"
		nextpos=8
		
	elseif(stringmatch(cropstr[0,2],"vac"))
		labelstr="V\BAC\M (\\uV)"
		nextpos=3		
	elseif(stringmatch(cropstr[0,2],"iac"))
		labelstr="I\BAC\M (\\uA)"
		nextpos=3
	
	elseif(stringmatch(cropstr[0,1],"R1") || stringmatch(cropstr[0,1],"R2") || stringmatch(cropstr[0,1],"R3") || stringmatch(cropstr[0,1],"R4"))
		nextpos=2
		labelstr="R\\BXX\\M (\\F'Symbol'W\\F'Arial')"	
	elseif(stringmatch(cropstr[0,1],"Rd"))
		nextpos=2
		labelstr="R\\Bd\\M (h/e²)"
	elseif(stringmatch(cropstr[0,1],"Rh"))
		nextpos=2
		labelstr="R\\BH\\M(h/e\\S2\\M)"
	elseif(stringmatch(cropstr[0,1],"v2"))
		labelstr="Second voltage (\\uV)"
		nextpos=2	
	elseif(stringmatch(cropstr[0,1],"i2"))
		labelstr="I\BDC\M (\\uA)"
		nextpos=2
	elseif(stringmatch(cropstr[0,3],"T_mc"))
		nextpos=4
		labelstr="T (\\umK)"
	elseif(stringmatch(cropstr[0,1],"T0") || stringmatch(cropstr[0,1],"T1") || stringmatch(cropstr[0,1],"T2") || stringmatch(cropstr[0,1],"T3") || stringmatch(cropstr[0,1],"T4") || stringmatch(cropstr[0,1],"T5"))
		nextpos=2
		labelstr="T (\\umK)"	
	elseif(stringmatch(cropstr[0,0],"T"))
		nextpos=1
		labelstr="T (\\umK)"
	elseif(stringmatch(cropstr[0,0],"I"))
		labelstr="I\\BDC\\M (\\u A)"
		nextpos=1
	elseif(stringmatch(cropstr[0,0],"V"))
		labelstr="V\\BDC\\M (\\u V)"
		nextpos=1

	else
		nextpos=0
		labelstr=""	// failed to figure out a label
	endif
	// sweep axes - axis=1 or 2
	if(axis>0)
		variable i=0
		do
			cropstr=cropstr[nextpos,30]
			i+=1
//			print cropstr		
			if(stringmatch(cropstr[0,6],"vdcdiff"))	
				labelstr="V\\BDC, DIFF\\M (\\F'Symbol'm\\F'Arial'V)"
				nextpos=7
			
			elseif(stringmatch(cropstr[0,7],"RF_power"))
				labelstr="RF_power (\\udB)"
				nextpos=8
			
			elseif(stringmatch(cropstr[0,2],"pna"))
				nextpos=3
				labelstr="center_freq on PNA (\\uGHz)"

			elseif(stringmatch(cropstr[0,5],"vdc_d1"))
				nextpos=6
				labelstr="vdc_d1 (\\umV)"

			elseif(stringmatch(cropstr[0,5],"vdc_d2"))
				nextpos=6
				labelstr="vdc_d2 (\\umV)"

			elseif(stringmatch(cropstr[0,4],"vdc_s"))
				nextpos=5
				labelstr="vdc_s (\\umV)"
			elseif(stringmatch(cropstr[0,4],"vdc_d"))
				nextpos=5
				labelstr="vdc_d (\\umV)"			
		
			elseif(stringmatch(cropstr[0,7],"vdc_both"))
				nextpos=8
				labelstr="vdc_both (\\umV)"
		
			elseif(stringmatch(cropstr[0,10],"time"))
				labelstr="time (\\u AU)"
				nextpos=4
			elseif(stringmatch(cropstr[0,10],"lo1_ac_freq"))
				labelstr="lock-in1 freq(\\u Hz)"
				nextpos=11
			elseif(stringmatch(cropstr[0,10],"lo2_ac_freq"))
				labelstr="lock-in2 freq(\\u Hz)"
				nextpos=11

			elseif(stringmatch(cropstr[0,7],"b_sp_sol"))
				nextpos=8
				labelstr="B\\Bsp+sol (\\u T )"

			elseif(stringmatch(cropstr[0,4],"b_all"))
				nextpos=5
				labelstr="B\\Bsplit (Bsol also present) (\\u T )"
	
			elseif(stringmatch(cropstr[0,5],"bsplit"))
				labelstr="B\\Bsplit\\M (\\uT)"
				nextpos=6

			elseif(stringmatch(cropstr[0,4],"noise"))
				labelstr="Time (\\usec)"
				nextpos=5
			elseif(stringmatch(cropstr[0,4],"basym"))
				labelstr="Channel Bias Asymmetry"
				nextpos=5
			elseif(stringmatch(cropstr[0,4],"vasym"))
				labelstr="Channel Drive Asymmetry"
				nextpos=5
			elseif(stringmatch(cropstr[0,4],"power"))
				labelstr="RF power (\\udBm)"
				nextpos=5	
			
			elseif(stringmatch(cropstr[0,3],"bsol"))
				labelstr="B\\Bsol\\M (\\uT)"
				nextpos=4
				
			elseif(stringmatch(cropstr[0,4],"bombo"))
				labelstr="bombo B\\Bsol\\M (\\uT)"
				nextpos=5
				
			elseif(stringmatch(cropstr[0,9],"bombo_freq"))
				labelstr="bombo_freq (\\uHz)"
				nextpos=10
				
			elseif(stringmatch(cropstr[0,3],"time"))
				labelstr="Time (\\usec)"
				nextpos=4
			elseif(stringmatch(cropstr[0,3],"vavg"))	//obsolete
				labelstr="Average channel/dot bias (\\uV)"
				nextpos=4				
			elseif(stringmatch(cropstr[0,3],"perp"))
				labelstr="B\\BPERP\\M (\\uT)"
				nextpos=4
			elseif(stringmatch(cropstr[0,3],"freq"))
				labelstr="Frequency (\\uHz)"
				nextpos=4
			elseif(stringmatch(cropstr[0,3],"vnet"))
				labelstr="Channel DC bias (mV)"
				nextpos=4
			elseif(stringmatch(cropstr[0,3],"vtot"))
				labelstr="Channel Drive Voltage (mVrms)"
				nextpos=4
				
			elseif(stringmatch(cropstr[0,2],"vdc"))	
				labelstr="V\\BDC\\M (\umV)"
				nextpos=3		
			elseif(stringmatch(cropstr[0,2],"par"))
				labelstr="B\\BPAR\\M (\\umT)"
				nextpos=3
			elseif(stringmatch(cropstr[0,2],"lnf"))
				labelstr="ln(Frequency/Hz)"
				nextpos=3
										
			elseif(stringmatch(cropstr[0,1],"fc"))
				paramnum=str2num(cropstr[2,3])
				chanstr=num2istr(paramnum)
				labelstr="Fine Chan " + chanstr + " (mV)"
				if(waveexists($"DAQLabel"))
					wave/T cnames=$"DAQlabel"
					labelstr=labelstr+" - "+cnames[paramnum]
				endif
				nextpos=strlen(chanstr)+2
			elseif(stringmatch(cropstr[0,9],"bz_with_by"))	// for 3axis magnet
				labelstr="bz with by also(\\uT)"
				nextpos=10
			elseif(stringmatch(cropstr[0,1],"bx"))	// for 3axis magnet
				labelstr="X Magnetic Field (\\uT)"
				nextpos=2
			elseif(stringmatch(cropstr[0,1],"by"))
				labelstr="Y Magnetic Field (\\uT)"
				nextpos=2
			elseif(stringmatch(cropstr[0,1],"bz"))
				labelstr="Z Magnetic Field (\\uT)"
				nextpos=2
				
			elseif(stringmatch(cropstr[0,1],"vb"))
				labelstr="Bias Voltage (\\uV)"
				nextpos=2
			elseif(stringmatch(cropstr[0,3],"T_mc"))
				nextpos=4
				labelstr="T (\\umK)"
						
			elseif(stringmatch(cropstr[0],"c"))
				paramnum=str2num(cropstr[1,2])
				chanstr=num2istr(paramnum)
				labelstr="c" + chanstr + " (mV)"
				if(waveexists($"DAQLabel"))
					wave/T cnames=$"DAQlabel"
					labelstr=labelstr+" - "+cnames[paramnum]
				endif
				nextpos=strlen(chanstr)+1	
			elseif(stringmatch(cropstr[0],"b"))	// as long as I just have one field... simpler name
				labelstr="B\\BPERP\\M (\\uT)"
				nextpos=1
			elseif(stringmatch(cropstr[0],"k"))
				labelstr="Pin (w/B and c1 correction) (mV)"
				nextpos=1
			elseif(stringmatch(cropstr[0],"p"))
				paramnum=str2num(cropstr[1,2])
				chanstr=num2istr(paramnum)
				labelstr="Param. "+chanstr + " (mV)"
				if(waveexists($"WC_names"))
					wave/T pnames=$"WC_names"
					labelstr=labelstr+" - "+pnames[paramnum]
				endif
				nextpos=strlen(chanstr)+1
				
			else
				labelstr=""	// failed to figure out a label
				nextpos=0
			endif
		while(i<axis)
	endif
	return labelstr
end

function KeepG(idstr)
	string idstr	// see getlabel for naming conventions
	string cmd
	variable nw=nextwave()
	string wavestr
	if(strlen(getlabel(idstr,0))==0)	// no data type identifier - assume cond
		sprintf wavestr, "cond%s_%d",idstr,nw
	else
		sprintf wavestr, "%s_%d",idstr,nw
	endif
	sprintf cmd,"duplicate g %s",wavestr
	execute cmd
	printf "created %s",wavestr
	logwave(wavestr)
	string label1=getlabel(wavestr,1)
	if(stringmatch(label1[0,3],"Perp"))	// perpendicular field sweep - save measured fields too
		sprintf wavestr, "bmt_%d",nw
		sprintf cmd, "duplicate bmt %s", wavestr
		execute cmd
		printf ", created %s",wavestr
	endif
	printf "\r"
end

function KeepG2(idstr)
	// keeps the wave g2 as cond2... assumes you've already saved g and want the same # for g2
	// as  this is assumed to have been a simultaneous measurement with, does not look for bmt
	string idstr	
	string cmd
	variable nw=nextwave()-1
	string wavestr
	if(strlen(getlabel(idstr,0))==0)	// no data type identifier - assume cond2
		sprintf wavestr, "cond2%s_%d",idstr,nw
	else
		sprintf wavestr, "%s_%d",idstr,nw
	endif
	sprintf cmd,"duplicate g2 %s",wavestr
	execute cmd
	printf "created %s\r",wavestr
	logwave(wavestr)
end

function KeepWave(wavestr)	// adds next sequential number to wavestr and logs it
	string wavestr

	string cmd
	variable nw=nextwave()
	string newwavestr
	sprintf newwavestr "%s_%d", wavestr,nw
	sprintf cmd,"duplicate %s %s",wavestr,newwavestr
	execute cmd
	printf "created %s\r",newwavestr
	logwave(newwavestr)
end

function nextwave()
//	variable maxnum=0
//	string waves=wavelist("*",";","")+"junk_0;"
//	print itemsinlist(waves,";")
//	make/o/n=(itemsinlist(waves,";")) nums
//	nums[]=str2num(stringfromlist(1,stringfromlist(p,waves,";"),"_"))
//	wavestats/q nums
//	return V_max+1
	variable/G next_wave
	next_wave += 1
	return next_wave
end

function saverange(num1,num2)
	variable num1
	variable num2
	variable i=num1
	do
		savenum(i)
		i+=1
	while(i<=num2)
end

function savenum(num)
	variable num
	string numstr
	sprintf numstr, "*_%d",num
	string list=wavelist(numstr,";","")
	savewaves(list)
end

function savewaves(list)
	string list
	save/B/P=homepath list
	if(itemsinlist(list,";")==1)
		print "saved "+ stringfromlist(0,list,";") +".ibw"
	else
		printf "saved %d files:\r%s\r",itemsinlist(list,";"),list
	endif
end

function shownum(num)
	variable num
	string numstr
	sprintf numstr, "*_%d",num
	string list=wavelist(numstr,";","")
	if(itemsinlist(list,";")==0)
		return 0
	elseif(itemsinlist(list,";")>1)	// don't show measured b values
		string bmtstr
		sprintf bmtstr, "bmt_%d",num
		list=removefromlist(bmtstr,list)
	endif
	showwaves(list)
end

function showmany(idstr,num1,num2,suffix)
	string idstr	// note: includes data type, and can also include wildcards
	variable num1,num2	// lowest and highest wave numbers to include
	string suffix	// to allow for _avg, _sd, etc - include the underscore if there's a suffix, else just use ""
	string searchstr
	string list="",list1
	variable i=num1
	do
		sprintf searchstr,"%s_%d%s",idstr,i,suffix
		list1=wavelist(searchstr,";","")
		list=list+list1
		i+=1
	while(i<=num2)
	variable items=itemsinlist(list,";")
	if(items>0)
		showwaves(stringfromlist(0,list,";"))
		variable dims=wavedims($stringfromlist(0,list,";"))
		if(items>1)
			i=1
			do
				if(dims==1)
					execute "appendtograph "+stringfromlist(i,list,";")
				else
					showwaves(stringfromlist(i,list,";"))
				endif
				i+=1
			while(i<items)
			graphcolors("")
		endif
	endif
end

function appendnum(num)
	variable num
	string numstr
	sprintf numstr, "*_%d",num
	string list=wavelist(numstr,";","")
	if(itemsinlist(list,";")>1)	// don't append measured b values
		string bmtstr
		sprintf bmtstr, "bmt_%d",num
		list=removefromlist(bmtstr,list)
	endif

	variable i=0
	string cmd
	do
		string item=stringfromlist(i,list,";")
		if(wavedims($item)==1)
			cmd="appendtograph "+item
		else
			cmd="appendimage "+item+";ModifyImage "+item+" ctab= {*,*,YellowHot,0}"
		endif
		execute cmd
		i+=1
	while(i<itemsinlist(list,";"))	
end

function showrange(num1,num2)
	variable num1
	variable num2
	
	variable i=num1
	do
		shownum(i)
		i+=1
	while(i<=num2)
end

function showdata(idstr)	// displays all waves with a given idstring (eg c1, c1c2, perp...)
	string idstr
	
	string searchstr="*"+idstr + "_*"
	string list=wavelist(searchstr,";","")
	showwaves(list)
end

function/S sh_ws(list)	// shows all waves in a given wave list
	string list
	variable i=0
	string cmd, tmp
	if(stringmatch(list,"")==0)
		cmd="display"
		execute cmd
		for(i=0;i<itemsinlist(list,";");i+=1)
			tmp = stringfromlist(i,list,";")
			cmd="AppendToGraph "+tmp
			execute cmd;
		endfor
		cmd = "Label bottom \"" + getlabel(tmp,1) + "\""
		execute cmd
		doupdate
		cmd="Label left \""+getlabel(tmp,0)+"\""
		execute cmd
		ModifyGraph stThick=0.5,ftThick=0.5,ttThick=0.5
		ModifyGraph grid=1
		if(stringmatch(tmp[4,6],"_Ph"))
			ModifyGraph mode=3
		endif
		labelgraph(list,0,10)
		doupdate
	endif
	return WinName(0,1)
end

function gr_rnb()
	string name = WinName(0, 1)
	//print name
	if(stringmatch(name,"")==0)
		string ws = waves_on_graph(name), tmp
		variable i, num = ItemsInList(ws, ";"), col_val
		for(i=0;i<num;i+=1)
			col_val = i/(num-1)
			tmp = StringFromList(i,ws,";")
			ModifyGraph rgb($tmp)=(rnb(col_val,"R"),rnb(col_val,"G"),rnb(col_val,"B"))
		endfor
	else
		print "---ERROR--- function gr_rnb() no waves on the Graph"
	endif
end

macro rainbow()
	execute "gr_rnb()"
endmacro

function rnb(input, color) // input from 0 to 1, color R G B
	variable input
	string color

	variable R, G, B
	variable i_max = 1
	variable max_c = 65535
	variable tmp = input / i_max
	if(tmp < 0)
		print "---ERROR--- Wrong input to rnb() function"
	// input 0:max
	//read - yellow (max, 0, 0) (max, max, 0)
	elseif(tmp < 1/4)
		R = 1	
		G = 4*tmp
		B = 0
	// input max:2max
	//yellow to green (max, max, 0) (0, max, 0)
	elseif(tmp<1/2)
		R = 1 - 4*(tmp - 1/4)
		G = 1
		B = 0 
	//input 2max:3max
	//green to aqua (0, max, 0) (0, max, max)
	elseif(tmp<3/4)
		R = 0
		G = 1
		B = 4*(tmp - 1/2)
	//input 3max:4max
	//aqua to blue (0, max, max) (0, 0, max)
	elseif(tmp<=1)
		R = 0
		G = 1 - 4*(tmp - 3/4)
		B = 1
	else
		print "---ERROR--- Wrong input to rnb() function"
	endif
	
	R *= max_c
	G *= max_c
	B *= max_c	

	if(stringmatch(color, "R"))
		return R
	elseif(stringmatch(color, "G"))
		return G
	elseif(stringmatch(color, "B"))
		return B
	else	
		print "---ERROR--- Wrong input to rnb() function"
	endif
end

function phase_colors()
	Make/O/N=(1000,3) phase_colors_w
	wave myColors = phase_colors_w
	Variable white=65535
	
	variable i, tmp = 1000/4
	for(i=0;i<tmp;i+=1)
		myColors[i][0]= 0
		myColors[i][1]= 0
		myColors[i][2]= 1-i/tmp
	endfor

	for(i=tmp;i<2*tmp;i+=1)
		myColors[i][0]= (i-tmp)/tmp
		myColors[i][1]= 0
		myColors[i][2]= 0
	endfor

	for(i=2*tmp;i<3*tmp;i+=1)
		myColors[i][0]= 1-(i-2*tmp)/tmp
		myColors[i][1]= (i-2*tmp)/tmp
		myColors[i][2]= 0
	endfor
	
	for(i=3*tmp;i<4*tmp;i+=1)
		myColors[i][0]= 0
		myColors[i][1]= 1-(i-3*tmp)/tmp
		myColors[i][2]= (i-3*tmp)/tmp
	endfor

	myColors*=white
	SetScale/I x, -180, 180, myColors
End

function showwaves(list)	// shows all waves in a given wave list
	string list
	variable i=0
	string cmd
	do
		string item=stringfromlist(i,list,";")
		if(wavedims($item)==1)
			cmd="display "+item+";Label bottom \"" + getlabel(item,1) + "\""
			cmd=cmd+";Label left \""+getlabel(item,0)+"\""	
			execute cmd;
			ModifyGraph tick=2,nticks=8,axThick=0.5,btLen=2,btThick=0.5,stLen=1
			ModifyGraph stThick=0.5,ftThick=0.5,ttThick=0.5
			//modifygraph gfsize=10,fsize=10
			modifygraph gfsize=8,fsize=8
			
			if(stringmatch(item[4,6],"_Ph"))
				ModifyGraph mode=3
			endif
		else
			cmd="display;appendimage "+item+";ModifyImage "+item+" ctab= {*,*,YellowHot,0}"
			cmd += ";Label bottom \"" + getlabel(item,1) + "\";Label left \"" + getlabel(item,2) + "\""
			cmd += ";ColorScale/C/N=text0/F=0/A=RC/E/X=0.00/Y=0.00 width=6, image="+item+",\""+getlabel(item,0)+"\""
			cmd += ";ModifyGraph gFont=\"Arial\", gfSize=10"
//			print item
//			if(stringmatch(item[4,6],"_Ph"))
//				cmd += ";ModifyImage " + item + " cindex= phase_colors_w;"
//				print item
//			endif
			execute cmd;
		endif
		//execute cmd;		//Taras
		//ModifyGraph fSize=10
		modifygraph gfsize=8,fsize=8
		labelgraph(item,0,10)
		i+=1
	while(i<itemsinlist(list,";"))
	doupdate
end

function logwave(wavestr)
	string wavestr
	
	wave/T DAClabel=$"DAClabel"
	wave DAC=$"DAC"
	wave DACDivider=$"DACDivider"
	wave Lockin=$"Lockin"
//	wave/T LabelLockin=$"LabelLockin"		//Taras
	string datestr=secs2date(datetime,-1)
	string junkstr
	string filestr="log_dmzj"+datestr[8,9]+datestr[3,4]+datestr[0,1]
	string filename=filestr+".txt"
	variable logsize=5+dimsize(lockin,0)+dimsize(dac,0)

	make/o/T/n=(logsize) $filestr
	wave/T logdata=$filestr
	logdata[0]=wavestr + " - " + secs2time(datetime,2)

	variable i=2,k=1
	do
//		sprintf junkstr,"   %s   %g",LabelLockin[i-2],Lockin[i-2]		//Taras
		junkstr = "_LabelLockin don`t work_"
		logdata[i]=junkstr
		i+=1
	while(i<dimsize(Lockin,0)+3)
	i+=1
	do
		sprintf junkstr,"   DAC %d - %s - %5.3f   DACDivider %d",k,DAClabel[k],DAC[k],DACDivider[k]
		logdata[i]=junkstr
		i+=1;k+=1
	while(i<3+dimsize(Lockin,0)+dimsize(dac,0))
	save/A=2/B/G/M="\r\n"/P=home filestr as filename
	killwaves/z logdata
end

function logwave2(wavestr)
	string wavestr
	
	wave/T DAClabel=$"DAClabel"
	wave DAC=$"DAC"
	wave DACDivider=$"DACDivider"
	string datestr=secs2date(datetime,-1)
	string junkstr
	string filestr="log_dmzj"+datestr[8,9]+datestr[3,4]+datestr[0,1]
	string filename=filestr+".txt"
	variable logsize=16
	if(waveexists($"WC_p"))
		logsize+=numpnts($"WC_p")
	endif
	make/o/T/n=(logsize) $filestr
	wave/T logdata=$filestr
	logdata[0]=wavestr + " - " + secs2time(datetime,2)
	SVAR comment=comment
	SVAR comment2=comment2
	SVAR comment3=comment3
	SVAR comment4=comment4
	SVAR comment5=comment5
//	if(SVAR_Exists(comment))	//intended to describe the measurement, eg which ohmics used
//								// needs to be changed manually every time the wiring is changed
//		logdata[1]=comment
//	endif
//	if(SVAR_Exists(comment2))	//intended for more complicated routines to describe their actions
//								// should be created by the routine, then deleted after wave is logged
//		logdata[2]=comment2
//	endif
//	if(SVAR_Exists(comment3))	//intended for more complicated routines to describe their actions
//								// should be created by the routine, then deleted after wave is logged
//		logdata[3]=comment3
//	endif
	if(SVAR_Exists(comment4))
		logdata[1]=comment4
	endif
	if(SVAR_Exists(comment5))
		logdata[2]=comment5
	endif
	variable i=1
	do
		sprintf junkstr,"   DAC %d - %s - %5.3f   DACDivider %d",i,DAClabel[i],DAC[i],DACDivider[i]
		logdata[i+3]=junkstr
		i+=1
	while(i<dimsize(dac,0))
//	if(waveexists($"WC_p"))
//		wave param=$"WC_p"
//		wave/T paramnames=$"WC_names"
//		i=0
//		do
//			sprintf junkstr,"   p%d - %s - %5.3f",i,paramnames[i],param[i]
//			logdata[i+20]=junkstr
//			i+=1		
//		while(i<numpnts(param))
//	endif
	save/A=2/B/G/M="\r\n"/P=home filestr as filename
	killwaves/z logdata
end

function wavenum(wavestr)
	string wavestr
	return str2num(wavestr[strsearch(wavestr,"_",0)+1,30])
end

function/S topimage(num)
	// returns tracename as a string of image (num) in the top graph
	// usage eg: ModifyImage $topimage(0) blahblahblah
	variable num
	return stringfromlist(num,imagenamelist("",";"),";")
end

function/S toptrace(num)
	// same as above, but for traces
	variable num
	return stringfromlist(num,tracenamelist("",";",1),";")
end

function hlog(str)
	string str
	variable num
	printf "%s %s, starting %d, %s\r",date(),time(),nextwave(),str
end