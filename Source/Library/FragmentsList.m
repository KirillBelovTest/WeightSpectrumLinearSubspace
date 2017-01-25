(* ::Package:: *)

(* :Mathematica Package: *) 

(* :Title:    FragmentsList *) 
(* :Context:  WeightSpectrumLinearSubspace`FragmentsList` *) 
(* :Authors:  Kirill Belov *) 

(* :Version:  0.0.3 *) 
(* :Keywords: Linear Code; Gray Code; *) 

BeginPackage["WeightSpectrumLinearSubspace`FragmentsList`"]; 

WeightSpectrumLinearSubspaceFragmentsList::usage = 
	"WeightSpectrumLinearSubspaceFragmentsList[vectorscount, kernelscount] >> " <> 
	"{{startnum1, endnum1}, {startnum2, ...}, ...}; "; 

Begin["`Private`"]; 

(* names cleaning *) 
ClearAttributes[WeightSpectrumLinearSubspaceFragmentsList, {Protected, ReadProtected}]; 
Clear[WeightSpectrumLinearSubspaceFragmentsList]; 

(* return table of ranges for the full Gray Code *) 
WeightSpectrumLinearSubspaceFragmentsList[vectorscount_Integer, kernelscount_Integer] /; 
	vectorscount > 0 && kernelscount > 0 := 

	Table[ 
		{
			ielem Floor[2^vectorscount / kernelscount], 
			If[ielem == kernelscount, 2^kernelscount - 1, (ielem + 1) Floor[(2^vectorscount) / kernelscount] - 1] 
		}, 
		{ielem, 0, kernelscount - 1} 
	]; 

(* from change protection *) 
Attributes[WeightSpectrumLinearSubspaceFragmentsList] = {ReadProtected, Protected}; 

End[]; (*`Private`*) 

EndPackage[]; (*WeightSpectrumLinearSubspace`FragmentsList`*) 
