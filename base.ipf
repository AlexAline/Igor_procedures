#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

function setval(idstr,value)
	string idstr 	
	variable value
	
	variable return_v = 1
	
	variable/G NumChan
	wave/T log_file
	
	if(!cmpstr(idstr[0],"c",2))
		variable channel
		sscanf idstr, "c%d", channel
		if(V_flag==1 && (value<50) && (value>-4001) && channel>0 && channel<NumChan-1)	// !!!! --- critical protection of the device --- !!!
			rampDAC(channel,value)
		elseif(channel==1 && value<6001 && value>-6001)
			rampDAC(channel,value)
		else
			abort("Protection: Gate voltage too large, channel "+num2str(channel)+" not changed")
		endif	


	elseif(!cmpstr(idstr,"Vsd",2))
		if(abs(value)<5.1)																// !!!! --- critical protection of the device --- !!!
			rampDAC(8,value)
		else
			print "DC voltage out of range"
		endif
		
		
	elseif(!cmpstr(idstr,"time",2))
		//do nothing
	elseif(!cmpstr(idstr,"bybz0",2))
		setval("by",value)
		setval("bz",value*(-0.15)+0.012667    -1.9)
		
	elseif(!cmpstr(idstr,"by",2))
		if(abs(value)<0.8)																	// !!!! ---   critical for quenching magnet   --- !!!
		
			variable/G IPS_VISA_address
			if(IPS_VISA_address>0)
//---------------- IPS power supply-------
//				setTargetField_IPS_VISA(IPS_VISA_address,value)					

//---------------- SMS power supply-------
				set_SMS_port(8)
				variable dt = abs((value - str2num(log_file[8][1]))*1000/0.98)
				set_SMS_midVal(value)
    			wait(dt)
				set_DAC_port()
			
				log_file[8][0] = "by"
				log_file[8][1] = num2str(value)
			else
				print "You have to run init_IPS(IPS_VISA_address) first"
			endif
		else
			print "By is too large"
		endif

	
	elseif(!cmpstr(idstr,"bz",2))
		if(abs(value)<9)																	// !!!! ---   critical for quenching magnet   --- !!!
		
			variable/G IPS_VISA_address
			if(IPS_VISA_address>0)
//---------------- IPS power supply-------
//				setTargetField_IPS_VISA(IPS_VISA_address,value)					

//---------------- SMS power supply-------
				set_SMS_port(7)
//				dt = abs((value - str2num(log_file[0][1]))*1000/0.98)        // for compensated By scuns
				dt = abs((value - str2num(log_file[0][1]))*1000/4.9)
				set_SMS_midVal(value)
				wait(dt)
				set_DAC_port()
			
				log_file[0][0] = "bz"
				log_file[0][1] = num2str(value)
			else
				print "You have to run init_IPS(IPS_VISA_address) first"
			endif
		else
			print "Bz is too large"
		endif
	else
		abort "ERROR: couldn't resolve idstr"
		return_v = 0
	endif
	
	return return_v
end


function/T get_meas_name(meas_ID)
	variable meas_ID
	
	wave/T meas_name
	wave/T meas_type
	
	string res
	res = meas_name[meas_ID]+meas_type[meas_ID]
	
	return res
end

function/T get_label(s_name)
	string s_name
	
	variable/G number_of_labels
	wave/T all_labels
	
	string s_tmp
	variable i
	for(i=0;i<number_of_labels;i+=1)
		if(!cmpstr(s_name[0],all_labels[i][0],2))
			sprintf s_tmp, all_labels[i][1], s_name[1,strlen(s_name)-1]
		
			if(strlen(s_name)>=5)
				if(!cmpstr(s_name[strlen(s_name)-4,strlen(s_name)-1],"loPh",2))
//					print "Phase ..."
					sprintf s_tmp, all_labels[i][1], s_name[1,strlen(s_name)-5]+"_Ph"
				endif
			endif
			
			if(strlen(s_name)>=4)
				if(!cmpstr(s_name[strlen(s_name)-3,strlen(s_name)-1],"loM",2))
