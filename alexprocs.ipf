#pragma rtGlobals=1		// Use modern global access method.
 
// Alex Johnson
// 1/25/03
// analysis and non-instrument-specific functions

macro initall()	// for some reason doesn't work as a function... gpib init doesn't complete.
	silent 1
	initgpib()
	initdmm(dmm11)
	setspeeddmm(dmm11,-1)
	initdmm(dmm12)
	setspeeddmm(dmm12,-1)
	initdmm(dmm13)
	setspeeddmm(dmm13,-1)
	initdmm(dmm14)
	setspeeddmm(dmm14,-1)
	init3axis()
	initNI6703()	// set linkages and dividers in here
	variable/G flagnolocal=0	// flag that lets sweeps not send the dmm back to local every point
	select33250(hp33250_6)
	init33250()
	select33250(hp33250_8)
	init33250()
	fixplots()
end

//×××××××××××××××××××××××××××××××××××××××××××××××××××××××××
// Run this before any GPIB session
// You need to add any additional instruments to this function

macro InitGPIB()
	// Store the GPIB indentifiers of the instruments in the corresponding variables
	variable/G gpibboard
	variable/G gpibboardnum

	variable/G V_dev1, V_dev2, V_dev3, V_dev4, V_dev5, V_dev6
	variable/G V_dev7, V_dev8, V_dev9, V_dev10, V_dev11, V_dev12

	variable/G dmm1, dmm2, dmm3, dmm4, dmm5, dmm6
	variable/G dmm7, dmm8, dmm9, dmm10, dmm11, dmm12

	variable/G Lockin7265_1
	variable/G Lockin7265_2
	variable/G Lockin7265_3

	variable/G LakeShore
	
	variable/G k2400
	variable/G k2400_2

	variable/G yoko0
	variable/G yoko1
	variable/G yoko2
	variable/G yoko3

	variable/G avs47
	variable/G SMS
	variable/G wavegen33220
	variable/G wavegen8257
	
//	variable/G egg
//	variable/G itc15
//	variable/G K2420_1
//	variable/G K2420_2
	variable/G K2420
//	variable/G HPmaster
//	variable/G HPslave
//	variable/G HPdrive
//	variable/G IPS120
//	variable/G K238
//	variable/G K485
//	variable/G lks
	variable/G dchp
//	variable/G achp
//	variable/G HP33250_6
//	variable/G HP33250_8 
//	variable/G HP33250_5 
	variable/G big_g
	
	// Get the GPIB identifiers
	execute "NI488 ibfind \"gpib0\", gpibboard"
	gpibboardnum=0


//------ with Agilend 82357B adapter:
// start
	
//	Variable/G gBoardAddress = 1	
//	Variable/G gBoardUD		
	
//	NI4882 ibfind={"gpib1"}; gBoardUD= V_flag	//Find and store the GPIB0 board UD
//	NI4882 SendIFC={gBoardAddress}				//Make GPIB0 the CIC (controller in charge), otherwise get NI-488.2 Error ECIC
//	GPIB2 board=gBoardUD		
	
//	NI4882 ibdev={gBoardAddress,3,0,10,1,0}; dmm3= V_flag
	
//	NI4882 ibdev={gBoardAddress,9,0,10,1,0}; wavegen8257= V_flag
	
//	NI4882 ibdev={gBoardAddress,6,0,10,1,0}; AWG7122C= V_flag
	
//	NI4882 ibdev={gBoardAddress,5,0,10,1,0}; Lockin7265= V_flag

// end
//------------------------------------------------

	execute "NI488 ibfind \"dev10\", Lockin7265_1"
	execute "NI488 ibfind \"dev11\", Lockin7265_2"
	execute "NI488 ibfind \"dev12\", Lockin7265_3"

	execute "NI488 ibfind \"dev3\", dmm3"
	execute "NI488 ibfind \"dev8\", dmm8"
	execute "NI488 ibfind \"dev9\", dmm9"
		
//	execute "NI488 ibfind \"dev1\", dmm1"
//	execute "NI488 ibfind \"dev2\", dmm2"
//	execute "NI488 ibfind \"dev14\", dmm3"
//	execute "NI488 ibfind \"dev4\", dmm4"
//	execute "NI488 ibfind \"dev16\", dmm5"
//	execute "NI488 ibfind \"dev11\", dmm6"

//	execute "NI488 ibfind \"dev9\", wavegen8257"
//	execute "NI488 ibfind \"dev5\", Lockin7265_v2"
//	execute "NI488 ibfind \"dev7\", LakeShore"
//	execute "NI488 ibfind \"dev12\", egg"

