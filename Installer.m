(* ::Package:: *)

(* : Title : Istaller *) 
(* : Version : 0.0.1 *) 
(* : MathematicaVersion : 8+ *)
(* : Author : Kirill Belov *) 

InstallThisProject[] := 
	Module[{initpath, autoloadpath, projectinitpath}, 
		projectinitpath = 
		FileNameJoin[{DirectoryName[$InputFileName], "Source", "Kernel", "Init.m"}]; 
		autoloadpath = FileNameJoin[{
			$UserBaseDirectory, "Autoload", "weightspectrumlinearsubspace", "Kernel"
		}]; 
		If[!FileExistsQ[autoloadpath], CreateDirectory[autoloadpath]]; 

		initpath = FileNameJoin[{autoloadpath, "Init.m"}]; 
		If[FileExistsQ[initpath], DeleteFile[initpath]]; 
		BinaryWrite[initpath, 
			ToCharacterCode["Get[\"" <> projectinitpath <> "\"]; "]
		];
	]; 

(* uninstall package *)
UninstallThisProject[] := 
	Module[{initpath, autoloadpath}, 
		autoloadpath = FileNameJoin[{
			$UserBaseDirectory, "Autoload", "weightspectrumlinearsubspace", "Kernel"
		}]; 
		initpath = FileNameJoin[{autoloadpath, "Init.m"}]; 
		If[FileExistsQ[initpath], 
			DeleteFile[initpath]; 
			DeleteDirectory[DirectoryName[initpath]]; 
			DeleteDirectory[DirectoryName[DirectoryName[initpath]]]]; 
	];

(* command line options handler *)
If[Length[$ScriptCommandLine] <= 2, 
	If[Last[$ScriptCommandLine] == "-install",
			Print[$ScriptCommandLine[[1]] <> 
				": run installing"];
			InstallThisProject[],
	If[Last[$ScriptCommandLine] == "-uninstall",
			Print[$ScriptCommandLine[[1]] <> 
				": run uninstalling"];
			UninstallThisProject[],
			Print[$ScriptCommandLine[[1]] <> 
				": use installer with options: '-install' or '-uninstall'"]
	]],
	Print[$ScriptCommandLine[[1]] <> ": expected only one option"]
]; 

Remove["Global`*"]; 
