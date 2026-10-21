$ErrorActionPreference = 'Stop'
try {
    Add-Type -AssemblyName System.Windows.Forms
    $root = Split-Path -Parent $PSScriptRoot
    $parent = Split-Path -Parent $root
    $runtimeDir = Join-Path $root 'Runtime'
    $toolsDir = Join-Path $root 'Tools'
    foreach ($dir in @($runtimeDir, $toolsDir, (Join-Path $root 'FactoryIO'))) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    if (Get-Process -Name HmiRTm -ErrorAction SilentlyContinue) {
        throw 'Hay dong WinCC Runtime truoc khi tao/cap nhat bo chay.'
    }

    # Reuse the tools already tested on this machine. Never overwrite bundled tools.
    foreach ($name in @('ffmpeg.exe', 'mediamtx.exe', 'mediamtx.yml')) {
        $target = Join-Path $toolsDir $name
        if (-not (Test-Path -LiteralPath $target)) {
            $existing = Join-Path (Join-Path $parent 'HMI_Video') $name
            if (-not (Test-Path -LiteralPath $existing)) {
                throw ('Thieu ' + $name + '. Hay copy file nay tu HMI_Video vao Tools, roi chay lai.')
            }
            Copy-Item -LiteralPath $existing -Destination $target
        }
    }

    if (-not (Test-Path -LiteralPath (Join-Path $runtimeDir 'pdata.fwc'))) {
        $generated = Join-Path $parent 'Nhom2_FactoryIO_Template_S7-1200_V20_Version1\IM\HMI\C\0\Generates'
        if (-not (Test-Path -LiteralPath (Join-Path $generated 'pdata.fwc'))) {
            $dialog = New-Object System.Windows.Forms.OpenFileDialog
            try {
                $dialog.Title = 'Chon pdata.fwc trong thu muc Generates cua du an da compile'
                $dialog.Filter = 'WinCC Runtime (pdata.fwc)|pdata.fwc'
                if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
                    throw 'Chua chon pdata.fwc.'
                }
                $generated = Split-Path -Parent $dialog.FileName
            }
            finally { $dialog.Dispose() }
        }
        # Copy every companion file/subdirectory, not only pdata.fwc.
        Get-ChildItem -LiteralPath $generated -Force | Copy-Item -Destination $runtimeDir -Recurse -Force
    }

    $compiler = @(
        (Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'),
        (Join-Path $env:WINDIR 'Microsoft.NET\Framework\v4.0.30319\csc.exe')
    ) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
    if (-not $compiler) { throw 'Khong tim thay csc.exe cua .NET Framework 4.x tren Windows.' }
    $output = Join-Path $root 'ChayDuAn.exe'
    & $compiler /nologo /target:winexe /platform:anycpu /reference:System.Windows.Forms.dll "/out:$output" (Join-Path $PSScriptRoot 'Launcher.cs')
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $output)) { throw 'Bien dich Launcher.cs that bai.' }
    Write-Host 'Da tao ChayDuAn.exe va chuan bi Runtime/Tools.' -ForegroundColor Green
    Write-Host 'Nho luu scene .factoryio vao thu muc FactoryIO.'
    exit 0
}
catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
