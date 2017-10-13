function Get-RepeatingXor {
<#
.SYNOPSIS

    Encrypts the provided message using repeating XOR.

    Author: Sebastian Solnica (@lowleveldesign)

.DESCRIPTION

    Encrypts the provided message using repeating XOR.

.PARAMETER BinaryMessage

    The binary message to be encrypted.

.PARAMETER Key

    The key that should be used for encryption.
      
.INPUTS

    Byte array as the binary message.

.OUTPUTS

    Byte array containing the encrypted message.
#>
    Param (
        [Parameter(Mandatory = $True, Position = 0)][Byte[]]$BinaryMessage,
        [Parameter(Mandatory = $True, Position = 1)][Byte[]]$Key
    )

    $Result = New-Object Byte[] $BinaryMessage.Length

    $KeyOffset = 0
    for ($i = 0; $i -lt $($BinaryMessage.Length); $i++) {
        $Result[$i] = $BinaryMessage[$i] -bxor $Key[$keyOffset]
        $KeyOffset = ($KeyOffset + 1) % $Key.Length
    }

    $Result
}