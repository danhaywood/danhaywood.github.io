---
author: danhaywood
comments: true
date: 2012-09-20 10:03:38+00:00
layout: post
slug: eclipse-juno-jee-setup
title: Eclipse Juno JEE Setup
wordpress_id: 1036
tags:
- eclipse
- maven
- tdd
- tools
---

My installation of Eclipse Juno seemed to have got its knickers in rather a twist, so just spent a “happy” hour reinstalling the damn thing.

Anyway, here’s what my setup currently consists of:

<!-- more -->

  * Eclipse Juno JEE (download from [http://eclipse.org/downloads/](http://eclipse.org/downloads/))
  * eGit integration (update site, via [http://download.eclipse.org/releases/juno](http://download.eclipse.org/releases/juno))
  * M2E integration (update site, via [http://download.eclipse.org/releases/juno](http://download.eclipse.org/releases/juno))
  * DataNucleus (update site, via [http://www.datanucleus.org/downloads/eclipse-update](http://www.datanucleus.org/downloads/eclipse-update))
  * EclEmma (update site, via [http://update.eclemma.org/](http://update.eclemma.org/))
  * Jetty Runner (update site, via [http://run-jetty-run.googlecode.com/svn/trunk/updatesite](http://run-jetty-run.googlecode.com/svn/trunk/updatesite))
  * Easy Shell (download from [http://sourceforge.net/projects/pluginbox/files/latest/download?source=files](http://sourceforge.net/projects/pluginbox/files/latest/download?source=files))
  * Coffee Bytes / Isis IDE (update site, via [https://dl.dropbox.com/u/10536589/com.halware.nakedide.eclipse.site](https://dl.dropbox.com/u/10536589/com.halware.nakedide.eclipse.site))

In addition, there’s a bunch of templates and other settings for the workspace. I download these and then install using Windows > Preferences:

  * [http://incubator.apache.org/isis/ide/eclipse/isis.importorder](http://incubator.apache.org/isis/ide/eclipse/isis.importorder)
  * [http://incubator.apache.org/isis/ide/eclipse/templates/Apache-Isis-code-style-cleanup.xml](http://incubator.apache.org/isis/ide/eclipse/templates/Apache-Isis-code-style-cleanup.xml)
  * [http://incubator.apache.org/isis/ide/eclipse/templates/Apache-code-style-formatting.xml](http://incubator.apache.org/isis/ide/eclipse/templates/Apache-code-style-formatting.xml)
  * [http://incubator.apache.org/isis/ide/eclipse/templates/Apache-code-style-template.xml](http://incubator.apache.org/isis/ide/eclipse/templates/Apache-code-style-template.xml)
  * [http://incubator.apache.org/isis/ide/eclipse/templates/isis-templates.xml](http://incubator.apache.org/isis/ide/eclipse/templates/isis-templates.xml)
  * [http://incubator.apache.org/isis/ide/eclipse/templates/jmock2-templates.xml](http://incubator.apache.org/isis/ide/eclipse/templates/jmock2-templates.xml)
  * [http://incubator.apache.org/isis/ide/eclipse/templates/junit4-templates.xml](http://incubator.apache.org/isis/ide/eclipse/templates/junit4-templates.xml)

And that’s me good to go, close enough.
