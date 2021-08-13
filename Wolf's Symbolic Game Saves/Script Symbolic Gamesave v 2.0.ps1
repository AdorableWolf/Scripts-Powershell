<#
No tests, won't work at other PC. Tons of errors if location is not existing.
Games needs to be added to txt file GameList.txt. No spaces allowed before location path.
#> 
$scriptBlock = {
[System.Collections.ArrayList]$game_pairs = @()
Set-Variable -Name save_container -Value 'D:\Symbolic Game Saves FFS\'
Set-Location $save_container
$game_list = Get-Content -Path '.\GameList.txt' 
foreach($g in $game_list){
$conv = ConvertFrom-String -Delimiter ';' -PropertyNames Name,Target $g 
$game_pairs.Add($conv)

}
<# Use this to select ONE property and index 0
Write-Host 'Hey! This is following text:'$game_pairs.'Name'[0]


$userinput_a = Read-Host "Enter name of the game."
$userinput_b = Read-Host "Enter savefile location."
 #>
foreach($p in $game_pairs){
cmd /c mklink /D ($save_container + $p.'Name') $p.'Target'
}
}
Start-Process powershell -Verb runAs -ArgumentList "-NoExit", "-Command & {$scriptBlock}"