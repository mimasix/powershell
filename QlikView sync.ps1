#Dominik Franczyk

$aplikacjedopodmiany = "Path where developers will upload apps to update them on the server"
$slownikowedopodmiany = "Path where developers will upload dictionary files to update them on the server"


$aplikacjenaswrwerze = "\\Apps\on\server\"
$slownikowenaswrwerze = "\\DictionaryFiles\on\server\"
$LogPath = "D:\LOG\path"
$date = ((Get-Date).ToString('yyyy-MM-dd hh-mm'))

######################################################
# Set the name of log files
######################################################
$logName1 = $date + " dictionary_files.log"
$logName2 = $date + " aplication.log"
$sFullPathSlownik = $LogPath + "\" + $LogName1
$sFullPathAplikacja = $LogPath + "\" + $LogName2

# Define Variables needed to define who is the FileOwner, when was the LastWriteTime and on what host was the file created #
$LastWrite = @{                                                                                                            #
    Name = 'Last Write Time'                                                                                               #
    Expression = { $_.LastWriteTime.ToString('u') }                                                                        #
  }                                                                                                                        #
  $Owner = @{                                                                                                              #
    Name = 'File Owner'                                                                                                    #
    Expression = { (Get-Acl $_.FullName).Owner }                                                                           #
  }                                                                                                                        #
  $HostName = @{                                                                                                           #
    Name = 'Host Name'                                                                                                     #
    Expression = { $env:COMPUTERNAME }                                                                                     #
  }                                                                                                                        #
# Define Variables needed to define who is the FileOwner, when was the LastWriteTime and on what host was the file created #


if (Test-Path $slownikowedopodmiany* -include *.xls, *.xlsx, *.csv) 
{
     Write-Host ("I found some DictionaryFiles to sync") -Fore green;
     New-Item -ItemType Directory -Path $slownikowedopodmiany$date #".\$((Get-Date).ToString('yyyy-MM-dd'))";
     Copy-Item -path $slownikowedopodmiany\* -Include *.xls, *.xlsx, *.csv  -Destination $slownikowenaswrwerze;
        Add-Content -Path $sFullPathSlownik -Value "***************************************************************************************************";
        Add-Content -Path $sFullPathSlownik -Value "Start synchronisation process - DICTIONARY FILES WHERE FOUND [$([DateTime]::Now)].";
        Add-Content -Path $sFullPathSlownik -Value "SYNCHRONIZED FILES:";
        Add-Content -Path $sFullPathSlownik -Value "";
        Add-Content -Path $sFullPathSlownik -Value (Get-ChildItem $slownikowedopodmiany\* -include *.xls, *.xlsx, *.csv | Select-Object Name, $LastWrite, $Owner, $HostName);
        Add-Content -Path $sFullPathSlownik -Value "";
        Add-Content -Path $sFullPathSlownik -Value "";
        Add-Content -Path $sFullPathSlownik -Value "End of synchronisation process [$([DateTime]::Now)].";
        Add-Content -Path $sFullPathSlownik -Value "***************************************************************************************************";
                                                                                                                     
     Move-Item -path $slownikowedopodmiany\* -Include *.xls, *.xlsx, *.csv  -Destination $slownikowedopodmiany$date;
}
else 
{
    Write-Host ("No DictionaryFiles were found.")-Fore red;
#Sekcja dotycząca aplikacji
}
if (Test-Path $aplikacjedopodmiany* -include *.qvw) 
{
     Write-Host ("I found some Applications to sync.") -Fore green;
     New-Item -ItemType Directory -Path $aplikacjedopodmiany$date #".\$((Get-Date).ToString('yyyy-MM-dd'))";
     Copy-Item -path $aplikacjedopodmiany\* -Include *.qvw  -Destination $aplikacjenaswrwerze;
        Add-Content -Path $sFullPathAplikacja -Value "***************************************************************************************************";
        Add-Content -Path $sFullPathAplikacja -Value "Start synchronisation process - QlikView apps were found [$([DateTime]::Now)].";
        Add-Content -Path $sFullPathAplikacja -Value "SYNCHRONIZED FILES:";
        Add-Content -Path $sFullPathAplikacja -Value "";
        Add-Content -Path $sFullPathAplikacja -Value (Get-ChildItem $aplikacjedopodmiany\* -include *.qvw | Select-Object Name, $LastWrite, $Owner, $HostName);
        Add-Content -Path $sFullPathAplikacja -Value "";
        Add-Content -Path $sFullPathAplikacja -Value "";
        Add-Content -Path $sFullPathAplikacja -Value "End of synchronisation process [$([DateTime]::Now)].";
        Add-Content -Path $sFullPathAplikacja -Value "***************************************************************************************************";
                                                                                                                     
     Move-Item -path $aplikacjedopodmiany\* -Include *.qvw -Destination $aplikacjedopodmiany$date;
}
else 
{
    Write-Host ("No ApplicationFiles were found")-Fore red;

}
