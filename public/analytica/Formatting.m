(* ::Package:: *)

(* ::Input::Initialization:: *)
DependsOnX= v_/;MemberQ[VariablesList,v]->v[x,y,z];
omitx[expr_]:= expr/.u_[x,y,z]->u
unbracket= {v_}->v;
Indexify1[expr_]:=expr/.u_[k_]/;MemberQ[VariablesList,u[_]]:>Subscript[u, k]
Indexify2[expr_]:=expr/.v_[i_,j_]/;MemberQ[VariablesList,v[_,_]]:>Subscript[v, i,j]
Esthetic[expr_]:=omitx[expr]//Indexify1//Indexify2
Format[bracket[obj_]]:=Style[DisplayForm@RowBox[{"{",obj}],SpanMaxSize->Infinity]
Format[matWithDiv[n_,opts:OptionsPattern[Grid]][m_?MatrixQ]]:=MatrixForm[{{Grid[m,opts,Dividers->{n->{Red},n->{Red}}]}}]
listProduct[x_]:=If[Length[x]>1,Times@@x,x]
