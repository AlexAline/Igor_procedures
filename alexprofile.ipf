#pragma rtGlobals=1		// Use modern global access method.
 
// Alex Johnson
// 9/02
// routines for slicing 2D waves along straight vert or horz lines, and for shifting rows or columns

macro alexprofile()	// call with a 2d plot as the top window
	silent 1
	string images=imagenamelist(winname(0,1),";")
	if(itemsinlist(images,";")==0)
		print "no images found in the top graph"
		return 0 
	endif

	if(strsearch(controlnamelist(winname(0,1)),"slice",0)!=-1)
		doslice("goawayslice")
	endif

	if(strsearch(controlnamelist(winname(0,1)),"profile",0)!=-1)
		return 0
	endif
	
	variable xcenter,ycenter
	getaxis/Q left
	if(V_flag==1)
		getaxis/Q right
	endif
	ycenter=(V_min+V_max)/2
	getaxis/Q bottom
	if(V_flag==1)
		getaxis/Q top
	endif
	xcenter=(V_min+V_max)/2
	make/o/n=6 hairx={-inf,0,inf,0,0,0},hairy={0,0,0,-inf,0,inf}
	appendtograph/C=(0,65535,0) hairy vs hairx
	ModifyGraph offset={xcenter,ycenter}, quickdrag=1
	
	Button goleft proc=doprofile,title="<-", pos={20,0}, size={20,14}
	Button goright proc=doprofile,title="->", pos={40,0}, size={20,14}
	Button goup proc=doprofile,title="up", pos={60,0}, size={20,14}
	Button godown proc=doprofile,title="dn", pos={80,0}, size={20,14}
	Button vertprofile proc=doprofile,title="V", pos={110,0}, size={20,14}
	Button horzprofile proc=doprofile,title="H", pos={130,0}, size={20,14}
	Button graphprofile proc=doprofile,title="Show Profile", pos={150,0}, size={100,14}
	Button goawayprofile proc=doprofile,title="Close", pos={250,0}, size={50,14}
	string/G profilenamestr="pw"
	string/G profilenamestr2=""
	string/G profilenamestr3=""
	SetVariable profilename noproc, title="Wave", value=profilenamestr, pos={302,0}, size={80,12}, labelback=(65535,65535,65535)
	SetVariable profilename2 noproc, title="Source 2", value=profilenamestr2, pos={382,0}, size={120,12}, labelback=(65535,65535,65535)
	SetVariable profilename3 noproc, title="Source 3", value=profilenamestr3, pos={502,0}, size={120,12}, labelback=(65535,65535,65535)
end

function doprofile(ctrlname): ButtonControl
	string ctrlname
	
	SVAR pstr = profilenamestr
	wave imagewave=imagenametowaveref(winname(0,1),stringfromlist(0,imagenamelist("",";")))
	variable xoffset,yoffset
	string offsetstr=stringbykey("offset(x)",TraceInfo("","hairy",0),"=",";")
	offsetstr=offsetstr[1,strlen(offsetstr)-2]
	xoffset=str2num(stringfromlist(0,offsetstr,","))
	yoffset=str2num(stringfromlist(1,offsetstr,","))

	SVAR wstr2=profilenamestr2
	variable flag2=0
	if(strlen(wstr2)>0)
		flag2=1
		string pstr2=pstr+"_2"
		wave imagewave2=$wstr2
	endif
	SVAR wstr3=profilenamestr3
	variable flag3=0
	if(strlen(wstr3)>0)
		flag3=1
		string pstr3=pstr+"_3"
		wave imagewave3=$wstr3
	endif

	string cmd
	variable xdelta=dimdelta(imagewave,0)
	variable ydelta=dimdelta(imagewave,1)
	if(stringmatch(ctrlname,"goleft"))
		xoffset=xoffset-abs(xdelta)
		sprintf cmd,"Modifygraph offset(hairy)={%5.8f,%5.8f}",xoffset,yoffset
		execute cmd
		ctrlname="vertprofile"
	elseif(stringmatch(ctrlname,"goright"))
		xoffset=xoffset+abs(xdelta)
		sprintf cmd,"Modifygraph offset(hairy)={%5.8f,%5.8f}",xoffset,yoffset
		execute cmd
		ctrlname="vertprofile"
	elseif(stringmatch(ctrlname,"goup"))
		yoffset=yoffset+abs(ydelta)
		sprintf cmd,"Modifygraph offset(hairy)={%5.8f,%5.8f}",xoffset,yoffset
		execute cmd
		ctrlname="horzprofile"
	elseif(stringmatch(ctrlname,"godown"))
		yoffset=yoffset-abs(ydelta)
		sprintf cmd,"Modifygraph offset(hairy)={%5.8f,%5.8f}",xoffset,yoffset
		execute cmd
		ctrlname="horzprofile"
	endif

	if(stringmatch(ctrlname,"vertprofile"))
		make/o/n=(dimsize(imagewave,1)) $pstr
		wave pw=$pstr
		pw[]=imagewave[(xoffset-dimoffset(imagewave,0))/xdelta][p]
		setscale/P x dimoffset(imagewave,1),ydelta,pw
