(* ::Package:: *)

(* ::Input::Initialization:: *)
Module[{VecVecDotProd,MatVecDotProd,MatMatDotprod1,MatMatDotprod2,MatMatDDprod,u,j,mat,mat2},
VecVecDotProd[d_]={Subscript[u_, j_] Subscript[v_, j_]:>\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(iSum = 1\), \(d\)]\(u[iSum]\ v[iSum]\)\),Subscript[u_, j_] Subscript[u_, j_]:>\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(iSum = 1\), \(d\)]\(u[iSum]\ u[iSum]\)\)};
MatVecDotProd[d_]={Subscript[mat_, ind1_,ind2_] Subscript[vec_, k_]:>\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(iSum = 1\), \(d\)]\(mat[i, iSum]\ vec[iSum]\)\),Subscript[mat_, k_,i_] Subscript[u_, k_]:>\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(iSum = 1\), \(d\)]\(mat[iSum, i]\ u[iSum]\)\)};
MatMatDotprod1[d_]={Subscript[mat_, i_,k_] Subscript[mat2_, k_,j_]/;(!TrueQ[i==j]):>\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(iSum = 1\), \(d\)]\(mat[i, iSum]\ mat2[iSum, j]\)\),Subscript[mat_, i_,k_] Subscript[mat2_, j_,k_]/;(!TrueQ[i==j]):>\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(iSum = 1\), \(d\)]\(mat[i, iSum]\ mat2[j, iSum]\)\),Subscript[mat_, k_,i_] Subscript[mat2_, k_,j_]/;(!TrueQ[i==j]):>\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(iSum = 1\), \(d\)]\(mat[iSum, i]\ mat2[iSum, j]\)\)};
MatMatDotprod2[d_]={Subscript[mat_, k_,i_] Subscript[mat2_, k_,j_]/;(i!=j):>\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(iSum = 1\), \(d\)]\(mat[iSum, i]\ mat2[iSum, j]\)\),Subscript[mat_, k_,i_] Subscript[mat2_, j_,k_]/;(!TrueQ[k==j]&&!TrueQ[k==i]&&!TrueQ[i==j]):>\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(iSum = 1\), \(d\)]\(mat[iSum, i]\ mat2[iSum, j]\)\)};
MatMatDDprod[d_]={Subscript[mat_, k_,i_] Subscript[mat2_, k_,i_]:>Sum[mat[iSum,jSum] mat2[iSum,jSum],{iSum,1,d},{jSum,1,d}],Subscript[mat_, k_,i_] Subscript[mat2_, i_,k_]:>Sum[mat[iSum,jSum] mat2[jSum,iSum],{iSum,1,d},{jSum,1,d}],Subscript[mat_, k_,i_] Subscript[mat_, k_,i_]:>Sum[mat[iSum,jSum] mat[iSum,jSum],{iSum,1,d},{jSum,1,d}],Subscript[mat_, k_,i_] Subscript[mat_, i_,k_]:>Sum[mat[iSum,jSum] mat[jSum,iSum],{iSum,1,d},{jSum,1,d}]};

Einstein[d_]=Union[MatVecDotProd[d],MatMatDotprod1[d],MatMatDotprod2[d],MatMatDDprod[d],VecVecDotProd[d]];
              ]   
                    
                    
