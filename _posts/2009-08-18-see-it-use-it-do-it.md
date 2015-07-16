---
author: danhaywood
comments: true
date: 2009-08-18 23:18:46+00:00
layout: post
slug: see-it-use-it-do-it
title: See It, Use It, Do It
wordpress_id: 137
excerpt: The Naked Objects programming model is designed to allow us to write behaviourally complete objects, ones that have a full set of responsibilities.  Part and parcel of these responsibilities is in enforcing preconditions for interacting with the object, (that is, invoking an actions, changing a property or adding to/removing from a collection).
tags:
- naked-objects
---

![Three Wise Monkeys](http://upload.wikimedia.org/wikipedia/commons/thumb/b/b0/Three_wise_monkeys_figure.JPG/300px-Three_wise_monkeys_figure.JPG){: .float-right}

The Naked Objects programming model is designed to allow us to write behaviourally complete objects, ones that have a full set of responsibilities rather than being [anaemic](http://en.wikipedia.org/wiki/Anemic_Domain_Model).

Part and parcel of these responsibilities is in enforcing preconditions for interacting with the object, (that is, invoking an actions, changing a property or adding to/removing from a collection).

In frameworks where the presentation and application layers is explicitly coded (ie non-NO), these preconditions usually amount to no more than ensuring that arguments (for actions) and proposed values (for properties/collections) are valid.  But we can also ask: is the action/property/collection visible to this user, and if so is it enabled or disabled?

<!-- more -->

In Naked Objects it is the responsibility of the domain object to answer these two additional questions.  In essence, the framework asks the object:



	
  * visibility: can this user see the class member?

	
  * usability: if so, can this user use the class member?

	
  * validity: if so, is the value(s) supplied by this user valid?


This might at first seem like we're placing presentation layer (visibility) or application layer (usability) concerns into the domain layer.  However, we're not.  The domain objects still don't (and shouldn't) know how the visibility and usability is represented in the presentation/application layers, they just know that it gets done somehow.  There's a similarity here with persistence; domain objects don't know _how_ they get persisted, but they know _that_ they get persisted.