//					print "Magnitude ..."
					sprintf s_tmp, all_labels[i][1], s_name[1,strlen(s_name)-4]+"_M"
				endif
			endif
			
			return s_tmp
		endif
	endfor
	
	//abort "ERRPR: No Label found for:" + s_name
	return s_name
end

function/T get_label_(s_name)
	string s_name
	
	variable/G number_of_labels
	wave/T all_labels
	
	variable i
	for(i=0;i<number_of_labels;i+=1)
		if(!cmpstr(s_name,all_labels[i][0],2))
			return all_labels[i][1]
		endif
	endfor
	
	abort "ERRPR: No Label found for:" + s_name
end

function init_get_label()
	make/T/O/N=(200,2) all_labels
	variable/G number_of_labels
	
	all_labels = ""
	
	variable i=0
	
	//----
	all_labels[i][0] = "R"
	all_labels[i][1] = "R\B%s\M (\uohm)"
	i+=1
	
	all_labels[i][0] = "G"
	all_labels[i][1] = "G\B%s\M (\\ue\\S2\\M/h)"
	i+=1
	
	all_labels[i][0] = "V"
	all_labels[i][1] = "V\B%s\M (\uV)"
	i+=1
	
	all_labels[i][0] = "I"
	all_labels[i][1] = "I\B%s\M (\uA)"
	i+=1

	all_labels[i][0] = "T"
	all_labels[i][1] = "T\B%s\M (\uK)"
	i+=1

	all_labels[i][0] = "c"
	all_labels[i][1] = "c\B%s\M (\umV)"
	i+=1

	all_labels[i][0] = "t"
	all_labels[i][1] = "t%s (\us)"
	i+=1
	
	all_labels[i][0] = "b"
	all_labels[i][1] = "B\B%s\M (\uT)"
	i+=1

	all_labels[i][0] = "P"
	all_labels[i][1] = "P\B%s\M (\umbar)"
	i+=1

	//----
	number_of_labels = i
end

