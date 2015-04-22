---
author: danhaywood
comments: true
date: 2012-09-17 08:20:25+00:00
layout: post
slug: responsibilities-of-the-application-layer-in-domain-driven-applications
title: Responsibilities of the Application Layer in Domain-Driven Applications
wordpress_id: 1030
tags:
- apache isis
- domain driven design
- naked objects
---


It's standard practice to build enterprise apps in layers: each layer has its own set of responsibilities, providing a separation of concerns.  In Evans' DDD book, _layered architecture_ is one of his named patterns, its intent being to isolate the domain layer from the adjacent layers of application and infrastructure.  The presentation layer is, of course, the other standard layer, sitting on top of the application layer:





  * presentation layer


  * application layer


  * domain layer


  * infrastructure layer






Of these layers, though, it's the _application layer_ that seems to cause the most difficulty, <!-- more -->and is a regular topic of conversation on the [yahoo DDD forum](http://tech.groups.yahoo.com/group/domaindrivendesign).  My contention is that most people put too much responsibility into this layer, writing reams of boilerplate code.  Maintaining all this code impairs the development of the larger goal, the _ubiquitous language_.  (Of course, maintaining reams of code in the presentation layer exacerbates this even further; I'll come back to this in a minute).




In a [recent thread on the DDD group](http://tech.groups.yahoo.com/group/domaindrivendesign/message/23528), I tried to elicit a list of the responsibilities of this application layer.  The list of responsibilities for the application layer that were eventually identified in that thread ended up as:





  1. to allow presentation layer vs domain layer to run in different processes/machines


  2. to implement cross-cutting concerns such as security and transaction management.


  3. to map identities and DTOs into domain objects that can be delegated to (hexagonal ports and adapters pattern)


  4. (if you don't own the client, or if the client isn't generic), to provide a stable API that allows domain entities to be refactored without changing the client


  5. (if required) to provide an ability to support different client versions concurrently


  6. (if dependency injection into entities is not used) to pass domain services into entities


  7. (if a domain module representing users/user identity does not exist), to map system level user identity into a representation that can be passed into entity method calls


  8. to assemble domain entities with respect to specific use cases (view models)






My contention in that thread is that most, and many times all, of these responsibilities can be implemented generically within framework code.  In other words there is no need to maintain custom-written code in the application layer.  Doing this does require making some explicit design choices, most notably:





  * dependency injection into entities, to obviate the need to pass domain services into entities, and


  * a domain module representing users, to obviate the need for the application layer to map user Ids






Of course, the naked objects frameworks ([Apache Isis](http://incubator.apache.org/isis), [NO MVC](http://nakedobjects.codeplex.com)) do this for you.  Moreover, they also produce a generic (though customizable) presentation layer.  The benefit of this is that you can focus just on the domain model, ie building your _ubiquitous language_.




It's a shame that most people who encounter naked objects don't get this, and would rather spend their days labouring away maintaining those other layers.  That said, I have a sneaking suspicion that lots of developers like doing this: writing lots and lots of boilerplate code.  Well, I guess it's easier than trying to think deeply about your domain model!  But I don't think that's what Evans had in mind when he included the _layered architecture_ pattern in his book.

