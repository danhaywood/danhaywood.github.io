---
author: danhaywood
comments: true
date: 2011-07-18 07:23:13+00:00
layout: post
slug: apache-isis-0-1-2-incubating-released
title: Apache Isis 0.1.2 (incubating) Released
wordpress_id: 790
tags:
- apache-isis
---

Finally... after 5 (count them) release candidates, and a pretty steep [learning curve](http://incubator.apache.org/isis/docbkx/html/guide/ch10.html), last week we finally released the first release of [Apache Isis](http://incubator.apache.org/isis) out of the [ASF incubator](http://incubator.apache.org/).

Apache Isis is a full-stack open source application development framework, designed to let you rapidly develop domain-driven business enterprise applications using the naked objects pattern. It's built with Maven and has a [quickstart archetype](http://incubator.apache.org/isis/quickstart-app.html) to get you going quickly:
<!-- more -->

    
    mvn archetype:generate  \
        -D archetypeGroupId=org.apache.isis \
        -D archetypeArtifactId=quickstart-archetype \
        -D groupId=com.mycompany \
        -D artifactId=myapp
    



This is the first release of Apache Isis, and comprises the initial take-on of the original Naked Objects Framework along with a number of sister projects developed for my book, [Domain Driven Design using Naked Objects](http://pragprog.com/titles/dhnako/domain-driven-design-using-naked-objects).

In addition, the release includes the [scimpi framework](http://incubator.apache.org/isis/viewer/scimpi/index.html), which provides a customizable web viewer (using JSF-like tags), and an initial version of a new [JSON viewer](http://incubator.apache.org/isis/viewer/json/index.html) (proving restful access to domain objects using JSON representations).  There is also an initial version of a [NoSQL object store](http://incubator.apache.org/isis/runtimes/dflt/objectstores/nosql/index.html), and improvements to the existing SQL object store.

Finally, there's an all-new website with lots of new documentation, and an all-new Maven archetype to get you going quickly.  See the website for the full [release notes](http://incubator.apache.org/isis/release-notes-0.1.2-incubating.html).

Some of the themes for the next release look out are improved documentation, Maven 3 support, improvements and extensions to the [Wicket viewer](http://incubator.apache.org/isis/viewer/wicket/index.html) and the [JSON viewer](http://incubator.apache.org/isis/viewer/json/index.html).  Now that we have a first release out, we're hoping to push out a new release every 6 weeks or so.
