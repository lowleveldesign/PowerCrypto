Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

. "$here\UtilsFor.Tests.ps1"

Add-Type -LiteralPath "$here\..\Lib\BouncyCastle.Crypto.dll"

Describe "Encoders" {
    It "Converts HEX to byte array" {
        $Bytes = "0x0102" | ConvertFrom-HexString
        AreByteArraysEqual $Bytes @(1,2) | Should Be $True
        $Bytes = "0102h" | ConvertFrom-HexString
        AreByteArraysEqual $Bytes @(1,2) | Should Be $True
        $Bytes = "0102" | ConvertFrom-HexString
        AreByteArraysEqual $Bytes @(1,2) | Should Be $True
    }
    It "Converts byte array to HEX" {
        @(1, 2, 3) | ConvertTo-HexString | Should Be "010203"
        @(1, 2, 3) | ConvertTo-HexString -Prefix | Should Be "0x010203"
    }
    It "Converts Base64 to byte array and vice versa" {
        $TextBytes = [Text.Encoding]::Utf8.GetBytes("test message")
        $Bytes = $TextBytes | ConvertTo-Base64String | ConvertFrom-Base64String
        [Text.Encoding]::UTF8.GetString($Bytes) | Should Be "test message"
    }
    It "Converts string to byte array and vice versa" {
        $Text = "test message"
        ,$(ConvertTo-ByteArray $Text -Encoding ASCII) | ConvertFrom-ByteArray -Encoding ASCII | Should Be $Text
        ,$(ConvertTo-ByteArray $Text) | ConvertFrom-ByteArray | Should Be $Text
        $Text = ""
        ,$(ConvertTo-ByteArray $Text) | ConvertFrom-ByteArray | Should Be $Text
    }
}
