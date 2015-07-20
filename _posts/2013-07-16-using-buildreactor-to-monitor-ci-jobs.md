---
author: danhaywood
comments: true
date: 2013-07-16 12:30:15+00:00
layout: post
slug: using-buildreactor-to-monitor-ci-jobs
title: Using buildreactor to monitor CI jobs
wordpress_id: 1189
tags:
- ci
- github
---

Following on from [yesterday's post](http://wp.me/p1JVoV-j4) (using travis-ci for github projects), I thought I'd use a Chrome plugin to monitor their status.  The one I chose was [buildreactor](https://chrome.google.com/webstore/detail/buildreactor/agfdekbncfakhgofmaacjfkpbhjhpjmp?hl=en) (itself [hosted on github](https://github.com/AdamNowotny/BuildReactor)).

Like Travis-CI, buildreactor is also ridiculously easy to configure.  Let me show you in pictures:

[![buildreactor-010]({{site.baseurl}}/images/buildreactor-010.png?w=300)]({{site.baseurl}}/images/buildreactor-010.png)

[![buildreactor-020]({{site.baseurl}}/images/buildreactor-020.png?w=604)]({{site.baseurl}}/images/buildreactor-020.png)

Once configured, the status is easily viewed (and buildreactor will also notify if a build fails:

[![buildreactor-030]({{site.baseurl}}/images/buildreactor-030.png?w=300)]({{site.baseurl}}/images/buildreactor-030.png)

I also was able to configure a separate account on travis-ci (for [Estatio](http://www.estatio.org)):

[![buildreactor-040]({{site.baseurl}}/images/buildreactor-040.png?w=300)]({{site.baseurl}}/images/buildreactor-040.png)

And I could also point buildreactor to our original [cloudbees CI](http://www.cloudbees.com/) for Estatio, running Jenkins:

[![buildreactor-050]({{site.baseurl}}/images/buildreactor-050.png?w=300)]({{site.baseurl}}/images/buildreactor-050.png)


