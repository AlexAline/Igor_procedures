#include <Multi-peak fitting 2.0>

function LED_illumination(v_time, v_mA, show)
	variable v_time, v_mA, show
	
	
	variable size = 1000
	make/O/N=(size) ILED_time_illumination
	if(show==1)
		showwaves("ILED_time_illumination")
	endif
	
	variable t0, t1, t2
	t0 = 2										// initial 3s wait
	t1 = ticks
	
	variable flag_LED_on = 0
	
	set_current_K2400(0)
	
	variable i
	for(i=0;i<size;i+=1)
		if(time_past(t1)>t0 && flag_LED_on==0 && time_past(t1)<t0+v_time)
			set_current_K2400(v_mA)
			flag_LED_on = 1
		endif

		if(time_past(t1)>t0+v_time && flag_LED_on==1)
			set_current_K2400(0)
			flag_LED_on = 0
		endif
		
		ILED_time_illumination[i] = read_current_K2400_()
	endfor
	
	t2 = time_past(t1)
	
	setscale/I x, 0, t2, ILED_time_illumination
	
	printf "Illuminated woth %2.2f mA for %2.2f s. Total time: %2.2f s\r", v_mA, v_time, t2
end

function time_past(t1)
	variable t1
	
	variable tmp
	tmp = ticks
	
	return (tmp-t1)/60.15
end

function nught_150719()
	do1d("bz",0,-6,3000,1)
	
		wait(10)
		do1d("bz",-6,6,6000,1)	
end


function nught_110719()
	setval("bz",-3)
	wait(560)
	
	setval("c4",-634)	
	setval("Vsd",-0.3)
	do2d("bz",-3,-1,250,30,"Vsd",-0.3,0.3,300,0.5)

		setval("c4",-576)
		setval("Vsd",-0.3)
		do2d("bz",-1,-3,250,30,"Vsd",-0.3,0.3,300,0.5)
end

function night_090719()
	setval("bz",6)
	wait(3100)
	do1d("bz",6,-6,6000,1)
	
		setval("Vsd",0)
		do2d("bz",-6,6,250,30,"c4",0,-1000,400,0.16)
	
			setval("Vsd",-0.3)
			do2d("bz",-6,6,250,30,"c4",0,-1000,400,0.16)
end

function night_180719()
	setval("bz",1)
	wait(750)
	
	setval("Vsd",0)
	do2d("bz",1,6,100,30,"c4",0,-1200,480,0.16)

		setval("bz",1)
		wait(2600)
	
		setval("Vsd",0.1)
		do2d("bz",1,6,100,30,"c4",0,-1200,480,0.16)

			setval("bz",1)
			wait(2600)
	
			setval("Vsd",0.3)
			do2d("bz",1,6,100,30,"c4",0,-1200,480,0.16)

end
function night_200719()
	setval("bz",1)
	wait(3600)
	
	setval("Vsd",-0.1)
	do2d("bz",1,6,100,30,"c4",0,-1200,480,0.16)

		setval("bz",1)
		wait(3600)
	
		setval("Vsd",-0.2)
		do2d("bz",1,6,100,30,"c4",0,-1200,480,0.16)
	
			setval("bz",1)
			wait(3600)
	
			setval("Vsd",-0.3)
			do2d("bz",1,6,100,30,"c4",0,-1200,480,0.16)
				setval("Vsd",0)
				setval("bz",1)
				print "done"
end

function night_240719()


	do1d("bz",2.75,6,3250,1)


		do2d("bz",6,-6,250,30,"c4",0,-1200,480,0.16)
			setval("c4",0)
		
end

function night_260719()


	do1d("bz",0,6,3250,1)
		do2d("bz",6,-6,750,15,"c4",0,-1200,480,0.16)
			setval("c4",0)
		
end


function visualize(w_in, w_out, value, d_value)
	wave w_in, w_out
	variable value, d_value

	w_out = abs(w_in[p][q]-value)<d_value ? nan : w_in[p][q]
end

function visualize_2(w_in, w_out, d_value)
	wave w_in, w_out
	variable d_value
	
	w_out = 0
	
	variable i
	for(i=1;i<5;i+=1)
		w_out += abs(w_in[p][q]-i)<d_value ? i : 0
	endfor
