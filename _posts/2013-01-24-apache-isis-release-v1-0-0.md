---
author: danhaywood
comments: true
date: 2013-01-24 12:39:50+00:00
layout: post
slug: apache-isis-release-v1-0-0
title: Apache Isis release v1.0.0
wordpress_id: 1083
tags:
- announce
- isis
- java
---

Following on from [recent graduation]({{ site.baseurl }}/2013/01/12/apache-isis-graduates-as-a-top-level-apache-project-gets-a-new-website/) as an Apache top level project and the work we've done since (new website, [moving to git]({{ site.baseurl }}/2013/01/16/apache-isis-sourcemoves-to-git/), [semantic versioning]({{ site.baseurl }}/2013/01/20/apache-isis-codebase-refactored-adopting-semantic-versioning)), I'm proud to announce that Isis 1.0.0 has been released.

In fact, the news is a little old by now; we [got the release out just in time for Xmas 2012](https://blogs.apache.org/isis/entry/ann_apache_isis_1_0), which had always been my hope.  

This first release consists of:

* Isis core 1.0.0
* Isis JDO ObjectStore 1.0.0, based on [JDO/DataNucleus](http://www.datanucleus.org/) 3.1.x
* Isis File-based security 1.0.0, providing simple authentication and authorization
* Isis Wicket Viewer 1.0.0, providing a generic (naked objects) UI as a webapp, based on [Apache Wicket](http://wicket.apache.org) 6.2.0
* Isis Restful Objects Viewer 1.0.0, providing a generic RESTful interface, based on [JBoss RestEasy](http://www.jboss.org/resteasy) 2.3.1

More information about these on the [Isis website](http://isis.apache.org/documentation.html).

In addition, we [released a new Maven archetype](http://isis.apache.org/getting-started/quickstart-archetype.html) that combines all the above components into a single archetype.  Thus, with one command, you can have a complete Isis webapp built, already integrating the Wicket or Restful viewers through to an RDBMS-based objectstore.

So, do take a moment to check it out.
