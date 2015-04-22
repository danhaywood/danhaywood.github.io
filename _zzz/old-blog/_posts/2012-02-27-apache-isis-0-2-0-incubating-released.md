---
author: danhaywood
comments: true
date: 2012-02-27 08:36:48+00:00
layout: post
slug: apache-isis-0-2-0-incubating-released
title: Apache Isis 0.2.0-incubating released
wordpress_id: 928
tags:
- apache isis
- domain driven design
---

Just a quick announcement that last week we put out our second release of [Apache Isis](http://incubator.apache.org/isis) from the incubator, namely 0.2.0-incubating.



The main theme in this release is to try to simplify things a little, so that would-be users can more easily grok what Isis is about:
<!-- more -->



	
  * We've updated the website, hopefully explaining better what Isis is and what use cases it hits.

	
  * we now have the [online demo](http://mmyco.co.uk:8180/isis-onlinedemo) linked directly from the website.

	
  * the archetype has also been reworked; rather than have a module for each of the viewers, we've reduced the number of viewers (just HTML viewer and JSON viewer) and put them into a single webapp module.





You can read full release notes [here](http://incubator.apache.org/isis/release-notes-0.2.0-incubating.html).



And, as for all Isis releases, the release can be found in the [Maven central repo](http://search.maven.org), you can use the Maven archetype to create a [quickstart app](http://incubator.apache.org/isis/quick-start.html), or you can [download the release](http://incubator.apache.org/isis/downloads.html) and build it from source.



By the way, work is well under way on the next release, where the plan is to re-introduce the Scimpi viewer to the archetype, and also to bring in NoSQL (MongoDB) support.

