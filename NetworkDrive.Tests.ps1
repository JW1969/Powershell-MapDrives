# NetworkDrive.Tests.ps1
Import-Module "$PSScriptRoot\NetworkDrive.psm1" -Force

Describe "NetworkDrive Class" {
    It "Creates a valid instance" {
        $d = [NetworkDrive]::new("Z", '\\Server\Share', "domain\username")
        $d.DriveLetter | Should -Be "Z"
        $d.SharePath   | Should -Be '\\Server\Share'
        $d.Username    | Should -Be "domain\username"
    }

    It "Returns a PSCredential from GetCredential" {
        $d = [NetworkDrive]::new("T", "\\Test\Drive", "FakeUser")
        $null = $d.ClearSavedCredential() # clean up if needed
        Add-Type -AssemblyName System.Windows.Forms
        $secPwd = ConvertTo-SecureString "Test1234!" -AsPlainText -Force
        $secPwd | Export-Clixml -Path $d.CredsFile
        $cred = $d.GetCredential()
        $cred | Should -BeOfType "System.Management.Automation.PSCredential"
    }

    It "Handles missing credential file gracefully" {
        $d = [NetworkDrive]::new("X", "\\Test\Drive2", "FakeUser2")
        $null = $d.ClearSavedCredential()
        Mock -CommandName Read-Host -MockWith { return ConvertTo-SecureString "FakePass!" -AsPlainText -Force }
        $cred = $d.GetCredential()
        $cred | Should -BeOfType "System.Management.Automation.PSCredential"
    }
}
