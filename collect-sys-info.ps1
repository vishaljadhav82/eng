<#
==========================================================
 Script Name: UploadSystemInfo.ps1
 Description: Collects system info, asks user for client name,
              username, and remarks, then uploads all data to Firestore.
 Compatible with: Windows 10 & 11
==========================================================
#>

Clear-Host
Write-Host "=== System Info Uploader ===" -ForegroundColor Cyan
Write-Host ""

# --- Get user input ---
$clientName = Read-Host "Enter client name"
$username   = Read-Host "Enter username"
$remarks    = Read-Host "Enter remarks or notes"

if (-not $clientName) { $clientName = "Unknown Client" }
if (-not $username)   { $username   = "Unknown User" }
if (-not $remarks)    { $remarks    = "No remarks provided" }

Write-Host ""
Write-Host "Collecting system information..." -ForegroundColor Cyan

# --- Collect system info (get all and pick later) ---
$sys = Get-ComputerInfo

# --- Calculate RAM in GB ---
if ($sys.CsTotalPhysicalMemory) {
    $ramGB = [math]::Round($sys.CsTotalPhysicalMemory / 1GB, 2)
} else {
    $ramGB = "Unknown"
}

# --- Get CPU model and detect generation ---
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1 Name
$cpuModel = $cpu.Name.Trim()

$cpuGen = "Unknown"
if ($cpuModel -match 'i[3579]-([0-9]{4,5})') {
    $cpuNum = [int]$matches[1]
    if ($cpuNum -ge 10000) {
        $cpuGen = [math]::Floor($cpuNum / 1000)  # e.g. 12500 -> 12th Gen
    } else {
        $cpuGen = [math]::Floor($cpuNum / 100)   # e.g. 8350 -> 8th Gen
    }
}

$processorInfo = if ($cpuGen -ne "Unknown") { "$cpuModel ($cpuGen`th Gen)" } else { $cpuModel }

# --- Calculate total storage in GB (local drives) ---
$drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
    Measure-Object -Property Size -Sum
$storageGB = if ($drives.Sum) { [math]::Round($drives.Sum / 1GB, 2) } else { "Unknown" }

# --- Build data object ---
$data = @{
    clientName    = $clientName
    username      = $username
    loggedInUser  = $sys.CsUserName
    remarks       = $remarks
    manufacturer  = $sys.CsManufacturer
    model         = $sys.CsModel
    osName        = $sys.OsName
    OSDisplayVersion = [string]$sys.OSDisplayVersion  # Force as string
    architecture  = $sys.OsArchitecture
    processor     = $processorInfo
    ramGB         = if ($ramGB -is [double]) { "$ramGB GB" } else { "Unknown" }
    storage       = if ($storageGB -is [double]) { "$storageGB GB" } else { "Unknown" }
    serial        = if ($sys.BiosSeralNumber) { $sys.BiosSeralNumber } else { "Unknown" }
    timestamp     = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
}

# --- Build Firestore JSON ---
$body = @{
    fields = @{
        clientName      = @{ stringValue = "$($data.clientName)" }
        username        = @{ stringValue = "$($data.username)" }
        loggedInUser    = @{ stringValue = "$($data.loggedInUser)" }
        remarks         = @{ stringValue = "$($data.remarks)" }
        manufacturer    = @{ stringValue = "$($data.manufacturer)" }
        model           = @{ stringValue = "$($data.model)" }
        osName          = @{ stringValue = "$($data.osName)" }
        OSDisplayVersion = @{ stringValue = "$($data.OSDisplayVersion)" }  # Match Firestore field name
        architecture    = @{ stringValue = "$($data.architecture)" }
        processor       = @{ stringValue = "$($data.processor)" }
        ramGB           = @{ stringValue = "$($data.ramGB)" }
        storage         = @{ stringValue = "$($data.storage)" }
        serial          = @{ stringValue = "$($data.serial)" }
        timestamp       = @{ stringValue = "$($data.timestamp)" }
    }
} | ConvertTo-Json -Compress -Depth 10

# --- Firestore Config ---
$projectId = "quiz-43b3e"      # Your Firebase Project ID
$collection = "systemInfo"     # Firestore collection name
$uri = "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$collection"

# --- Upload to Firestore ---
Write-Host ""
Write-Host "Uploading to Firestore..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Method Post -Uri $uri -Body $body -ContentType 'application/json'
    Write-Host "✅ Successfully uploaded system info to Firestore." -ForegroundColor Green
}
catch {
    Write-Host "❌ Upload failed:" -ForegroundColor Red
    Write-Host $_.Exception.Message
    if ($_.ErrorDetails.Message) {
        Write-Host "Server response: " $_.ErrorDetails.Message
    }
}

Write-Host ""
Read-Host -Prompt "Press Enter to exit"
