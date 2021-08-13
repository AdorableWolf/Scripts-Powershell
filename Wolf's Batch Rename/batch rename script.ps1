#Known issue: Don't work with names that contain "+" sign
#Fixed issue: "+" sign is replaced with " "
[string]$insertPath = ""
[string]$outputPath = ""
[bool]$addTitle = 0; <# 0:no 1:yes #>
[string]$ext = "";
[int]$year = 0000;
[System.Collections.ArrayList]$episodes = @();
[System.Collections.ArrayList]$removeDots = @();
[System.Collections.ArrayList]$newName = @();
Write-Host "Insert Path of the Series Episodes."
$insertPath = Read-Host
Write-Host "Insert Extension of the Series. (.mkv/.avi/.mpg)"
$ext = Read-Host
#Write-Host "Add year (YYYY)"
#$year = Read-Host
<#Write-Host "Do you want to include title? (0:no/1:yes"
$addTitle = Read-Host#>

$episodes = Get-ChildItem -Path $insertPath\* -Include *$ext -Name
$removeDots = $episodes -Replace '\.' , ' '

for($item = 0; $item -lt $episodes.Count; $item++){
    <#Rename-Item $episodes[$item]  $newName[$item]#>
    
    $removeDots[$item] -Match '(?<title>\S[a-zA-Z 0-9.]+\S).(?<seasonEpisode>S[0-9]+E[0-9]+).(?<episodeTitle>\S[a-zA-Z 0-9.]+\S)?.?(?<quality>1080p|720p).*' | Out-Null
    if(($Matches.episodeTitle).Count -eq 0){
    
    $newName += $removeDots[$item] -Replace $removeDots[$item], ($Matches.title + ' ' + $Matches.seasonEpisode + ' ' + $Matches.quality + $ext) 
    } 
    if(($Matches.episodeTitle).Count -eq 1){
    $newName += $removeDots[$item] -Replace $removeDots[$item], ($Matches.title + ' ' + $Matches.seasonEpisode + ' ' + $Matches.episodeTitle + ' ' + $Matches.quality + $ext) 
    }
    $outputPath = Join-Path $insertPath $episodes[$item]
    #Write-Host $outputPath $newName[$item]
    $item | Rename-Item -Path $outputPath -NewName {$_.FullName -replace '.*', $newName[$item]} -WhatIf

}
$outputPath
