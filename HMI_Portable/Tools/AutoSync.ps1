param([ValidateSet('Install','Watch','Remove')][string]$Mode = 'Install')
$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot)).TrimEnd('\')
$hashAlgorithm = [Security.Cryptography.SHA256]::Create()
try {
    $key = ([BitConverter]::ToString($hashAlgorithm.ComputeHash([Text.Encoding]::UTF8.GetBytes($root.ToLowerInvariant())))).Replace('-', '').Substring(0, 20)
} finally { $hashAlgorithm.Dispose() }
$state = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) ('HUST-HMI-AutoSync\' + $key)
New-Item -ItemType Directory -Force -Path $state | Out-Null
$configFile = Join-Path $state 'config.json'
$stopFile = Join-Path $state 'stop'
$shortcutFile = Join-Path ([Environment]::GetFolderPath('Startup')) ('HUST-HMI-AutoSync-' + $key + '.lnk')
$mutexName = 'Local\HUST_HMI_AutoSync_' + $key
$target = Join-Path $root 'Runtime'
$statusFile = Join-Path $PSScriptRoot 'AutoSync-Status.txt'

function Write-Status([string]$message) {
    $line = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' ' + $message
    Add-Content -LiteralPath (Join-Path $state 'sync.log') -Value $line -Encoding UTF8
    try { Set-Content -LiteralPath $statusFile -Value $line -Encoding UTF8 } catch { }
}

function Show-Message([string]$message) {
    Add-Type -AssemblyName System.Windows.Forms
    [void][System.Windows.Forms.MessageBox]::Show($message, 'HMI AutoSync')
}

function Runtime-IsOpen {
    return ($null -ne (Get-Process -Name HmiRTm -ErrorAction SilentlyContinue | Select-Object -First 1))
}

function Source-IsValid([string]$folder) {
    $data = Join-Path $folder 'pdata.fwc'
    return ((Test-Path -LiteralPath $data -PathType Leaf) -and (Get-Item -LiteralPath $data).Length -gt 0)
}

function File-List([string]$folder) {
    return @(Get-ChildItem -LiteralPath $folder -Recurse -File -Force | Sort-Object FullName)
}

function Metadata([string]$folder) {
    $prefix = $folder.TrimEnd('\') + '\'
    $lines = foreach ($file in (File-List $folder)) {
        $file.FullName.Substring($prefix.Length) + '|' + $file.Length + '|' + $file.LastWriteTimeUtc.Ticks
    }
    return ($lines -join "`n")
}

function Content-Hashes([string]$folder) {
    $prefix = $folder.TrimEnd('\') + '\'
    $lines = foreach ($file in (File-List $folder)) {
        $file.FullName.Substring($prefix.Length) + '|' + (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
    }
    return ($lines -join "`n")
}

function Copy-Snapshot([string]$source, [string]$expectedMetadata) {
    if (Runtime-IsOpen) { return $false }
    if (-not (Source-IsValid $source)) { throw 'Source pdata.fwc is missing or empty.' }
    $stage = Join-Path $root ('Runtime_AutoSync_Stage_' + [guid]::NewGuid().ToString('N'))
    $backup = Join-Path $root 'Runtime_AutoSync_Backup'
    try {
        New-Item -ItemType Directory -Path $stage | Out-Null
        Get-ChildItem -LiteralPath $source -Force | Copy-Item -Destination $stage -Recurse -Force
        if ((Metadata $source) -cne $expectedMetadata) { return $false }
        $sourceHashes = Content-Hashes $source
        if ($sourceHashes -cne (Content-Hashes $stage)) { return $false }
        if ((Metadata $source) -cne $expectedMetadata) { return $false }
        if (Runtime-IsOpen) { return $false }
        if (Test-Path -LiteralPath $backup) { Remove-Item -LiteralPath $backup -Recurse -Force }
        if (Test-Path -LiteralPath $target) { Move-Item -LiteralPath $target -Destination $backup }
        try { Move-Item -LiteralPath $stage -Destination $target }
        catch {
            if (-not (Test-Path -LiteralPath $target) -and (Test-Path -LiteralPath $backup)) {
                Move-Item -LiteralPath $backup -Destination $target
            }
            throw
        }
        Write-Status 'SYNC OK: Runtime updated. Previous version: Runtime_AutoSync_Backup.'
        return $true
    }
    finally {
        if (Test-Path -LiteralPath $stage) { Remove-Item -LiteralPath $stage -Recurse -Force }
    }
}

function Stop-PreviousWatcher {
    Set-Content -LiteralPath $stopFile -Value 'stop'
    $control = New-Object System.Threading.Mutex($false, $mutexName)
    $acquired = $false
    try {
        try { $acquired = $control.WaitOne(15000) }
        catch [System.Threading.AbandonedMutexException] { $acquired = $true }
        if (-not $acquired) { throw 'AutoSync is copying files. Wait a moment, then run setup again.' }
    }
    finally {
        if ($acquired) { $control.ReleaseMutex() }
        $control.Dispose()
    }
}

if ($Mode -eq 'Install' -or $Mode -eq 'Remove') {
    try {
        if ($Mode -eq 'Remove') {
            if (Test-Path -LiteralPath $shortcutFile) { Remove-Item -LiteralPath $shortcutFile -Force }
            Stop-PreviousWatcher
            Write-Status 'STOPPED: Automatic startup removed.'
            Show-Message 'Da tat AutoSync va go tu khoi dong cung Windows. Du lieu Runtime duoc giu nguyen.'
            exit 0
        }
        if (-not (Test-Path -LiteralPath (Join-Path $root 'ChayDuAn.exe'))) {
            throw 'Hay dat Tools/AutoSync.ps1 vao HMI_Portable da co ChayDuAn.exe.'
        }
        Stop-PreviousWatcher
        Add-Type -AssemblyName System.Windows.Forms
        $suggested = Join-Path (Split-Path -Parent $root) 'Nhom2_FactoryIO_Template_S7-1200_V20_Version1\IM\HMI\C\0\Generates'
        $dialog = New-Object System.Windows.Forms.OpenFileDialog
        try {
            $dialog.Title = 'Chon pdata.fwc NGUON trong du an TIA / Generates, KHONG chon ban trong HMI_Portable'
            $dialog.Filter = 'WinCC Runtime (pdata.fwc)|pdata.fwc'
            if (Test-Path -LiteralPath $suggested) { $dialog.InitialDirectory = $suggested }
            $dialog.FileName = 'pdata.fwc'
            if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { throw 'Chua chon nguon. AutoSync dang dung; chay lai BatTuDongBo.cmd de bat.' }
            $source = [IO.Path]::GetFullPath((Split-Path -Parent $dialog.FileName)).TrimEnd('\')
        }
        finally { $dialog.Dispose() }
        # Refuse overlapping source/destination paths before any copy or deletion.
        if ($source.Equals($root, [StringComparison]::OrdinalIgnoreCase) -or
            $source.StartsWith($root + '\', [StringComparison]::OrdinalIgnoreCase) -or
            $root.StartsWith($source + '\', [StringComparison]::OrdinalIgnoreCase)) {
            throw 'Nguon phai o ngoai HMI_Portable. Hay chon pdata.fwc trong thu muc Generates cua du an TIA.'
        }
        if (-not (Source-IsValid $source)) { throw 'File pdata.fwc nguon khong hop le.' }
        @{ Source = $source; Root = $root } | ConvertTo-Json | Set-Content -LiteralPath $configFile -Encoding UTF8
        $ignoreFile = Join-Path $root '.gitignore'
        $existing = if (Test-Path -LiteralPath $ignoreFile) { Get-Content -LiteralPath $ignoreFile } else { @() }
        foreach ($pattern in @('Runtime_AutoSync_Backup/', 'Runtime_AutoSync_Stage_*/', 'Tools/AutoSync-Status.txt', 'Tools/video-logs/')) {
            if ($existing -notcontains $pattern) { Add-Content -LiteralPath $ignoreFile -Value ("`r`n" + $pattern) -Encoding UTF8 }
        }
        $ps = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
        $arguments = '-NoLogo -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File "' + $PSCommandPath + '" -Mode Watch'
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($shortcutFile)
        $shortcut.TargetPath = $ps
        $shortcut.Arguments = $arguments
        $shortcut.WorkingDirectory = $root
        $shortcut.WindowStyle = 7
        $shortcut.Description = 'Synchronize compiled HMI data to this HMI_Portable folder.'
        $shortcut.Save()
        Remove-Item -LiteralPath $stopFile -Force -ErrorAction SilentlyContinue
        $start = New-Object Diagnostics.ProcessStartInfo
        $start.FileName = $ps
        $start.Arguments = $arguments
        $start.WorkingDirectory = $root
        $start.UseShellExecute = $false
        $start.CreateNoWindow = $true
        $start.WindowStyle = [Diagnostics.ProcessWindowStyle]::Hidden
        $child = [Diagnostics.Process]::Start($start)
        $child.Dispose()
        Show-Message 'Da bat AutoSync va tu khoi dong cung Windows. Dong Runtime de cho phep cap nhat. Xem Tools/AutoSync-Status.txt sau khoang 15 giay.'
        exit 0
    }
    catch { Show-Message $_.Exception.Message; exit 1 }
}

$mutex = New-Object System.Threading.Mutex($false, $mutexName)
$locked = $false
try {
    try { $locked = $mutex.WaitOne(0) }
    catch [System.Threading.AbandonedMutexException] { $locked = $true }
    if (-not $locked) { exit 0 }
    if (-not (Test-Path -LiteralPath $configFile)) { throw 'Run BatTuDongBo.cmd first.' }
    $config = Get-Content -LiteralPath $configFile -Raw | ConvertFrom-Json
    $source = [string]$config.Source
    $observed = $null
    $synced = $null
    $stableSince = Get-Date
    $waiting = $false
    Write-Status 'WATCHING: Waiting for stable compiled data and a closed Runtime.'
    while (-not (Test-Path -LiteralPath $stopFile)) {
        try {
            if (-not (Source-IsValid $source)) { throw 'Source pdata.fwc missing; waiting for compilation.' }
            $current = Metadata $source
            if ($current -cne $observed) {
                $observed = $current
                $stableSince = Get-Date
                $waiting = $false
                Write-Status 'PENDING: Source changed. Waiting 10 seconds without file changes.'
            }
            elseif ($current -cne $synced -and ((Get-Date) - $stableSince).TotalSeconds -ge 10) {
                if (Runtime-IsOpen) {
                    if (-not $waiting) { Write-Status 'WAITING: Close WinCC Runtime to apply the compiled update.'; $waiting = $true }
                }
                elseif (Copy-Snapshot $source $current) {
                    $synced = $current
                    $waiting = $false
                }
                else {
                    $stableSince = Get-Date
                    Write-Status 'RETRY: Files changed or Runtime opened during copying. Existing Runtime kept.'
                }
            }
        }
        catch {
            Write-Status ('RETRY: ' + $_.Exception.Message)
            $stableSince = Get-Date
        }
        Start-Sleep -Seconds 3
    }
    Write-Status 'STOPPED: Watcher exited.'
}
catch { Write-Status ('ERROR: ' + $_.Exception.Message) }
finally {
    if ($locked) { $mutex.ReleaseMutex() }
    $mutex.Dispose()
}