function init_get_label_()
	make/T/O/N=(200,2) all_labels
	variable/G number_of_labels
	
	variable i=0
	
	//----
	all_labels[i][0] = "R"
	all_labels[i][1] = "R (\uohm)"
	i+=1
	
	all_labels[i][0] = "G"
	all_labels[i][1] = "G (\\ue\\S2\\M/h)"
	i+=1
	
	all_labels[i][0] = "R2t"
	all_labels[i][1] = "R\B2t\M (\uohm)"
	i+=1

	all_labels[i][0] = "G2t"
	all_labels[i][1] = "G\B2t\M (\\ue\\S2\\M/h)"
	i+=1
	
	all_labels[i][0] = "Vdc"
	all_labels[i][1] = "V\Bdc\M (\uV)"
	i+=1
	
	all_labels[i][0] = "Idc"
	all_labels[i][1] = "I\Bdc\M (\uA)"
	i+=1

	all_labels[i][0] = "T1K"
	all_labels[i][1] = "T\B1K\M (\uK)"
	i+=1

	all_labels[i][0] = "Tstil"
	all_labels[i][1] = "T\Bstil\M (\uK)"
	i+=1

	all_labels[i][0] = "Tmc"
	all_labels[i][1] = "T\Bmc\M (\uK)"
	i+=1

	all_labels[i][0] = "R1K"
	all_labels[i][1] = "R\B1K\M (\uohm)"
	i+=1

	all_labels[i][0] = "Rstil"
	all_labels[i][1] = "R\Bstil\M (\uohm)"
	i+=1

	all_labels[i][0] = "Rmc"
	all_labels[i][1] = "R\Bmc\M (\uohm)"
	i+=1

	all_labels[i][0] = "IloM"
	all_labels[i][1] = "I_M (\uA)"
	i+=1

	all_labels[i][0] = "IloPh"
	all_labels[i][1] = "I_Ph (\udeg)"
	i+=1

	all_labels[i][0] = "VloM"
	all_labels[i][1] = "V_M (\uV)"
	i+=1

	all_labels[i][0] = "VloPh"
	all_labels[i][1] = "V_Ph (\udeg)"
	i+=1
	
	all_labels[i][0] = "VxxloM"
	all_labels[i][1] = "Vxx_M (\uV)"
	i+=1

	all_labels[i][0] = "VxxloPh"
	all_labels[i][1] = "Vxx_Ph (\udeg)"
	i+=1
	
	all_labels[i][0] = "VxyloM"
	all_labels[i][1] = "Vxy_M (\uV)"
	i+=1

	all_labels[i][0] = "VxyloPh"
	all_labels[i][1] = "Vxy_Ph (\udeg)"
	i+=1


	all_labels[i][0] = "Vxy1loM"
	all_labels[i][1] = "Vxy1_M (\uV)"
	i+=1

	all_labels[i][0] = "Vxy1loPh"
	all_labels[i][1] = "Vxy1_Ph (\udeg)"
	i+=1
	
		all_labels[i][0] = "Vxy2loM"
	all_labels[i][1] = "Vxy2_M (\uV)"
	i+=1

	all_labels[i][0] = "Vxy2loPh"
	all_labels[i][1] = "Vxy2_Ph (\udeg)"
	i+=1

	all_labels[i][0] = "c1"
	all_labels[i][1] = "c\B1\M (\umV)"
	i+=1

	all_labels[i][0] = "c2"
	all_labels[i][1] = "c\B2\M (\umV)"
	i+=1

	all_labels[i][0] = "c3"
	all_labels[i][1] = "c\B3\M (\umV)"
	i+=1

	all_labels[i][0] = "c4"
	all_labels[i][1] = "c\B4\M (\umV)"
	i+=1

	all_labels[i][0] = "c5"
	all_labels[i][1] = "c\B5\M (\umV)"
	i+=1

	all_labels[i][0] = "c6"
	all_labels[i][1] = "c\B6\M (\umV)"
	i+=1

	all_labels[i][0] = "c7"
	all_labels[i][1] = "c\B7\M (\umV)"
	i+=1

	all_labels[i][0] = "c8"
	all_labels[i][1] = "c\B8\M (\umV)"
	i+=1

	all_labels[i][0] = "Vsd"
	all_labels[i][1] = "V\Bsd\M (\umV)"
	i+=1
	
	all_labels[i][0] = "time"
	all_labels[i][1] = "time (\us)"
	i+=1
	
	all_labels[i][0] = "bz"
	all_labels[i][1] = "B\Bz\M (\uT)"
	i+=1

	all_labels[i][0] = "Rxx"
	all_labels[i][1] = "R\Bxx\M (\uohm)"
	i+=1
	
	all_labels[i][0] = "Rxy"
	all_labels[i][1] = "R\Bxy\M (\uohm)"
	i+=1

	all_labels[i][0] = "Gxx"
	all_labels[i][1] = "G\Bxx\M (\\ue\\S2\\M/h)"
	i+=1
	
	all_labels[i][0] = "Gxy"
	all_labels[i][1] = "G\Bxy\M (\\ue\\S2\\M/h)"
	i+=1

	all_labels[i][0] = "PSTIL"
	all_labels[i][1] = "P\BSTIL\M (\umbar)"
	i+=1

	all_labels[i][0] = "PIVC"
	all_labels[i][1] = "P\BIVC\M (\umbar)"
	i+=1
	
	//----
	
	number_of_labels = i
end

//-------------BASE-------------

