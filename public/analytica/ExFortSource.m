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




replaceParameters[expr_]:=StringReplace[expr,str__/;MemberQ[parListFortran,str]:>"EQN%"<>str]
ExFortSource[filename_,EqnNumber_,ModelName_]:=(
outputStream=OpenAppend[filename];

WriteString[outputStream,"!========================================================================================== \n"];
WriteString[outputStream,"!======================= PDE.f90 Source Terms  ================================== \n"];
WriteString[outputStream,"!========================================================================================== \n\n"];
WriteString[outputStream,StringForm["#ifdef EQNTYPE``        !``\n\n",EqnNumber,ModelName]];


Do[
Srcterms=Esthetic[Src[[i]]]; (*Remove space dependence and subscripts indexed variables*)
Srcterms=Srcterms/.uu_/;MemberQ[Vclean,uu]:>v[Position[Vclean,uu]/.unbracket/.unbracket];(*Replaces primitive variables by their corresponding V[i] *)
Srreplacecterms=Srcterms/.Prim2ConsRules/.q[jjj_]:>q[jjj][x,y,z];(*Applies Prim2Cons to obtain expressions in conservatives*)
Srcterms=Srcterms/.Derivative[a_,b_,c_][expr_]:>D[expr,{x,a},{y,b},{z,c}]; (*Replaced derivatives so that they can be expanded*)
Srcterms=Expand[omitx[Srcterms]]; (*Removes the {x,y,z} from expression and expands all products*)
Srctermsprint=StringReplace[MyFortranForm[Srcterms],"q"->"Q"];
Srctermsprint=replaceParameters[Srctermsprint];

If[TrueQ[Srcterms==0],"",
If[LeafCount[Srcterms]<300,WriteString[outputStream,StringForm["  S(`1`) = `2` \t !`3` \n",i,Srctermsprint,Varname[VV[[i]]]]],WriteString[outputStream,StringForm["  AQx(`1`)=`2`\n",i,"0.0   !Too long. Please check formulas and create auxiliary variables..."]]];
];
,{i,1,Ncl}];
WriteString[outputStream,StringForm["\n#endif\n\n"]];
Close[outputStream];)