//		make/o/n=(dimsize(imagewave2,1)) $(pstr+"2")
//		wave pw2=$(pstr+"2")
//		pw2[]=imagewave2[(xoffset-dimoffset(imagewave2,0))/xdelta+1][p]
//		setscale/P x dimoffset(imagewave2,1),ydelta,pw2
//		make/o/n=(dimsize(imagewave2,1)) $(pstr+"3")
//		wave pw3=$(pstr+"3")
//		pw3[]=imagewave2[(xoffset-dimoffset(imagewave2,0))/xdelta+2][p]
//		setscale/P x dimoffset(imagewave2,1),ydelta,pw3
		if(flag2)
			make/o/n=(dimsize(imagewave2,1)) $pstr2
			wave pw2=$pstr2
			pw2[]=imagewave2[(xoffset-dimoffset(imagewave2,0))/xdelta][p]
			setscale/P x dimoffset(imagewave2,1),ydelta,pw2
		endif
		if(flag3)
			make/o/n=(dimsize(imagewave3,1)) $pstr3
			wave pw3=$pstr3
			pw3[]=imagewave3[(xoffset-dimoffset(imagewave3,0))/xdelta][p]
			setscale/P x dimoffset(imagewave3,1),ydelta,pw3
		endif
	elseif(stringmatch(ctrlname,"horzprofile"))
		make/o/n=(dimsize(imagewave,0)) $pstr
		wave pw=$pstr
		pw[]=imagewave[p][(yoffset-dimoffset(imagewave,1))/ydelta]
		setscale/P x dimoffset(imagewave,0),xdelta,pw
		if(flag2)
			make/o/n=(dimsize(imagewave2,0)) $pstr2
			wave pw2=$pstr2
			pw2[]=imagewave2[p][(yoffset-dimoffset(imagewave2,1))/ydelta]
			setscale/P x dimoffset(imagewave2,0),xdelta,pw2
		endif
		if(flag3)
			make/o/n=(dimsize(imagewave3,0)) $pstr3
			wave pw3=$pstr3
			pw3[]=imagewave3[p][(yoffset-dimoffset(imagewave3,1))/ydelta]
			setscale/P x dimoffset(imagewave3,0),xdelta,pw3
		endif
	elseif(stringmatch(ctrlname,"graphprofile"))
		display $pstr
		if(flag2)
			appendtograph/R $pstr2
			graphcolors("")
		endif
		if(flag3)
			appendtograph/R $pstr3
			graphcolors("")
		endif
	else	// goaway
		killcontrol vertprofile
		killcontrol horzprofile
		killcontrol graphprofile
		killcontrol goawayprofile
		killcontrol profilename
		killcontrol profilename2
		killcontrol profilename3
		if(strsearch(tracenamelist(winname(0,1),";",1),"hairy",0)!=-1)
			removefromgraph $"hairy"
		endif
		killcontrol goleft
		killcontrol goright
		killcontrol goup
		killcontrol godown
	endif
//	smooth 30,pw
end

