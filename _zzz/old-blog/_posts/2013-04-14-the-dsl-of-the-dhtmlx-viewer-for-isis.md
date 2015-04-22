---
author: danhaywood
comments: true
date: 2013-04-14 12:26:52+00:00
layout: post
slug: the-dsl-of-the-dhtmlx-viewer-for-isis
title: The DSL of the DHTMLX viewer for Isis
wordpress_id: 1131
tags:
- apache isis
- dhtmlx
- dsl
- javascript
---

In my [last post]({{ site.baseurl }}/2013/04/04/go-play-with-the-dhtmlx-viewer-for-apache-isis/) and [previously to that]({{ site.baseurl }}/2013/02/26/marrying-dhtmlx-with-apache-isis/) I've publicised the work that Mylaensys (Madytyoo and chums) have been building a new viewer for [Isis](http://isis.apache.org) based on the [DHTMLX](http://dhtmlx.com) javascript library. One of the most noteworthy things about this viewer is its support for a domain-specific language to describe the layout of the widgets in the UI.

Mylaensys have [now blogged](http://blog.mylaensys.com/2013/04/inside-apache-isis-viewer-for-dhtmlx.html) about the internal design of this DSL (exploiting Madytyoo's experience early in his career building compilers). It makes for interesting reading.

Or, if you want to just play with the DSL yourself, go to the [sample application running on Google App Engine](http://isis-viewer-dhtmlx.appspot.com). The link to change the DSL (and update the layout dynamically) is top right of the screen.
