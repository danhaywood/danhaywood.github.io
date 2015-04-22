---
author: danhaywood
comments: true
date: 2009-09-04 16:22:10+00:00
layout: post
slug: session-on-scimpi
title: Session on Scimpi
wordpress_id: 188
tags:
- apache isis
---

[![exploring](http://scimpi.org/images/logo_Scimpi_w200x80web-use_.jpg)](http://scimpi.org)

One of the alternate viewers I discuss in the last chapter of the book is Scimpi.  This is a web framework designed by Robert Matthews (project architect for Naked Objects itself), and which is implemented as a viewer for Naked Objects.

Like the original HTML viewer, Scimpi is still an OOUI: each of its pages correspond to a domain object.  However, unlike the HTML viewer Scimpi is designed from the outset to be customisable.  Whereas with the HTML viewer there's no way to influence the page shown, Scimpi on the other hand searches for the best page to render the object by.  Only if no page exists is a default view used.  That means that different objects can be displayed in different ways.

Another difference is that the HTML viewer "owns" the entire page and always renders all the visible properties of the object.  Scimpi in contrast uses (something akin to) taglibs, so the developer has much more control as to what is shown.

Putting the above two together, it also allows for Scimpi to provide composite views, such as an order / orderline.

I'm going to be giving a short 30 min talk on [Scimpi at the Devoxx conference](http://devoxx.com/display/DV09/Uni+Day+1) in November, so if you were planning on going then you might want to take a look.
