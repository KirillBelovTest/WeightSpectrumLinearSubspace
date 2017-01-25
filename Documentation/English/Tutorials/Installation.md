## How to install the project
### Manual installation
* Download project on your computer as zip-archive or clone repository
* Open `$UserBaseDirectory`
* Open file `FileNameJoin[{$UserBaseDirectory, "Kernel", "Init.m"}]`
* Put to the file following: `Get[<download path>\Source\Kernel\Init.m]`.
* Restart Mathematica kernel.
* Execute following code: ```<<WeightSpectrumLinearSubspace` ``` 

### Auto-installation
* Download project on your computer as zip-archive or clone repository
* Open terminal in the project folder (with PacletInfo.m and Installer.m)
* Run following command: ```MathematicaScript -script Installer.m -install```
* Open Mathematica and execute this: ```<<WeightSpectrumLinearSubspace` ```
