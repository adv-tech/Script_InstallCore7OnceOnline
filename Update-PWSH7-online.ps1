function Install-PWSHCore7 {
  $Core7EXE = "$($env:ProgramFiles)\PowerShell\7\pwsh.exe"
  if (!(Test-Path -PathType Leaf -Path $Core7EXE -ErrorAction Ignore)) {
      $SysArch = [System.IntPtr]::Size*8
      $FileName = "PowerShell-7.1.3.msi"
      $TempDir  = "$($env:LOCALAPPDATA)\Temp\PowerShell-win-x$($SysArch)\"
      $MSIPath  = "$($TempDir)$($FileName)"
      $MSIURL = "https://github.com/PowerShell/PowerShell/releases/download/v7.1.3/PowerShell-7.1.3-win-x$($SysArch).msi"
      New-Item -ItemType Directory -Path $TempDir -Force -ErrorAction Ignore|out-null
      Write-Debug "Downloading $MSIURL"
      Invoke-WebRequest -Uri $MSIURL -OutFile $MSIPath -EA SilentlyContinue -ErrorVariable dlFailed
      Start-Sleep 15
      Write-Debug "Running $MSIPath"
      if ($dlFailed) {
        Write-Error "Failed to download the installer. Core 7 will not be installed"
      } else {
        Start-Process -Wait -FilePath msiexec.exe -ArgumentList "/package `"$MSIPath`" /quiet ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1"|out-null
      }
  } else {Write-Debug "Core 7 is already installed."}
}

Install-PWSHCore7
Start-Sleep 5
Unregister-ScheduledTask -TaskPath '\advinsight\OneAndDone\' -TaskName 'Instal PWSH core 7.1.3' -Confirm:$false
