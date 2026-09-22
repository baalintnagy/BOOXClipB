$LauncherPath = Join-Path $PSScriptRoot "Start-BooxClipboard.vbs"

$Action = New-ScheduledTaskAction `
  -Execute "$env:SystemRoot\System32\wscript.exe" `
  -Argument "`"$LauncherPath`""

$Trigger = New-ScheduledTaskTrigger -AtLogOn

$Settings = New-ScheduledTaskSettingsSet `
  -AllowStartIfOnBatteries `
  -DontStopIfGoingOnBatteries `
  -RestartCount 3 `
  -RestartInterval (New-TimeSpan -Minutes 1)

Register-ScheduledTask `
  -TaskName "BOOX Clipboard Watcher" `
  -Action $Action `
  -Trigger $Trigger `
  -Settings $Settings `
  -Description "Copies new BOOX screenshots from C:\SyncBOOX to clipboard" `
  -Force
