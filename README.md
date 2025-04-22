# Powershell-MapDrives
PowerShell Class to Map a network Drive or Drives

# Map a drive 
$d = [NetworkDrive]::new("Z", '\\Server\Share','domain\username'))
$d.Mapdrive()


