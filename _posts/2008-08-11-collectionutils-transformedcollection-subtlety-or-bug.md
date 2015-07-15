---
author: danhaywood
comments: true
date: 2008-08-11 21:00:00+00:00
layout: post
slug: collectionutils-transformedcollection-subtlety-or-bug
title: 'CollectionUtils.transformedCollection(...) : subtlety or bug?'
wordpress_id: 26
tags:
- java
---

I've been tidying up some of the Naked Objects handling of collection recently, and thought it made sense to use other people's good work.  Since the Apache Commons Collections has been around for donkey's years, seemed like a sensible enough dependency to introduce.

Now in Naked Objects we wrap every pojo with an implementation of the `NakedObject` interface, which keeps track of various admin info such as an OID (object identifier), whether the object is fully resolved, and optimistic locking.  So switching from underlying pojo to wrapping NakedObject is quite common.

I wrote a little `Transformer` implementation called `ObjectToNakedObjectTransformer`, the idea then being to use transform a collection of pojos into a collection of `NakedObject`s:

    
{% highlight java %}    
Collection nakedObject =
    CollectionUtils.transformedCollection(
        collectionOfPojos,
        new ObjectToNakedObjectTransformer());
{% endhighlight %}    
    


Turns out this doesn't work though.  The returned collection will only do a transform on new stuff added to it; the objects in the original collection are never transformed.

You could call this a subtlety, but it's very misleading code.  It looks like a decorator, smells like a decorator, it just doesn't decorate.

And the right way?

    
    
{% highlight java %}    
Collection nakedObject =
    CollectionUtils.collect(
        collectionOfPojos,
        new ObjectToNakedObjectTransformer());
{% endhighlight %}    


Even then though I don't like the implementation; it eagerly does the transformation rather than on a just-in-time fashion.  I ended up not using it in the end.