//	execute "NI488 ibfind \"dev15\", avs47"
//	execute "NI488 ibfind \"dev3\", wavegen33220"
//	execute "NI488 ibfind \"dev1\", yoko1"
//	execute "NI488 ibfind \"dev3\", yoko2"
//	execute "NI488 ibfind \"dev5\", yoko3"

//	execute "NI488 ibfind \"dev4\", SMS"
//	execute "NI488 ibfind \"dev2\", k2400"
//	execute "NI488 ibfind \"dev5\", k2400_2"
//	execute "NI488 ibfind \"dev3\", k2420_1"
//	execute "NI488 ibfind \"dev3\", k2420_1"

//	execute "NI488 ibfind \"dev15\", itc15"

//	execute "NI488 ibfind \"dev2\", IPS120"
//	execute "NI488 ibfind \"dev13\", HP3325B"
	dchp=13
//	achp=17
//	HP33250_6=HP33250
//	execute "NI488 ibfind \"dev6\", HP33250_8"
//	execute "NI488 ibfind \"dev6\", HP33250_5"
//	execute "NI488 ibfind \"dev16\", HPdrive"
//	execute "NI488 ibfind \"dev17\", HPmaster"
//	execute "NI488 ibfind \"dev18\", HPslave"
//	execute "NI488 ibfind \"dev10\", K238"
//	execute "NI488 ibfind \"dev26\", K485"
//	execute "NI488 ibfind \"dev10\", lks"

	// Make sure we're talking to the right board
//	execute "GPIB board gpibboard"

//	NVAR dmmvarx=$("dmm"+num2str(V_dmmnum1))
//	NVAR dmmx=$("V_dmm1")
//	dmmvarx=dmmx
End

//function wait(seconds) //Commented out by JBM.  See Below
//	variable seconds
//	variable t=ticks
//	do
//	while((ticks - t)/60.15 < seconds)
//End

function wait(seconds)  //Much more accurate timer brought to you by JBM
	variable seconds
	variable now=stopMStimer(-2)
	do
	while((stopMStimer(-2)-now)/1e6 < seconds)
end


macro fixplots()	// fixes blurry plots: run this and resize your window to force a redraw.
	setigoroption windraw, forcecoloroncolor=1
end
	
// use this procedure to automatically color traces on a graph different colors
function graphcolors(graphname)
	string graphname	// make this "" to take the top graph
	
	make/o rwave={65280,65280,52224,32768,0,0,36864,0,32768}
	make/o gwave={0,43520,52224,65280,52224,15872,14592,0,32768}
	make/o bwave={0,0,0,0,52224,65280,65280,0,32768}
	variable imax=numpnts(rwave)
	string list
	
	if(strlen(graphname)>0)
		list=tracenamelist(graphname,";",1)
	else
		list=tracenamelist("",";",1)
	endif
	
	variable i=0
	
	do
		string trace=stringfromlist(i,list,";")
		if(strlen(trace)>0)
			if(strlen(graphname)>0)
				modifygraph /W=graphname rgb($trace)=(rwave[mod(i,imax)],gwave[mod(i,imax)],bwave[mod(i,imax)])
			else
				modifygraph rgb($trace)=(rwave[mod(i,imax)],gwave[mod(i,imax)],bwave[mod(i,imax)])
			endif
		endif
		i+=1
	while(strlen(trace)>0)
end


Function/d quadratureline(w,x)
	variable /d x
	wave /d w
	
	return sqrt(w[0]^2+(w[1]*x)^2)

				//w[0] = zero limit
				//w[1] = slope
end

function/S makereplist(num,reps)
	variable num
	variable reps
	
	string liststr=num2str(num)
	variable i=1
	if(reps>1)
		do
			liststr=liststr+","+num2str(num)
			i+=1
		while(i<reps)
	endif
	return liststr
end

function/S listfromwave(w)
	wave w
	
	string liststr=num2str(w[0])
	variable i=1
	if(numpnts(w)>1)
		do
			liststr=liststr+","+num2str(w[i])
			i+=1
		while(i<numpnts(w))
	endif
	return liststr	
end

