---
author: danhaywood
comments: true
date: 2012-01-04 11:04:25+00:00
layout: post
slug: updating-visual-studio-project-references-from-nuget-packages-config
title: Updating Visual Studio project references from NuGet packages.config
wordpress_id: 878
tags:
- nuget
- powershell
---

**UPDATE: a refined version of this can be found [here]({{ site.baseurl }}/2012/04/04/updating-visual-studio-project-references-from-nuget-packages-config-2/).**

(Among other things), NuGet offers an alternative way of managing project references in Visual Studio.

The usual flow is to right-click on References, and choose "Manage NuGet Packages".  The NuGet dialog then pops up, showing available packages.  Once you've selected a package, NuGet will:



	
  * download the package to your repository (if required)

	
  * update the VS project file (.csproj or .vbproj etc)

	
  * update its own packages.config file.


What if things get out-of-sync, though, eg you've moved your repository so that all the reference hints in the .csproj file are wrong?  It'd be nice to be able to use the info in the packages.config to automatically resync the .csproj file.

Here's one brute-force way to do this (from within the Package Manager console in VS):

<!-- more -->

[sourcecode language="powershell"]
get-project -all | %{
  $proj = $_ ;
  get-package -project $proj.name | %{
    uninstall-package -projectname $proj.name -id $_.id -version $_.version -RemoveDependencies -force ;
   install-package -projectname $proj.name -id $_.id -version $_.version
  }
}
[/sourcecode]

Actually, I have a suspicion there's a flag for one of the NuGet commands to do this much more simply; but my google-fu failed me on this occasion.  If you know of a better way, please comment below.
