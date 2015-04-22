---
author: danhaywood
comments: true
date: 2011-09-04 22:30:46+00:00
layout: post
slug: more-on-the-restful-objects-spec
title: More on the Restful Objects spec
wordpress_id: 815
tags:
- restful objects
---

[caption id="" align="alignright" width="300" caption="Resources and Representations"]![](http://restfulobjects.files.wordpress.com/2011/09/resource-representations-0-22.png?w=300&h=294)[/caption]

Been continuing to work on the Restful Objects spec, which aims to defines a set of RESTful resources, and corresponding JSON representations, for accessing and manipulating a domain object model.

I've just uploaded the current draft (v0.22) up to the [Restful Objects](http://restfulobjects.org) site.  There have been numerous changes since the last version, not least of which is the set of resources that it defines (see left).

Another change is that the spec now explicitly indicates that it is agnostic as to the nature of the server-side state that it exposes, in that it may be used either to expose domain entities (Customer, Order, Product) or may be used to expose use cases/commands (CheckIntoFlight, CancelOrder).  So, irrespective of [which](http://java.dzone.com/articles/domain-model-rest-anti-pattern) [view](http://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven) you have of how to do REST, Restful Objects aims to provide useful support.

Anyway, if any of this sounds of interest, head over to the Restful Objects site to download the latest version of the spec.
