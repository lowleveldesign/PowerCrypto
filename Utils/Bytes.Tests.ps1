$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Bytes" {
    Context "Hamming Distance" {
        It "the Hamming distance between two one-byte strings" {
            $Message1 = [Text.Encoding]::ASCII.GetBytes('a')
            $Message2 = [Text.Encoding]::ASCII.GetBytes('b')
            Measure-HammingDistance $Message1 $Message2 | Should Be 2
        }

        It "the Hamming distance between two same strings" {
            $Message1 = [Text.Encoding]::ASCII.GetBytes('test')
            Measure-HammingDistance $Message1 $Message1 | Should Be 0
        }

        It "the Hamming distance between strings" {
            $Message1 = [Text.Encoding]::ASCII.GetBytes('this is a test')
            $Message2 = [Text.Encoding]::ASCII.GetBytes('wokka wokka!!!')
            Measure-HammingDistance $Message1 $Message2 | Should Be 37
        }

        It "the Hamming distance between strings with different lenghts" {
            $Message1 = [Text.Encoding]::ASCII.GetBytes('this is a test')
            $Message2 = [Text.Encoding]::ASCII.GetBytes('wokka wokka!!!!')
            { Measure-HammingDistance $Message1 $Message2 } | Should Throw "Arrays do not have the same length"
        }
    }
}
