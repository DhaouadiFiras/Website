(* ::Package:: *)

(* ::Input::Initialization:: *)
(** Define here the steps to monitor through the program **)
step[1]="Initializiation" ;
step[2]="Loading the equations";
step[3]="Building the quasilinear matrix";
step[4]="Computing the eigenvalues";
step[5]="Exporting the results to LaTeX";
(* Define total number of steps to monitor *)
Nmsg=5; 
(*Generic messages adding the words "pending", "in progress" and "complete" to the steps *)
Do[msg0[i]=Style[step[i]<>" pending.",LightGray],{i,1,Nmsg}];Do[msg1[i]=Row[{Style[step[i]<>" in progress.",Gray],ProgressIndicator[Appearance->"Percolate"]}],{i,1,Nmsg}]
Do[msg2[i]=Row[{step[i]<>" complete ", Style[\[Checkmark],Bold]}],{i,1,Nmsg}]

(*Initialize the messages as pending, only for the initialization step message which is set to in "progress"*)
msg[1]=msg1[1];
Do[msg[i]=msg0[i],{i,2,Nmsg}];

iMsg=1;
Print[Dynamic[msg[1]]];
Print[Dynamic[msg[2]]];
Print[Dynamic[msg[3]]];
Print[Dynamic[msg[4]]];
Print[Dynamic[msg[5]]];
(*This function marks the current step as complete and the next step as in progress*)
updateMsg[]:=Module[{},
msg[iMsg]=msg2[iMsg];
msg[iMsg+1]=msg1[iMsg+1];
iMsg=iMsg+1 ]

