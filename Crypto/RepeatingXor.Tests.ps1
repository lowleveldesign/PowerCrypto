Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

. "$here\..\Utils\Encoders.ps1"

Add-Type -LiteralPath ..\Lib\BouncyCastle.Crypto.dll

Describe "RepeatingXor" {
    It "Check the repeating XOR" {
        $Key = [Text.Encoding]::ASCII.GetBytes("ICE")
        $Message = [Text.Encoding]::ASCII.GetBytes("Burning 'em, if you ain't quick and nimble`nI go crazy when I hear a cymbal")
        Get-RepeatingXor $Message $Key  |
            ConvertTo-HexString -Prefix | Should Be "0x0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
    }

    It "Check the repeating XOR with one-byte key" {
        [Byte[]]$Key = @(88)
        $Message = ConvertFrom-HexString "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
        $DecryptedMessage = Get-RepeatingXor $Message $Key
        [Text.Encoding]::ASCII.GetString($DecryptedMessage) | Should BeExactly "Cooking MC's like a pound of bacon"
    }
}
