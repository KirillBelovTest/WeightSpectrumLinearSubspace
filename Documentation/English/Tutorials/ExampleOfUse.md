# Example of use

### Initialization
After installation you can execute the following code:
```mathematica
Needs["WeightSpectrumLinearSubspace`"]; 
```
If the package does not installed then need to execute following for this document:
```mathematica
Get[FileNameJoin[{
	ParentDirectory[ParentDirectory[ParentDirectory[NotebookDirectory[]]]],
	"Source", "WeightSpectrumLinearSubspace.m"
}]];
```
---

### Using

Now you can try to calculate the weight spectrum:

```mathematica
simplevectors = {{0}, {1}};
WeightSpectrumLinearSubspace[simplevectors]

(* Out[..] = {2, 2} *)
```

And for the other data:

```mathematica
list20dim32 = RandomInteger[{0, 1}, {20, 32}];
list20dim32 // Dimensions
weightoflist20dim32 = WeightSpectrumLinearSubspace[list20dim32]

(*
	Out[..] = {20, 32}
	Out[..] = {1, 0, 0, 1, 7, 48, 217, 822, 2541, 6889, 15845, 31345, 55097,
		85069, 115010, 137868, 146635, 138274, 115522, 84715, 54761, 31554,
		15845, 6830, 2583, 821, 217, 51, 7, 1, 0, 0, 0}
*)
```


Now construct a graph of the calculated distributions

```mathematica
ListPlot[weightoflist20dim32, PlotTheme->"Web"]
```

![](./Images/SpectrumList20Dim32.png)

---

### Options

**CompilationTarget:** you can use CCompiler for speed-up of the calculation.
Time difference computing is such:

```mathematica
timitesttarget = RandomInteger[{0, 1}, {24, 32}];

AbsoluteTiming[WeightSpectrumLinearSubspace[timitesttarget];]
AbsoluteTiming[WeightSpectrumLinearSubspace[timitesttarget,
	  CompilationTarget -> "C"];]

(*
	Out[..] = {6.11827, Null}
	Out[..] = {3.14008, Null}
*)
```

**Listable:** by default the function does not work with list of arguments.
You can use it:

```mathematica
listabletest1 = RandomInteger[{0, 1}, {20, 64}];
listabletest2 = RandomInteger[{0, 1}, {20, 64}];

listableresult1 =
	AbsoluteTiming[WeightSpectrumLinearSubspace[listabletest1]];

listableresult2 =
	AbsoluteTiming[WeightSpectrumLinearSubspace[listabletest2]];

listableresultAll =
	AbsoluteTiming[WeightSpectrumLinearSubspace[{listabletest1, listabletest2},
		Listable -> True]];

listableresult1[[1]] + listableresult2[[1]]
listableresultAll[[1]]

(*
	Out[..] = 0.964372
	Out[..] = 0.489801
*)
```

**Parallelization:** this option can distribute computation between cores:

```mathematica
paralleltest = RandomInteger[{0, 1}, {24, 128}];
If[Kernels[] == {}, LaunchKernels[]];

AbsoluteTiming[WeightSpectrumLinearSubspace[paralleltest];]
AbsoluteTiming[WeightSpectrumLinearSubspace[paralleltest,
	Parallelization -> True];]

(*
	Out[..] = {10.3901, Null}
	Out[..] = {3.43338, Null}
*)
```

---
