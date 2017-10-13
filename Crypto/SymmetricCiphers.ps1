
function CallCipherEngine {
    [CmdletBinding()]Param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True, Position = 0)]
        [Byte[]]
        $BinaryMessage,
        [Parameter(Mandatory = $True)]
        [Byte[]]
        $Key,
        [Parameter(Mandatory = $False)]
        [Byte[]]
        $InitializationVector,
        [Parameter(Mandatory = $True)]
        [String]
        $Cipher,
        [Parameter(Mandatory = $True)]
        [String]
        $CipherMode,
        [Parameter(Mandatory = $True)]
        [String]
        $CipherPadding,
        [Parameter(Mandatory = $True)]
        [Boolean]
        $ForEncryption
    )

    $CipherEngine = [Org.BouncyCastle.Security.CipherUtilities]::GetCipher("$Cipher/$CipherMode/$CipherPadding")

    if ($CipherMode -ne "ECB" -and !$InitializationVector) {
        throw [ArgumentException]"Initialization vector is required for all modes except ECB"
    }

    $CipherParameters = New-Object Org.BouncyCastle.Crypto.Parameters.KeyParameter(,$Key)
    if ($CipherMode -ne "ECB") {
        $CipherParameters = New-Object -TypeName Org.BouncyCastle.Crypto.Parameters.ParametersWithIV($CipherParameters,$InitializationVector)
    }

    $CipherEngine.Init($ForEncryption, $CipherParameters)

    $OutputBytes = New-Object Byte[] $($CipherEngine.GetOutputSize($BinaryMessage.Length))

    $OutputOffset = $CipherEngine.ProcessBytes($BinaryMessage, $OutputBytes, 0)
    $OutputOffset = $OutputOffset + ($CipherEngine.DoFinal($OutputBytes, $OutputOffset))

    $OutputBytes[0..$($OutputOffset - 1)]
}

function Protect-BinaryMessage {
<#
.SYNOPSIS

    Encrypts the provided message.

    Author: Sebastian Solnica (@lowleveldesign)
    Requires: BouncyCastle

.DESCRIPTION

    Uses the chosen symmetric cipher to encrypt the provided message.

.PARAMETER BinaryMessage

    The binary message to be encrypted.

.PARAMETER Key

    The key that should be used for encryption (the size must be 
    compatible with the chosen algorithm).

.PARAMETER InitializationVector

    The initialization vector which will be used during encryption 
    (not required for ECB mode).

.PARAMETER Cipher

    The symmetric cipher to be used (by default AES).

.PARAMETER CipherMode

    The cipher mode of operation (by default CBC).
      
.EXAMPLE

    Protect-BinaryMessage $MyMessage $MyKey -Cipher AES -CipherMode ECB

.INPUTS

    Byte array as the binary message.

.OUTPUTS

    Byte array containing the encrypted message.
#>
    [CmdletBinding()]Param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True, Position = 0)]
        [Byte[]]
        $BinaryMessage,
        [Parameter(Mandatory = $True, Position = 1)]
        [Byte[]]
        $Key,
        [Parameter(Mandatory = $False, Position = 2)]
        [Byte[]]
        $InitializationVector,
        [ValidateSet("AES", "3DES")]
        [String]
        $Cipher = "AES",
        [ValidateSet("ECB", "CBC", "OFB", "CFB", "CTR")]
        [String]
        $CipherMode = "CBC",
        [ValidateSet("NOPADDING", "PKCS1", "PKCS5", "PKCS7")]
        [String]
        $CipherPadding = "PKCS7"
    )

    CallCipherEngine -BinaryMessage $BinaryMessage -Key $Key -InitializationVector $InitializationVector `
        -Cipher $Cipher -CipherMode $CipherMode -CipherPadding $CipherPadding -ForEncryption $True
}


function Unprotect-BinaryMessage {
<#
.SYNOPSIS

    Decrypts the provided cipher text.

    Author: Sebastian Solnica (@lowleveldesign)
    Requires: BouncyCastle

.DESCRIPTION

    Uses the chosen symmetric cipher to decrypt the provided cipher text.

.PARAMETER CipherText

    The cipher text to decrypt.

.PARAMETER Key

    The key that should be used for decryption (the size must be 
    compatible with the chosen algorithm).

.PARAMETER InitializationVector

    The initialization vector which will be used during decryption 
    (not required for ECB mode).

.PARAMETER Cipher

    The symmetric cipher to be used (by default AES).

.PARAMETER CipherMode

    The cipher mode of operation (by default CBC).

.PARAMETER CipherPadding

    The padding used during encryption.
      
.EXAMPLE

    Unprotect-BinaryMessage $MyCipherText $MyKey -Cipher AES -CipherMode ECB

.INPUTS

    Byte array as the cipher text.

.OUTPUTS

    Byte array containing the decrypted message.
#>
    Param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True, Position = 0)]
        [Byte[]]
        $CipherText,
        [Parameter(Mandatory = $True, Position = 1)]
        [Byte[]]
        $Key,
        [Parameter(Mandatory = $False, Position = 2)]
        [Byte[]]
        $InitializationVector,
        [ValidateSet("AES", "3DES")]
        [String]
        $Cipher = "AES",
        [ValidateSet("ECB", "CBC", "OFB", "CFB", "CTR")]
        [String]
        $CipherMode = "CBC",
        [ValidateSet("NOPADDING", "PKCS1", "PKCS5", "PKCS7")]
        [String]
        $CipherPadding = "PKCS7"
    )

    CallCipherEngine -BinaryMessage $CipherText -Key $Key -InitializationVector $InitializationVector `
        -Cipher $Cipher -CipherMode $CipherMode -CipherPadding $CipherPadding -ForEncryption $False
}