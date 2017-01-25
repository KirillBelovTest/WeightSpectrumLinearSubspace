(* ::Package:: *)

(* :Mathematica Package: *) 

(* :Title:    WeightSpectrumLinearSubspace *) 
(* :Context:  WeightSpectrumLinearSubspace` *) 
(* :Authors:  Alexander Bannikov, Kirill Belov *) 

(* :Version:  0.0.3 *) 
(* :Keywords: Linear Subspace; Weight Spectrum; Linear Code; Discrete Math; Gray Code; *) 

Needs[
	"WeightSpectrumLinearSubspace`GrayCode`", 
	FileNameJoin[{
		DirectoryName[$InputFileName], 
		"Library", "GrayCode.m"
	}]
]; 

Needs[
	"WeightSpectrumLinearSubspace`ParallelCalculation`", 
	FileNameJoin[{
		DirectoryName[$InputFileName], 
		"Library", "ParallelCalculation.m"
	}]
]; 

BeginPackage["WeightSpectrumLinearSubspace`" , 
{"WeightSpectrumLinearSubspace`GrayCode`", 
"WeightSpectrumLinearSubspace`ParallelCalculation`"}];

(* creating descriptions *)
WeightSpectrumLinearSubspace::usage =
	"Usage: \n\t" <>
	"WeightSpectrumLinearSubspace[{vector1, vector2, ...}] >> " <>
		"{1, 0, ..., <i-th weights>, ... } \n\t" <>
	"WeightSpectrumLinearSubspace[{vector1, vector2, ...}, " <>
		"CompilationTarget, Listable, Parallelization] >> ... \n\t" <>
	"WeightSpectrumLinearSubspace[{vector1, vector2, ...}, " <>
		"Option -> ..., ] >> ... \n\n" <> 

	"Possible additional arguments: \n\t" <> 
	"CompilationTarget must be \"C\" or \"MVM\" \n\t" <> 
	"Listable is a boolean value \n\t" <> 
	"Parallelization is a boolean value \n\n" <> 

	"Possible options and their default values: \n\t" <> 
	"\"CompilationTarget\" -> \"MVM\" \n\t" <> 
	"\"Listable\" -> False \n\t" <> 
	"\"Parallelization\" -> False \n\n"; 

Begin["`Private`"]; 

(* names cleaning *) 
ClearAttributes[WeightSpectrumLinearSubspace, Attributes[WeightSpectrumLinearSubspace]]; 
Clear[WeightSpectrumLinearSubspace]; 

WeightSpectrumLinearSubspace::illegalarg = 
	"\n\t" <> "basevectors should be a two dimensions tensor; "; 

(* illegal optoins - the message appears when you misuse the basic function options *) 
WeightSpectrumLinearSubspace::illegalopt = 
	"\n\t" <> "function was called with incorrect options; " <> 
	"\n\t" <> "CompilationTarget must be \"C\" or \"MVM\"; " <> 
	"\n\t" <> "Listable is a boolean value; " <> 
	"\n\t" <> "Parallelization is a boolean value; "; 

Options[WeightSpectrumLinearSubspace] = 
	{
		"CompilationTarget" -> "MVM", 
		"Listable" -> False, 
		"Parallelization" -> False 
	}; 

(* the first definition - options of the calculation used as an arguments for the function *)
WeightSpectrumLinearSubspace[vectors_List, target_String : "MVM", 
	listable_Symbol : False, parallel_Symbol : False] /; 
	If[MatchQ[Dimensions[vectors], {__Integer}], 
		True, 
		Message[WeightSpectrumLinearSubspace::illegalarg]; False
	] && 
	If[(target == "C" || target == "MVM") && 
		And @@ (BooleanQ /@ {listable, parallel}), 
		True, 
		(*Else*) 
		Message[WeightSpectrumLinearSubspace::illegalopt]; False
	] := 

	If[parallel,
		WeightSpectrumLinearSubspaceParallelCalculation[vectors, 
		"CompilationTarget" -> target, "Listable" -> listable], 
		(*Else*)
		WeightSpectrumLinearSubspaceGrayCode[vectors, 
		"CompilationTarget" -> target, "Listable" -> listable] 
	]; 

(* the additional definition -  overload for the possibility of using the options as is *) 
WeightSpectrumLinearSubspace[vectors_List, OptionsPattern[]] := 
WeightSpectrumLinearSubspace[vectors, 
	OptionValue["CompilationTarget"], 
	OptionValue["Listable"], 
	OptionValue["Parallelization"]
]; 

(* from change protection *) 
Attributes[WeightSpectrumLinearSubspace] = {ReadProtected, Protected}; 

End[]; (*`Private`*) 

EndPackage[]; (*WeightSpectrumLinearSubspace`*) 