function init()
	init_get_label()
	
	init_GPIB_Devices_panel()
	init_Data_Types_panel()
	init_Constant_and_log_panel()
	
	init_phase_corr()

	execute "initDAC()"
	execute "GPIB_Devices_panel()"
	execute "Data_Types_panel()"
	execute "Constant_and_log_panel()"

	string/G exception_list=""
	
	exception_list += "all_labels;"																// Graphs labels
	
	exception_list += "DAC;DACDivider;DACLabel;DACLimit;DACOffset;DACRange;"		// DAC
	
	exception_list += "device_family;device_family_ID;device_meas_table;"			// GPIB devices panel
	exception_list += "GPIB_addresses;GPIB_names;GPIB_instr_ID;"						// GPIB devices panel
	
	exception_list += "meas_device;meas_device_ID;meas_log;meas_name;"				// Data types panel
	exception_list += "meas_type;meas_type_ID;calc_eq;"									// Data types panel
	
	exception_list += "constant_name;constant_value;constant_desc;"					// Constants panel
	
	make/O/T/N=(30,2) log_file
	exception_list += "log_file;"																	// Log data
	
	exception_list += "phase_colors_w;"															// phase colors
end

function wait(seconds)
	variable seconds
	variable now=stopMStimer(-2)
	do
	while((stopMStimer(-2)-now)/1e6 < seconds)
end

function set_nextwave(val)
	variable val
	
	variable/G next_wave
	next_wave = val
end

function nextwave()
	variable/G next_wave
	return next_wave
end

function inc_nextwave()
	variable/G next_wave
	next_wave+=1
end

function showwaves(w_name)
	string W_name
	
	string label_x, label_y, label_color
	
	if(itemsInList(w_name,"_")<3)
		abort "wave has a wrong name to be shown with showwaves"
	endif
			
	display
	if(wavedims($(w_name))==1)
		appendtograph $(w_name)
	
		label_x = get_label(stringfromlist(1,w_name,"_"))
		label_y = get_label(stringfromlist(0,w_name,"_"))
	
		label bottom label_x
		label left label_y
		modifyGraph tick=2,nticks=8,axThick=0.5,btLen=2,btThick=0.5,stLen=1
		modifyGraph stThick=0.5,ftThick=0.5,ttThick=0.5
		modifygraph gfsize=10,fsize=10
		//modifygraph gfsize=8,fsize=8		
	elseif(wavedims($(w_name))==2)
		appendimage $(w_name)

		label_x = get_label(stringfromlist(1,w_name,"_"))
		label_y = get_label(stringfromlist(2,w_name,"_"))
		label_color = get_label(stringfromlist(0,w_name,"_"))
	  	
		label bottom label_x
		label left label_y
		ModifyImage $(w_name) ctab= {*,*,YellowHot,0}
		ColorScale/C/N=text0/F=0/A=RC/E/X=0.00/Y=0.00 width=6, image=$(w_name), label_color
		ModifyGraph gFont="Arial", gfSize=10
	endif
	
	labelgraph(w_name,0,10)
	
	doupdate
end

function endsweep(t1,t2)
	variable t1,t2
	
	printf "created waves #%d, finished at %s, elapsed time %6.3f min (%6.3f sec)\r",nextwave(),time(),(t2-t1)/(60.15*60), (t2-t1)/60.15
	variable/g trace_time=(t2-t1)/(60.15*60)
	saveexperiment
end

function get_data()
	wave/T calc_eq
	variable/G number_of_measurements
	make/O/N=(number_of_measurements) meas_data
	meas_data = nan
	
	duplicate/O meas_data, V	
	duplicate/O meas_data, M
	
	variable i
	for(i=0;i<number_of_measurements;i+=1)
		meas_data[i] = get_one_data(i)
	endfor
	
	V = meas_data
	
	variable/G V_tmp
	for(i=0;i<number_of_measurements;i+=1)
		execute "V_tmp="+calc_eq[i]
		meas_data[i] = V_tmp
		M = meas_data
	endfor
end

function get_one_data(i)
	variable i
	
	wave GPIB_instr_ID
	wave meas_device_ID
	wave/T meas_type
	variable/G value_red
	
	string cmd
	if(cmpstr(meas_type[i],"-",2)==0)
		value_red = nan
	else
		sprintf cmd, "read_%s(%d)", meas_type[i], GPIB_instr_ID[meas_device_ID[i]]
