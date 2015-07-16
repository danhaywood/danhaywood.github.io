---
author: danhaywood
comments: true
date: 2014-09-23 06:32:29+00:00
excerpt: 'I recently completed a new <a href="https://github.com/isisaddons/isis-module-security"
  target="_blank">security module</a> that handles both authentication and authorization
  for Isis apps. '
layout: post
slug: configuring-apache-isis-security-module-add-on
title: Configuring Apache Isis' Security Module Add-on
wordpress_id: 1309
tags:
- apache-isis
- isisaddons
- screencast
---

When v1.6 of [Apache Isis](http://isis.apache.org) was released a [month or two]({{ site.baseurl }}/2014/07/28/ann-apache-isis-version-1-6-0-released/) back we also announced the creation of a new ["add-ons"](http://www.isisaddons.org/) website as a place to hold reusable module of code for any Apache Isis app.

Working with [Jeroen](https://github.com/jcvanderwal) I recently completed a new [security module](https://github.com/isisaddons/isis-module-security) that handles both authentication and authorization for Isis apps. 

The screencast below explains how to get it configured; check out the module's [README](https://github.com/isisaddons/isis-module-security) for screenshots and more detailed discussion.

<iframe width="640" height="360" src="https://www.youtube.com/embed/bj8735nBRR4" frameborder="0" allowfullscreen></iframe>

This module should work with any Isis app, and can also co-exist alongside other authentication realms such as LDAP.  We're really happy with what we've ended up with, so do try it out.
