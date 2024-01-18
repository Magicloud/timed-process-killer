param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false) {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    }
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

'running with full privileges'

$Cult = New-Object system.globalization.cultureinfo("zh-CN")

for (; ; ) {
    $Now = Get-Date
    $Host.UI.RawUI.WindowTitle = $Cult.DateTimeFormat.GetDayName($Now.DayOfWeek)
    Get-Process | ForEach-Object -Process {
        if ( ($_.ProcessName -in 'browser', 'qbclient') -and ($Now -gt $_.StartTime.AddSeconds(30)) ) {
            Stop-Process -Id $_.Id
        }
    }

    Start-Sleep 10
}