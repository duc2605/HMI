# Windows PowerShell 5.1. Supervisor v1.1: follow Runtime restarts.
param([int]$RuntimeId = 0)
# Starts no terminal windows. Only processes started here are stopped here.
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$logDir = Join-Path $root 'video-logs'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$mutex = New-Object System.Threading.Mutex($false, 'Local\HUST_HMI_Video_Autostart')
$locked = $false
$server = $null
$encoder = $null
$runtime = $null
$captureHandle = 0
$retryAt = [datetime]::MinValue
$runtimeMissingSince = $null
$runtimeGraceSeconds = 90

function Write-VideoLog([string]$message) {
    Add-Content -LiteralPath (Join-Path $logDir 'supervisor.log') -Value ((Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' ' + $message)
}

function Test-Alive($process) {
    if ($null -eq $process) { return $false }
    try { $process.Refresh(); return (-not $process.HasExited) }
    catch { return $false }
}

# ChayDuAn.exe allows one HMI Runtime session. Prefer a visible Runtime;
# RuntimeId is accepted for compatibility, not used as a lifetime lock.
function Find-LiveRuntime {
    $all = @(Get-Process -Name HmiRTm -ErrorAction SilentlyContinue |
        Sort-Object StartTime -Descending)
    $visible = @($all | Where-Object { $_.MainWindowHandle -ne 0 })
    if ($visible.Count -gt 0) { return $visible[0] }
    if ($all.Count -gt 0) { return $all[0] }
    return $null
}

function Stop-OwnedProcess($process) {
    if (Test-Alive $process) {
        try { $process.Kill(); $null = $process.WaitForExit(3000) }
        catch { Write-VideoLog ('Cannot stop owned process: ' + $_.Exception.Message) }
    }
}

function Test-RtspPort {
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $client.Connect('127.0.0.1', 8554)
        return $true
    }
    catch { return $false }
    finally { $client.Dispose() }
}

try {
    try { $locked = $mutex.WaitOne(0) }
    catch [System.Threading.AbandonedMutexException] { $locked = $true }
    if (-not $locked) { return }

    foreach ($name in @('mediamtx.exe', 'mediamtx.yml', 'ffmpeg.exe')) {
        if (-not (Test-Path -LiteralPath (Join-Path $root $name))) {
            throw ('Missing file: ' + $name)
        }
    }

    Write-VideoLog ('Supervisor v1.1 started; launcher PID hint ' + $RuntimeId)
    # Runtime may hand off to a different PID or be retried after a load error.
    $deadline = (Get-Date).AddSeconds($runtimeGraceSeconds)
    do {
        $runtime = Find-LiveRuntime
        if ($null -ne $runtime) { break }
        Start-Sleep -Seconds 1
    } while ((Get-Date) -lt $deadline)
    if ($null -eq $runtime) { throw 'No HmiRTm process found within 90 seconds. Open WinCC Runtime and run the launcher again.' }
    Write-VideoLog ('Attached to Runtime PID ' + $runtime.Id)

    if (Test-RtspPort) {
        Write-VideoLog 'RTSP port already in use. Reusing the existing server; it will not be stopped by this script.'
    }
    else {
        $server = Start-Process -FilePath (Join-Path $root 'mediamtx.exe') -ArgumentList '"mediamtx.yml"' -WorkingDirectory $root -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $logDir 'mediamtx-out.log') -RedirectStandardError (Join-Path $logDir 'mediamtx-error.log')
        for ($i = 0; $i -lt 15; $i++) {
            if (Test-RtspPort) { break }
            if (-not (Test-Alive $server)) { throw 'MediaMTX stopped; inspect mediamtx-error.log.' }
            Start-Sleep -Seconds 1
        }
        if (-not (Test-RtspPort)) { throw 'MediaMTX did not open port 8554.' }
    }

    while ($true) {
        if (-not (Test-Alive $runtime)) {
            $replacement = Find-LiveRuntime
            if ($null -ne $replacement) {
                if ($null -ne $runtime) { $runtime.Dispose() }
                $runtime = $replacement
                $runtimeMissingSince = $null
                Write-VideoLog ('Reattached to Runtime PID ' + $runtime.Id)
            }
            else {
                if ($null -eq $runtimeMissingSince) {
                    $runtimeMissingSince = Get-Date
                    Write-VideoLog 'Runtime PID exited. Keeping video available for up to 90 seconds while waiting for a replacement Runtime.'
                }
                if (((Get-Date) - $runtimeMissingSince).TotalSeconds -ge $runtimeGraceSeconds) { break }
                Start-Sleep -Seconds 1
                continue
            }
        }
        $runtimeMissingSince = $null
        $factory = Get-Process -ErrorAction SilentlyContinue |
            Where-Object { $_.ProcessName -match 'factory' -and $_.MainWindowHandle -ne 0 } |
            Select-Object -First 1
        $currentHandle = 0
        if ($null -ne $factory) { $currentHandle = $factory.MainWindowHandle.ToInt64() }

        if ((Test-Alive $encoder) -and $currentHandle -ne $captureHandle) {
            Stop-OwnedProcess $encoder
            $encoder = $null
            $retryAt = [datetime]::MinValue
        }

        if ($currentHandle -ne 0 -and -not (Test-Alive $encoder) -and (Get-Date) -ge $retryAt) {
            $captureHandle = $currentHandle
            $graph = "gfxcapture=hwnd=${captureHandle}:max_framerate=10:capture_cursor=0,hwdownload,format=bgra,scale=640:360:force_original_aspect_ratio=decrease:force_divisible_by=2,pad=640:360:(ow-iw)/2:(oh-ih)/2,setsar=1,format=yuv420p[video]"
            $arguments = '-hide_banner -nostdin -filter_complex "' + $graph + '" -map "[video]" -an -r 10 -c:v libx264 -preset ultrafast -tune zerolatency -profile:v baseline -pix_fmt yuv420p -b:v 800k -g 10 -f rtsp -rtsp_transport tcp rtsp://127.0.0.1:8554/factory'
            Write-VideoLog ('Starting capture for HWND ' + $captureHandle)
            $encoder = Start-Process -FilePath (Join-Path $root 'ffmpeg.exe') -ArgumentList $arguments -WorkingDirectory $root -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $logDir 'ffmpeg-out.log') -RedirectStandardError (Join-Path $logDir 'ffmpeg-error.log')
            $retryAt = (Get-Date).AddSeconds(10)
        }
        Start-Sleep -Seconds 2
    }
    Write-VideoLog 'No Runtime for 90 seconds. Stopping owned video processes.'
}
catch {
    Write-VideoLog ('ERROR: ' + $_.Exception.Message)
    try {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show(('Video error: ' + $_.Exception.Message + [Environment]::NewLine + 'See Tools/video-logs.'), 'HMI Video') | Out-Null
    } catch { }
}
finally {
    Stop-OwnedProcess $encoder
    Stop-OwnedProcess $server
    if ($locked) { $mutex.ReleaseMutex() }
    $mutex.Dispose()
    if ($null -ne $runtime) { $runtime.Dispose() }
}
