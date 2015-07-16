---
title: '[ANN] Apache Isis version 1.7.0 Released'
slug: ann-apache-isis-version-1-7-0-released
author: danhaywood
comments: true
date: 2014-10-21 06:20:34+00:00
layout: post
wordpress_id: 1315
tags:
- announce
- apache-isis
- isisaddons
- java
---

We just pushed out Isis 1.7.0, which consists of:

* Apache Isis Core version 1.7.0
* Wicket Viewer 1.7.0
* SimpleApp Archetype 1.7.0
* ToDoApp Archetype 1.7.0

This was mostly a bug fix release, including as it did some security fixes raised by the community ([ISIS-883](https://issues.apache.org/jira/browse/ISIS-883), [ISIS-884](https://issues.apache.org/jira/browse/ISIS-884), [ISIS-895](https://issues.apache.org/jira/browse/ISIS-895)).  It did have a couple of new features in it though, notably:

- [ISIS-809](https://issues.apache.org/jira/browse/ISIS-809): `@ViewModel` annotation, no longer requiring explicit implementation of the `IViewModel` interface.
- [ISIS-916](https://issues.apache.org/jira/browse/ISIS-916): ability to override framework-provided services, such as `MementoService` or `BookmarkService`.
- [ISIS-917](https://issues.apache.org/jira/browse/ISIS-917): (beta): pluggable representations for the RO viewer

A lot of work was also done over in the [Isis add-ons](http://www.isisaddons.org) website, in particular the new isis-module-security add-on (see also [this previous post]({{ site.baseurl }}/2014/09/23/configuring-apache-isis-security-module-add-on/)).

Full [release](http://isis.apache.org/core/release-notes/isis-1.7.0.html) [notes](http://isis.apache.org/components/viewers/wicket/release-notes/isis-viewer-wicket-1.7.0.html) for the release are available on the [Isis website](http://isis.apache.org), as well as a [migration guide](http://isis.apache.org/core/release-notes/migrating-to-1.7.0.html).