//		print cmd
		execute cmd
	endif
	
	return value_red
end

function move_to_pos_(monitor, divider, pos)
	variable monitor //1,2
	variable divider //1,2,4,6,8,12
	variable pos//1..divider

	string screen_tmp
	variable depth, left_v, top_v, right_v, bottom_v

	variable n_screens = NumberByKey("NSCREENS", IgorInfo(0))	// Number of active displays
	
	screen_tmp = StringByKey("SCREEN2", IgorInfo(0))
	sscanf screen_tmp, "DEPTH=%d,RECT=%d,%d,%d,%d", depth, left_v, top_v, right_v, bottom_v

//	print depth, left_v, top_v, right_v, bottom_v
	
	movewindow 0, 0, 200, 200
	getwindow kwTopWin, psize
	print V_left, V_right, V_top, V_bottom

	getwindow kwTopWin, psizeDC
	print V_left, V_right, V_top, V_bottom
end

function	move_to_pos(monitor, divider, pos)
	variable monitor //1,2
	variable divider //1,2,4,6,8,12
	variable pos//1..divider
	
	variable l_1, l_2, t_, r_1, r_2, b_
	variable v_size, h_size, l_, r_, v_delta, h_delta
	l_1 = 0.5
	l_2 = 51
	t_ = 2
	r_1 = 50
	r_2 = 100.5
	b_ = 28.5
	v_size = b_ - t_
	h_size = r_1 - l_1
	v_delta = 1
	h_delta = 0.4
	
	if(monitor==1)
		l_ = l_1
		r_ = r_1
	elseif(monitor == 2)
		l_ = l_2
		r_ = r_2
	endif
	
	variable w_v_size, w_h_size, n_v, n_h
	if(divider==1)
		n_v = 1
		n_h = 1
	elseif(divider==2)
		n_v = 2
		n_h = 1
	elseif(divider==4)
		n_v = 2
		n_h = 2
	elseif(divider==6)
		n_v = 2
		n_h = 3
	elseif(divider==12)
		n_v = 3
		n_h = 4
	endif

	w_v_size = v_size / n_v
	w_h_size = h_size	 / n_h
	
	variable  w_l, w_t, w_r, w_b
	variable v_n, h_n
	v_n = floor((pos-1)/ n_h)
	h_n = mod((pos-1), n_h)
	
	w_l = l_ + h_n * w_h_size
	w_t = t_ + v_n * w_v_size
	w_r = w_l + w_h_size - h_delta
	w_b = w_t + w_v_size - v_delta

	movewindow/M w_l, w_t, w_r, w_b
end

function killlast()
	variable/G kill_flag
	string/G meas_graphs
	string/G meas_waves
	
	string name, cmd, tmp
	if(kill_flag==1)
		variable i
		for(i=0;i<itemsinlist(meas_graphs,";");i+=1)
			name= stringfromlist(i, meas_graphs,";")
			//			print name
			cmd = "Dowindow/K "+name
			execute cmd
		endfor
		
				
		for(i=0; i<itemsinlist(meas_waves,";"); i +=1)
			name= stringfromlist(i,meas_waves,";")
			sprintf  cmd, "KillWaves %s", name
			execute cmd
		endfor
		
		
		kill_flag = 0
		meas_graphs = ""
		meas_waves = ""
	else
		print "too late to KillLast"
	endif
end

