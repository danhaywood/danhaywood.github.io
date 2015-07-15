---
author: danhaywood
comments: true
date: 2008-07-21 23:21:00+00:00
layout: post
slug: maven-bundle-plugin-bundle-packaging-lifecycle
title: maven-bundle-plugin bundle packaging lifecycle
wordpress_id: 22
tags:
- maven
- java
---

In Maven the  element in the `pom.xml` corresponds to a lifecycle to use to build the code.  The lifecycle in turn comprises a number of phases, each of which is bound to goals provided by plugins.  (NB: since this is a 1:1 relationship we can use packaging and lifecycle interchangeably).  
  
The Maven defaults for lifecycles, phases and phase-to-goal bindings are in a file called component.xml.  For Maven 2.0.x this lives [here](http://svn.apache.org/repos/asf/maven/components/branches/maven-2.0.x/maven-core/src/main/resources/META-INF/plexus/components.xml).  
  
There are three lifecycles: 'default', 'clean' and 'site', the first being by far the most involved and including compilation, running tests etc.  More detail on Maven lifecycles [here](http://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html).  
  
It is also possible for Maven plugins to define their own lifecycle (as per the [Maven book](http://www.sonatype.com/book/reference/writing-plugins.html#d0e21193)), provided that they specify true.  So for example the maven-bundle-plugin does exactly this, defining a 'bundle' lifecycle.  The phases and goal bindings for this lifecycle are similar to the 'default' lifecycle.  See the maven-bundle-plugin's [components.xml here](http://svn.apache.org/repos/asf/felix/releases/maven-bundle-plugin-1.4.1/src/main/resources/META-INF/plexus/components.xml).
