---
author: danhaywood
comments: true
date: 2011-08-18 21:29:04+00:00
layout: post
slug: restful-objects-spec-updated
title: Restful Objects spec - updated
wordpress_id: 804
tags:
- restful objects
---

Have been continuing to develop the Restful Objects specification, which aims to map a RESTful API onto a domain object model.

The [restful objects](http://restfulobjects.org) site now highlights the broad concepts, but I've moved the main content out into a [Doc](http://restfulobjects.files.wordpress.com/2011/08/restful-objects-spec-0-1.doc)/[PDF](http://docs.google.com/viewer?url=http%3A%2F%2Frestfulobjects.files.wordpress.com%2F2011%2F08%2Frestful-objects-spec-0-1.pdf) so that it's easy to edit and to print out as a single entity.  There's also a nice little diagram showing the resources defined by the spec:

<!-- more -->![](http://restfulobjects.files.wordpress.com/2011/07/resource-relationships-0-1.png?w=300&h=225)

Some early feedback that I need to address ... there's a presumption that the domain objects being exposed by Restful Objects are entities, which 'taint necessarily so. That is, the objects being exposed could represent process objects/use cases instances (ie capturing and aggregating a particular end-users interaction with the system). I guess that'll need spelling out explicitly if RO is to attract interest.