Function KillAll()
	string fulllist = WinList("*", ";","WIN:5")
	string name, cmd
	variable i,j
	for(i=0; i<itemsinlist(fulllist); i +=1)
		name= stringfromlist(i, fulllist)
		sprintf  cmd, "Dowindow/K %s", name
		execute cmd		
	endfor
	
	fulllist = WaveList("*", ";","")
	
	string/G exception_list

	string item, exc_item, out_list, res
	out_list = ""	
	for(j=0;j<ItemsInList(fulllist,";");j+=1)
		item = stringFromList(j,fulllist,";")
		
		res = item + ";"
		for(i=0;i<ItemsInList(exception_list,";");i+=1)
			exc_item = stringFromList(i,exception_list,";")
			if(cmpstr(item, exc_item, 2)==0)
				res = ""
				break
			endif
		endfor
		
		out_list += res
	endfor
	fulllist = out_list
	
	for(i=0; i<itemsinlist(fulllist); i +=1)
		name= stringfromlist(i, fulllist)
		sprintf  cmd, "KillWaves %s", name
		execute cmd		
	endfor

	//	variable/G next_wave = 0
end

function post_proc(annotation)
	string annotation

	variable/G kill_flag
	
	//	add_legend()		// was useful for quantum dot experiments
	current_folder()
	save_data()
	save_log()
	
	execute "data_Layout()"
	
	save_layout()
	hide_new_graphs()
	
	kill_flag = 0
	inc_nextwave()
	saveexperiment
end

tileWindows

function add_legend()
	wave DAC
	string c1 = num2str(DAC[1])
	string c2 = num2str(DAC[2])
	string c3 = num2str(DAC[3])
	string c4 = num2str(DAC[4])
	string c5 = num2str(DAC[5])
	string c6 = num2str(DAC[6])
	string c7 = num2str(DAC[7])
	
	//	wave/T Lockin_I
	//	string By = Lockin_I[15][1]
	//	string Bz = Lockin_I[16][1]
	
	//TODO: 	
	//	TextBox/C/N=text1/F=0/A=RB/X=-39/Y=-17 "By "+By+"\rBz "+Bz+"\r\rc1 "+c1+"\rc2 "+c2+"\rc3 "+c3+"\rc4 "+c4+"\rc5 "+c5+"\rc6 "+c6+"\rc7 "+c7
end

function current_folder()
	variable new = DateTime
	pathinfo home
	string s_new_path = S_path + "automatic"
	NewPath /C/O/Q current_date, s_new_path
	
	s_new_path = S_path + "automatic:"+Secs2Date(new,-2)
	NewPath /C/O/Q current_date, s_new_path
end


function save_data()
	string/G meas_waves
	variable i
	string tmp
	for(i=0;i<ItemsInList(meas_waves,";");i+=1)
		tmp = StringFromList(i,meas_waves,";")
		Save/C/P=current_date $tmp as tmp+".ibw"
	endfor
end


function save_log()

	wave DAC=$"DAC"
	wave DACDivider=$"DACDivider"

	wave/T log_file

	string/G last_scan
	variable/G trace_time

	variable/g trace_time
	variable/G number_of_devices
	variable/G number_of_measurements
	variable/G number_of_constants
	
	variable log_size = 0
	log_size += 20 + dimsize(DACDivider,0) + dimsize(DAC,0)
	log_size += dimsize(log_file,0)
	log_size += number_of_devices
	log_size += number_of_measurements
	log_size += number_of_constants
	
	make/O/T/N=(log_size) log_w
	log_w = ""
	
	variable i,k=0
	string tmp

	log_w[k]="DAC:"										//-------------
	k+=1
	for(i=0;i<dimsize(DAC,0);i+=1)
		sprintf tmp, "c%g = %g", i, DAC[i]
		log_w[k+i] = tmp
	endfor
	k+=i+1

	log_w[k]="DAC Divider:"								//-------------
	k+=1
	for(i=0;i<dimsize(DACDivider,0);i+=1)
		sprintf tmp, "c%g = %g", i, DACDivider[i]
		log_w[k+i] = tmp
	endfor
	k+=i+1
	
	log_w[k]="GPIB panel:"								//-------------
	k+=1
	for(i=1;i<=number_of_devices;i+=1)
		tmp = get_log_from_waves(i,"GPIB_names;device_family;GPIB_addresses;GPIB_instr_ID;")
		log_w[k+i] = tmp
	endfor
	k+=i+1

	log_w[k]="Data types panel:"						//-------------
	k+=1
	for(i=0;i<number_of_measurements;i+=1)
		tmp = get_log_from_waves(i,"meas_name;meas_device;meas_type;calc_eq;meas_log;")
		log_w[k+i] = tmp
	endfor
	k+=i+1

	log_w[k]="Constants and log data panel:"		//-------------
	k+=1
	for(i=0;i<number_of_constants;i+=1)
		tmp = get_log_from_waves(i,"constant_name;constant_value;constant_desc;")
		log_w[k+i] = tmp
	endfor
	k+=i+1


	log_file[6][0] = "Scan"
	log_file[6][1] = last_scan
	log_file[7][0] = "Scan time"
	log_file[7][1] = num2str(trace_time)+" min"
	

	log_w[k]="Log wave:"									//-------------
	k+=1
	for(i=0;i<dimsize(log_file,0);i+=1)
		sprintf tmp, "%s : %s", log_file[i][0], log_file[i][1]
		if(cmpstr(" : ",tmp,2)==1)
			log_w[k+i] = tmp
		else
			log_w[k+i] = ""
		endif
	endfor
	k+=i+1

		
	save/G/M="\r\n"/P=current_date log_w as "log_for_"+num2str(nextwave())+".txt"
	
	killwaves log_w
