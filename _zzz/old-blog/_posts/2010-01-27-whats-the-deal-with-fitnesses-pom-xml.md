---
author: danhaywood
comments: true
date: 2010-01-27 23:11:32+00:00
layout: post
slug: whats-the-deal-with-fitnesses-pom-xml
title: What's the deal with FitNesse's pom.xml?
wordpress_id: 500
---

I've started work on moving [Tested Objects'](http://testedobjects.sourceforge.net) FitNesse support onto the latest version of [FitNesse](http://fitnesse.org), using the new SLIM protocol.

Now for the previous version I manually installed the fitnesse.jar into my local Maven repository and also scp'ed it up to the [release repository](http://starobjects.sourceforge.net/m2-repo/release)  on [StarObjects](http://starobjects.sourceforge.net).  This time round I looked a little more closely and was delighted to discover a Maven pom.xml.  "Great", thought I, "all I need to do is a quick 'mvn clean install' and I'll be good".

Er, no.
<!-- more -->
It turns out that FitNesse's Maven pom.xml, even though it sits there nice and sweet at the base of the [downloaded](http://github.com/unclebob/fitnesse/downloads) source tree, has a bunch of problems with it:




  * first, it fails its tests.  Okay, only one test fails, but that's not a good start for a release version of a testing library



  * second, it depends upon org.json:json:1.0 as a system dependency (in lib/json.jar).  Why is this a system dependency?  And what is 1.0 anyway?  Looking at the central Maven repository, the latest version is org:json:json:20090211.



  * third, I checked the file sizes and the json.jar that comes with FitNesse is not the same as any of the three versions up on central Maven repo.  There is no source code around either for this json.jar; so basically FitNesse as distributed seems to depend on byte code for which no obvious source exists.



  * fourth, the JAR created by Maven does not contain as the binary distribution.  For example, the aforementioned json classes are present in the binary distribution (which itself is somewhat suspect) but are missing in the Maven JAR.



  * fifth (somewhat more trivially), it could benefit from a maven-source-plugin to ZIP up the source code.





Like many people I'm a great admirer of Uncle Bob's writings - he gets several mentions in my book, and for good reason.   And trust me, being a committer on Naked Objects and its sister projects I do appreciate how hard it is to get code distributed properly.  But might I humbly suggest that Uncle B removes this damnable pom.xml until he gets it working properly?
