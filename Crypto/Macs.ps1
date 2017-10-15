
function Get-Mac {
<#
.SYNOPSIS

    Calculates a message MAC and outputs it as a byte array.

    Author: Sebastian Solnica (@lowleveldesign)
    Requires: BouncyCastle

.DESCRIPTION

    Calculates a message MAC and outputs it as a byte array. You may use
    ConvertTo-HexString or Format-HexPrettyPrint to display the result in hex.

.PARAMETER Mac

    The type of MAC you want to calculate.

.PARAMETER Key

    The key to use when calculating the MAC.

.PARAMETER BinaryMessage

    The binary message for which we will calculate the MAC.

.EXAMPLE

    $key = ConvertTo-ByteArray "YELLOW SUBMARINE"
    $b = ConvertTo-ByteArray "test message"
    Get-Mac -Key $key -BinaryMessage $b | ConvertTo-HexString

.INPUTS

    Byte array as the binary message.

.OUTPUTS

    Byte array containing the message digest.
#>

    [CmdletBinding()]Param (
        [Parameter(Mandatory = $True, Position = 0)]
        [Byte[]]
        $Key,
        [Parameter(Mandatory = $True, ValueFromPipeline = $True, Position = 1)]
        [Byte[]]
        $BinaryMessage,
        [Parameter(Position = 2)]
        [ValidateSet("HMAC-SHA1", "HMAC-MD5", "HMAC-SHA256", "HMAC-SHA512")]
        [String]
        $Mac = "HMAC-SHA1")

    $KeyParameter = New-Object "Org.BouncyCastle.Crypto.Parameters.KeyParameter" (,$Key)
    [Org.BouncyCastle.Security.MacUtilities]::CalculateMac($Mac, $KeyParameter, $BinaryMessage)
}