function asdasd()
	string ctrlname
	
	SVAR pstr = profilenamestr
	wave imagewave=imagenametowaveref(winname(0,1),stringfromlist(0,imagenamelist("",";")))
	variable xoffset,yoffset
	string offsetstr=stringbykey("offset(x)",TraceInfo("","hairy",0),"=",";")
	offsetstr=offsetstr[1,strlen(offsetstr)-2]
	xoffset=str2num(stringfromlist(0,offsetstr,","))
	yoffset=str2num(stringfromlist(1,offsetstr,","))

	SVAR wstr2=profilenamestr2
	variable flag2=0
	if(strlen(wstr2)>0)
		flag2=1
		string pstr2=pstr+"_2"
		wave imagewave2=$wstr2
	endif
	SVAR wstr3=profilenamestr3
	variable flag3=0
	if(strlen(wstr3)>0)
		flag3=1
		string pstr3=pstr+"_3"
		wave imagewave3=$wstr3
	endif

	string cmd
	variable xdelta=dimdelta(imagewave,0)
	variable ydelta=dimdelta(imagewave,1)
	if(stringmatch(ctrlname,"goleft"))
		xoffset=xoffset-abs(xdelta)
		sprintf cmd,"Modifygraph offset(hairy)={%5.8f,%5.8f}",xoffset,yoffset
		execute cmd
		ctrlname="vertprofile"
	elseif(stringmatch(ctrlname,"goright"))
		xoffset=xoffset+abs(xdelta)
		sprintf cmd,"Modifygraph offset(hairy)={%5.8f,%5.8f}",xoffset,yoffset
		execute cmd
		ctrlname="vertprofile"
	elseif(stringmatch(ctrlname,"goup"))
		yoffset=yoffset+abs(ydelta)
		sprintf cmd,"Modifygraph offset(hairy)={%5.8f,%5.8f}",xoffset,yoffset
		execute cmd
		ctrlname="horzprofile"
	elseif(stringmatch(ctrlname,"godown"))
		yoffset=yoffset-abs(ydelta)
		sprintf cmd,"Modifygraph offset(hairy)={%5.8f,%5.8f}",xoffset,yoffset
		execute cmd
		ctrlname="horzprofile"
	endif
	
	if(stringmatch(ctrlname,"vertprofile"))
		make/o/n=(dimsize(imagewave,1)) $pstr
		wave pw=$pstr
		pw[]=imagewave[(xoffset-dimoffset(imagewave,0))/xdelta][p]
		setscale/P x dimoffset(imagewave,1),ydelta,pw
		make/o/n=(dimsize(imagewave2,1)) $(pstr+"2")
		wave pw2=$(pstr+"2")
		pw2[]=imagewave2[(xoffset-dimoffset(imagewave2,0))/xdelta+1][p]
		setscale/P x dimoffset(imagewave2,1),ydelta,pw2
		make/o/n=(dimsize(imagewave2,1)) $(pstr+"3")
		wave pw3=$(pstr+"3")
		pw3[]=imagewave2[(xoffset-dimoffset(imagewave2,0))/xdelta+2][p]
		setscale/P x dimoffset(imagewave2,1),ydelta,pw3
		if(flag2)
			make/o/n=(dimsize(imagewave2,1)) $pstr2
			wave pw2=$pstr2
			pw2[]=imagewave2[(xoffset-dimoffset(imagewave2,0))/xdelta][p]
			setscale/P x dimoffset(imagewave2,1),ydelta,pw2
		endif
		if(flag3)
			make/o/n=(dimsize(imagewave3,1)) $pstr3
			wave pw3=$pstr3
			pw3[]=imagewave3[(xoffset-dimoffset(imagewave3,0))/xdelta][p]
			setscale/P x dimoffset(imagewave3,1),ydelta,pw3
		endif
	elseif(stringmatch(ctrlname,"horzprofile"))
		make/o/n=(dimsize(imagewave,0)) $pstr
		wave pw=$pstr
		pw[]=imagewave[p][(yoffset-dimoffset(imagewave,1))/ydelta]
		setscale/P x dimoffset(imagewave,0),xdelta,pw
		if(flag2)
			make/o/n=(dimsize(imagewave2,0)) $pstr2
			wave pw2=$pstr2
			pw2[]=imagewave2[p][(yoffset-dimoffset(imagewave2,1))/ydelta]
			setscale/P x dimoffset(imagewave2,0),xdelta,pw2
		endif
		if(flag3)
			make/o/n=(dimsize(imagewave3,0)) $pstr3
			wave pw3=$pstr3
			pw3[]=imagewave3[p][(yoffset-dimoffset(imagewave3,1))/ydelta]
			setscale/P x dimoffset(imagewave3,0),xdelta,pw3
		endif
	elseif(stringmatch(ctrlname,"graphprofile"))
		display $pstr
		if(flag2)
			appendtograph/R $pstr2
			graphcolors("")
		endif
		if(flag3)
			appendtograph/R $pstr3
			graphcolors("")
		endif
	else	// goaway
		killcontrol vertprofile
		killcontrol horzprofile
		killcontrol graphprofile
		killcontrol goawayprofile
		killcontrol profilename
		killcontrol profilename2
		killcontrol profilename3
		if(strsearch(tracenamelist(winname(0,1),";",1),"hairy",0)!=-1)
			removefromgraph $"hairy"
		endif
		killcontrol goleft
		killcontrol goright
		killcontrol goup
		killcontrol godown
	endif
