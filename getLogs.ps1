$targetComp = Read-Host -Prompt 'What Computer?'
Write-Host $targetComp

$logDir = "\C$\ProgramData\ETS\IBT2\wks"
$logDirTEST = "\Users"


$targetMachines = net view | select -Skip 1 | ?{$_-match '205-'}


foreach($computer IN $targetMachines)
{
    #write-host $computer.Substring(0,8)
    $station = $computer.Substring(0,8)

    $fileLoc = $station + $logDir

    Set-Location $fileLoc
    Get-ChildItem
}

#\\200-01\c$