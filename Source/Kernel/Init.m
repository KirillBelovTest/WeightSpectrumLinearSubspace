(* ::Package:: *)

(* :Title: Initialization File *) 

$Path = DeleteDuplicates[Append[$Path, DirectoryName[DirectoryName[$InputFileName]]]]; 
If[
	!NameQ["WeightSpectrumLinearSubspace`WeightSpectrumLinearSubspace"] || 
	!TrueQ[ContainsAll[Attributes["WeightSpectrumLinearSubspace.md"], {Stub}]], 
DeclarePackage["WeightSpectrumLinearSubspace`", "WeightSpectrumLinearSubspace"]]; 
