
function Get-MessageDigest {
<#
.SYNOPSIS

    Calculates a message digests and outputs it as a byte array. 

    Author: Sebastian Solnica (@lowleveldesign)
    Requires: BouncyCastle

.DESCRIPTION

    Calculates a message digests and outputs it as a byte array. You may use
    ConvertTo-HexString or Format-HexPrettyPrint to display the digest in hex.

.PARAMETER BinaryMessage

    The binary message to be encrypted.

.PARAMETER Digest

    The digest algorithm, which should be used to calaulte the digest.

.EXAMPLE

    $b = ConvertTo-ByteArray "test message"
    Get-MessageDigest  $b | ConvertTo-HexString

.INPUTS

    Byte array as the binary message.

.OUTPUTS

    Byte array containing the message digest.
#>

    [CmdletBinding()]Param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True, Position = 0)]
        [Byte[]]
        $BinaryMessage,
        [Parameter(Position = 1)]
        [ValidateSet("MD4", "MD5", "SHA1", "SHA256", "SHA512")]
        [String]
        $Digest = "SHA256")

    [Org.BouncyCastle.Security.DigestUtilities]::CalculateDigest($Digest, $BinaryMessage)
}