end

macro slices()	// call with a 2d plot as the top window: makes many-slice plots
	silent 1
	string images=imagenamelist(winname(0,1),";")
	if(itemsinlist(images,";")==0)
		print "no images found in the top graph"
		return 0
	endif
	
	if(strsearch(controlnamelist(winname(0,1)),"profile",0)!=-1)
		doprofile("goawayprofile")
	endif
	
	if(strsearch(controlnamelist(winname(0,1)),"slice",0)!=-1)
		return 0
	endif

	Button vertslice proc=doslice,title="V", pos={20,0}, size={20,14}
	Button horzslice proc=doslice,title="H", pos={40,0}, size={20,14}
	Button graphslice proc=doslice,title="Show", pos={60,0}, size={50,14}
	Button goawayslice proc=doslice,title="Close", pos={110,0}, size={50,14}
	string/G slicenamestr="sw"
	SetVariable slicename noproc, title="Wave", value=slicenamestr, pos={162,0}, size={80,12}, labelback=(65535,65535,65535)
	variable/G slicedelta
	SetVariable slicedelta noproc, title="Delta", value=slicedelta, pos={244,0}, size={80,12}, labelback=(65535,65535,65535)
	variable/G slicestep=1
	SetVariable slicestep noproc, title="Step", value=slicestep, pos={326,0}, size={80,12}, labelback=(65535,65535,65535)
end

function doslice(ctrlname): ButtonControl
	string ctrlname

	SVAR sstr = slicenamestr
	string sstrx=sstr+"_x"
	NVAR sd=slicedelta
	NVAR ss=slicestep
	wave imagewave=imagenametowaveref(winname(0,1),stringfromlist(0,imagenamelist(winname(0,1),";")))
	variable i=0,j=0,size0=dimsize(imagewave,0),size1=dimsize(imagewave,1),numslices
	
	if(stringmatch(ctrlname,"vertslice"))
		numslices=floor(size0/ss)
		make/o/n=((size1+1)*numslices) $sstr,$sstrx
		wave swy=$sstr
		swy=NaN
		wave swx=$sstrx
		swx=NaN
		do
			j=0
			do
				swy[i*(size1+1)+j]=imagewave[i*ss][j]+sd*i
				swx[i*(size1+1)+j]=dimoffset(imagewave,1)+j*dimdelta(imagewave,1)
				j+=1
			while(j<size1)
			i+=1
		while(i<numslices)
	elseif(stringmatch(ctrlname,"horzslice"))
		numslices=floor(size1/ss)
		make/o/n=((size0+1)*numslices) $sstr,$sstrx
		wave swy=$sstr
		swy=NaN
		wave swx=$sstrx
		swx=NaN
		do
			j=0
			do
				swy[j*(size0+1)+i]=imagewave[i][j*ss]+sd*i
				swx[j*(size0+1)+i]=dimoffset(imagewave,0)+i*dimdelta(imagewave,0)
				j+=1
			while(j<numslices)
			i+=1
		while(i<size0)
	elseif(stringmatch(ctrlname,"graphslice"))
		display $sstr vs $sstrx
	else	// goaway
		killcontrol vertslice
		killcontrol horzslice
		killcontrol graphslice
		killcontrol goawayslice
		killcontrol slicename
		killcontrol slicedelta
		killcontrol slicestep
	endif
end

macro alexbuttons()
	silent 1
	string images=imagenamelist(winname(0,1),";")
	if(itemsinlist(images,";")==0)
		print "no images found in the top graph"
		return 0
	endif

	if(strsearch(controlnamelist(winname(0,1)),"slice",0)!=-1)
		doslice("goawayslice")
	endif

	if(strsearch(controlnamelist(winname(0,1)),"profile",0)!=-1)
		doprofile("goawayprofile")
	endif

	if(strsearch(controlnamelist(winname(0,1)),"buttons",0)!=-1)
		return 0
	endif
	
	variable xcenter,ycenter
	getaxis/Q left
	if(V_flag==1)
		getaxis/Q right
	endif
	ycenter=(V_min+V_max)/2
	getaxis/Q bottom
	if(V_flag==1)
		getaxis/Q top
	endif
	xcenter=(V_min+V_max)/2
	make/o lx0={0,0,0},ly0={-inf,0,inf},lx1={0,0,0},ly1={-inf,0,inf}
	appendtograph/C=(0,65535,0) ly0 vs lx0
	ModifyGraph offset(ly0)={xcenter,ycenter}, quickdrag(ly0)=1,lstyle(ly0)=1
	appendtograph/C=(0,65535,0) ly1 vs lx1
	ModifyGraph offset(ly1)={xcenter,ycenter}, quickdrag(ly1)=1,lstyle(ly1)=1
	
	Button gominus proc=dobuttons,title="up", pos={160,0}, size={20,14}
	Button goplus proc=dobuttons,title="dn", pos={180,0}, size={20,14}
	Button vertbuttons proc=dobuttons,title="V", pos={210,0}, size={20,14}
	Button horzbuttons proc=dobuttons,title="H", pos={230,0}, size={20,14}
	Button goawaybuttons proc=dobuttons,title="Close", pos={250,0}, size={50,14}
	variable/G buttondelta=1
	SetVariable buttondelta noproc, title="Delta", value=buttondelta, pos={304,0}, size={80,12}, labelback=(65535,65535,65535), limits={1,inf,1}

