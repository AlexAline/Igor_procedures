#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

function do1d(idstr,start,stop,numdivs,delay)
	string idstr			// generalized 1D sweep - figures out from idstr what to sweep
	variable start			// starting value
	variable stop			// ending value
	variable numdivs		// number of points minus 1
	variable delay			// seconds of delay between points

	hide("g")
	hide("l")

	string/G last_scan
	sprintf last_scan, "do1d(\"%s\",%f,%f,%d,%f)", idstr,start,stop,numdivs,delay

	variable/G number_of_measurements
	string/G meas_graphs = ""
	string/G meas_waves = ""
	variable/G kill_flag = 0
	wave meas_log
	wave/T meas_name
	wave/T meas_type	

	make/O/N=(number_of_measurements) meas_data
	meas_data = nan
		
	variable numpts=numdivs+1
	make/o/n=(numpts) w_value
	w_value[]=start+p*(stop-start)/numdivs
	
	string m_name
	variable i
	for(i=0;i<number_of_measurements;i+=1)
		if(cmpstr(meas_type(i),"-",2)==1)
			m_name = meas_name[i]+meas_type[i]+"_"+idstr+"_"+num2str(nextwave())
		elseif(cmpstr(meas_type(i),"-",2)==0)
			m_name = meas_name[i]+"_"+idstr+"_"+num2str(nextwave())
		endif
		make/O/N=(numpts) $(m_name)=nan
		setscale/I x, start, stop, $(m_name)

		showwaves(m_name)
		if(meas_log(i)==1)
			ModifyGraph log(left)=1
		endif
				
		meas_graphs+=WinName(0,1)+";"
		meas_waves+=m_name+";"
	
		move_to_pos(1,12,i+1)
	endfor
	
	kill_flag = 1
	
	setval(idstr,w_value[0])
	wait(1)

	variable t1,t2,time_per_point
	t1 = ticks
	print "start: ", Secs2Date(DateTime,-2), time()
	
	variable j
	for(j=0;j<numpts;j+=1)
		
		setval(idstr,w_value[j])
		wait(delay)
		
		get_data()
	
		for(i=0;i<number_of_measurements;i+=1)
			if(cmpstr(meas_type(i),"-",2)==1)
				m_name = meas_name[i]+meas_type[i]+"_"+idstr+"_"+num2str(nextwave())
			elseif(cmpstr(meas_type(i),"-",2)==0)
				m_name = meas_name[i]+"_"+idstr+"_"+num2str(nextwave())
			endif
			wave tmp = $(m_name)
			tmp[j] = meas_data[i]
			
			if(cmpstr(idstr,"time",2)==0)
				t2=ticks
				time_per_point=(t2-t1)/(60.15*(j+1))
				setscale/p x,0,time_per_point,tmp
			endif
		endfor

		if(delay<1)
			if(mod(j,10)==0)
				doupdate
			endif
		else
			doupdate
		endif
		
	endfor
	
	t2=ticks
	endsweep(t1,t2)

	post_proc("")
end

function speed_test()
	variable i, t1, t2
	t1=ticks
	print "start: ", Secs2Date(DateTime,-2), time()
	
	for(i=0;i<=100;i+=1)
//		readdmm(2)
//		read_dc(2)
//		get_one_data(0)

//		Lockin_M_VISA(5)
//		read_loM(5)
//		get_one_data(0)
		
		get_data()	
	endfor
	t2=ticks
	endsweep(t1,t2)
end