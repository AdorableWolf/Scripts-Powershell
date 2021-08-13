<#
No tests, won't work at other PC. Tons of errors if location is not existing.
Games needs to be added in the script itself.
#> 
$scriptBlock = {
Set-Variable -Name save_container -Value 'D:\Symbolic Game Saves FFS\'

[System.Collections.ArrayList]$pairs = @(
[pscustomobject]@{
Name='Minecraft Save MultiMC'
Target='C:\Minecraft\MultiMC'
},
[pscustomobject]@{
Name='7DaysToDie'
Target='C:\Users\AdorableWolf\AppData\Roaming\7DaysToDie'
}
)
<#
$userinput_a = Read-Host "Enter name of the game."
$userinput_b = Read-Host "Enter savefile location."
#> 
foreach($p in $pairs){
cmd /c mklink /D ($save_container + $p.Name) $p.Target
}
}
Start-Process powershell -Verb runAs -ArgumentList "-NoExit", "-Command & {$scriptBlock}"