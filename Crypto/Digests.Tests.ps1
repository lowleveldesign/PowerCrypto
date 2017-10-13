Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

. "$here\$sut"
. "$here\..\Utils\Encoders.ps1"

Add-Type -LiteralPath ..\Lib\BouncyCastle.Crypto.dll

Describe "Digests" {
    It "Test digests output" {
        $Message = [Text.Encoding]::ASCII.GetBytes("test message")
        Get-MessageDigest -BinaryMessage $Message -Digest "MD4" | ConvertTo-HexString | `
            Should Be "41C4909E181FBB60BABC321EA7A9DB3C"
        Get-MessageDigest -BinaryMessage $Message -Digest "SHA1" | ConvertTo-HexString | `
            Should Be "35EE8386410D41D14B3F779FC95F4695F4851682"
        Get-MessageDigest -BinaryMessage $Message -Digest "SHA256" | ConvertTo-HexString | `
            Should Be "3F0A377BA0A4A460ECB616F6507CE0D8CFA3E704025D4FDA3ED0C5CA05468728"
    }
}
