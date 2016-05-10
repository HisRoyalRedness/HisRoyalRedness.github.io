---
layout:     post
title:      NLog Cheat Sheet
date:       2016-04-02 23:47 +1300
summary:    Some NLog brain joggers.
categories: c#
thumbnail:  cogs
tags:       c# nlog
---

* TOC
{:toc}

# Log from app

```c#
readonly Logger _logger = NLog.LogManager.GetCurrentClassLogger();
```

# Log levels

  * **Trace** - very detailed logs, which may include high-volume information such as protocol payloads. This log level is typically only enabled during development
  * **Debug** - debugging information, less detailed than trace, typically not enabled in production environment.
  * **Info** - information messages, which are normally enabled in production environment
  * **Warn** - warning messages, typically for non-critical issues, which can be recovered or which are temporary failures
  * **Error** - error messages
  * **Fatal** - very serious errors

![NLog log levels in the console](/image/NLogLevels.png)

# NLog.config

```xml
<?xml version="1.0" encoding="utf-8" ?>
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <targets>
        <target
            name="logfile"
            xsi:type="File"
            fileName="file.log"
            layout="${longdate}|${pad:padding=5:inner=${level:uppercase=true}}|${message} ${onexception:${newline}  ${exception:format=ToString}}"
        />
        <target
            name="console"
            xsi:type="Console"
            layout="${longdate}|${pad:padding=5:inner=${level:uppercase=true}}|${message} ${onexception:${newline}  ${exception:format=ToString}}"
        />

        <target
            name="colourconsole"
            xsi:type="ColoredConsole"
            layout="${longdate}|${pad:padding=5:inner=${level:uppercase=true}}|${message} ${onexception:${newline}  ${exception:format=ToString}}"
            useDefaultRowHighlightingRules="true"
        >
            <!--<highlight-row backgroundColor="Enum" condition="Condition" foregroundColor="Enum"/>-->

            <highlight-word backgroundColor="Yellow" foregroundColor="Black" ignoreCase="false" text="ERROR" wholeWords="true" />
            <highlight-word backgroundColor="Red" foregroundColor="White" ignoreCase="false" text="FATAL" wholeWords="true" />

        </target>

    </targets>

    <rules>
        <logger name="*" minlevel="Info" writeTo="logfile" />
        <logger name="*" minlevel="Trace" writeTo="colourconsole" />
    </rules>
</nlog>
```
    
Remember to set the `Copy to Output Directory` property of the config file to `Copy if newer`.
    
# Exceptions

There are a number of exception overloads, but after NLog 4.0, exceptions need to appear before
other arguments

```c#
logger.Error(ex, "Oops, an exception occured");
```

# Useful NLog.config formats

Log exceptions:

```xml
<target 
    name="logfile" 
    xsi:type="File" 
    fileName="file.log" 
    layout="${longdate}|${level:uppercase=true}|${message} ${exception:format=tostring}" />
```

Log exceptions on a new line. Note the two spaces before ${exception} so that it is indented on its new line

```xml
<target 
    name="logfile" 
    xsi:type="File" 
    fileName="file.log" 
    layout="${longdate}|${level:uppercase=true}|${message} ${onexception:${newline}  ${exception:format=tostring}}" />
```


Default layout:

```xml
    ${longdate}|${level:uppercase=true}|${logger}|${message}
```

   
# Links
 
  * [Tutorial on GitHub](https://github.com/NLog/NLog/wiki/Tutorial)
  * [Renderers](https://github.com/NLog/NLog/wiki/Layout-renderers)