end


function night_170719_2()

	setval("bz",6)

	
	wait(3600)
	


	do2d("bz",6,-6,250,30,"c4",0,-1200,480,0.16)

	
		setval("bz",0)
	
end

function night_170719()

	variable/G value_red
	print "starting temp"
	read_Rmc(73); 
	print value_red
	
	setval("bz",6)
	
	print "Temp after ramping"
	read_Rmc(73); 
	print value_red
	
	wait(3600)
	
	print "Temp after waiting"
	read_Rmc(73); 
	print value_red

	do2d("bz",6,-6,250,30,"c4",0,-1200,480,0.16)
	
		print "Temp after do2d"
		read_Rmc(73); 
		print value_red
	
		setval("bz",0)
	
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

function/S waves_on_graph(name)
	string name

	return waves_on_graph_dim(name, 12)
end

function/S waves_on_graph_dim(name, dim)
	string name
	variable dim
	
	string rez="", tmp = ""
	string w_y, w_x
	variable i=0
	
		
	if(dim==2)
		tmp += ImageNameList(name, ";")
	elseif(dim==1)
		do
			w_y = WaveName(name, i, 1)
			w_x = WaveName(name, i, 2)
			tmp += w_y + ";" + w_x + ";"
			i += 1
		while(stringmatch(w_x,"")!=1 || stringmatch(w_y,"")!=1)
	elseif(dim==12)
		tmp += ImageNameList(name, ";")
		do
			w_y = WaveName(name, i, 1)
			w_x = WaveName(name, i, 2)
			tmp += w_y + ";" + w_x + ";"
			i += 1
		while(stringmatch(w_x,"")!=1 || stringmatch(w_y,"")!=1)
	endif
	
	rez = simplify_str_list(tmp)
	return rez
end

function/S simplify_str_list(str_list)
	string str_list
	
	string tmp1, tmp2, rez
	variable i, j
	for(i=0;i<ItemsInList(str_list,";");i+=1)
		tmp1 = StringFromList(i,str_list,";")
		for(j=i+1;j<ItemsInList(str_list,";");j+=1)
			tmp2 = StringFromList(j,str_list,";")
			if(stringmatch(tmp1, tmp2))
				return simplify_str_list(cut_i(str_list,j))
			endif
		endfor
	endfor
	str_list = remove_str_list(str_list,";;")
	return str_list
end

function/S cut_i(str_list, i)
	string str_list
	variable i
	
	string rez = ""
	variable j
	for(j=0;j<ItemsInList(str_list,";");j+=1)
		if(j!=i)
			rez += StringFromList(j,str_list,";")+";"
		endif
	endfor
	return rez
end

function/S remove_str_list(str_list1, str_list2)		// remove items from str_list2 in str_list1
	string str_list1, str_list2
	
	string rez = "", str1, str2
	variable i, j, flag
	for(i=0;i<ItemsInList(str_list1,";");i+=1)
		str1 = StringFromList(i,str_list1,";")
		flag = 0
		for(j=0;j<ItemsInList(str_list2,";");j+=1)
			str2 = StringFromList(j,str_list2,";")
			if(stringmatch(str1, str2))
				flag = 1
			endif
		endfor
		if(flag == 0)
			rez += str1 + ";"
		endif
	endfor
	return rez
end


function sm_diff(w_in, amount, smth_dir, diff_dir)
	// smth_dir, diff_dir: 0 Rows, 1 Columns
	wave w_in
	variable amount, smth_dir, diff_dir
	
	string w_out_name = nameofwave(w_in)+"_smth"
	Duplicate/O w_in, $(w_out_name)
	wave w_out = $(w_out_name)
	
	Smooth/DIM=(smth_dir) amount, w_out
	
	w_out_name = nameofwave(w_out)+"_DIF"
	Duplicate/O w_out, $(w_out_name)
	wave w_out2 = $(w_out_name)
		
	Differentiate/DIM=(diff_dir) w_out/D=w_out2

	//	showwaves(w_out_name)
end

