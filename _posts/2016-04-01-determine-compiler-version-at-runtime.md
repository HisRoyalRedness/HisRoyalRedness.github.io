---
layout:     post
title:      Determine the compiler version at compile time
date:       2016-04-01 18:42 +1300
summary:    Conditionally compile portions of code depending on the compiler version.
categories: c#
thumbnail:  cogs
tags:       c# compiler
---


Add the following to the project file

```xml
  <PropertyGroup>
    <DefineConstants>NETFX$(TargetFrameworkVersion.Replace("v", "").Replace(".", "_"));$(DefineConstants)</DefineConstants>
  </PropertyGroup>
```

This will define `NETFX4_6`, `NETFX4_5_2` etc. for the framework versions 4.6 and 4.5.2.

You can then selectively compile code based on compiler version 

```c#
    #if NETFX4_6
        Console.WriteLine("Ver 4.6");
    #endif
    #if NETFX4_5_2
        Console.WriteLine("Ver 4.5.2");
    #endif
    #if NETFX4_5_1
        Console.WriteLine("Ver 4.5.1");
    #endif
```
