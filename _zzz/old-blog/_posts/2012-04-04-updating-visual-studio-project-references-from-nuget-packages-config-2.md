---
author: danhaywood
comments: true
date: 2012-04-04 14:22:33+00:00
layout: post
slug: updating-visual-studio-project-references-from-nuget-packages-config-2
title: Updating Visual Studio project references from NuGet packages.config (2)
wordpress_id: 960
tags:
- how-to
- nuget
- powershell
---

Here's a small refinement to the script I wrote a while back to update VS project references from the packages.config file:

[sourcecode language="powershell"]
function Sync-References([string]$PackageId) {
  get-project -all | %{
    $proj = $_ ;
    Write-Host $proj.name; 
    get-package -project $proj.name | ? { $_.id -match $PackageId } | % { 
      Write-Host $_.id; 
      uninstall-package -projectname $proj.name -id $_.id -version $_.version -RemoveDependencies -force ;
      install-package -projectname $proj.name -id $_.id -version $_.version
    }
  }
}
[/sourcecode]

You can then use it to update selected packages, eg:

[sourcecode language="powershell"]
Sync-References FluentAssertions
[/sourcecode]

