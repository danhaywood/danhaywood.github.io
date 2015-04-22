---
author: danhaywood
comments: true
date: 2011-11-08 00:31:29+00:00
layout: post
slug: restful-objects-v0-51-uploaded
title: Restful Objects v0.51 uploaded
wordpress_id: 828
tags:
- restful objects
---

Since my last post there's been a couple more updates to the Restful Objects spec.


Restful Objects defines a set of RESTful resources, and corresponding representations, for accessing and manipulating a domain object model.  The most up-to-date version of this specification may be downloaded from [ ](http://www.restfulobjects.org/)[http://restfulobjects.org](http://restfulobjects.org); as of now I'm up to v0.51.


Noteworthy changes since my last post include:

<!-- more -->



	
  * moved content from introductory chapter into new "Patterns and Practices" section at end, and expanded its discussion

	
  * added diagrams to show links from every representation out to the resources

	
  * Introduced a new action-result representation, with object, list and scalar representations inlined.  This allows implementations to append additional information in the "extensions" and "lists" nodes.  In particular, Apache Isis provides changed/dirty object lists in the "extensions" node.

	
  * renamed the "domain type member" resources to "domain member description"

	
  * introduced a new domain type action equivalent to java.lang.Class#isAssignableFrom().  This allows clients to query the type hierarchy of domain types

	
  * 204 "no content" is hardly returned anywhere anymore.  In particular, object put, property put, property delete, collection put, collection post, collection delete all now return representations.  Actions returning void return the action-result representation.


The spec is currently being implemented by two different open source frameworks: [Apache Isis](http://incubator.apache.org/isis) (Java) and [Naked Objects MVC](http://nakedobjects.net) (.NET).    The changes in this version have come about either from those implementations, or from feedback of a Javascript client implementation that is underway.

Other comments always welcome.
