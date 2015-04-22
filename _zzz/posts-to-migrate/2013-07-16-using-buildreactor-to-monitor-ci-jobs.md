---
author: danhaywood
comments: true
date: 2013-07-16 12:30:15+00:00
layout: post
slug: using-buildreactor-to-monitor-ci-jobs
title: Using buildreactor to monitor CI jobs
wordpress_id: 1189
tags:
- buildreactor
- ci
- github
- travis
---

Following on from [yesterday's post](http://wp.me/p1JVoV-j4) (using travis-ci for github projects), I thought I'd use a Chrome plugin to monitor their status.  The one I chose was [buildreactor](https://chrome.google.com/webstore/detail/buildreactor/agfdekbncfakhgofmaacjfkpbhjhpjmp?hl=en) (itself [hosted on github](https://github.com/AdamNowotny/BuildReactor)).

Like Travis-CI, buildreactor is also ridiculously easy to configure.  Let me show you in pictures:

[![buildreactor-010](http://danhaywood.files.wordpress.com/2013/07/buildreactor-010.png?w=300)](http://danhaywood.files.wordpress.com/2013/07/buildreactor-010.png)

[![buildreactor-020](http://danhaywood.files.wordpress.com/2013/07/buildreactor-020.png?w=604)](http://danhaywood.files.wordpress.com/2013/07/buildreactor-020.png)

Once configured, the status is easily viewed (and buildreactor will also notify if a build fails):<!-- more -->

[![buildreactor-030](http://danhaywood.files.wordpress.com/2013/07/buildreactor-030.png?w=300)](http://danhaywood.files.wordpress.com/2013/07/buildreactor-030.png)

I also was able to configure a separate account on travis-ci (for [Estatio](http://www.estatio.org)):

[![buildreactor-040](http://danhaywood.files.wordpress.com/2013/07/buildreactor-040.png?w=300)](http://danhaywood.files.wordpress.com/2013/07/buildreactor-040.png)

And I could also point buildreactor to our original [cloudbees CI](http://www.cloudbees.com/) for Estatio, running Jenkins:

[![buildreactor-050](http://danhaywood.files.wordpress.com/2013/07/buildreactor-050.png?w=300)](http://danhaywood.files.wordpress.com/2013/07/buildreactor-050.png)


