Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$WatchPath = "C:\SyncBOOX"
$LogPath   = "C:\develop\gitrepos\BOOXClipB\boox-clipboard.log"

$extensions = @(".png", ".jpg", ".jpeg", ".bmp", ".gif")

function Log($msg) {
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $msg"
    Add-Content -Path $LogPath -Value $line
    Write-Host $line
}

function Wait-FileReady($path) {
    for ($i = 0; $i -lt 30; $i++) {
        try {
            $stream = [System.IO.File]::Open($path, 'Open', 'Read', 'Read')
            $stream.Close()
            return $true
        }
        catch {
            Start-Sleep -Milliseconds 300
        }
    }
    return $false
}

function Copy-ImageToClipboard($path) {
    $ext = [System.IO.Path]::GetExtension($path).ToLowerInvariant()

    if ($extensions -notcontains $ext) {
        Log "Ignored non-image: $path"
        return
    }

    if (!(Test-Path $path)) {
        Log "File vanished: $path"
        return
    }

    if (!(Wait-FileReady $path)) {
        Log "File not ready after timeout: $path"
        return
    }

    try {
        # Avoid locking the original file by loading through a MemoryStream.
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $ms = New-Object System.IO.MemoryStream(,$bytes)
        $img = [System.Drawing.Image]::FromStream($ms)

        [System.Windows.Forms.Clipboard]::SetImage($img)

        $img.Dispose()
        $ms.Dispose()

        Log "Copied image to clipboard: $path"
    }
    catch {
        Log "FAILED copying image: $path :: $($_.Exception.Message)"
    }
}

if (!(Test-Path $WatchPath)) {
    New-Item -ItemType Directory -Path $WatchPath -Force | Out-Null
}

Log "Watching: $WatchPath"

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $WatchPath
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$action = {
    $path = $Event.SourceEventArgs.FullPath

    # Syncthing may create temp files first; ignore its internal files.
    if ($path -match "\\\.stfolder\\|\\\.stversions\\|\.tmp$|\.syncthing\..*\.tmp$") {
        return
    }

    Start-Sleep -Milliseconds 700
    Copy-ImageToClipboard $path
}

Register-ObjectEvent $watcher Created -Action $action | Out-Null
Register-ObjectEvent $watcher Changed -Action $action | Out-Null
Register-ObjectEvent $watcher Renamed -Action $action | Out-Null

while ($true) {
    Start-Sleep -Seconds 1
}
