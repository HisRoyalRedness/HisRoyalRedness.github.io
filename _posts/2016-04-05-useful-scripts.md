---
layout:     post
title:      Useful PowerShell scripts
date:       2016-04-05 20:57 +1300
summary:    A random collection os useful scripts.
categories: powershell
thumbnail:  cogs
tags:       powershell script
---

# Signing powershell scripts

##### Extracted from an blog post by [Scott Hanselman][1]

Create a Local Certificate Authority certificate

```
  makecert -n "CN=PowerShell Local Certificate Root" -a sha1 -eku 1.3.6.1.5.5.7.3.3 -r -sv root.pvk root.cer -ss Root -sr localMachine
```

Make a personal certificate from the previously created root certificate

```
  makecert -pe -n "CN=PowerShell User" -ss MY -a sha1 -eku 1.3.6.1.5.5.7.3.3 -iv root.pvk -ic root.cer
```

Verify the certificates in PowerShell

```powershell
Get-ChildItem cert:\CurrentUser\My -codesign
```

Sign a script

```powershell
Set-AuthenticodeSignature c:\foo.ps1 @(Get-ChildItem cert:\CurrentUser\My -codesign)[0]
```


# Hash tables

##### Content shamelessly stolen from [SS64][2]

Initialise the Hash Table

```powershell
$array_name = @{key1 = item1; key2 = item2;...} 
# Keep fields ordered with [Ordered]
$array_name = [Ordered]@{key1 = item1; key2 = item2;...}
```

Add items to a Hash Table

```powershell
$usa_states.Add("GA", "Goregia")
```

Edit items in a Hash Table

```powershell
$usa_states.Set_Item("GA", "Georgia")
```

Combine Hash Tables

```powershell
$world_states = $usa_states + $india_states
```

Remove items from a Hash Table

```powershell
$usa_states.Remove("GA")
```

Retrieve items from a Hash Table by key

```powershell
$usa_states.'NY'
```

# Miscellaneous

Return the value of a regular expression match

```powershell
get-content SomeTarget.txt | ([regex]"<pattern_text>").Matches($_) | 
    % { $_.Value }
```

Create a custom object from a pipeline

```powershell
get-childitem SomeFolder | 
    % { new-object psobject -property @{ Col1 = 1; Col2 = 2 } }
# Create an ordered hash table
get-childitem SomeFolder | 
    % { new-object psobject -property ([Ordered]@{ Col1 = 1; Col2 = 2 }) }
```

Suppress type info from CSV files

```powershell
$SomeData | export-csv target.csv -NoTypeInformation
```


Stop on the first error

```powershell
$ErrorActionPreference = "Stop";
```

[1]: http://www.hanselman.com/blog/SigningPowerShellScripts.aspx
[2]: http://ss64.com/ps/syntax-hash-tables.html