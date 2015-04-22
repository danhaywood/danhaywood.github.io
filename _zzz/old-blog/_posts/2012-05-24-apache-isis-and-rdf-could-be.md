---
author: danhaywood
comments: true
date: 2012-05-24 05:41:05+00:00
layout: post
slug: apache-isis-and-rdf-could-be
title: Apache Isis and RDF - could be...
wordpress_id: 975
tags:
- apache isis
- rdf
- restful objects
---

An interesting question came in on the Apache Isis [mailing list](http://incubator.apache.org/isis/mail-lists.html), regarding Isis and its support for building apps that interact with RDF and semantic web technologies:<!-- more -->



<blockquote>
I'm currently developing some kind of knowledge management application using RDF and such semantic web related technologies. I've found Isis and thought it will be great to use it as a a front end while developing and maybe I think it as a service layer given the REST functionality that is provided.

The question is given that I have no previous knowledge of the object types and the properties I should handle because the schema is dynamic, I wonder if it will be worth trying to develop some kind of Dynamic Object Model adapter layer over my model and to provide it to Isis so this model and its persistence leverages the benefits of using the framework. I also should handle context/interaction/actions which should be provided as operations but they are also modeled in an ontological fashion so I should adapt this too.
</blockquote>






It occurred to me that this might be something that Isis could support.  Here's my reply, at any rate:



<blockquote>
I must admit I don't think I completely grok what you are aiming to do, but let me do my best.

Isis, as you know, currently builds its metamodel from pojos, and this metamodel is built up using a registry of FacetFactory classes, all combined together in the ProgrammingModel (the default being org.apache.isis.progmodels.dflt.ProgrammingModelFacetsJava5).  All interactions through the UI are using this API, and most of the object stores do also.

I think it would be fairly easy to reflect upon something other than pojos - in your case RDF thingies - by providing a different ProgrammingModel implementation with a different set of FacetFactories.

One limitation is that the metamodel is deemed to be immutable after initialization.  So if you are inventing different RDF structures while the app is running, then Isis wouldn't be able to pick this up.  (I have thought of changing this actually, and providing a way to ask Isis to rebuild its metamodel.  It occurred to me that that would be a useful feature if using a tool such as JRebel.  However, I haven't done anything on this).

So, I dunno if the above is useful, but it might direct your investigations a little.  One other detail while I remember it: in the set of FacetFactorys in ProgrammingModel, you need to ensure that there is at least one that implements the special PropertyOrCollectionIdentifyingFacetFactory interface.  These are called first and - as their name suggests - are used to identify the properties and collections on which all the other FacetFactorys then act.  (There isn't an ActionIdentifyingFacetFactory because any public methods that are not properties or collections are deemed to be actions).
</blockquote>






If this little interaction leads to anything of interest, I'll follow up with a post here.
