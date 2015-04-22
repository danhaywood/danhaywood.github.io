---
author: danhaywood
comments: true
date: 2011-08-03 07:23:59+00:00
layout: post
slug: restful-objects
title: Restful Objects
wordpress_id: 796
tags:
- apache isis
- restful objects
---

Now that we have our [first release of Apache Isis]({{ site.baseurl }}/2011/07/18/apache-isis-0-1-2-incubating-released/) out of the door, I've been spending some time on [Restful Objects](http://restfulobjects.org/), which forms the basis of the [JSON viewer](http://incubator.apache.org/isis/viewer/json/index.html) within Isis.

The idea of Restful Objects is to provide a standard, generic RESTful interface for domain object models, exposing representations of their structure using JSON and enabling interactions with domain object instances using HTTP GET, POST, PUT and DELETE.

<!-- more -->The [Restful Objects](http://restfulobjects.org/) website is a place where the specification will be documented as it evolves, and if you take a look through the spec as it stands you may realize that it's very much based on the idea of a domain model as envisaged by naked objects.   That is:



	
  * the start page provides links to the set of registered services/repositories

	
  * from these services, references to domain object instances can be obtained

	
  * each domain object has properties, collections and actions

	
  * the usual business rules (hiding, disabling and validating) are supported

	
  * actions (idempotent or non-idempotent) can be invoked


More generally, you'll see that all the representations are fully self-describing, opening up the possibility of generic viewers to be implemented if required, eg in languages such as HTML5/Ajax, Flex, Silverlight etc etc.

Alternatively, the representations can be consumed directly by a bespoke application.

One of the nice things about this specification is that it is completely language-independent.  As you might expect, I'll be implementing this specification through the Isis JSON viewer, and using that implementation to refine the spec.  In addition Richard Pawson is hoping to commit to working on a similar implementation for [Naked Objects MVC](http://nakedobjects.net) (he's a co-author on the Restful Objects site).

But, if you know of or are the author of another naked objects-style framework, eg written in Ruby or Python, and the idea of Restful Objects interests you, then I'd love to hear from you.
