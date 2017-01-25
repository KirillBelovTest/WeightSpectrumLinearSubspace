(* ::Package:: *)

Needs[
	"WeightSpectrumLinearSubspace`CompileGrayCode`", 
	FileNameJoin[
		{
			DirectoryName[$InputFileName], 
			"CompileGrayCode.m"
		}
	]	
]; 

Needs[
	"WeightSpectrumLinearSubspace`FragmentsList`", 
	FileNameJoin[
		{
			DirectoryName[$InputFileName], 
			"FragmentsList.m"
		}
	]	
]; 

BeginPackage["WeightSpectrumLinearSubspace`ParallelCalculation`", 
	{"WeightSpectrumLinearSubspace`CompileGrayCode`", 
	"WeightSpectrumLinearSubspace`FragmentsList`"}]; 

(*description*)
WeightSpectrumLinearSubspaceParallelCalculation::usage = 
	"WeightSpectrumLinearSubspaceParallelCalculation[basevectors, target, listable] >> " <> 
		"{1, 0, ..., <i-th weights of range {istart, iend}>, ... } \n" <> 
	"compiled function for calculating the weight spectrum for a partial set of linear combinations of " <> 
		"the basis vectors for the specified range with usinig multithreading "; 

Begin["`Private`"]; 

(*clear the function*)
ClearAttributes[WeightSpectrumLinearSubspaceParallelCalculation, 
	Attributes[WeightSpectrumLinearSubspaceParallelCalculation]]; 
Clear[WeightSpectrumLinearSubspaceParallelCalculation]; 

(*messages for exceptions*)
WeightSpectrumLinearSubspaceParallelCalculation::illegalfuncgenerate = 
	"\n\tgeneration called with incorrect options \n" <> 
	"\ttarget must be \"C\" or \"MVM\" \n" <> 
	"\tlistable is a boolean value \n" <> 
	"\tkernels must be a list of kernels or a integer value "; 

WeightSpectrumLinearSubspaceParallelCalculation::illegalarg = 
	"\n\tfunction was called with a incorrect arguments " <> 
	"\n\t{vector1, vector2, ...} - is a two-dimensional list " <> 
	"\n\t{istart, iend} - is a integer values that is greater than one "; 

(*make options of the function*)
Options[WeightSpectrumLinearSubspaceParallelCalculation] = 
	{
		"CompilationTarget" -> "MVM", 
		"Listable" -> False
	}; 

(*main definition*)
WeightSpectrumLinearSubspaceParallelCalculation[basevectors_List, target_String, False] /; 
	If[(target == "MVM" || target == "C") && Depth[basevectors] == 3, 
		True, 
		(*Else*) 
		Message[WeightSpectrumLinearSubspaceParallelCalculation::illegalfuncgenerate]; False 
	] := 
	(
		(* my favorite function *) 
		If[Kernels[] == {}, LaunchKernels[]]; 
		Block[{fragments = WeightSpectrumLinearSubspaceFragmentsList[Length[basevectors], $KernelCount]}, 
			SetSharedVariable[target, basevectors, fragments]; 
			Total @ (
				WaitAll @ 
				Table[ParallelEvaluate[ParallelSubmit[
					{ikernel, fragments}, 
					WeightSpectrumLinearSubspaceCompileGrayCode[target, False][
						basevectors, fragments[[ikernel]]
					]], 
					Kernels[][[ikernel]]], 
					{ikernel, 1, $KernelCount}
				]
			)
		]
	);   

WeightSpectrumLinearSubspaceParallelCalculation[basevectors_List, target_String, True] /; 
	Depth[basevectors] > 3 := 
	Map[WeightSpectrumLinearSubspaceParallelCalculation[#, target, False]&, basevectors, {-3}]; 

WeightSpectrumLinearSubspaceParallelCalculation[basevectors_List, target_String, True] /; 
	Depth[basevectors] == 3 := 
	WeightSpectrumLinearSubspaceParallelCalculation[basevectors, target, False]; 

(*additional definition - option overload*)
WeightSpectrumLinearSubspaceParallelCalculation[basevectors_List, OptionsPattern[]] := 
WeightSpectrumLinearSubspaceParallelCalculation[
	basevectors, 
	OptionValue["CompilationTarget"], 
	OptionValue["Listable"]
]; 

(*from change protection*) 
Attributes[WeightSpectrumLinearSubspaceParallelCalculation] = 
	{
		ReadProtected, 
		Protected
	}; 

End[]; (*`Private`*) 

EndPackage[]; (*WeightSpectrumLinearSubspace`ParallelCalculation`*) 
