#Arrays created to avoid searching active directory
$lab205 = @("205-00","205-01","205-02","205-03","205-04","205-05","205-06","205-07","205-08","205-09","205-10","205-11","205-12","205-13","205-14","205-15")
$lab207 = @("207-00","207-01","207-02","207-03","207-04","207-05","207-06","207-07","207-08","207-09","207-10","207-11","207-12","207-13","207-14","207-15","207-16","207-17","207-18","207-19","207-20","207-21","207-22","207-23")

#Path below is where logs are stored on each machine
$logDir = "\C$\ProgramData\ETS\IBT\wks"

#Logs are stored in same Directory as script
$rootFolder =  "\\islabs.edu\dfs\ETS\$((Get-Date).ToString('yyyy-MM-dd'))"


Function safePath{
    Process{
        #below tests to see if current date folder already exists. or it will create new one.
        $rootExists = Test-Path -Path $rootFolder

        if($rootExists -eq $false)
        {
            $null = New-Item -ItemType Directory -Path $rootFolder
        }        
    }
}

Function getLabMachine{
    Process{
        #User may enter lab205 || lab 207 to target all  machines in each lab.
        #user also has option of entering name of single machine.
        #Single machine name entered will be verified within arrays above to ensure a correct name was entered.
        Write-Host ""
        $target = Read-Host -Prompt 'What Computer? You may Enter: lab205, lab207, or 20X-XX'

        if($target -eq "lab205")
        {
            foreach($station IN $lab205)
            {
                Write-Host ""
                Write-Host $station

                $fileLoc = "\\" + $station + $logDir
                $logExists = Test-Path -Path $fileLoc
                
                #below excapes iteration if directory doesnt exist for A- No machine connection B-No Log
                if($logExists -eq $false)
                {
                    Write-Host "Computer may be off, or no log file is present." -foreground Red
                    continue
                }

                Set-Location $fileLoc
                $logsArray = [System.Collections.ArrayList]@()
                foreach($item IN Get-ChildItem)
                {
                    if($item.Name.EndsWith('.log'))
                    {
                        $null = $logsArray.Add($item)
                    }    
                }

                #below excapes iteration if there is no Logs present in directory
                if($logsArray.Count -eq 0)
                {
                    Write-Host "No log files present." -foreground Red
                    continue
                }

                #subdirectory for specific machine is only created if there is a log file to extract
                $destination = $rootFolder + "\" + $station + "_" + $((Get-Date).ToString('HH.mm.ss')) 
                $null = New-Item -ItemType Directory -Path $destination

                foreach($log IN $logsArray)
                {
                    Write-Host $log -foreground Green
                    Copy-Item -Path $log -Destination $destination
                }
            }
        }
        elseif($target -eq "lab207")
        {
            foreach($station IN $lab207)
            {
                Write-Host ""
                Write-Host $station

                $fileLoc = "\\" + $station + $logDir
                $logExists = Test-Path -Path $fileLoc
                
                #below excapes iteration if directory doesnt exist for A- No machine connection B-No Log
                if($logExists -eq $false)
                {
                    Write-Host "Computer may be off, or no log file is present." -foreground Red
                    continue
                }

                Set-Location $fileLoc
                $logsArray = [System.Collections.ArrayList]@()
                foreach($item IN Get-ChildItem)
                {
                    if($item.Name.EndsWith('.log'))
                    {
                        $null = $logsArray.Add($item)
                    }    
                }

                #below excapes iteration if there is no Logs present in directory
                if($logsArray.Count -eq 0)
                {
                    Write-Host "No log files present." -foreground Red
                    continue
                }

                $destination = $rootFolder + "\" + $station + "_" + $((Get-Date).ToString('HH.mm.ss')) 
                $null = New-Item -ItemType Directory -Path $destination

                foreach($log IN $logsArray)
                {
                    Write-Host $log -foreground Green
                    Copy-Item -Path $log -Destination $destination
                }
            }
        }
        else
        {
            if(($lab205 -contains $target) -or ($lab207 -contains $target))
            {
                Write-Host ""
                Write-Host $target

                $fileLoc = "\\" + $target + $logDir
                $logExists = Test-Path -Path $fileLoc

                if($logExists -eq $false)
                {
                    Write-Host "Computer may be off, or no log file is present." -foreground Red
                    reRunPrompt
                }

                Set-Location $fileLoc
                $logsArray = [System.Collections.ArrayList]@()
                foreach($item IN Get-ChildItem)
                {
                    if($item.Name.EndsWith('.log'))
                    {
                        $null = $logsArray.Add($item)
                    }    
                }

                if($logsArray.Count -eq 0)
                {
                    Write-Host "No log files present." -foreground Red
                    reRunPrompt
                }

                $destination = $rootFolder + "\" + $target + "_" + $((Get-Date).ToString('HH.mm.ss')) 
                $null = New-Item -ItemType Directory -Path $destination

                foreach($log IN $logsArray)
                {
                    Write-Host $log -foreground Green
                    Copy-Item -Path $log -Destination $destination
                }
            }
            else
            {
                Write-Host "Lab/Machine name is invalid. Please check spelling."
                getLabMachine
            }
        }
    }
}
    
Function reRunPrompt{
    Process{
        Write-Host ""
        $repeatLog = Read-Host -Prompt 'Do you wish to grab log(s) again? (yes/no)'
        if($repeatLog -eq "yes")
        {
            getETSLogs
        }
        elseif($repeatLog -eq "no")
        {
            Write-Host "No mas"
        }
        else
        {
            Write-Host ""
            Write-Host "yes || no"
            reRunPrompt
        }
    }
}

Function getETSLogs{
    Process{
        
        #function below creates a new dirctory with DATE, IF dir does not already exist
        safePath

        #function below will prompt user for lab || machine name
        getLabMachine
        
        #function below will confirm if you wish to run logs again
        reRunPrompt

    }#process closing bracket
}#function closing bracket

getETSLogs
