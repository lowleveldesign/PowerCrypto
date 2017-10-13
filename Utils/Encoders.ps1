function ConvertTo-Base64String {
<#
.SYNOPSIS

    Converts the byte array to the base64 encoded string.

    Author: Sebastian Solnica (@lowleveldesign)

.PARAMETER ByteArray

    The byte array to be encoded.

.OUTPUTS

    The base64 encoded string representing the input byte array.
#>

    [CmdletBinding()] Param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)][Byte[]]$ByteArray
    )

    BEGIN
    {
        $Buffer = @()
    }

    PROCESS {
        foreach ($Byte in $ByteArray) {
            $Buffer += $Byte
        }
    }

    END
    {
        [Convert]::ToBase64String($Buffer)
    }
}

function ConvertFrom-Base64String {
<#
.SYNOPSIS

    Converts the base64 encoded string to the byte array.

    Author: Sebastian Solnica (@lowleveldesign)

.PARAMETER InputString

    The base64 encoded string.

.OUTPUTS

    The byte array decoded from the base64 string.
#>

    [CmdletBinding()] Param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)][String]$InputString
    )

    BEGIN { }

    PROCESS {
        [Convert]::FromBase64String($InputString)
    }

    END { }
}

function ConvertTo-HexString {
<#
.SYNOPSIS

    Converts a byte array to its HEX representation.

.DESCRIPTION

    It is possible to pass the byte array through a pipeline.

.PARAMETER ByteArray

    A byte array to convert.

.EXAMPLE

    ConvertTo-Hex @(1,2,3)

.INPUTS

    Byte array

.OUTPUTS

    HEX representation of the array
#>

    [CmdletBinding()] Param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)][Byte[]]$ByteArray,
        [Switch]$Prefix = $False
    )

    BEGIN
    {
        $Buffer = @()
    }

    PROCESS {
        foreach ($Byte in $ByteArray) {
            $Buffer += $Byte
        }
    }

    END
    {
        $Hex = [Org.BouncyCastle.Utilities.Encoders.Hex]::ToHexString($Buffer)
        if ($Prefix) {
            "0x$Hex"
        } else {
            $Hex
        }
    }
}

function ConvertFrom-HexString {
<#
.SYNOPSIS

    Converts a HEX string to a byte array.

.DESCRIPTION

    It is possible to pass the HEX string through a pipeline.

.PARAMETER HexString

    A HEX string to convert.

.EXAMPLE

    ConvertFrom-Hex 010203

.INPUTS

    A HEX string.

.OUTPUTS

    Byte array represented by the HEX string.
#>
    [CmdletBinding()] Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)][string]$HexString
    )

    if ($HexString.StartsWith("0x", [StringComparison]::OrdinalIgnoreCase)) {
        $HexString = $HexString.Substring(2)
    } elseif ($HexString.EndsWith("h", [StringComparison]::OrdinalIgnoreCase)) {
        $HexString = $HexString.Substring(0, $HexString.Length - 1)
    }
    [Org.BouncyCastle.Utilities.Encoders.Hex]::Decode($HexString)
}

function ConvertTo-ByteArray {
<#
.SYNOPSIS

    Converts string to a byte array using a specified encoding.

.DESCRIPTION

    It is possible to pass the string through a pipeline.

.PARAMETER Text

    String to convert.

.EXAMPLE

    ConvertTo-ByteArray "test"

.INPUTS

    Any string.

.OUTPUTS

    Byte array representing a given string.
#>
    Param (
        [Parameter(Position = 0, ValueFromPipeline = $True)]
        [String]
        $Text,

        [Parameter(Position = 1)]
        [ValidateSet('ASCII', 'UTF8', 'UTF16', 'UTF32')]
        [String]
        $Encoding = 'UTF8'
    )

    if (!$Text) {
        return [Byte[]]@()
    }

    [Text.Encoding]::GetEncoding($($Encoding -replace 'UTF','UTF-')).GetBytes($Text)
}

function ConvertFrom-ByteArray {
<#
.SYNOPSIS

    Converts a byte array to a string using a specified encoding.

.DESCRIPTION

    It is possible to pass the byte array through a pipeline.

.PARAMETER ByteArray

    A byte array to encode.

.EXAMPLE

    ConvertFrom-ByteArray @(116,101,115,116)

.INPUTS

    A byte array.

.OUTPUTS

    A string represented by a given array.
#>
    Param (
        [Parameter(Position = 0, ValueFromPipeline = $True)]
        [Byte[]]
        $ByteArray,

        [Parameter(Position = 1)]
        [ValidateSet('ASCII', 'UTF8', 'UTF16', 'UTF32')]
        [String]
        $Encoding = 'UTF8'
    )

    if (!$ByteArray) {
        return ''
    }

    [Text.Encoding]::GetEncoding($($Encoding -replace 'UTF','UTF-')).GetString($ByteArray)
}