end

function dobuttons(ctrlname): ButtonControl
	string ctrlname

	// buttons is getting some slightly different functionality: it will not wrap, rather it will add enough
	// NaN's around the edges to let the rows or cols slide arbitrarily.  Scaling will always keep the same
	// x0 and deltax etc so the original wave will never be lost (unless you decide to do shifts in both
	// dimensions...)

	NVAR delta=buttondelta
	wave imagewave=imagenametowaveref(winname(0,1),stringfromlist(0,imagenamelist("",";")))
	variable xoffset0,yoffset0
	string offsetstr0=stringbykey("offset(x)",TraceInfo("","ly0",0),"=",";")
	offsetstr0=offsetstr0[1,strlen(offsetstr0)-2]
	xoffset0=str2num(stringfromlist(0,offsetstr0,","))
	yoffset0=str2num(stringfromlist(1,offsetstr0,","))
	variable xoffset1,yoffset1
	string offsetstr1=stringbykey("offset(x)",TraceInfo("","ly1",0),"=",";")
	offsetstr1=offsetstr1[1,strlen(offsetstr1)-2]
	xoffset1=str2num(stringfromlist(0,offsetstr1,","))
	yoffset1=str2num(stringfromlist(1,offsetstr1,","))
	
	string cmd
	variable xdelta=dimdelta(imagewave,0)
	variable xstep=sign(xdelta)
	variable ydelta=dimdelta(imagewave,1)
	variable ystep=sign(ydelta)
	variable x0=dimoffset(imagewave,0)
	variable y0=dimoffset(imagewave,1)
	variable xsize=dimsize(imagewave,0)
	variable ysize=dimsize(imagewave,1)
	variable p0=round((xoffset0-x0)/xdelta)
	variable p1=round((xoffset1-x0)/xdelta)
	variable pstep=sign(p1-p0)
	variable q0=round((yoffset0-y0)/ydelta)
	variable q1=round((yoffset1-y0)/ydelta)
	variable qstep=sign(q1-q0)
	wave lx0=$"lx0",ly0=$"ly0",lx1=$"lx1",ly1=$"ly1"
	variable i,j
	
	if(stringmatch(ctrlname,"vertbuttons"))
		Button gominus title="up"
		Button goplus title="dn"
		lx0={0,0,0};ly0={-inf,0,inf};lx1=lx0;ly1=ly0
	elseif(stringmatch(ctrlname,"horzbuttons"))
		Button gominus title="<-"
		Button goplus title="->"
		lx0={-inf,0,inf};ly0={0,0,0};lx1=lx0;ly1=ly0
	elseif(stringmatch(ctrlname,"goplus") || stringmatch(ctrlname,"gominus"))
		// first make junkwave2 be imagewave with a buffer of NaN's
		variable idelta=0,jdelta=0
		if(lx0[0]==0)	// vertical
			make/o/n=((xsize),(ysize+2*delta)) junkwave2=NaN
			jdelta=delta
		else
			make/o/n=((xsize+2*delta),(ysize)) junkwave2=NaN
			idelta=delta
		endif	
		i=0
		do
			j=0
			do
				junkwave2[i+idelta][j+jdelta]=imagewave[i][j]
				j+=1
			while(j<ysize)
			i+=1
		while(i<xsize)
		copyscales/P imagewave,junkwave2
		
		// next shift things in junkwave2 and find rows which are all NaN, and copy data back to
		// a redimensioned imagewave
		variable stepsign=1,firstrow=-1,lastrow=-1
		if(stringmatch(ctrlname,"gominus"))
			stepsign=-1
		endif
		
		if(lx0[0]==0)	// vertical
			make/o/n=(ysize+2*delta) junkwave
			i=p0-pstep
			do
				i+=pstep
				junkwave[]=junkwave2[i][p]
				junkwave2[i][]=junkwave[mod(q+(stepsign*ystep*delta)+(ysize+2*delta),(ysize+2*delta))]
			while(i!=p1)
			i=0
			do
				j=0
				do
					if(numtype(junkwave2[j][i])!=2)
						firstrow=i
					endif
					j+=1
				while(j<xsize)
				i+=1
			while((i<ysize+2*delta)&&(firstrow==-1))
			i=ysize+2*delta-1
			do
				j=0
				do
					if(numtype(junkwave2[j][i])!=2)
						lastrow=i
					endif
					j+=1
				while(j<xsize)
				i-=1
			while((i>=0)&&(lastrow==-1))
			redimension/n=((xsize),(lastrow-firstrow+1)) imagewave
			imagewave[][]=junkwave2[p][q+firstrow]
			copyscales/P junkwave2,imagewave
		else	// horizontal
			make/o/n=(xsize+2*delta) junkwave
			i=q0-qstep
			do
				i+=qstep
				junkwave[]=junkwave2[p][i]
				junkwave2[][i]=junkwave[mod(p-stepsign*(xstep*delta)+(xsize+2*delta),(xsize+2*delta))]
			while(i!=q1)
			i=0
			do
				j=0
				do
					if(numtype(junkwave2[i][j])!=2)
						firstrow=i
					endif
					j+=1
				while(j<ysize)
				i+=1
			while((i<xsize+2*delta)&&(firstrow==-1))
			i=xsize+2*delta-1
			do
				j=0
				do
					if(numtype(junkwave2[i][j])!=2)
						lastrow=i
					endif
					j+=1
				while(j<ysize)
				i-=1
			while((i>=0)&&(lastrow==-1))
			redimension/n=((lastrow-firstrow+1),(ysize)) imagewave
			imagewave[][]=junkwave2[p+firstrow][q]
			copyscales/P junkwave2,imagewave
		endif
	else	// goaway or error
		killcontrol goplus
		killcontrol gominus
		killcontrol vertbuttons
		killcontrol horzbuttons
		killcontrol goawaybuttons
		killcontrol buttondelta
		if(strsearch(tracenamelist(winname(0,1),";",1),"ly0",0)!=-1)
			removefromgraph $"ly0"
		endif
		if(strsearch(tracenamelist(winname(0,1),";",1),"ly1",0)!=-1)
			removefromgraph $"ly1"
		endif
	endif
