(* ::Package:: *)

(* Mathematica Package *) 

(* :Title: GrayCode *) 
(* :Context: WeightSpectrumLinearSubspace`GrayCode` *) 
(* :Authors: Kirill Belov *) 

(* :Package Version: 0.0.3 *) 
(* :Keywords: Gray Code; Call Compiled Function; Fragments of Gray Code *) 

(*get package with fast compiled function with Gray code*)
Needs[
	"WeightSpectrumLinearSubspace`CompileGrayCode`", 
	FileNameJoin[{
		DirectoryName[$InputFileName], 
		"CompileGrayCode.m"
	}]
]; 

BeginPackage["WeightSpectrumLinearSubspace`GrayCode`", 
	{"WeightSpectrumLinearSubspace`CompileGrayCode`"}]; 

WeightSpectrumLinearSubspaceGrayCode::usage = 
"WeightSpectrumLinearSubspaceGrayCode[basevectors] >> " <> 
"return weight specrum for full Gray Sequence; \n" <> 
"WeightSpectrumLinearSubspaceGrayCode[basevectors, options -> ...]; "; 

Begin["`Private`"]; 

WeightSpectrumLinearSubspaceGrayCode::illegalopt = 
"Function called with incorrect options"; 

(*clear definition*) 
ClearAttributes[WeightSpectrumLinearSubspaceGrayCode, {Protected}]; 
Clear[WeightSpectrumLinearSubspaceGrayCode]; 

(*make options of the function*)
Options[WeightSpectrumLinearSubspaceGrayCode] = 
	{
		"Range" -> Full, 
		"CompilationTarget" -> "MVM", 
		"Listable" -> False
	}; 

(*main definition*)
WeightSpectrumLinearSubspaceGrayCode[
	basevectors_List, range_List, target_String, listable_Symbol] := 
WeightSpectrumLinearSubspaceCompileGrayCode[target, listable][basevectors, range]; 

WeightSpectrumLinearSubspaceGrayCode[basevectors_List, Full, target_String, False] := 
WeightSpectrumLinearSubspaceGrayCode[basevectors, {0, 2^Length[basevectors] - 1}, target, False]; 

WeightSpectrumLinearSubspaceGrayCode[basevectors_List, range_List, target_String, True] /; 
(Depth[basevectors] == Depth[range]) && Depth[range] > 2 := 
WeightSpectrumLinearSubspaceGrayCode[basevectors, range, target, True]; 

WeightSpectrumLinearSubspaceGrayCode[basevectors_List, range_List, target_String, True] /; 
Depth[basevectors] == Depth[range] && Depth[range] == 2 := 
WeightSpectrumLinearSubspaceGrayCode[basevectors, range, target, False]; 

WeightSpectrumLinearSubspaceGrayCode[basevectors_List, Full, target_String, True] /; 
Depth[basevectors] > 3 := 
WeightSpectrumLinearSubspaceGrayCode[basevectors, Map[{0, 2^Length[#] - 1}&, basevectors, {-3}], target, True]; 

WeightSpectrumLinearSubspaceGrayCode[basevectors_List, OptionsPattern[]] := 
WeightSpectrumLinearSubspaceGrayCode[
	basevectors, 
	OptionValue["Range"], 
	OptionValue["CompilationTarget"], 
	OptionValue["Listable"]
]; 

End[]; (*`Private`*) 

(*From change protection*)
Attributes[WeightSpectrumLinearSubspaceGrayCode] = 
{
	ReadProtected, 
	Protected
}; 

EndPackage[]; (*WeightSpectrumLinearSubspace`GrayCode`*) 
