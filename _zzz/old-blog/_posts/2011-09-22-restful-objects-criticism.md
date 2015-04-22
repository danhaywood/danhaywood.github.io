---
author: danhaywood
comments: true
date: 2011-09-22 00:18:58+00:00
layout: post
slug: restful-objects-criticism
title: Restful Objects criticism
wordpress_id: 818
tags:
- restful objects
---

The [Restful Objects spec](http://restfulobjects.org) drew some criticism on twitter today. I'm quite happy to get feedback so long as its constructive.  Of course, the 'net being the 'net, that ain't always the case.  Oh well.  [UPDATE: the replies to this post so far *have* been constructive... my thanks]

Since 140 characters isn't really enough to drill down into issues and concerns, I thought I'd post some of the criticism here and attempt to answer the points.  It'd be nice to think I may get some comments against this post which could help develop the spec, rather than summarily dismiss it.   Whether that happens, we shall see.

Anyway, on with the criticism...

<!-- more -->

**[@serialseb](http://j.mp/pFwsAH): Custom headers, with an X- profile, confusing operations and resources, generic media types, use of more custom headers, ignoring Link...**

Taking each in turn:

a) The custom request headers defined by the RO spec are:



	
  * X-Page, X-Page-Size

	
  * X-Sort-By

	
  * X-Follow-Links

	
  * X-Validate-Only

	
  * X-Domain-Model


I can imagine that there might be a standard way to specify paging and sorting; if there is I'd be interested in being pointed to the relevant prior art.  On the REST project I've been working this last year, we deal with pagination using regular query args.  The issue I have with that is that it doesn't distinguish between arguments that could be consumed by the infrastructure (for paging etc) vs arguments that are specific to business logic.

An alternative approach might have been to define standard query args, and require any implementations of the spec to ensure that collisions with business logic are managed some how.  That didn't feel particularly pleasant, though.

The **X-Follow-Links** is used by clients to provide a hint for avoid the N+1 problem that ORMs can suffer from.  To me this seems more elegant than having to go to all the bother of defining a specific resource acting like a view-model which is just there to perform a specific aggregation (eg Order plus all OrderItems).  Instead, the client can specify a value of  "items" for this header when requesting the Order resource; this hints to the resource for the returned representation to inline representations of all OrderItems also.

The **X-Validate-Only** is a hint to request that a mutation to the state of the resource be validated but not applied.  For example, a client can verify if a set of arguments for an operation are valid prior to actually performing the operation.   This could be useful for some client's that want to provide feedback in their UI.

An alternative approach would have been to define separate subresources that would allow a client to request validation, and earlier versions of the spec did toy around with this.   However, taking this approach added a lot of complexity for a requirement that I felt was more easily satisfied through this custom header.

The **X-Domain-Model** is another hint for those clients that want to obtain a full representation of the domain metamodel.  I suspect this would only really be of interest to those writing a general-purpose RESTful client that provides a generic UI for any domain model (ie in the style of naked objects).  I suspect that those who don't get or dig naked objects (yes, there are many, I know) won't see the point of this header.

b) The custom response headers defined by the spec are:



	
  * X-Representation-Type


This is intended to allow clients to distinguish different representations.  This ties in with the criticism made about...

c) generic media types, presumably criticising that the spec says to return "application/json" as the media type for all representations.

