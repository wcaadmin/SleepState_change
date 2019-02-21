$WSLocalDir = "C:\_Scripts"
$WorkingDir = (new-item -path "$WSLocalDir\PatchManagement\" -itemtype directory -force).Name
$taskname = "DisableSleep"
$Check_event01 = "SleepState_disabled"
$runcheck = Get-Content -Path $Logpath |? {$_ -like "*$Check_event01*"}
#
#CleaupLogs

#create_log
$Logpath = (new-item -path "$WSLocalDir\PatchManagement\config.log) -force
#
#Check network 
function Check_Network {
(Get-NetIPAddress | Where-Object { ($_.IPAddress -Like "192.168.0*" -or $_.IPAddress -Like "10.40.*")})}
#
function Cleanup_task
{
    Get-ScheduledTask -TaskName $taskname -ErrorVariable GettaskError01 -ErrorAction SilentlyContinue
    if ($GettaskError01){}else {Get-ScheduledTask -TaskName $taskname| Unregister-ScheduledTask -confirm:$false -ErrorAction SilentlyContinue}
}
#Disable_SleepState
if (Check_Network) -and ($runcheck -eq $null){
powercfg.exe -change disk-timeout-ac 0
powercfg.exe -change disk-timeout-dc 0
powercfg.exe -change standby-timeout-ac 0
powercfg.exe -change standby-timeout-dc 0
powercfg.exe -change hibernate-timeout-ac 0
powercfg.exe -change hibernate-timeout-dc 0
#
add-content -Path $Logpath -Value "-------Start---------" -Force
add-content -Path $Logpath -Value "SleepState_disabled" -Force
}

if ($runcheck){
powercfg.exe -change disk-timeout-ac 120
powercfg.exe -change disk-timeout-dc 30
powercfg.exe -change standby-timeout-ac 60
powercfg.exe -change standby-timeout-dc 30
powercfg.exe -change hibernate-timeout-ac 120
powercfg.exe -change hibernate-timeout-dc 60
}
