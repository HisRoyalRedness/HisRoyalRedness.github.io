---
layout:     post
title:      Embedded DLLs as resources
date:       2016-04-02 23:35 +1300
summary:    Embedding references as resources so that you get a single file executable.
categories: c#
thumbnail:  code
tags:       c# resources
---

This will look for all references that have `Copy Local = True`, and will add them as embedded resources in the assembly. 
The main method must be `STAThread`. For console apps, start the app from an instance of a class (eg. `new Program().Start()`). 
If you put the app code in the static `Main()` method, or any other static method for that matter, references will attempt to 
load before you have the opportunity to extract them from the resources.


In the project file:

```xml
<Import Project="$(MSBuildToolsPath)\Microsoft.CSharp.targets" />
<Target Name="AfterResolveReferences">
  <ItemGroup>
    <EmbeddedResource S
        Include="@(ReferenceCopyLocalPaths)" 
        Condition="'%(ReferenceCopyLocalPaths.Extension)' == '.dll'">
      <LogicalName>%(ReferenceCopyLocalPaths.DestinationSubDirectory)%(ReferenceCopyLocalPaths.Filename)%(ReferenceCopyLocalPaths.Extension)</LogicalName>
    </EmbeddedResource>
  </ItemGroup>
</Target>
```

In code:

```c#
[STAThread]
static void Main(string[] args)
{

    var assemblies = new System.Collections.Generic.Dictionary<string, System.Reflection.Assembly>();
    var executingAssembly = System.Reflection.Assembly.GetExecutingAssembly();
    var resources = executingAssembly.GetManifestResourceNames().Where(n => n.EndsWith(".dll"));

    // Fetch assemblies from our resource stream
    foreach (string resource in resources)
    {
        using (var stream = executingAssembly.GetManifestResourceStream(resource))
        {
            if (stream == null)
                continue;

            var bytes = new byte[stream.Length];
            stream.Read(bytes, 0, bytes.Length);
            try
            {
                assemblies.Add(resource, System.Reflection.Assembly.Load(bytes));
                System.Diagnostics.Debug.Print("Fetched {0} from resources.", resource);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.Print(string.Format("Failed to load: {0}, Exception: {1}", resource, ex.Message));
            }
        }
    }

    AppDomain.CurrentDomain.AssemblyResolve += (s, e) =>
    {
        // First, try find the assembly for an exact match (probably ignoring namespace)
        var assemblyName = new System.Reflection.AssemblyName(e.Name);
        var path = string.Format("{0}.dll", assemblyName.Name);
        if (assemblies.ContainsKey(path))
        {
            System.Diagnostics.Debug.Print("Found {0} in our assembly cache.", path);
            return assemblies[path];
        }
        else
        {
            // Not found? Now try with a fuzzy match (probably accounting for namespace)
            System.Diagnostics.Debug.Print("First chance not finding {0}.", path);
            var candidate = assemblies.Keys.Where(k => k.EndsWith(path, StringComparison.CurrentCultureIgnoreCase)).FirstOrDefault();
            if (candidate != null)
            {
                System.Diagnostics.Debug.Print("Found {0} in our assembly cache (second chance).", path);
                return assemblies[path];
            }
            else
            {
                System.Diagnostics.Debug.Print("Could not find {0}.", path);
                return null;
            }
        }
    };
}
```