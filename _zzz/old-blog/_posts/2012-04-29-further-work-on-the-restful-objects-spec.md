---
author: danhaywood
comments: true
date: 2012-04-29 15:47:32+00:00
layout: post
slug: further-work-on-the-restful-objects-spec
title: Further work on the Restful Objects spec.
wordpress_id: 964
tags:
- restful objects
---

The [Restful Objects spec](http://restfulobjects.org) - a hypermedia API for domain objects models - is getting ever closer to a v1.0.0 release.  Right now it's at [0.69.0 (pdf)](https://bitbucket.org/danhaywood/restfulobjects-spec/src/1b5e7960907a/restfulobjects-spec.pdf) (yes, there have actually been 69 versions, though some of the earliest ones are lost in the mists...)

<!-- more -->
Recent changes have brought in:



	
  * namespaced rel links

	
  * the concept of addressable view models (a key part of supporting conneg)

	
  * a slight change in the URL format so that the object's domain type is no longer considered opaque

        
  * deferral of some more advanced features such as paging and sorting and eager following of links (these will be added back in at a later date, for now they have moved to the 'discussions' chapters at the end)

	
  * [semantic versioning](http://semver.org) of the spec itself


There's a reasonably complete change history in the doc itself.

The current state of implementations varies.  [Restful Objects for .NET](http://restfulobjects.codeplex.com) has been tracking the spec closely, and is almost feature complete.  On the Java platform, [Restful Objects for Isis](http://incubator.apache.org/isis) (as I'm now calling it) hasn't moved on very much - it's still back at v0.56 or thereabouts.  Such time as I've had has been working on the spec itself, rather than the Isis implementation.

Anyway, any feedback welcome as ever.
