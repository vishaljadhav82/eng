@echo off
:: ==========================================================
:: UploadSystemInfo.cmd
:: Collects system info and uploads it to Firebase Firestore
:: Compatible with Windows 10 and 11
:: ==========================================================

echo Collecting and uploading system information...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$sys = Get-ComputerInfo | Select-Object CsManufacturer, CsModel, OsName, OsVersion, OsArchitecture, TotalPhysicalMemory, BIOSSerialNumber; ^
   $ramGB = [math]::Round($sys.TotalPhysicalMemory / 1GB, 2); ^
   $data = @{ ^
      manufacturer = $sys.CsManufacturer; ^
      model = $sys.CsModel; ^
      osName = $sys.OsName; ^
      osVersion = $sys.OsVersion; ^
      architecture = $sys.OsArchitecture; ^
      ramGB = \"$ramGB GB\"; ^
      serial = $sys.BIOSSerialNumber; ^
      timestamp = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); ^
   }; ^
   $body = @{ ^
     fields = @{ ^
       manufacturer = @{ stringValue = $data.manufacturer }; ^
       model = @{ stringValue = $data.model }; ^
       osName = @{ stringValue = $data.osName }; ^
       osVersion = @{ stringValue = $data.osVersion }; ^
       architecture = @{ stringValue = $data.architecture }; ^
       ramGB = @{ stringValue = $data.ramGB }; ^
       serial = @{ stringValue = $data.serial }; ^
       timestamp = @{ stringValue = $data.timestamp }; ^
     } ^
   } | ConvertTo-Json -Depth 10; ^
   $projectId = 'quiz-43b3e'; ^
   $collection = 'systemInfo'; ^
   $uri = 'https://firestore.googleapis.com/v1/projects/' + $projectId + '/databases/(default)/documents/' + $collection; ^
   Write-Host 'Uploading to Firestore...'; ^
   try { ^
     $response = Invoke-RestMethod -Method Post -Uri $uri -Body $body -ContentType 'application/json'; ^
     Write-Host '✅ Successfully uploaded system info to Firestore.' ^
   } catch { ^
     Write-Host '❌ Upload failed:'; ^
     Write-Host $_.Exception.Message ^
   }"

echo.
pause
