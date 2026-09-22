Option Explicit

Dim shell, fileSystem, scriptDirectory, watcherPath, command

Set shell = CreateObject("WScript.Shell")
Set fileSystem = CreateObject("Scripting.FileSystemObject")

scriptDirectory = fileSystem.GetParentFolderName(WScript.ScriptFullName)
watcherPath = fileSystem.BuildPath(scriptDirectory, "Watch-BooxClipboard.ps1")
command = "powershell.exe -NoProfile -NonInteractive -WindowStyle Hidden -STA " & _
          "-ExecutionPolicy Bypass -File " & Chr(34) & watcherPath & Chr(34)

' Window style 0 starts PowerShell without displaying a console window. Waiting
' keeps the scheduled task tied to the lifetime of the watcher process.
shell.Run command, 0, True
