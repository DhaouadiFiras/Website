(* ::Package:: *)

FilterParameters[list_]:=Module[{crit1,crit2,crit3},
crit1[expr_]:=!MemberQ[Vclean,expr]; (* not a variable *)
crit2[expr_]:=!MatchQ[expr,\!\(\*
TagBox[
StyleBox[
RowBox[{
RowBox[{"Derivative", "[", 
RowBox[{"_", ",", "_", ",", "_"}], "]"}], "[", "_", "]"}],
ShowSpecialCharacters->False,
ShowStringCharacters->True,
NumberMarks->True],
FullForm]\)]; (* not a derivative *)
crit3[expr_]:=!MatchQ[expr,_[_]]; (* not a function *)
parameters=Select[list,crit1[#]&& crit2[#]&& crit3[#]&];
parameters
]

ExportReadpar[filename_,EqnNumber_,ModelName_]:=(

outputStream=OpenAppend[filename];

WriteString[outputStream,"!========================================================================================== \n"];
WriteString[outputStream,"!================================ readpar.f90 ============================================= \n"];
WriteString[outputStream,"!========================================================================================== \n\n"];
WriteString[outputStream,StringForm["#ifdef EQNTYPE``        !``\n\n",EqnNumber,ModelName]];

Do[WriteString[outputStream,StringForm["  READ (332,*) EQN%`1`\n",parListFortran[[i]]]];,{i,1,nPar}];
WriteString[outputStream,StringForm["\n#endif\n\n"]];
WriteString[outputStream,"\n IF ( myrank .EQ. 0) THEN\n\n"];
WriteString[outputStream,  StringForm["  WRITE(*,*) '|  You are solving the `1` !'\n",ModelName]];
Do[WriteString[outputStream,StringForm["  WRITE(*,*) '| `1` =', EQN%`1`   \n",parListFortran[[i]]]];,{i,1,nPar}];

WriteString[outputStream,"\n ENDIF\n\n"];

WriteString[outputStream,"!========================================================================================== \n"];
WriteString[outputStream,"!============================= MainVariables.f90 ========================================== \n"];
WriteString[outputStream,"!========================================================================================== \n\n"];
WriteString[outputStream,StringForm["#ifdef EQNTYPE``        !``\n\n",EqnNumber,ModelName]];

parString="        REAL    :: ";
Do[parString=parString<>parListFortran[[i]]<>",";,{i,1,nPar}];
parString=StringReplacePart[parString,"\n",{-1,-1}];
WriteString[outputStream,"    TYPE tEquation \n"];
WriteString[outputStream,"        ! Your parameters: Declared by default as real. PLEASE CHANGE IF NECESSARY.\n"];
WriteString[outputStream, parString];
WriteString[outputStream,"        ! These parameters are necessary for AMR3D to work.\n"];
WriteString[outputStream,"        REAL    :: Pi, C0, Rho0, A01, A02, GAMMA1, CV1, C01, Rho01, P01, Gamma2, CV2\n"];
WriteString[outputStream,"        REAL    :: C02, Rho02, P02, P0, K1, K2, Mu1, Mu2, LAMBDA1, Mu, cT\n"];
WriteString[outputStream,"        INTEGER :: EOSType = 0, EOS1 = 0, EOS2 = 0 \n"];
WriteString[outputStream,"    END TYPE tEquation\n"];
WriteString[outputStream,StringForm["\n#endif\n\n"]];


Close[outputStream];)




replaceDerivative[expr_]:=StringReplace[expr,{"Derivative(1)("~~u_~~")"->u~~"prime","Derivative(2)("~~u_~~")"->u~~"second"}]
replaceParameters[expr_]:=StringReplace[expr,str__/;MemberQ[parListFortran,str]:>"EQN%"<>str]
ExportFortranEigvals[filename_,EqnNumber_,ModelName_]:=(

outputStream=OpenAppend[filename];

WriteString[outputStream,"!========================================================================================== \n"];
WriteString[outputStream,"!============================== PDE.f90 Eigenvalues  =========================================== \n"];
WriteString[outputStream,"!========================================================================================== \n\n"];
WriteString[outputStream,StringForm["#ifdef EQNTYPE``        !``\n\n",EqnNumber,ModelName]];

Do[WriteString[outputStream,StringForm["    L(``) = ``",i,StringReplace[MyFortranForm[GroupedEigvals[[i]][[1]]/.u_/;
MemberQ[Vclean,u]:>tempname[Position[Vclean,u]/.unbracket/.unbracket]],"tempname"->"Vp"]<>"\n"//replaceDerivative//replaceParameters]],{i,1,nEigval}];
WriteString[outputStream,StringForm["\n#endif\n\n"]];

Close[outputStream];)




ExFortNC[filename_,EqnNumber_,ModelName_]:=(
outputStream=OpenAppend[filename];

WriteString[outputStream,"!========================================================================================== \n"];
WriteString[outputStream,"!======================= PDE.f90 nonConservative Terms  ================================== \n"];
WriteString[outputStream,"!========================================================================================== \n\n"];
WriteString[outputStream,StringForm["#ifdef EQNTYPE``        !``\n\n",EqnNumber,ModelName]];

WriteString[outputStream,"  AQx = 0. \n"];  
WriteString[outputStream,"  BQy = 0. \n"];  
WriteString[outputStream,"  CQz = 0. \n\n"];  

Do[
NCterms=Esthetic[B[[i]]]; (*Remove space dependence and subscripts indexed variables*)
NCterms=NCterms/.uu_/;MemberQ[Vclean,uu]:>v[Position[Vclean,uu]/.unbracket/.unbracket];(*Replaces primitive variables by their corresponding V[i] *)
NCterms=NCterms/.Prim2ConsRules/.q[jjj_]:>q[jjj][x,y,z];(*Applies Prim2Cons to obtain expressions in conservatives*)
NCterms=NCterms/.Derivative[a_,b_,c_][expr_]:>D[expr,{x,a},{y,b},{z,c}]; (*Replaced derivatives so that they can be expanded*)
NCterms=Expand[omitx[NCterms]]; (*Removes the {x,y,z} from expression and expands all products*)
AQxi=NCterms/._*Derivative[0,_,_][_]->0/.Derivative[1,0,0][q[jjj_]]->ToExpression["qx["<>ToString[jjj]<>"]"]; (*keep only x derivatives*)
BQyi=NCterms/._*Derivative[_,0,_][_]->0/.Derivative[0,1,0][q[jjj_]]->ToExpression["qy["<>ToString[jjj]<>"]"]; (*keep only y derivatives*)
CQzi=NCterms/._*Derivative[_,_,0][_]->0/.Derivative[0,0,1][q[jjj_]]->ToExpression["qz["<>ToString[jjj]<>"]"]; (*keep only z derivatives*)

AQxiprint=StringReplace[MyFortranForm[AQxi],"q"->"Q"];
BQyiprint=StringReplace[MyFortranForm[BQyi],"q"->"Q"];
CQziprint=StringReplace[MyFortranForm[CQzi],"q"->"Q"];

If[TrueQ[NCterms==0],"",
WriteString[outputStream,StringForm["!`1` \n",Varname[VV[[i]]]]]
If[LeafCount[AQxi]<300,WriteString[outputStream,StringForm["  AQx(`1`) = `2`\n",i,AQxiprint]],WriteString[outputStream,StringForm["  AQx(`1`)=`2`\n",i,"0.0   !Too long. Please check formulas and create auxiliary variables..."]]];
If[LeafCount[BQyi]<300,WriteString[outputStream,StringForm["  BQy(`1`) = `2`\n",i,BQyiprint]],WriteString[outputStream,StringForm["  AQx(`1`)=`2`\n",i,"0.0   !Too long. Please check formulas and create auxiliary variables..."]]];
If[LeafCount[CQzi]<300,WriteString[outputStream,StringForm["  CQz(`1`) = `2`\n",i,CQziprint]],WriteString[outputStream,StringForm["  AQx(`1`)=`2`\n",i,"0.0   !Too long. Please check formulas and create auxiliary variables..."]]];
];
,{i,1,Ncl}];
WriteString[outputStream,StringForm["\n#endif\n\n"]];
Close[outputStream];)



ExportParfile[filename_]:=(

outputStream=OpenWrite[filename];

WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"<  AMR VERSION                      >\n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"2.0                                  ! AMR version \n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"<  AMR EQUATIONS                    >\n"];
WriteString[outputStream,"<----------------------------------->\n"];
Do[WriteString[outputStream,StringForm["...                                  ! `1`\n",parListFortran[[i]]]];,{i,1,nPar}];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"<  AMR PARAMETERS                   >\n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"0                                    ! MAXREFLEVEL\n"];
WriteString[outputStream,"1                                    ! Refinement Criterion: 1=GradError, 2=SecondDerivative \n"];
WriteString[outputStream,"0.6                                  ! RefineThreshold\n"];
WriteString[outputStream,"0.2                                  ! RecoarseThreshold\n"];
WriteString[outputStream,"standard                             ! Refine Initial Conditions: standard/manual\n"];
WriteString[outputStream,"0                                    ! Refine Radius\n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"<  AMR INITIAL CONDITIONS           >\n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"IC_TYPE                              ! As defined in Init.f90 \n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"<  AMR MESH                         >\n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"200                                ! MAXEL\n"];
WriteString[outputStream,"50                                 ! MAXMPI\n"];
WriteString[outputStream,"128                                ! IMAX   104\n"];
WriteString[outputStream,"4                                  ! JMAX   104 \n"];
WriteString[outputStream,"1                                  ! KMAX\n"];
WriteString[outputStream,"-1.0                               ! ymin    \n"];
WriteString[outputStream,"+1.0                               ! ymax\n"];
WriteString[outputStream,"-1.0                               ! ymin\n"];
WriteString[outputStream,"+1.0                               ! ymax\n"];
WriteString[outputStream,"-1.0                               ! zmin\n"];
WriteString[outputStream,"+1.0                               ! zmax\n"];
WriteString[outputStream,"NO                                 ! Use ParMtis?\n"];
WriteString[outputStream,"16 1 1                             ! \n"];
WriteString[outputStream,"0.01                                ! tend\n"];WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"<  Boundaries                       >\n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"0 1 0                                ! periodic   b.c. in (x,y,z)     : 1=TRUE, 0=FALSE \n"];
WriteString[outputStream,"0 0 0                                ! active b.c. at (xmin,ymin,zmin): 1=TRUE, 0=FALSE \n"];
WriteString[outputStream,"0 0 0                                ! active b.c. at (xmax,ymax,zmax): 1=TRUE, 0=FALSE \n"];
WriteString[outputStream,"0                                    ! wall geometry (0)=none,(1)=full forward facing step,(2)=classic half forward facing step...,(3)=DMR\n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"<  Discretization                   >\n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"0.9                                  ! CFL (Not yet divided by nDim)\n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"<  Output                           >\n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"OUTPUTNAME                           ! Base filename \n"];
WriteString[outputStream,"6                                    ! Type of output (1=ASCII, 2=Discont. ASCII, 3=Discont. BINARY, 4=Joint MPI Binary)\n"];
WriteString[outputStream,"2                                    ! Criterion for index of printed info: 1=iter,2=time,3=timesteps+time\n"];
WriteString[outputStream,"5                                    ! index of printed info in timesteps\n"];
WriteString[outputStream,"0.1                                  ! index of printed info in time\n"];
WriteString[outputStream,"0.1                                  ! pickdt\n"];
WriteString[outputStream,"NO                                   ! SaveRestart? Set 'YES' or 'NO'\n"];
WriteString[outputStream,"0                                    ! No. of pickpoints\n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"<  Analysis of results              >\n"];
WriteString[outputStream,"<----------------------------------->\n"];
WriteString[outputStream,"0                                    ! Write Reference solution\n"];
WriteString[outputStream,"0                                    ! RunTime Analyse data (0=off, 1=on)\n"];
WriteString[outputStream,"6                                    ! Analyse data (0=off, 1=on)\n\n\n\n\n"];
Close[outputStream];)
