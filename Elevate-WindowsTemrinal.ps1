# SCRIPT PURPOSE: Open an Admin Windows Terminal from a non-admin Windows Terminal
class WindowsTerminal{
    [string]$ProcessName = "WindowsTerminal" # The name of Windows Terminal Process shown in GET-PROCESS results [as of 10/13/23 the process name is WindowsTermainal]
    [string]$CommandName = "wt" # The command to run that opens/starts a new Windows Terminal [as of 10/13/23 the command is 'wt']
    [int32]$PID # Process ID show in GET-PROCESS results
}

# Create a new WindowsTerminal Object
$nonadminTerminal = [WindowsTerminal]::new()
# Get the current Windows Terminal Process ID - needed to close the non-admin terminal after the Admin terminal is started
$nonadminTerminal.PID = get-process | Where-Object {$_.Name -eq $nonadminTerminal.ProcessName} | Select-Object -ExpandProperty ID
# Start a new Windows Terminal with Admin permissions
start-process -FilePath $nonadminTerminal.CommandName -Verb Runas
# Get the Process ID of the Admin Windows Terminal
try {
    start-process -FilePath $nonadminTerminal.CommandName -Verb Runas
    exit
    # Stop-Process -Id $nonadminTerminal.PID -Force 
}
catch {
    Write-Host "Failed to open Windows Terminal with Admin Permissions `n $Error"
}