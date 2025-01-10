(* ::Package:: *)

(* ::Input::Initialization:: *)
MyTeXForm1[expr_]:=StringReplace[ToString[TeXForm[expr]],{Shortest["\\text{"~~word___~~"}"]->word}]
MyTeXForm2[expr_]:=StringReplace[MyTeXForm1[expr],x:LetterCharacter~~n:DigitCharacter->x~~"_"~~n]
MyTeXForm[expr_]:=StringReplace[MyTeXForm2[expr],"$"->""]
ExportLatex[filename_]:=(
strm=OpenWrite[filename];
WriteString[strm," System of equations \\eqref{eq:...} can be cast into the quasilinear form
	    \\begin{equation}
		\\mathbf{V}_t + \\mathbf{B}( \\mathbf{V}) \\mathbf{V}_x = \\mathbf{S} ( \\mathbf{V})
		\\label{eq:quasilin}
	    \\end{equation}
where $\\mathbf{V}$ is the vector of primitive variables and $A$ is the quasilinear matrix given by \n \\begin{equation}\n"<>"A = "<>MyTeXForm[Aeval]<>"\n"<>"\\end{equation}\n"];
WriteString[strm,"Straightforward linear algebra shows that it admits "<>ToString[Ncl]<>" eigenvalues whose expressions are given hereafter \n \\begin{align}\n"];
j=1;
For[i=1,i<=nEigval,i++,
eig=GroupedEigvals[[i]][[1]];
mul=GroupedEigvals[[i]][[2]];
sub =If[mul>1,ToString[j]<> "-" <> ToString[j-1+mul],ToString[j]] ;
todisplay=If[StringContainsQ[ToString[eig,StandardForm],"Root"],"No explicit expression",ToString[eig]];
WriteString[strm,"&"<>ToString[MyTeXForm[Subscript["\[Xi]",sub]]]<>" = "<>MyTeXForm[eig]<>"\\\\ \n"," "];
 j=j+mul];
WriteString[strm,"\\end{align}"];
Close[strm];)
