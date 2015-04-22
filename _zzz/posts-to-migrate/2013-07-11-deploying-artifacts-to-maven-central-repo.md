---
author: danhaywood
comments: true
date: 2013-07-11 09:45:16+00:00
layout: post
slug: deploying-artifacts-to-maven-central-repo
title: Deploying artifacts to Maven central repo
wordpress_id: 1177
tags:
- git
- github
- gpg
- how-to
- mac
- maven
- msysgit
- sourcetree
---

I have a [bunch of open source github repos](https://github.com/danhaywood?tab=repositories), mostly related to [Apache Isis](http://isis.apache.org), and have been exploring how to deploy these artifacts up to Maven central repo. It's a mostly straightforward process, but I hit a few bumps along the way so thought I'd capture them here.

First, my dev setup is a bit unusual: I run Windows 7 in a Parallels VM on top of an old MacBook Pro. The MBP has an SSD and 8Gb RAM, so the performance is good enough for me, and - even though I really dislike the MacOS UI, it is comforting to know that I have native Unix environment to jump back to.

In my Win7 VM, I use github's fork of msysgit as my shell; in other words, Unix on top of Windows on top of Unix. Yeah, a bit weird, it works for me.

Anyway, back to the point. To deploy these repositories into Maven, <!-- more -->I used Sonatype's OSS service. This has a well written [user guide](https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide), so I won't repeat all the details here. A few things to note though:



	
  * per [step 3 of the guide](https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide#SonatypeOSSMavenRepositoryUsageGuide-3.CreateaJIRAticket), I created JIRA tickets for all my repositories, because the Maven groupId of their POMs are different. They are, however, all grouped under com.danhaywood. The Sonatype guy closed all of these bar one, and changed the groupId to just com.danhaywood. So, if you have a similar setup, just specify a top-level groupId corresponding to your domain name

	
  * per [step 5](https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide#SonatypeOSSMavenRepositoryUsageGuide-7a.3.StageaRelease), I created a new gpg signing key. I do actually have one of these as an Apache committer, but decided it would be wrong to reuse this key for my own projects. But I did reuse the [process to create a key](http://isis.apache.org/contributors/key-generation.html), as documented on the Apache Isis website. I also uploaded this key to the pgp.mit.edu key server (gpg --send-keys --keyserver pgp.mit.edu nnnnnnnn), and it seemed to sync automatically to the server (hkp://pool.sks-keyservers.net/) that OSS Sonatype uses

	
  * per [step 6](https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide#SonatypeOSSMavenRepositoryUsageGuide-6.CentralSyncRequirement), I updated my POMs to be parented by the sonatype parent POM, and added in the missing SCM entry, license and other tags. Because I use github's [windows credentials helper](https://gitcredentialstore.codeplex.com/), I used the https:// connection URL rather than the SSH git: URL that is [suggested in the guide](https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide#SonatypeOSSMavenRepositoryUsageGuide-7a.1.POMandsettingsconfig).

	
  * Also in the pom.xml, I added in plugin definitions for maven-source-plugin and maven-javadoc-plugin (to generate the -source.jar and -javadoc.jar JARs), and updated the jar-plugin configuration (to generate a -test.jar). You can see an example pom.xml for one of my projects [here](https://github.com/danhaywood/java-testsupport/blob/49b9236dba82abb303f125245cfc49059745685c/pom.xml).

	
  * per [step 7a2](https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide#SonatypeOSSMavenRepositoryUsageGuide-7a.2.PublishSnapshots), I did a trial deploy of my snapshots using mvn clean deploy. This "just worked", no mucking about.

	
  * per [step 7a3](https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide#SonatypeOSSMavenRepositoryUsageGuide-7a.3.StageaRelease), I then moved onto performing an actual release, using mvn release:clean release:prepare, followed by mvn release:perform.  For the simple projects (not Maven multi-modules), eg [java-testsupport](https://github.com/danhaywood/java-testsupport) and [isis-wicket-excel](https://github.com/danhaywood/isis-wicket-excel), this also "just worked".  
        

        
  * After uploading the artifacts, I logged onto the staging repositories tab of the [Sonatype OSS Nexus](https://oss.sonatype.org/index.html#stagingRepositories), and closed and staged the repos.   Again [as documented](https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide#SonatypeOSSMavenRepositoryUsageGuide-9.ActivateCentralSync) in the guide, after I released the first artifact I updated the JIRA ticket I had raised, and Sonatype setup automatic syncing.  A couple of hours later, as promised, my first artifacts [appeared on Maven Central Repo](http://search.maven.org/#search%7Cga%7C1%7Cdanhaywood).



So far so very good.  However, things started going wrong when I tried to release my Maven multi-module projects ([isis-wicket-gmap3](https://github.com/danhaywood/isis-wicket-gmap3) and [isis-wicket-wickedcharts](https://github.com/danhaywood/isis-wicket-wickedcharts)).  The issue I hit was an error in git-add: "C:\...\applib\pom.xml is outside repository".  Other's have been here before me, most notably [SCM-667](https://jira.codehaus.org/browse/SCM-667) and [MRELEASE-581](http://jira.codehaus.org/browse/MRELEASE-581).  Although the first issue says it is fixed, the second is not.  A patch submitted by Mark Struberg (one of Apache Isis' mentors while in the incubator) doesn't seem to have been applied.

Some googling around found others still complaining of the problem, too.  The workaround suggested on [this blog post](http://gibaholms.wordpress.com/category/java/maven/) (to use cmd.exe rather than msysgit), didn't work for me.  Nor did a similar suggestion to carefully ensure that the drive letter was uppercased (C:\...) rather than the lowercase default (c:\...).

So, I decided it was time to fallback to my native Mac OS... after all, most of these tools are developed on *nix, and the issue I was hitting was clearly Windows related.  Of course, what that meant was configuring my Mac environment.

First thing I did was to setup the Mac OS equivalent of the windows-credential-store utility.  According to [this page](https://help.github.com/articles/set-up-git#platform-mac) on github, this is built into git 1.7.x and beyond, by running git credential-osxkeychain.  However, when I ran this I got a segfault (signal 11).  I said my MBP is quite old ... I haven't upgraded from Snow Leopard (OSX 10.6).  So I could imagine some sort of issue here.  Once more others have been here before, so I did what is suggested in this [stackoverflow question](http://stackoverflow.com/questions/14272634/error-git-credential-osxkeychain-died-of-signal-11), and downloaded and installed an update of the git-credential-osxkeychain helper (as per the [github page](https://help.github.com/articles/set-up-git#platform-mac) again).  W00t! that sorted out that issue.

Next thing I did was to download Atlassian's [SourceTree](http://www.sourcetreeapp.com/).  On Windows SourceTree is unusably slow, but on MacBook it seems quite fast enough.  And installing it got me an updated version of git on my $PATH.  I then cloned my two troublesome github repos onto my MacBook.  I pushed a dummy update to one of them in order that my github credentials would be stored.

Next thing was to install gpg on my MacBook.  I downloaded from [gpgtools.org](https://gpgtools.org/installer/index.html) and installed; that got me gpg on my $PATH.  Back on my Win7 VM, I exported my secret key, using gpg --export-secret-key NNNNNNNN > NNNNNNNN.secret.asc, and then imported into my MacBook's store using the gpgtool's UI (GPG Keychain Access).

After all that palava, it was, once more, time to attempt the mvn release:clean mvn release:prepare, mvn release:perform.  And you know what?  This time it worked.  Double w00t!

So, after reading all that, if you are stuck on Windows and hit the same git-add issue, my suggestion would be to do the release on *nix.  For example, use something like [VirtualBox](https://www.virtualbox.org/) to run up a [Ubuntu](http://www.ubuntu.com/) VM, and just use it for doing the releases.  A bit clunky, but should get you there.

And finally: my thanks to Sonatype for offering the OSS staging service.  I guess it's in their interest to drive adoption of Maven; even so, it's pretty cool that they offer it for free.  Also, it didn't take anywhere like 2 business days for my JIRA tickets to be approved... more like a couple of hours. 
