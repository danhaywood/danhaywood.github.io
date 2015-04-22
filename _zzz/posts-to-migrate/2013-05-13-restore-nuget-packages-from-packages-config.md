---
author: danhaywood
comments: true
date: 2013-05-13 10:42:23+00:00
layout: post
slug: restore-nuget-packages-from-packages-config
title: Restore NuGet packages from packages.config
wordpress_id: 1165
tags:
- nuget
- powershell
---

Another in my [occasional]({{ site.baseurl }}/2013/04/24/updating-a-nuget-package-across-all-projects-in-visual-studio/) [series]({{ site.baseurl }}/2012/04/04/updating-visual-studio-project-references-from-nuget-packages-config-2/) of wrangling with NuGet within Visual Studio.

This one is to restore all packages from a packages.config file:

[sourcecode language="powershell"]
function Restore-Packages() {
  $proj = get-project
  get-package -project $proj.name | % {
    Write-Host $_.id;
    uninstall-package -projectname $proj.name -id $_.id -version $_.version -RemoveDependencies -force ;
    install-package -projectname $proj.name -id $_.id -version $_.version
  }
}

[/sourcecode]

To use, first edit the packages.config as you require. Then, in the Package Manager Console in VS (in the 'default project' dropdown set correctly), just type:

[sourcecode language="powershell"]
Restore-Packages
[/sourcecode]

Enjoy.