function color_scale(w_in, n_bins, disp)
	wave w_in
	variable n_bins
	variable disp
		
	string w_out_name = nameofwave(w_in)+"_Hist"
	Make/N=(n_bins)/O $(w_out_name)
	wave w_out = $(w_out_name)
	
	variable x_min = wavemin(w_in)
	variable x_max = wavemax(w_in)
	variable dx = (x_max-x_min)/n_bins
	setscale/I x, x_min, x_max, w_out
	
	
	Histogram/B={x_min,dx,n_bins} w_in, w_out
	if(disp == 1)
		showwaves(w_out_name)
		ModifyGraph log(left)=1
	endif
end


Window Table3() : Table
	PauseUpdate; Silent 1		// building window...
	Edit/W=(4.8,42.2,1408.8,699.8) G2t_bz_c4_120_121_diff_nan
	ModifyTable format(Point)=1
EndMacro

Function Kill()
	variable kill_line = 1440
	string name, cmd, exc_lay_graphs="", exc_graphs="", all_exc_graphs="", tmp
	string kill_graphs, kill_waves
	variable i, j, v_tmp
	
	string layoutlist = WinList("*",";","WIN:4")
	for(i=0; i<itemsinlist(layoutlist); i +=1)
		name = stringfromlist(i, layoutlist)
		cmd = "GetWindow "+name+", wsize"
		execute cmd
		variable/G V_left
		if(V_left < 1440)
			sprintf  cmd, "Dowindow/K %s", name
			execute cmd
			//			print cmd
		else
			tmp = LayoutInfo(name, "Layout")
			v_tmp = NumberByKey("NUMOBJECTS", tmp, ":", ";")
			for(j=0; j<v_tmp; j+=1)
				tmp = LayoutInfo(name, num2str(j))
				if(stringmatch(StringByKey("TYPE", tmp, ":", ";"),"Graph"))
					exc_lay_graphs += StringByKey("NAME", tmp, ":", ";")+";"
				endif
			endfor
		endif
	endfor

	string all_graphs = WinList("*", ";","WIN:1")	
	for(i=0; i<itemsinlist(all_graphs); i +=1)
		name= stringfromlist(i, all_graphs)
		cmd = "GetWindow "+name+", wsize"
		execute cmd
		variable/G V_left
		if(V_left > kill_line)
			exc_graphs += name+";"
		endif
	endfor

	for(i=0;i<ItemsInList(all_graphs,";");i+=1)
		name = StringFromList(i,all_graphs,";")
		cmd  = "GetWindow "+name+", wsize"
		execute cmd
		variable/G V_left
		if(V_left < kill_line)
			Dowindow /HIDE=1 $(name)
		endif
	endfor
	
	all_exc_graphs = simplify_str_list(exc_lay_graphs + exc_graphs)
	//	print all_exc_graphs
	kill_graphs = remove_str_list(all_graphs, all_exc_graphs)

	for(i=0; i<itemsinlist(kill_graphs); i +=1)
		name = stringfromlist(i, kill_graphs)
		sprintf  cmd, "Dowindow/K %s", name
		execute cmd
		//		print name
	endfor

	string all_waves = WaveList("*", ";","")
	string/G exception_list
	string all_exc_waves =""
	for(i=0;i<itemsinlist(all_exc_graphs); i+=1)
		name= stringfromlist(i, all_exc_graphs)
		all_exc_waves += waves_on_graph(name)
	endfor
	all_exc_waves = simplify_str_list(all_exc_waves + exception_list)

	kill_waves = remove_str_list(all_waves, all_exc_waves)
	for(i=0; i<itemsinlist(kill_waves); i +=1)
		name= stringfromlist(i, kill_waves)
		sprintf  cmd, "KillWaves %s", name
		execute cmd
		//		print name
	endfor
end

Function density(w,B) : FitFunc
	Wave w
	Variable B

	//CurveFitDialog/ These comments were created by the Curve Fitting dialog. Altering them will
	//CurveFitDialog/ make the function less convenient to work with in the Curve Fitting dialog.
	//CurveFitDialog/ Equation:
	//CurveFitDialog/ f(B) = B/(1.602e-19*n)
	//CurveFitDialog/ End of Equation
	//CurveFitDialog/ Independent Variables 1
	//CurveFitDialog/ B
	//CurveFitDialog/ Coefficients 1
	//CurveFitDialog/ w[0] = n

	return B/(1.602e-19*w[0])
End
