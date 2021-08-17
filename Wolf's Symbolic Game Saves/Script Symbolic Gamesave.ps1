<#
Note: This script runs as admin to create links. You need to allow PowerShell to run scripts if it isn't working.
Path to games needs to be added to GameList.txt in same location.
save_container needs to be edited manually inside of the script to path you are using.
#> 
$scriptBlock = {
[System.Collections.ArrayList]$game_pairs = @()

<#Set a folder where your GameList.txt exists.
Example: Z:\Game Saves\
#>
Set-Variable -Name save_container -Value ''

<#Example for GameList.txt structure:
[Game name];[Path to the folder you want to make a link.]
#>
Set-Location $save_container
$game_list = Get-Content -Path '.\GameList.txt' 
foreach($g in $game_list){
$conv = ConvertFrom-String -Delimiter ';' -PropertyNames Name,Target $g 
<#
Replaces user and path to environment variables, allowing for easier move between PCs.
Only Documents or AppData is suported for this replacement.
#>
$replaceUser = $conv.'Target' -Replace '([A-Z]):\\(Users)\\([a-zA-Z_0-9]+)\\(Documents|Appdata)\\([a-zA-Z_0-9]+)', ('$1:\$2\'+[regex]::escape($env:UserName)+'\$4\$5') 
$conv.'Target' = $replaceUser
Write-Host 'User:' $conv.'Target'
<#
if($conv.'Target' -Match '[A-Z]:\Users\'){
 
}
#>
if(Test-Path -Path ($conv.'Target')){
Write-Host 'Target Path Exists:' $conv.'Target'
$game_pairs.Add($conv) | Out-Null
}
else{
Write-Host 'Target Path Doesn''t Exist:' $conv.'Target'
}
}
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