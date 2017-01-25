(* ::Package:: *)

(* :Mathematica Package: *) 

(* :Title:    CompileGrayCode *) 
(* :Context:  WeightSpectrumLinearSubspace`CompileGrayCode` *) 
(* :Authors:  Alexander Bannikov, Kirill Belov *) 

(* :Package Version:  0.0.3 *) 
(* :Keywords: Linear Code; Gray Code; Compiled Function; Weight Spectrum; Linear Subspace *) 

BeginPackage["WeightSpectrumLinearSubspace`CompileGrayCode`"]; 

WeightSpectrumLinearSubspaceCompileGrayCode::usage = 
"WeightSpecrumLinearSubspaceCompileGrayCodeFragment[compileoptions][{vector1, vector2, ...}, {istart, iend}] >> " <> 
"{1, 0, ..., <i-th weights of range {istart, iend}>, ... } " <> 
"\n" <> "compiled function for calculating the weight spectrum for a partial set of " <> 
"linear combinations of the basis vectors for the specified range; "; 

Begin["`Private`"]; 

ClearAttributes[WeightSpectrumLinearSubspaceCompileGrayCode, {ReadProtected, Protected}]; 
Clear[WeightSpectrumLinearSubspaceCompileGrayCode]; 

WeightSpectrumLinearSubspaceCompileGrayCode::illegalcompile = 
"\n\t" <> "compilation called with incorrect options; " <> 
"\n\t" <> "target must be \"C\" or \"MVM\"; " <> 
"\n\t" <> "listable is a boolean value; "; 

WeightSpectrumLinearSubspaceCompileGrayCode[target_String, listable_Symbol] /; 
	If[
		(target == "MVM" || target == "C") && 
		(listable == True || listable == False), 
			True, 
			(*Else*) 
			Message[WeightSpectrumLinearSubspaceCompileGrayCode::illegalcompile]; False 
	] := (
		Unprotect[WeightSpectrumLinearSubspaceCompileGrayCode]; 
		WeightSpectrumLinearSubspaceCompileGrayCode[target, listable] = 

		Compile[{{basevectors, _Integer, 2}, {range, _Integer, 1}}, 

			(*main code*) 
			Module[
				{
					istart = First[range], 
					iend = Last[range] - 1, 
					bitposition = 0, 
					weight = 0, 
					length = Length[basevectors], 
					dimension = Last[Dimensions[basevectors]], 
					vector = If[First[range] != 0, 
						Mod[Total[Reverse[IntegerDigits[BitXor[First[range], 
						Quotient[First[range], 2]], 2, Length[basevectors]]] * basevectors], 2], 
						(*Else*) 
						Table[0, {Last[Dimensions[basevectors]]}] 
					], 
					(*Result*) 
					spectrum = Table[0, {Last[Dimensions[basevectors]] + 1}] 
				}, 

				(**) 
				If[istart == 0, spectrum[[1]] = 1, weight = Total[vector] + 1; 
					spectrum[[weight]] = spectrum[[weight]] + 1]; 

				(*Iterations*) 
				Do[ 
					bitposition = Log2[BitAnd[BitNot[b], b + 1]] + 1; 

					(*Next vector related of the previous*) 
					vector = BitXor[vector, basevectors[[bitposition]]]; 

					(**) 
					weight = Total[vector] + 1; 
					spectrum[[weight]] = spectrum[[weight]] + 1, 

					(*Iterator*) 
					{b, istart, iend} 
				]; 

				(*Return*) 
				spectrum 
			], 

			(*
				compilation options:
				listable == True:   possible using this: WeightSpectrumLinearSubspaceCompileGrayCode[{vs1, vs2, ..}] 
				listable == False:  speedup but WeightSpectrumLinearSubspaceCompileGrayCode[{vs1, vs2, ..}] >> Error 
				target == "MVM":    compile to byte-code 
				target == "C":      compile to C-code 
			*) 
			CompilationTarget -> target, RuntimeOptions -> "Speed", 
			Evaluate @ (ReleaseHold @ (Sequence @@ 
				{
					If[listable, 
						(*RuntimeAttributes -> {Listable}, Parallelization -> True*) 
						Hold[Sequence[RuntimeAttributes -> {Listable}, Parallelization -> True]], 
						(*Else*) 
						(*Parallelization -> False*) 
						Hold[Sequence[Parallelization -> False]] 
					] 
				} 
			)) 
		]; 
		Protect[WeightSpectrumLinearSubspaceCompileGrayCode]; 
		(*MainReturn*) 
		WeightSpectrumLinearSubspaceCompileGrayCode[target, listable] 
	); 

(*setting for using the function in parallel execution*) 
SetSharedFunction[WeightSpectrumLinearSubspaceCompileGrayCode]; 

End[]; (*`Private`*) 

Attributes[WeightSpectrumLinearSubspaceCompileGrayCode] = 
	{
		Protected, 
		ReadProtected
	}; 

EndPackage[]; (*`CompileGrayCode`*) 