end

function/T get_log_from_waves(line,waves)
	variable line
	string waves
	
	string out, w_name_tmp, info
	out = ""
	
	variable i
	for(i=0;i<itemsinlist(waves,";");i+=1)
		w_name_tmp = stringFromList(i,waves,";")
		info = waveinfo($(w_name_tmp),0)
		if(NumberByKey("NUMTYPE", info)==0)
			wave/T w_tmp_T = $(w_name_tmp)
			out += w_tmp_T[line]+" "
		else
			wave w_tmp_V = $(w_name_tmp)
			out += num2str(w_tmp_V[line])+" "
		endif
	endfor
	
	return out
end

//	exception_list += "meas_device;meas_device_ID;meas_log;meas_name;"				// Data types panel
//	exception_list += "meas_type;meas_type_ID;calc_eq;"									// Data types panel
//	
//	exception_list += "constant_name;constant_value;constant_desc;"					// Constants panel
	
	

Window data_Layout() : Layout
	string name="exp_layout_"+num2str(nextwave())	

	NewLayout/N=$name/W=(7.5,42.5,360,516.5) as name
	add_graphs()
	execute "Tile"
	
	//	SetWindow $name, hide = 1			// hide layout
EndMacro

function add_graphs()
	string/G meas_graphs
	variable i
	 
	for(i=0;i<ItemsInList(meas_graphs,";");i+=1)
		AppendLayoutObject graph $(StringFromList(i,meas_graphs,";"))
	endfor
end

function save_layout()
	SavePICT/C=2/EF=1/E=-8/B=72/P=current_date as "exp_layout_"+num2str(nextwave())+".pdf"
end

function hide_new_graphs()
	string/G meas_graphs
	variable i
	string tmp
	for(i=0;i<ItemsInList(meas_graphs,";");i+=1)
		tmp = StringFromList(i,meas_graphs,";")
		SetWindow $tmp, hide = 1
	endfor
end

function hide(objects)
	string objects //"g" will hide all graphs on the left screen, "l" all the layouts

	variable kill_line = 400
	
	string obj, name, cmd
	variable i
	
	if(cmpstr(objects,"g",2)==0)
		obj = WinList("*",";","WIN:1")
	elseif(cmpstr(objects,"l",2)==0)
		obj = WinList("*",";","WIN:4")
	else
		print "ERROR in the hide function, wrong argument"
		return 0
	endif
	
	for(i=0; i<itemsinlist(obj); i +=1)
		name = stringfromlist(i, obj)
		cmd = "GetWindow "+name+", wsize"
		execute cmd
		variable/G V_left
		if(V_left < kill_line)
			//			print name
			SetWindow $name, hide = 1
		endif
	endfor
end



