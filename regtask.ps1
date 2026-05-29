$ScriptPath = "C:\develop\gitrepos\BOOXClipB\Watch-BooxClipboard.ps1"

$Action = New-ScheduledTaskAction `
  -Execute "powershell.exe" `
  -Argument "-NoProfile -WindowStyle Hidden -STA -ExecutionPolicy Bypass -File `"$ScriptPath`""

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
  -Description "Copies new BOOX screenshots from C:\SyncBOOX to clipboard"