Earlier versions of the spec did say to return "application/vnd.xxx+json", where "xxx" was a unique string representing the type (eg x.Customer or x.PlaceOrderCommand).  The issue, though, is that plugins for browsers (eg  [REST console](https://chrome.google.com/webstore/detail/faceofpmfclkengnkgkgjkcibdbhemoc)) don't recognise the returned representation as JSON.  So the **X-Representation-Type** is a work-around to deal with such pragmatic concerns.

But... if there's a more standard header that addresses this (or even a plugin for browsers that understands the vnd.xxx syntax), then I'd like to know.

d) I'm not sure what I've confused between operations and resources, though I suspect it's a reaction to the fact that the spec exposes an object's actions (eg Customer#placeOrder) as two (sub-)resources: one to obtain a description of the action, and one to invoke the action.  No apology here.  A domain object (especially if that domain object is really a view model) may want to indicate the valid set of values in order to perform some operation.  This is what the action description resource provides.  The invoke subresource then allows the operation to be performed (GET, PUT or POST depending on idempotency/side-effects etc).

That said, and as I point out in the spec, there is a school of thought that says that only commands should be exposed as RESTful resources... it shouldn't be Customer#placeOrder, instead it should be PlaceOrderCommand#execute, so that the arguments needed to perform the command are PUT as subresources of the command resouce prior to it being executed.  The RO spec does support this as well.  But, admittedly, the examples in the spec don't use this style.

e) "ignoring Link"; the spec does define its own JSON representation for a link between resources.  I did search for an existing standard for representing links, but clearly didn't look hard enough.  I'm guessing that the Link spec you mean is [http://tools.ietf.org/html/draft-nottingham-http-link-header-05](http://tools.ietf.org/html/draft-nottingham-http-link-header-05)?  If so, I shall look into it some more.

[@serialseb](http://j.mp/qsADjw): **Use of 412 for things that are not http header preconditions, pagination following none of the original specs...**

a) 412.  The spec defines to return a 412 if a client attempts to perform an operation which fails server-side validation.  For example, if a customer tries to place an order for a negative number of items, that would probably be a validation error for one of the arguments.

Now, according to w3c, 412 should be returned when:

_The precondition given in one or more of the request-header fields evaluated to false when it was tested on the server. This response code allows the client to place preconditions on the current resource metainformation (header field data) and thus prevent the requested method from being applied to a resource other than the one intended._

So, yes, there's probably some justification in this criticism, though the intent is very similar.  Of course a simple 400 might suffice, but I'd prefer a more targetted response code.  Are there alternative conventions here?

b) pagination... I mentioned above.  I'd be happy to adopt a standard if there is one.  Again, my searches didn't seem to show up a clear standard; see for example this [thread](http://stackoverflow.com/questions/924472/paging-in-a-rest-collection) on stackoverflow.  Admittedly that dates from 2009, so perhaps a consensus has since been reached?

[@serialseb](http://j.mp/q9wxHb): **Use of Last-Modified but no Etags..**

I can see that an ETag would be needed for concurrency control if there is no Last-Modified/If-Modified-Since, but if there are these headers (which is what the spec says) then what benefit does an ETag bring?

[@serialseb](http://j.mp/qv5e7a): **Modelling RPC calls as resources (at least that one is discutable slightly)**

I'm not sure exactly which RPC calls are being referred to here... it might be a reference to the spec exposing (singleton) domain services/repositories, eg Customers or ProductCatalog, or it might be a reference to the spec exposing domain object actions (discussed above).

[@serialseb](http://j.mp/n1Fo54): **And all in all plenty of opaque behavior straight at the http level, disregarding completely defining a correct media type definition**.

I'm guessing the opacity is in terms of the custom headers (discussed above); media types vs representation types was also discussed above.  To my knowledge there's nothing else in the spec that might be considered opaque.

Indeed, I should turn that accusation around.  The fact that the spec allows any set of domain objects (be they entities, commands, view models or whatever) be exposed in a completely predictable manner, and defines how to expose the metamodel of those domain objects, and as such could be consumed by a completely generic REST client if required, makes me think that the representations and resources defined by the spec are the exact opposite of being opaque.

In contrast, I would describe a REST system as opaque if its resources are designed in an adhoc fashion, are poorly documented (because who wants to do documentation?), that doesn't fully define how to handle bad inputs, where the provided representations don't explain fully how to follow the links, where there's no guarantee that all links needed to fully traverse the resources will even be provided in representations, and where the underlying domain model is at best implicit.

[@darrel_miller](http://j.mp/q0ankb): **"So, irrespective of which view you have of how to do REST" contains two links to articles saying don't do what he is doing!**

The spec doesn't actually say which style of REST to do: you can expose view models or commands (a la Rickard Oberg) or entities or whatever.  If there's a failure in the spec, I think it is that it only has examples of entity representations.

The more significant of the two articles I quote is Roy Fielding's 2008 [post on REST APIs being hypertext driven](http://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven).  The representations defined by the spec are very much hypertext driven; if they weren't then one couldn't write a generic REST client a la naked objects.

Re-reading Fielding's post, the place where the RO spec comes closest to falling foul is where he says:

_A REST API should never have “typed” resources that are significant to the client....  The only types that are significant to a client are the current representation’s media type and standardized relation names._

One could argue that exposing entities without projection means that those entity types are significant to the client. However, there is a degree of abstraction even here in that the RO spec defines a media type along with the X-Representation-Type header workaround (discussed above).  Any, in any case, there's nothing in the RO spec that says you can't wrap your entities in view models or commands if you so wish.

[@colin_jack](http://j.mp/pkUpmx): You need to project from any non-trivial domain model if you want any sort of API surely?

[@darrel_miller](http://j.mp/rcmSbF): Exactly. Without that projection you are just doing remote objects again. We tried that route, for 10 years.

I'm guessing that "projection" means a view model or command layer in front of entities; in which case, as discussed, you can do this if you want.

I suppose I should point out though the counter-example (for what it's worth) that you can build non-trivial domain models without doing this projection; ie the naked objects government system in Ireland.  Yes, I know it's the one we always quote, but it's still being developed on and it's still churning out a new release every month (first release was 6 years ago), and is still being used by >1000 governmental employees.  So I have an existence proof that it isn't always necessary to project from a non-trivial domain model.  And given that's the case, let me ask the opposite question: how do you know you are adding projections unnecessarily in your systems?

[@algermissen](http://j.mp/nWKTB3): **Why the hell do I need a REST interf. to a dom.obj.model? Any clue what prob this solves?**

Because, honestly, we shouldn't be being paid for building REST interfaces.  We should, instead, be applying our brainpower to the business domain.  The spec aims to define a standard binding for domain objects/services in terms of REST in order that we can do just that.  Yes, there are areas where the spec can be improved; indeed, I'd be amazed if that weren't the case.  But I haven't yet read any criticism that invalidates this basic goal.

OK; that was all the tweets I could find.  But there'll be more flames tomorrow, no doubt.
