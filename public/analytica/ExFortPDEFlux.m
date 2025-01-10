(* ::Package:: *)

(* ::Input::Initialization:: *)
GreekLetters=Union[Alphabet["Greek"],Alphabet["Greek"]//ToUpperCase,{"\[Phi]"}];
GreekToText[expr_]:=StringReplace[ToString[expr],u_/;MemberQ[GreekLetters,ToString[u]]:>ToLowerCase[CharacterName[ToString[u]]]]
MyFortranForm[expr_]:=GreekToText[FortranForm[expr]]/."0"->"0.0"/.Subscript[x_,y_]->StringForm["````",x,y]
Varname[var_]:=var/.u_[mm_]->StringForm["````",u,mm]/.u_[mm_,nn_]->StringForm["`1``2``3`",u,mm,nn]//GreekToText


ExFortFlux[filename_,EqnNumber_,ModelName_]:=(
VV=Table[0,{i,1,Ncl}];QQ=Table[0,{i,1,Ncl}];FF=Table[0,{i,1,Ncl},{k,1,3}];BB=Table[0,{i,1,Ncl}];SS=Table[0,{i,1,Ncl}];
Module[{ii,s,Vi,Qi,fluxik,Bi,Vij,Qij,fluxij,Bij,Si,Sij},
ii=1;
For[s=1,s<=Neq,s++, 
If[MemberQ[V1[[s]],Subscript[_, i]],
(*then*)  Vi=Table[V1[[s]]/.Subscript[v_, i_]:>v[i],{i,1,dims[[s]]}]//Flatten;VV[[ii;;ii+dims[[s]]-1]]=Vi[[1;;dims[[s]]]]; 
                    Qi=Table[Q1[[s]]/.Subscript[v_, i_]:>v[i],{i,1,dims[[s]]}]//Flatten;QQ[[ii;;ii+dims[[s]]-1]]=Qi[[1;;dims[[s]]]]; 
                    fluxik=Table[F1[[s]]/.Subscript[v_, i_]:>v[i]/.Subscript[v_, i,k]:>v[i,k],{i,1,dims[[s]]},{k,1,d}]/.unbracket;FF[[ii;;ii+dims[[s]]-1,1;;d]]=fluxik;
                    Bi=Table[B1[[s]]/.Subscript[x, j_]->X[[j]]/.Subscript[v_, j_]:>v[j],{i,1,dims[[s]]}]/.unbracket//Quiet; BB[[ii;;ii+dims[[s]]-1]]=Bi[[1;;dims[[s]]]] ;
        Si=Table[S1[[s]]/.Subscript[x, j_]->X[[j]]/.Subscript[v_, j_]:>v[j],{i,1,dims[[s]]}]/.unbracket//Quiet; SS[[ii;;ii+dims[[s]]-1]]=Si[[1;;dims[[s]]]] ;
                    ii=ii+dims[[s]],
(*elseif*) If[MemberQ[V1[[s]],Subscript[_, i,j]],
(*then*)   Vij=Table[V1[[s]]/.Subscript[v_, i,j]:>v[i,j],{i,1,dims[[s]][[1]]},{j,1,dims[[s]][[2]]}]//Flatten;VV[[ii;;ii+dims[[s]][[1]]*dims[[s]][[2]]-1]]=Vij[[1;;dims[[s]][[1]]*dims[[s]][[2]]]];
                     Qij=Table[Q1[[s]]/.Subscript[v_, i,j]:>v[i,j],{i,1,dims[[s]][[1]]},{j,1,dims[[s]][[2]]}]//Flatten;QQ[[ii;;ii+dims[[s]][[1]]*dims[[s]][[2]]-1]]=Qij[[1;;dims[[s]][[1]]*dims[[s]][[2]]]];
                     fluxijk=Table[F1[[s]]/.Subscript[v_, i_]:>v[i]/.Subscript[v_, i_,j_]:>v[i,j],{i,1,dims[[s]][[1]]},{j,1,dims[[s]][[2]]},{k,1,d}]/.unbracket; 
                     Bij=Table[B1[[s]]/.Subscript[x, ww_]->X[[ww]]/.Subscript[v_, ww_]:>v[ww]/.Subscript[v_, ww_,xx_]:>v[ww,xx],{i,1,dims[[s]][[1]]},{j,1,dims[[s]][[1]]}]/.unbracket//Quiet;
                     BB[[ii;;ii+dims[[s]][[1]]*dims[[s]][[2]]-1]]=Flatten[Bij]; 
       Sij=Table[S1[[s]]/.Subscript[x, ww_]->X[[ww]]/.Subscript[v_, ww_]:>v[ww]/.Subscript[v_, ww_,xx_]:>v[ww,xx],{i,1,dims[[s]][[1]]},{j,1,dims[[s]][[1]]}]/.unbracket//Quiet;
                     SS[[ii;;ii+dims[[s]][[1]]*dims[[s]][[2]]-1]]=Flatten[Sij]; 
                     For[kk=1,kk<=d,kk++,FF[[ii;;ii+dims[[s]][[1]]*dims[[s]][[2]]-1,kk]]=Flatten[fluxijk[[All,All,kk]]] ];           
                     ii=ii+dims[[s]][[1]]*dims[[s]][[2]],
(*else*){VV[[ii]]}=V1[[s]];
                  {QQ[[ii]]}=Q1[[s]];
                   BB[[ii]]=B1[[s]]/.Subscript[x, j_]->X[[j]]/.Subscript[v_, j_]:>v[j]/.Subscript[v_, i_,j_]->v[[i,j]]/.unbracket//Quiet;
     SS[[ii]]=S1[[s]]/.Subscript[x, j_]->X[[j]]/.Subscript[v_, j_]:>v[j]/.Subscript[v_, i_,j_]->v[[i,j]]/.unbracket//Quiet;
                   FF[[ii,1;;d]] = Table[F1[[s]]/.Subscript[v_, k]:>v[k]/.unbracket,{k,1,d}];
                    ii=ii+1;]]
];
];

Ffortran=FF;
Bfortran=BB;
Sfortran=SS;
Do[Ffortran=Ffortran/.(VV[[i]]/.unbracket)->V[i],{i,1,Ncl}];



outputStream=OpenWrite[filename];
Fluxnames={"f","g","h"};(*PDE fluxes f, g and h*)

WriteString[outputStream,"!========================================================================================== \n"];
WriteString[outputStream,"!=========================== STEP 0: AMRInit.f90  =================================== \n"];
WriteString[outputStream,"!========================================================================================== \n\n"];
WriteString[outputStream,StringForm["#ifdef EQNTYPE``        !``\n",EqnNumber,ModelName]];
WriteString[outputStream,StringForm["    nAux = ... ! Optional \n"]];
WriteString[outputStream,StringForm["#endif\n\n"]];

WriteString[outputStream,"!========================================================================================== \n"];
WriteString[outputStream,"!=========================== STEP 1: MainVariables.f90  =================================== \n"];
WriteString[outputStream,"!========================================================================================== \n\n"];
WriteString[outputStream,StringForm["#ifdef EQNTYPE``        !``\n",EqnNumber,ModelName]];
WriteString[outputStream,StringForm["  INTEGER, PARAMETER :: nVar = `1` \n",Ncl]];
WriteString[outputStream,StringForm["#endif\n\n"]];

WriteString[outputStream,"!=========================== STEP 2: Rusanov.f90  =================================== \n"];
WriteString[outputStream,StringForm["Just add EQNTYPE`1` to the list of EQNTYPES already there \n\n", EqnNumber]];

WriteString[outputStream,"!========================================================================================== \n"];
WriteString[outputStream,"!=========================== STEP 3: PDE.f90 fluxes  ====================================== \n"];
WriteString[outputStream,"!====================== EXERT CAUTION HERE!! CHECK EVERY LINE ============================= \n\n"];
WriteString[outputStream,StringForm["#ifdef EQNTYPE``        !``\n\n",EqnNumber,ModelName]];
WriteString[outputStream,"    CALL PDECons2Prim(V,Q,x,time,iErr)\n"]
Do[ 
{Do[WriteString[outputStream,StringForm[ "    `1`(`2`) = `3`   ! `4`  \n", Fluxnames[[k]],i,MyFortranForm[Ffortran[[i]][[k]] ],Varname[VV[[i]]]]  ],{i,1,Ncl}];WriteString[outputStream,"\n"]},{k,1,d}];
WriteString[outputStream,StringForm["#endif\n\n"]];




WriteString[outputStream,"!========================================================================================== \n"];
WriteString[outputStream,"!======================== STEP 4: PDE.f90 Variable Names  ================================= \n"];
WriteString[outputStream,"!========================================================================================== \n\n"];

WriteString[outputStream,StringForm["#ifdef EQNTYPE``        !``\n\n",EqnNumber,ModelName]];
Do[WriteString[outputStream,StringForm[ "    Name(`1`) = \"`2`\" \n", i,Varname[VV[[i]]]]],{i,1,Ncl}];WriteString[outputStream,"\n"];
WriteString[outputStream,StringForm["#endif\n"]];

Close[outputStream];)

Math2FortSource[filename_,EqnNumber_,ModelName_]:=(
outputStream=OpenAppend[filename];
WriteString[outputStream,"!========================================================================================== \n"];
WriteString[outputStream,"!=========================== STEP 4: PDE.f90 Sources  ======================================= \n"];
WriteString[outputStream,"!============================================================================================ \n\n"];
WriteString[outputStream,StringForm["#ifdef EQNTYPE``        !``\n\n",EqnNumber,ModelName]];


Do[If[TrueQ[Sfortran[[i]]==0],"",WriteString[outputStream,StringForm[ "   S(`1`) = `2`   ! `3`  \n",i,MyFortranForm[Sfortran[[i]] ]//replaceParameters,Varname[VV[[i]]]]]],{i,1,Ncl}];WriteString[outputStream,"\n"];
WriteString[outputStream,StringForm["#endif\n\n"]];
Close[outputStream];)

