@{
# Script module or binary module file associated with this manifest.
ModuleToProcess = 'PowerCrypto.psm1'

# Version number of this module.
ModuleVersion = '1.0.0.0'

# ID used to uniquely identify this module
GUID = '968c41dc-4216-4574-863d-59eab1cd309d'

# Author of this module
Author = 'Sebastian Solnica'

# Company or vendor of this module
CompanyName = ''

# Copyright statement for this module
Copyright = 'MIT'

# Description of the functionality provided by this module
Description = 'Contains various cryptographic functions.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '2.0'

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = @('Lib\BouncyCastle.Crypto.dll')

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = ''

# Functions to export from this module
FunctionsToExport = @('Protect-BinaryMessage',
                      'Unprotect-BinaryMessage',
                      'Get-MessageDigest',
                      'Get-Mac',
                      'Get-RepeatingXor',
                      'Measure-HammingDistance',
                      'ConvertTo-Base64String',
                      'ConvertFrom-Base64String',
                      'ConvertTo-HexString',
                      'ConvertFrom-HexString',
                      'ConvertTo-ByteArray',
                      'ConvertFrom-ByteArray',
                      'Format-HexPrettyPrint',
                      'Get-RandomBytes')

# Cmdlets to export from this module
CmdletsToExport = ''

# Variables to export from this module
VariablesToExport = ''

# Aliases to export from this module
AliasesToExport = ''

# List of all modules packaged with this module.
ModuleList = ''
}
