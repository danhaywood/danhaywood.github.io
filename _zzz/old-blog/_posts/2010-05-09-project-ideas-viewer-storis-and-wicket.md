---
author: danhaywood
comments: true
date: 2010-05-09 11:20:08+00:00
layout: post
slug: project-ideas-viewer-storis-and-wicket
title: Project Ideas, Viewer Stories and Wicket
wordpress_id: 584
tags:
- apache isis
---

You might (but then again might not) have noticed a couple of new (permanent) pages at the top of this blog.




  * The first lists a number of [project ideas]({{ site.baseurl }}/resources/project-ideas/) for extending Naked Objects, of various sizes.  As well as being indicative of the flexibility of the NO framework, I'm also hoping that they'll inspire anyone looking for an interesting project to work with.  In particular, if you're a IT/CompSci student looking for a subject for your thesis, then check them out.


  * Second, and related, I've also put up a page that [lists a set of user stories]({{ site.baseurl }}/resources/viewer-stories/) / features that make up a reasonably comprehensive viewer for Naked Objects.  [Naked Objects itself](http://www.nakedobjects.org) already as the DnD viewer and the HTML viewer, and the next version will include the [Scimpi](http://www.scimpi.org) web viewer too.  Meanwhile in the [sister projects](http://starobjects.org) my Restful Objects is a viewer of sorts, and I've been working on a new one based on Wicket (more below).  Anyway, take a look-see; if you fancy writing a viewer in Android or JavaFX, it'll give an indication of the work required.



And finally, onto Wicket.  I was able to rattle off that list of stories because I've spent my last couple of months of spare time and odd days working on a generic OOUI viewer based on [Apache Wicket](http://wicket.apache.org).  This basically picks up on the stuff I covered in chapter 15 in my book where I demonstrate the principle.


Anyway, so we now have a new sister project, called (you can probably guess) [Wicket Objects](http://sourceforge.net/projects/wicketobjects).  It's not quite finished but is getting pretty close, and I'm gonna be demonstrating it at the [SPA conference](http://www.spaconference.org/spa2010/sessions/session294.html) in London in a week or two.  I have to say that I love how this little project has turned out: Wicket Objects leverages Wicket for the UI, has Naked Objects do the back-end stuff.  As a developer you get a Wicket-based UI for your domain objects for free, which you can then extend using your Wicket knowledge as need be.



I'm gonna be blogging more about Wicket Objects as I tidy it up and get its documentation together; in the meantime there's some basic notes on its [wiki at Sourceforge](http://sourceforge.net/apps/trac/wicketobjects).