function colstats(wstr)
	string wstr
	wave w=$wstr
	variable numcols=dimsize(w,0)
	variable numrows=dimsize(w,1)
	variable wn=wavenum(wstr)
	string avgstr,sdstr
	sprintf avgstr, "vavg_%d",wn
	sprintf sdstr, "vsd_%d",wn
	make/o/n=(numcols) $avgstr,$sdstr
	wave vavg=$avgstr
	wave vsd=$sdstr
	setscale/p x,(dimoffset(w,0)),(dimdelta(w,0)),vavg,vsd
	make/o/n=(numrows) junkwave
	variable i=0
	do
		junkwave[]=w[i][p]
		wavestats/q junkwave
		vavg[i]=V_avg
		vsd[i]=V_sdev
		i+=1
	while(i<numcols)
end

function slicestats(wavestr,dimtoavg)
	string wavestr	//string name of wave to average: must be 2D
	variable dimtoavg	//which dimension to perform stats over: will take slices constant in the other dim
	
	wave w=$wavestr
	if(wavedims(w)!=2)
		printf "%s is not 2D\r",wavestr
		return 0
	endif
	
	if(dimtoavg==0)
		duplicate/o w junkwave
	else	// make junk be the transpose of w
		make/o/n=((dimsize(w,1)),(dimsize(w,0))) junkwave
		setscale/p x,(dimoffset(w,1)),(dimdelta(w,1)),junkwave
		setscale/p y,(dimoffset(w,0)),(dimdelta(w,0)),junkwave
		junkwave[][]=w[q][p]
	endif
	
	variable npts=dimsize(junkwave,1)
	string avgstr=wavestr+"_avg"
	string sdstr=wavestr+"_sd"
	make/o/n=(npts) $avgstr,$sdstr
	wave avgwave=$avgstr
	wave sdwave=$sdstr
	setscale/p x (dimoffset(junkwave,1)),(dimdelta(junkwave,1)),avgwave,sdwave
	variable i=0
	make/o/n=(dimsize(junkwave,0)) junkwave2
	variable V_avg
	variable V_sdev
	do
		junkwave2[]=junkwave[p][i]
		wavestats/Q junkwave2
		avgwave[i]=V_avg
		sdwave[i]=V_sdev
		i+=1
	while(i<npts)
//	display avgwave,sdwave
//	execute "ModifyGraph zero(left)=1"
//	graphcolors("")
end

function addinline(w,radd)
	wave w	// wave to alter
	variable radd	// resistance to add to assumed inline resistance
	//g_new=1/((1/g_old)-delta_r/r_q)
	w[]=1/((1/w[p])-(radd/25813))
end

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

function merge(w1,w2)		// overwrite a portion of a 2d wave with another
	// note: I'm not sure what this does if the wave scalings do not line up points
	wave w1	// wave to be written into
	wave w2	// wave to insert
	variable imax=dimsize(w1,0)
	variable jmax=dimsize(w1,1)
	variable i=0
	variable j=0
	variable xmin=dimoffset(w2,0)
	variable xmax=xmin+dimdelta(w2,0)*(dimsize(w2,0)-1)
	variable ymin=dimoffset(w2,1)
	variable ymax=ymin+dimdelta(w2,1)*(dimsize(w2,1)-1)
	if(xmax<xmin)
		xmax-=xmin
		xmin+=xmax
		xmax=xmin-xmax
	endif
	if(ymax<ymin)
		ymax-=ymin
		ymin+=ymax
		ymax=ymin-ymax
	endif
	variable do0=dimoffset(w1,0)
	variable do1=dimoffset(w1,1)
	variable dd0=dimdelta(w1,0)
	variable dd1=dimdelta(w1,1)
	variable x,y
	do
		x=do0+dd0*i
		if((x>=xmin)&&(x<=xmax))
			j=0
			do
				y=do1+dd1*j
				if((y>=ymin)&&(y<=ymax))
					w1[i][j]=w2(x)(y)
				endif
				j+=1
			while(j<jmax)
		endif
		i+=1
	while(i<imax)
end

function condhist(w,numbins)
	wave w
	variable numbins
	variable V_max,V_npnts
	variable minbin=.2	// ignore conductances below .2e^2/h
	wavestats/Q w
	if(V_max>10)
		V_max=10
	endif
	variable binsize=(V_max-minbin)/(numbins+1)
	string histstr
	sprintf histstr,"%s_hist",nameofwave(w)
	make/o/n=(numbins) $histstr
	wave hist=$histstr
	histogram/B={minbin,binsize,numbins} w,hist
end

function addpw(num)
	variable num
	string pwstr
	sprintf pwstr,"pw%d",num
	string cmd
	sprintf cmd,"append %s;Modifygraph lsize(%s)=2,rgb(%s)=(0,0,52224)",pwstr,pwstr,pwstr
	execute cmd
end