//--------------TO BE REMOVED-----------------

function labelgraph(labelstr,pos,fontsize)
	// labels the top graph putting labelstr above the data, without adding any extra border
	string labelstr	// text to insert
	variable pos		// position: 0=left, 1=center, 2=right, 3=off the right corner
	// Will remove anny label in the same place made by this function
	variable fontsize
	string fontstr
	if(fontsize==0)	// use this to mean default font size
		fontstr=""
	elseif(fontsize<10)	// there must be a better way to add a leading zero to a short number!
		sprintf fontstr,"\\Z0%d",fontsize
	elseif(fontsize<100)
		sprintf fontstr,"\\Z%d",fontsize
	else
		print "labelgraph failed - font too big"
		return 0
	endif
	string fullabel=fontstr+labelstr
	
	if(pos==0)
		textbox/c/n=lefttext/f=0/a=LB/x=0/y=100/b=3 fullabel
	elseif(pos==1)
		textbox/c/n=midtext/f=0/a=MB/x=0/y=100/b=3 fullabel
	elseif(pos==2)
		textbox/c/n=righttext/f=0/a=RB/x=0/y=100/b=3 fullabel
	elseif(pos==3)
		textbox/c/n=righttext/f=0/a=LB/x=100/y=100/b=3 fullabel
	else
		print "labelgraph failed - unrecognized position"
	endif
end

function phase_corr(w_name)
	wave w_name
	
	print "Not working..."
//	wave phase_colors_w
	
//	ModifyImage w_name cindex= phase_colors_w
end

function init_phase_corr()
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

function load_exp(exp_num)
	variable exp_num

	load_wave("*"+num2str(exp_num))
end

function load_wave(w_name)
	string w_name
	
	pathinfo home
	string all_dirs = all_dirs_in_dir(S_path+"automatic:")
	string file_list = ""
	string file
	
	variable i, j
	for(i=0;i<itemsinList(all_dirs);i+=1)
		newpath/O/Q tmp_path, stringfromList(i,all_dirs,";")
		
		file_list = indexedFile(tmp_path,-1,".ibw")
		
		for(j=0;j<itemsInList(file_list);j+=1)
			file = stringfromList(j,file_list,";")
		
			if(stringmatch(file, w_name+".ibw"))
//				print file
				loadwave/Q/O/P=tmp_path file
				
				print replacestring(".ibw", file, "")
			endif
		endfor
	endfor
end

function/T all_dirs_in_dir(s_dir)
	string s_dir
	
	string all_dirs = ""
	string tmp_dirs = ""

	string tmp_dir
	string tmp_sub_dirs
	
	variable i
	
	newpath/O/Q tmp_path, s_dir
	tmp_dirs = IndexedDir(tmp_path, -1, 1)

	all_dirs += tmp_dirs
	
	do
		tmp_sub_dirs = ""
		for(i=0;i<ItemsInList(tmp_dirs);i+=1)
			tmp_dir = StringFromList(i,tmp_dirs,";")
			tmp_sub_dirs += dirs_in_dir(tmp_dir)	
		endfor
		
		all_dirs += tmp_sub_dirs
		tmp_dirs = tmp_sub_dirs
	while(itemsinList(tmp_dirs,";")>0)
	
	return all_dirs
end

function/T dirs_in_dir(s_dir)
	string s_dir
	
	newpath/O/Q tmp_path, s_dir
	return IndexedDir(tmp_path,-1,1)
end

function plot_g_and_g_sub_int(w_name)
	wave w_name
	
	showwaves(nameofwave(w_name))
	move_to_pos(1,12,7)
	duplicate/O w_name, $(nameofwave(w_name)+"_sub")
	wave w_out = $(nameofwave(w_name)+"_sub")
	
	subtruct_int(w_name, w_out)
	showwaves(nameofwave(w_out))
	move_to_pos(1,12,3)
	
	ModifyImage $nameofwave(w_out) ctab= {*,*,RedWhiteBlue,0}
end