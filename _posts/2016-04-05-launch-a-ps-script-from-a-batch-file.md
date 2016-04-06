---
layout:     post
title:      Launch a PS script from a batch file
date:       2016-04-05 12:58 +1300
summary:    Launch a PS script from a batch file.
categories: powershell
thumbnail:  cogs
tags:       powershell script batch
---

Add the following to the project file

```powershell
@echo off
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dpn0.ps1'"
```

This expects a .ps1 file to be in the same directory as the batch file, with the same base file name.

It's probably also handy to add the following to the Powershell script, so that errors or messages are visible.

```powershell
# If running in the console, wait for input before closing.
if ($Host.Name -eq "ConsoleHost")
{ 
    Write-Host "Press any key to continue..."
    # Make sure buffered input doesn't "press a key" and skip the ReadKey().
    $Host.UI.RawUI.FlushInputBuffer()
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}
```
