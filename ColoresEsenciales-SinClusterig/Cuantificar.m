function Cuantificar( Child)
		%int x = 0,y=0,t=0,j=0;
		%double dm=0,d=0;
		%long k=0;
		%Region *sr,*srt;
		%NodoList *Actual,*Actual2,*Actual3;
		%Graphics::TBitmap *tmp2;
		%picy=Child->Image->Picture->Height;
		%picx=Child->Image->Picture->Width;
        [h,w,p] = size(Child);
		ind = (Region ***)malloc(sizeof(Region*)*picx);
		slist2=(Lista **)malloc(sizeof(Lista*)*101);
		slist3=(Lista **)malloc(sizeof(Lista*)*101);
		tmp2 = new Graphics::TBitmap();
		tmp2->PixelFormat = pf24bit;
		tmp2->IgnorePalette = true;
		tmp2->Height=picy;
		tmp2->Width=picx;
		for(j=0; j<=picx; j++){
			ind[j]=(Region **)malloc(sizeof(Region*)*picy);
			}
		for (x=0;x<=picx;x++)
			for (y=0;y<=picy;y++)
				ind[x][y]=NULL;
		Label5->Caption="Regionize";
		this->Refresh();
		ParentForm->ProgressBar1->Position=0;
		ParentForm->ProgressBar1->Max=picx;
		for (x=0; x<picx; x++){
			ParentForm->ProgressBar1->Position+=1;
			for (y=0; y<picy; y++){
				regioniza(x,y,Child->lab->Canvas->Pixels[x][y]);
				}
			}
		Label5->Caption="Generating list";
		this->Refresh();
		Lista *list=new Lista();
		ParentForm->ProgressBar1->Position=0;
		for(x=0;x<picx;x++){
			ParentForm->ProgressBar1->Position+=1;
			for(y=0;y<picy;y++){
				if(ind[x][y]->enLista!=1){
						list->add(ind[x][y]);
						ind[x][y]->enLista=1;
						}
				}
			}
		Child->CantObjetos=list->CantEle;
		for (x=0;x<=101;x++){
			slist2[x]=new Lista();
			slist3[x]=new Lista();
			}
		Label5->Caption="Colors distributing";
		ParentForm->ProgressBar1->Position=0;
		ParentForm->ProgressBar1->Max=list->CantEle;
		Actual=list->Cabeza;
		while(Actual!=NULL){
			ParentForm->ProgressBar1->Position=ParentForm->ProgressBar1->Position+1;
			t=0;
			Actual2=slist2[GetRValue(Actual->Reg->Col)]->Cabeza;
			while(Actual2!=NULL&&t==0){
				d=CIE2000(Actual->Reg->Col,Actual2->Reg->Col);
				if	(d<=U){
					t=1;
					mix_region(Actual2->Reg,Actual->Reg,1,1,1);
					}
					else
						Actual2=Actual2->Sig;
				}
			if(t==0||Actual2==NULL)
				slist2[GetRValue(Actual->Reg->Col)]->addlast(Actual->Reg);
			Actual=Actual->Sig;
			}
		t=0;
		for (x=0;x<=101;x++){
			t=t+slist2[x]->CantEle;
			}
		ParentForm->ProgressBar1->Position=0;
		ParentForm->ProgressBar1->Max=t;
		Label5->Caption="Merging colors";
		for (x=0;x<=101;x++){
			Actual=slist2[x]->Cabeza;
			while(Actual!=NULL){
				ParentForm->ProgressBar1->Position=ParentForm->ProgressBar1->Position+1;
				t=0;
				Actual2=slist3[0]->Cabeza;
				while(Actual2!=NULL&&t==0){
					d=CIE2000(Actual->Reg->Col,Actual2->Reg->Col);
					if	(d<=U){
						t=1;
						mix_region(Actual2->Reg,Actual->Reg,1,1,1);
						}
						else
							Actual2=Actual2->Sig;
					}
				if(t==0||Actual2==NULL)
					slist3[0]->addlast(Actual->Reg);
				Actual=Actual->Sig;
				}
			}
	Label5->Caption="Creating color palette";
	j=1;
	for(x=0;j==1;x++){
		j=0;
		ParentForm->ProgressBar1->Position=0;
		ParentForm->ProgressBar1->Max=slist3[x]->CantEle;
			Actual=slist3[x]->Cabeza;
			while(Actual!=NULL){
				ParentForm->ProgressBar1->Position=ParentForm->ProgressBar1->Position+1;
				t=0;
				Actual2=slist3[x+1]->Cabeza;
				while(Actual2!=NULL&&t==0){
					d=CIE2000(Actual->Reg->Col,Actual2->Reg->Col);
					if	(d<=U){
						t=1;
						j=1;
						mix_region(Actual2->Reg,Actual->Reg,1,1,1);
						}
						else
							Actual2=Actual2->Sig;
					}
				if(t==0||Actual2==NULL)
					slist3[x+1]->add(Actual->Reg);
				Actual=Actual->Sig;
				}
		k=slist3[x+1]->CantEle;
		}
		Label5->Caption="Erasing unimportant colors";
		ParentForm->ProgressBar1->Position=0;
		ParentForm->ProgressBar1->Max=k;
			Actual=slist3[x]->Cabeza;
			while(Actual!=NULL){
				ParentForm->ProgressBar1->Position=ParentForm->ProgressBar1->Position+1;
				d=(double)Actual->Reg->CantPixels/(double)(picx*picy);
				if	(d<0.0001){
					Actual2=slist3[x]->Cabeza;
					dm=100;
					while(Actual2!=NULL){
						d=CIE2000(Actual->Reg->Col,Actual2->Reg->Col);
						if(d<dm&&d>0){
							Actual3=Actual2;
							dm=d;
							}
						Actual2=Actual2->Sig;
						}
					slist3[x]->del(Actual);
					mix_region(Actual3->Reg,Actual->Reg,1,1,1);
					}
					else
						slist3[x+1]->addlast(Actual->Reg);
				Actual=Actual->Sig;
				}
		k=slist3[x+1]->CantEle;
		if (CheckBox5->Checked==true){
			Label5->Caption="Segmented Image";
			this->Refresh();
			ParentForm->ProgressBar1->Position=0;
			ParentForm->ProgressBar1->Max=picx;
			for(x=0;x<picx;x++){
				ParentForm->ProgressBar1->Position=ParentForm->ProgressBar1->Position+1;
				for(y=0;y<picy;y++)
					tmp2->Canvas->Pixels[x][y]=(TColor)lab2rgb(ind[x][y]->Col);
				}
			MostrarImagen(tmp2,"Segmented("+Child->Caption+","+U+","+Child->CantObjetos+","+k+")");
			}
		tmp2->Free();
		ParentForm->ProgressBar1->Position=0;
		Screen->Cursor = crHourGlass;
		if (CheckBox2->Checked==true){
			Label5->Caption="Dithered Image";
			this->Refresh();
			Calc(Child->Caption,"Segmented("+Child->Caption+","+U+","+Child->CantObjetos+","+k+")",13,"Dithered Image");
			}
		Screen->Cursor = crHourGlass;
		if (CheckBox3->Checked==true){
			Label5->Caption="Nearest Image";
			this->Refresh();
			Calc(Child->Caption,"Segmented("+Child->Caption+","+U+","+Child->CantObjetos+","+k+")",12,"Nearest Image");
			Calc(Child->Caption,"Nearest Image("+Child->Caption+",Segmented("+Child->Caption+","+U+","+Child->CantObjetos+","+k+"))",11,"Mean Square Error");
			}
	return k;
	}