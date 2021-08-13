<#
Some tests won't work at other PC without small tweaks. 
If location is not existing, skip.
Games needs to be added GameList.txt in same location.
save_container needs to be edited manually inside of the script to path you are using.
#> 
$scriptBlock = {
[System.Collections.ArrayList]$game_pairs = @()
Set-Variable -Name save_container -Value 'D:\Symbolic Game Saves FFS\'
Set-Location $save_container
$game_list = Get-Content -Path '.\GameList.txt' 
foreach($g in $game_list){
$conv = ConvertFrom-String -Delimiter ';' -PropertyNames Name,Target $g 

if(Test-Path -Path ($conv.'Target')){
Write-Host 'Target Path Exists:' $conv.'Target'
$game_pairs.Add($conv) | Out-Null
}
else{
Write-Host 'Target Path Doesn''t Exist:' $conv.'Target'
}
}
<# Use this to select ONE property and index 0
Write-Host 'Hey! This is following text:'$game_pairs.'Name'[0]


$userinput_a = Read-Host "Enter name of the game."
$userinput_b = Read-Host "Enter savefile location."
#>
foreach($p in $game_pairs){
if(Test-Path -Path ($save_container + $p.'Name')){
Write-Host 'Symbolic Pair Existing. Ignoring:' ($save_container + $p.'Name')
} 
else{
Write-Host 'Symbolic Pair Not Existing. Adding:' ($save_container + $p.'Name')
cmd /c mklink /D ($save_container + $p.'Name') $p.'Target'
}
}
Write-Host -ForegroundColor Cyan 'Task Completed, Enjoy Your New GameSave Location!'
}
Start-Process powershell -Verb runAs -ArgumentList "-NoExit", "-Command & {$scriptBlock}"