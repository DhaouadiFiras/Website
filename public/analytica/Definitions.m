(* ::Package:: *)

(* ::Input::Initialization:: *)
Parameters={};
AuxVars={};
SetAttributes[DefineAux,HoldAll]
SetAttributes[DefinePar,HoldAll]
DefineAux[a_,b_]:=(AppendTo[AuxVars,{HoldForm[a],HoldForm[b]}]; a=b ; )
DefinePar[a_,b_]:=(AppendTo[Parameters,{HoldForm[a],HoldForm[b]}]; a=b ; )

(*Definitions of the Identity matrix in index notation and with Subscript[Id, n] shortcut*)
\[Delta][m_,n_]=KroneckerDelta[m,n];
Subscript[\[Delta], m_,n_]=KroneckerDelta[m,n];
LeviCivita=Table[Signature[{i,j,k}],{i,3},{j,3},{k,3}];
Subscript[\[Epsilon], m_,n_,l_]=LeviCivita[[m,n,l]];
Subscript[Id, n_]=IdentityMatrix[n];

