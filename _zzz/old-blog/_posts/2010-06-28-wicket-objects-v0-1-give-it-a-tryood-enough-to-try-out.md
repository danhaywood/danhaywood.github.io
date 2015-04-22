---
author: danhaywood
comments: true
date: 2010-06-28 09:26:04+00:00
layout: post
slug: wicket-objects-v0-1-give-it-a-tryood-enough-to-try-out
title: Wicket Objects v0.1 ... give it a try
wordpress_id: 608
tags:
- apache isis
---

Over the last few months I've been plugging away at another sister project for [Naked Objects](http://nakedobjects.org), this time a new web-based viewer built using the [Apache Wicket](http://wicket.apache.org) web framework.  I reckon it's now in a fit enough state to be tried out more widely, and hopefully find some contributors with better web UI skills than I do!

But what does it do?  Well, Wicket Objects is a way of rapidly developing web apps simply by writing the domain objects.  Fundamentally it consists of a set of Wicket IModel's that wrap the NO metamodel, and a bunch of Wicket Components that can render those IModel's.  Given that there's no UI code to write to get a fully-functional webapp, this means you can develop good code, very quickly.  Then, when you do need to start to customize the app, you can just use the Wicket API against the aforementioned IModel's.

Here's a screenshot of Wicket Objects in action with its standard form for an entity:
![wicketobjects-blog-screenshot](http://farm5.static.flickr.com/4136/4741899022_f041b1a451.jpg)

I've put together a new Maven [website](http://wicketobjects.sourceforge.net), plus some [docs](http://wicketobjects.sourceforge.net/m2-site/main/documentation/docbkx/html/user-guide/user-guide.html), and I've uploaded a snapshot into the sister projects snapshot repo.  So, to try it out with a small test app, just do the following:

    
    svn co https://wicketobjects.svn.sourceforge.net/svnroot/wicketobjects/trunk/testapp/claims .
    mvn clean install
    cd webapp
    mvn jetty:run
    


To logon, use sven/pass.

One of the objectives of Wicket Objects is to be customizable.  But I didn't want to invent some new proprietary API for developers to have to understand.  Hence choosing Wicket; I basically use its API for building Components as my customization API.

That also makes it easy to reuse 3rd party Wicket components to create customized views.  For example, we can customize Wicket Objects so that Locatable objects are displayed in a google maps mashup; behind the scenes this uses the [gmap2](http://wicketstuff.org/confluence/display/STUFFWIKI/wicket-contrib-gmap2) Component on WicketStuff:
![wicketobjects google maps mashup](http://farm5.static.flickr.com/4101/4741314913_8cd0f70b79.jpg)

So, please give it a try.  And if you like what you see and either already know or want to learn Wicket, why not help me take it up to a 1.0 release?
