---
author: danhaywood
comments: true
date: 2013-01-28 12:58:28+00:00
layout: post
slug: apache-isis-now-has-shiro-integration-for-security
title: Apache Isis now has Shiro integration for security
wordpress_id: 1085
tags:
- apache isis
- apache shiro
- java
---

Hot on the heels of [Isis' first release]({{ site.baseurl }}/2013/01/24/apache-isis-release-v1-0-0/) as an [Apache top-level project]({{ site.baseurl }}/2013/01/12/apache-isis-graduates-as-a-top-level-apache-project-gets-a-new-website/), we've now released a new security component that integrates with [Apache Shiro](http://shiro.apache.org).

At the same time, we've updated [our Maven archetype](http://isis.staging.apache.org/getting-started/quickstart-archetype.html) (that combines Wicket, Restful and JDO) to incorporate this new Shiro security component.<!-- more -->

The Maven archetype has also been simplified so that there is now just a single webapp that hosts both the Wicket viewer and the RestfulObjects viewer.  There's also a new welcome page to help you get started and start refactoring the app towards your own requirements.

Give it a whirl!
