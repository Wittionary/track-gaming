<#
Readme needs to have info to copy-paste a script that sets up a scheduled task
to run the script every time interval (60 seconds?)
https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/new-scheduledtask?view=win10-ps

Build in fail safe to stop existing gaming timers in case the PC was shut off before the platform was exited and script ran
#>
Import-Module -Name PSToggl -MinimumVersion 1.3.24

$Processes = @("steam", "Battle.net", "EpicGamesLauncher")
foreach ($Process in $Processes) {
    if (Get-Process $Process) {
        # The process exists
        # See if existing timer is going, if not start a timer
        $RunningTimer = Get-TogglEntry -Current
        if($null -eq $RunningTimer) {
            Start-TogglEntry -Description $Process -Tags "Entertainment"
        } 
    } else {
        # The process does not exist, but it may have just exited
        # Check for existing/running toggl timer for it and stop the timer
        $RunningTimer = Get-TogglEntry -Current
        if ($null -ne $RunningTimer) {
            Stop-TogglEntry
        } 
    }
}