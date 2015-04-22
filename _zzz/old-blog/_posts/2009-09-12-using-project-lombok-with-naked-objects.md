---
author: danhaywood
comments: true
date: 2009-09-12 23:20:09+00:00
layout: post
slug: using-project-lombok-with-naked-objects
title: Using Project Lombok with Naked Objects
wordpress_id: 277
tags:
- apache isis
---

[![Old super 8 video camera's](http://farm4.static.flickr.com/3318/3219874303_134538d190.jpg)](http://www.flickr.com/photos/b_uncie/3219874303/)

[Project Lombok](http://projectlombok.org) is a recent project that exploits with [Java 1.6's APT (Annotation Processing Tool) API](http://java.sun.com/javase/6/docs/technotes/guides/apt/index.html) to generate boilerplate code from annotations.  In this screencast I show how Lombok can be easily used to remove the boilerplate getters and setters from a pojo domain object.
<!-- more -->
[http://content.screencast.com/users/danhaywood/folders/Jing/media/abd24c96-cd44-4771-aa3f-a95a6ff922ac/jingh264player.swf](http://content.screencast.com/users/danhaywood/folders/Jing/media/abd24c96-cd44-4771-aa3f-a95a6ff922ac/jingh264player.swf)

At the time of writing Project Lombok is still very new.  It doesn't need any IDE, but if you are using an IDE then only Eclipse is supported (and it's still relatively early days).   But the project leads are also actively encouraging the community to experiment with new annotations and features (see for example the related [Project Morbok](http://code.google.com/p/morbok/)).  I can see several possibilities for Naked Objects though:



	
  * currently we use bytecode enhancement (cglib or javassist) to override the getters for lazy loading, transparently calling the DomainObjectContainer#resolve().   We do something similar in the setters to mark the object as dirty, by transparently called DomainObjectContainer#objectChanged.  An enhanced version of Lombok's @Getters and @Setters, also applied to collections, might mean us being able to remove this bytecode enhancement

	
  * an enhanced version could also generate the standard supporting methods, modifyXxx() and clearXxx() method for properties, and addToXxx() and removeFromXxx() for collections.  These could then call hook methods (onModifyXxx() and so on) for any further business processing

	
  * going further still, these standard supporting methods be generated the standard mutual registration pattern for bidirectional dependencies.  This would need the annotation could specify whether the relationship is bidirectional, equivalent to JPA's mappedBy or Hibernate's "inverse" attributes.  In fact, why not simply use JPA's annotation...?


I suspect a few other of the conventions of the Naked Objects programming model could be ported over to Lombok... if you have any good ideas, post a comment.
