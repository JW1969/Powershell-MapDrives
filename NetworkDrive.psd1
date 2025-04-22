@{
  # General Info
  RootModule           = 'NetworkDrive.psm1'
  ModuleVersion        = '1.0.0'
  GUID                 = 'f6a5f6b2-36fc-404c-a7df-9b78f4fa7abc'
  Author               = 'Matt Williamson'
  Description          = 'A simple PowerShell module to map network drives with saved credentials.'

  # Compatibility
  PowerShellVersion    = '7.0'
  CompatiblePSEditions = @('Core', 'Desktop')

  # Visibility
  FunctionsToExport    = @()
  CmdletsToExport      = @()
  VariablesToExport    = @()
  AliasesToExport      = @()

  # This tells PowerShell to load the class defined in the .psm1 file
  FileList             = @('NetworkDrive.psm1')

  # Optional: Add these if you're planning to publish to a gallery later
  PrivateData = @{
      PSData = @{
          Tags       = @('NetworkDrive', 'Mapping', 'Credentials', 'Drives')
          ProjectUri = 'https://github.com/yourname/NetworkDriveModule'
          LicenseUri = 'https://opensource.org/licenses/MIT'
      }
  }
}
# End of module manifest