---
author: danhaywood
comments: true
date: 2009-09-09 23:03:27+00:00
layout: post
slug: ducktyping-in-java-and-the-ubiquitous-language
title: DuckTyping in Java (and the Ubiquitous Language)
wordpress_id: 215
excerpt: A utility for implementing duck typing in Java, and why you probably shouldn't use it.
tags:
- ddd
---

[![Ducks in a row...](http://farm1.static.flickr.com/221/501334109_72733521d5.jpg)](http://www.flickr.com/photos/troikkonen/501334109/)

I've recently discovered [javaposse.com](http://javaposse.com) (recommended), and was listening to an [podcast from last year](http://javaposse.com/index.php?post_id=401248) on the [DRY principle](http://en.wikipedia.org/wiki/Don%27t_repeat_yourself).

One of the questions asked was: when coding in Java, where do we have to repeat ourselves?  There was the usual point made about generics being overly verbose (Java 7's [diamond operator](http://mail.openjdk.java.net/pipermail/coin-dev/2009-February/000009.html) will help), but another answer came back about the repetition required in having to explicitly say that a class implemented an interface in addition to just providing an implementation of all the methods in that interface... in other words, why can't Java support [duck typing](http://en.wikipedia.org/wiki/Duck_typing):

So, suppose:

    
    public interface IDuck {
        public void quack(int volume);
        public void float();
    }


and

    
    public class DuckLike {
        public void quack(int volume) {  .... }
        public void float() { }
    }


What our speaker wanted was to be able to pass a DuckLike object around to something that would use `IDuck`s, without having to say "class DuckLike implements IDuck":

    
    public class DuckUser {
        public void useDuck(Object o) {
            ... use the supplied object as a duck if it quacks and floats ...
        }
    }


In order to support ducktyping, note that the `DuckUser#useDuck(...) takes an `Object`, not an `IDuck`.

So, one solution that came back was a utility to automatically provide a proxy for the duckLike thing that implements IDuck if it does indeed have a suitable implementation.  This proxy then delegates to the underlying duckLike.  I must admit this caught my fancy so I thought I'd have a go at writing it.

So, given an instance of `DuckLike` and the `IDuck`, you can write:

    
    DuckLike duckLike = new DuckLike();
    IDuck duck = DuckTyping.quacks(duckLike, IDuck.class);
    if (duck != null) {
        ... use duckLike as a duck ...
    }


Turns out that the utility class, `DuckTyping`, isn't that difficult to write (ie it's taking me longer to write the blog than the code did...):

    
    package com.danhaywood.misc.duck;
    
    import java.lang.reflect.InvocationHandler;
    import java.lang.reflect.Method;
    import java.lang.reflect.Proxy;
    
    public class DuckTyping {
        @SuppressWarnings("unchecked")
        public static T like(final Object duckLike, Class requiredClass) {
            final Class duckLikeClass = duckLike.getClass();
            if (requiredClass.isAssignableFrom(duckLikeClass)) {
                return (T) duckLike;
            }
            for (Method method : requiredClass.getMethods()) {
                try {
                    duckLikeClass.getMethod(method.getName(), method
                            .getParameterTypes());
                } catch (NoSuchMethodException e) {
                    return null;
                }
            }
            InvocationHandler handler = new InvocationHandler() {
                public Object invoke(Object proxy, Method method, Object[] args)
                        throws Throwable {
                    Method duckLikeMethod = duckLikeClass.getMethod(method
                            .getName(), method.getParameterTypes());
                    return duckLikeMethod.invoke(duckLike, args);
                }
            };
            return (T) Proxy.newProxyInstance(
                    requiredClass.getClassLoader(),
                    new Class[] { requiredClass },
                    handler);
        }
    }


We can then updated our `DuckUser` library to use the new utility:

    
    public class DuckUser {
        public void useDuck(Object o) {
            IDuck duck = DuckTyping.like(o, IDuck.class);
            if (duck != null) {
                ... use supplied object as a duck ...
            }
        }
    }


How cool is that?

Actually, I'm not sure that it's very cool at all.

Let's think about the ubiquitous language of this little example.  Okay, so we've made it possible to pass arbitrary objects to `DuckUser`, and if that object quacks like a duck and floats like a duck then the `DuckUser` will be able to use it as an (I)Duck.  However, the concept of duckiness is now hidden within `DuckUser`.  Does this represent good encapsulation?  No, I think it means that our ubiquitous langauge is missing a concept, we haven't surfaced the concept of duckiness, and so we can't talk about ducks.

So, hey, make the object implement the interface.  We're not violating the DRY principle when we implement an interface; we're expressing syntactically that we intend to comply with the semantics of the concept represented by an interface (as opposed to just accidentally having some methods that are the same signature).

Interfaces are a key part of defining the ubiquitous language.  Very often we start off defining the obvious, concrete classes.  Only later on, with deeper understanding, do the roles that objects play to each other start to appear ... it's these roles that define the [conceptual contours](http://domaindrivendesign.org/node/97) of the model.

So, yes, the above `DuckTyping` utility was fun to write.  But I don't think I'll be using it in my domain models.
