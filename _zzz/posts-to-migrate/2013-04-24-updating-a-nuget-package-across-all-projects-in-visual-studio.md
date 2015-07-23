---
author: danhaywood
comments: true
date: 2013-04-24 15:08:48+00:00
layout: post
slug: updating-a-nuget-package-across-all-projects-in-visual-studio
title: Updating a NuGet package across all projects in Visual Studio
wordpress_id: 1133
tags:
- how-to
- nuget
- powershell
---

A little while back I did a [couple]({{ site.baseurl }}/2012/04/04/updating-visual-studio-project-references-from-nuget-packages-config-2/) of [posts]({{ site.baseurl }}/2012/01/04/updating-visual-studio-project-references-from-nuget-packages-config/) how to force a reinstall of all references in a Visual Studio from the NuGet packages.config.

A similar requirement is to update a package to its latest version, across all projects.  Here's how:

[sourcecode language="powershell"]
function Update-Package-All([string]$PackageId) {
  get-project -all | %{
    $proj = $_ ;
    Write-Host $proj.name; 
    get-package -project $proj.name | ? { $_.id -match $PackageId } | % { 
      Write-Host $_.id; 
      uninstall-package -projectname $proj.name -id $_.id -version $_.version -RemoveDependencies -force ;
      install-package -projectname $proj.name -id $_.id
    }
  }
}
[/sourcecode]

You can then just use:

[sourcecode language="powershell"]
Update-Package-All "FluentAssertions"
[/sourcecode]

Or whatever.
