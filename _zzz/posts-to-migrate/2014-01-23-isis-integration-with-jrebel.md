---
author: danhaywood
comments: true
date: 2014-01-23 12:31:36+00:00
layout: post
slug: isis-integration-with-jrebel
title: Isis integration with JRebel
wordpress_id: 1232
---

You probably know about [JRebel](http://zeroturnaround.com/software/jrebel/) already - it's a commercial product that dynamically reloads Java classes without having to redeploy your webapp.  [Not necessarily the cheapest](http://zeroturnaround.com/software/jrebel/) of products, but if you're a full-time dev working on the JVM, then it can easily pay for itself.   Oh, and it's [free for use on any hobby/open source projects](https://my.jrebel.com/).

JRebel itself is pluggable, and so for a while now I've been meaning to work on an integration with [Apache Isis](http://isis.apache.org).  Actually, invalidating Isis' metadata caches is pretty easy, the difficulty really arises in Isis' JDO/[DataNucleus](http://datanucleus.org) objectstore.

But, with a bit of experimentation, I've got what I think is a workable integration going, full details up on [github](https://github.com/danhaywood/isis-jrebel-plugin).

And if you just want to see what this means, take a look at this screencast (also available on the [the Isis website](http://isis.apache.org/getting-started/screencasts.html#jrebel)):

[youtube http://www.youtube.com/watch?v=PxVgbz3ae_g&w=560&h=315]

