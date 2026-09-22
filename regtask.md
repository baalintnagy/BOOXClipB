# BOOX Clipboard Watcher

Run `regtask.ps1` once to create or update the logon task. Run it as
Administrator if the existing task was originally created with elevated
permissions. The task uses the
windowless `Start-BooxClipboard.vbs` launcher, so the watcher does not display a
terminal window.

- Start: `Start-ScheduledTask -TaskName "BOOX Clipboard Watcher"`
- Check: `Get-ScheduledTask -TaskName "BOOX Clipboard Watcher" | Get-ScheduledTaskInfo`
- Stop: `Stop-ScheduledTask -TaskName "BOOX Clipboard Watcher"`

You can also double-click `Start-BooxClipboard.vbs` to start the watcher without
showing a terminal.
