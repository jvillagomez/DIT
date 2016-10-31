#Arrays created to avoid searching active directory
$lab205_7 = @("205-00","205-01","205-02","205-03","205-04","205-05","205-06","205-07","205-08","205-09","205-10","205-11","205-12","205-13","205-14","205-15","207-00","207-01","207-02","207-03","207-04","207-05","207-06","207-07","207-08","207-09","207-10","207-11","207-12","207-13","207-14","207-15","207-16","207-17","207-18","207-19","207-20","207-21","207-22","207-23")

#Path below is where logs are stored on each machine
$logDir = "\C$\ProgramData\ETS\IBT\wks\"
$logPath = "\C$\ProgramData\ETS\IBT\wks\testingLog.log"

#replace string below with correct IT_SHARE folder. Replace(c:\logs_testing)
$rootFolder =  "\\islabs.edu\dfs\ETS\logs\$((Get-Date).ToString('yyyy-MM-dd'))"

Function createDummyLogs{
    Process{
            foreach($station IN $lab205_7)
            {
                Write-Host $station
                $testingLog = "\\" + $station + $logPath
                $stationPath = "\\" + $station + "\C$"
                $machineOn = Test-Path -Path $stationPath
                if($machineOn -eq $false)
                {
                    Write-host "Cannot connect to machine" -ForegroundColor Red
                    Write-Host ""
                    continue
                }
                
                $null = New-Item -ItemType File -Path $testingLog -value $station -Force 
                Write-Host $testingLog -ForegroundColor Green
                Write-Host ""
        }
    }
}
    
createDummyLogs