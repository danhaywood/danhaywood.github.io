---
author: danhaywood
comments: true
date: 2013-02-07 15:14:32+00:00
layout: post
slug: apache-isis-core-1-1-0-isis-shiro-security-1-1-0-isis-wicket-viewer-1-1-0
title: Apache Isis Core 1.1.0, Isis Shiro Security 1.1.0, Isis Wicket Viewer 1.1.0
wordpress_id: 1096
tags:
- announce
- isis
- shiro
- wicket
- gmap3
- java
---

A few days ago we pushed out a new point release of [Apache Isis](http://isis.apache.org) Core (v1.1.0), along with two of its components Isis Shiro Security (v1.1.0) and the Isis Wicket Viewer (v1.1.0).  The Quickstart Archetype that combines Wicket, Shiro, Restful and JDO also got an update (v1.0.2).

New and notable features in this release are:

  * upload/download of files in the Wicket viewer
  * support for bulk actions in the Wicket viewer
  * improved extensibility of Wicket viewer (eg for gmap3 support)
  * support for LDAP authorization through a Shiro Realm implementation

Full release notes are of course available on the [Isis website](http://isis.apache.org).

You might also want to check out a companion [github repo](https://github.com/danhaywood/isis-wicket-gmap3) that I set up for the gmap3 support.  This will allow you to customize the Wicket UI.

UPDATE: the gmap3 component has moved to [Isis addons](http://isisaddons.org).
