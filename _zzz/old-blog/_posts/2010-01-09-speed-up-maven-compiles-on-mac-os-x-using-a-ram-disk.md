---
author: danhaywood
comments: true
date: 2010-01-09 20:25:18+00:00
layout: post
slug: speed-up-maven-compiles-on-mac-os-x-using-a-ram-disk
title: Speed up Maven compiles - maybe? - on Mac OS X using a Ram disk
wordpress_id: 487
---

_[POST UPDATED: using RamDiskSync instead of Esperance]_

_[POST UPDATED AGAIN: act in haste, repent at leisure.  A couple of comments have applauded the use of RamDisk here, but a couple more have asked for like for like testing.  So, having done so... it turns out that RamDisk doesn't make any appreciable difference after all for my builds.  I was so happy to see the faster builds compared to what I was used to, I rushed to conclude that RamDisk was making the difference and jumped to announce my "discovery" to the world!  That said, I still think that RamDiskSync is a great tool when you want to force disk pages to be memory resident.  On a dedicated build server where there is page swapping, for example, RamDiskSync could be just the ticket._

Still building my dev env on Mac OS X, and here's another trick that some googling around has thrown up: put the local Maven repo (in ~/.m2/repository) onto a Ram disk.

Doing this lets me build the complete [Naked Objects](http://nakedobjects.svn.sourceforge.net/svnroot/nakedobjects/framework/trunk) distribution in something just over 2 minutes; an order of magnitude faster than it was on my old XP box:<!-- more -->


[![Fast Maven builds using a RamDisk](http://farm5.static.flickr.com/4038/4259630765_0d4182abba.jpg)](http://www.flickr.com/photos/danhaywood/4259630765/)


It's easy enough to setup the RAM disk using either the diskutil UNIX command or a front-end such as the [Esperance](http://www.mparrot.net/) System Preferences plugin.  However, when the system is rebooted, the data will be lost.  That would be fine for a web cache, but not for our Maven local repo.

After some further googling around I found another System preferences plugin, [RamDiskSync](http://code.google.com/p/ramdisk-sync).  This also sets up a Ram disk, but also takes responsibility for sync'ing its contents back to a directory.

I started out by moving my ~/.m2/repository directory into ~/RamDisk/MavenLocalRepo directory:


    
    $ mv ~/.m2/repository ~/RamDisk/MavenLocalRepo



I also updated ~/.m2/settings.xml to specify the new location for the repository:


    
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
    
      <localRepository>/Users/dan/RamDisk/MavenLocalRepo</localRepository>
    
    </settings>
    



And then I setup the RamDisk, specifying that this directory be sync'ed:

[![Setting up a RamDisk using RamDiskSync](http://farm5.static.flickr.com/4014/4262204680_1f8ef3c451.jpg)](http://www.flickr.com/photos/danhaywood/4262204680/)

When the RamDisk is created, it moves the original directory to one side and creates a symlink to /Volumes/RamDisk/....  And when the disk is ejected, it copies the files back.

The one feature that seems to be missing is that no sync'ing occurs on a restart; you must remember to eject the disk first.  That's inconvenient, but I tend to sleep the Mac rather than restart anyway, so I can live with it I think.
