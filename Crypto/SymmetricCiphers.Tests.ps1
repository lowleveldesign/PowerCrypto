Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

. "$here\$sut"

Add-Type -LiteralPath ..\Lib\BouncyCastle.Crypto.dll

Describe "SymmetricCiphers" {
    It "Test exception if IV is missing" {
        { Protect-BinaryMessage @(1,2,3) @(1,2,3) -Cipher AES -CipherMode CBC } | Should Throw "Initialization vector is required for all modes except ECB"
    }
    It "Encryption and Decryption test" {
        $Message = [Text.Encoding]::ASCII.GetBytes("test message")
        $Key = [Text.Encoding]::ASCII.GetBytes("my little s3cr3t")
        $EncryptedMessage = Protect-BinaryMessage $Message $Key -Cipher AES -CipherMode ECB
        $DecryptedMessage = Unprotect-BinaryMessage $EncryptedMessage $Key -Cipher AES -CipherMode ECB
        [Text.Encoding]::ASCII.GetString($DecryptedMessage) | Should Be "test message"
    }
}
