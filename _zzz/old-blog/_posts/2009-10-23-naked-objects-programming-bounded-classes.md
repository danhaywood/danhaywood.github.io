---
author: danhaywood
comments: true
date: 2009-10-23 14:04:12+00:00
layout: post
slug: naked-objects-programming-bounded-classes
title: 'Naked Objects Programming: Bounded Classes'
wordpress_id: 376
tags:
- apache isis
---

In this screencast we're going to continue looking at domain object properties, building on the [first post]({{ site.baseurl }}/2009/10/13/naked-objects-programming-model-series-properties-and-choices/) in this series.

We've already seen how Naked objects allows us to write supporting validateXxx() and choicesXxx() methods which we can use to limit the set of values that can be taken for a property, (eg "visa", "mastercard" or "amex").  But suppose there were two different classes that both had the same rules?  That would suggest there's a concept missing from our ubiquitous language (eg PaymentMethodType).  What the values then represent are the bounded set of instances of that type (just like an enum).

So in this screencast <!-- more --> we extend the previous example and replace a simple string property with one that references a new bounded (entity) class.  And that sets us up to start pushing functionality onto it.

PS: By the way, in these screencasts I'm mostly using the Naked Objects drag-n-drop viewer.  But if you want to retrace my steps you should find it works just the same with the HTML viewer too.

[http://content.screencast.com/users/danhaywood/folders/Jing/media/180b7e7b-cfc2-42bb-8d4b-22671ee27083/jingh264player.swf](http://content.screencast.com/users/danhaywood/folders/Jing/media/180b7e7b-cfc2-42bb-8d4b-22671ee27083/jingh264player.swf)
