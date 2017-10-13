
function AreByteArraysEqual {
    Param (
        [Byte[]]$Array1,
        [Byte[]]$Array2
    )

    if ($Array1.Length -ne $Array2.Length) {
        $False
    }

    $AllEqual = $True
    for ($i = 0; $i -lt $Array1.Length; $i++) {
        if ($Array1[$i] -ne $Array2[$i]) {
            $AllEqual = $False
            break
        }
    }
    $AllEqual
}