end

macro findplateaus()
	dofindplateaus()
end

function dofindplateaus()
	Variable/G V_rinline=0
	setvariable testrinline proc=doplateau, title="Inline Resistance", value=V_rinline, pos={80,0},size={140,12}, labelback=(65535,65535,65535), limits={0,inf,10}
	button goawayplateaus proc=undoplateau, title="Close", pos={220,0}, size={50,14}
	string tracestr=toptrace(0)
	variable tracelen=strlen(tracestr)
	string txstr="tx_"+tracestr
	string tlstr="tl"
	make/o $txstr={0,1,2,3,4,5,6,7,8,9,10}
	wave tx=$txstr
	make/T/o $tlstr={"0","1","2","3","4","5","6","7","8","9","10"}
	wave tl=$tlstr
	if(stringmatch(tracestr[tracelen-4,tracelen-1],"hist"))	// for histograms make these ticks on the bottom
		ModifyGraph grid(bottom)=2,userticks(bottom)={tx,tl}
	else		// for conductance data make these ticks on the left
		ModifyGraph grid(left)=2,userticks(left)={tx,tl}
	endif
end

function undoplateau(ctrlname): ButtonControl
	string ctrlname
	killcontrol testrinline
	killcontrol goawayplateaus
	variable/G V_rinline
	string labelstr;sprintf labelstr,"Ticks for Rinline=%d",V_rinline
	labelgraph(labelstr,0,8)
end

function doplateau(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	variable i=1,R0=25813
	string txstr="tx_"+toptrace(0)
	wave tx=$txstr
	do
		tx[i]=1/((1/i)+varNum/R0)
		i+=1
	while(i<=10)
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

function/S toptrace(num)
	// same as above, but for traces
	variable num
	return stringfromlist(num,tracenamelist("",";",1),";")
end