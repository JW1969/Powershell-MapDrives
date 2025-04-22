class NetworkDrive {
  [string]$DriveLetter
  [string]$SharePath
  [string]$Username
  [string]$CredsFile

  NetworkDrive([string]$driveLetter, [string]$sharePath, [string]$username) {
      $this.DriveLetter = $driveLetter
      $this.SharePath = $sharePath
      $this.Username = $username
      $this.CredsFile = "$env:USERPROFILE\drive-creds-$($driveLetter).xml"
  }

  [System.Management.Automation.PSCredential] GetCredential() {
      if (-Not (Test-Path $this.CredsFile)) {
          Write-Host "No saved credentials found for drive $($this.DriveLetter). Prompting for password..." -ForegroundColor Yellow
          $password = Read-Host "Enter password for $($this.Username)" -AsSecureString
          $password | Export-Clixml -Path $this.CredsFile
      } else {
          $password = Import-Clixml -Path $this.CredsFile
      }
      return [System.Management.Automation.PSCredential]::new($this.Username, $password)
  }

  [void] MapDrive() {
      $credential = $this.GetCredential()

      # Remove existing drive
      if (Get-PSDrive -Name $this.DriveLetter -ErrorAction SilentlyContinue) {
          Remove-PSDrive -Name $this.DriveLetter -Force
      }

      try {
          New-PSDrive -Name $this.DriveLetter -PSProvider FileSystem -Root $this.SharePath -Credential $credential -Persist
          Write-Host "✅ Drive $($this.DriveLetter): mapped to $($this.SharePath)." -ForegroundColor Green
      } catch {
          Write-Error "❌ Failed to map drive $($this.DriveLetter): $_"
      }
  }

  [void] ClearSavedCredential() {
      if (Test-Path $this.CredsFile) {
          Remove-Item $this.CredsFile -Force
          Write-Host "🧹 Removed saved credentials at $($this.CredsFile)"
      } else {
          Write-Host "⚠️ No saved credentials to remove for drive $($this.DriveLetter)."
      }
  }

  static [void] ListMappedDrives() {
      Get-PSDrive -PSProvider FileSystem | Where-Object { $_.DisplayRoot -like "\\*" } | Format-Table Name, Root
  }

  static [void] MapMultiple([NetworkDrive[]]$drives) {
      foreach ($drive in $drives) {
          $drive.MapDrive()
      }
  }

  static [void] ClearAllSavedCredentials() {
      Get-ChildItem "$env:USERPROFILE" -Filter "drive-creds-*.xml" | ForEach-Object {
          Remove-Item $_.FullName -Force
          Write-Host "🧹 Removed: $($_.Name)"
      }
  }
}
#map drive Z: '\\VAGWESQLEVMS01.vha.med.va.gov\E$' with account "va\oitwnywillij0")
$d = [NetworkDrive]::new("Z", '\\VAGWESQLEVMS01.vha.med.va.gov\E$', "va\oitwnywillij0")
$d.mapdrive()

