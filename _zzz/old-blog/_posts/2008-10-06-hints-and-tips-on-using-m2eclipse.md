---
author: danhaywood
comments: true
date: 2008-10-06 10:07:00+00:00
layout: post
slug: hints-and-tips-on-using-m2eclipse
title: Hints and tips on using m2eclipse
wordpress_id: 28
---

m2eclipse ([http://m2eclipse.codehaus.org/](http://m2eclipse.codehaus.org/)) is an excellent way of combining Maven with Eclipse. We use it in both Naked Objects ([http://www.nakedobjects.org](http://www.nakedobjects.org/)) development and I've also been using it for the sister Restful Objects ([http://restfulobjects.sourceforge.net](http://restfulobjects.sourceforge.net/)).

<!-- more -->
When you invoke a build in Eclipse, m2eclipse "sort of" delegates to the Maven builder.  In fact, I am told by Eugene that it still uses Eclipse's own JDT to do the compilation, but it's still a pretty good approximation.  You can use the Maven console to see what's going on, and the output (to my eyes at least) is pretty much the same as running Maven from the command line.

If you perform a Maven build (mvn clean install) from the command line,  then all modules are picked up from the local repository. m2eclipse sets up the classpath slightly differently so that all Maven modules that are in the workspace are referenced locally, and everything else is picked up from your local repository. In practice this means that you can develop in Eclipse pretty much the same as before.

It is worthwhile performing builds occasionally using Maven command line; there are sometimes slight differences between the Sun javac and Eclipse's built-in Java compiler. If you do run a command-line build then you must perform a refresh in Eclipse workspace.  A project/clean is often required after that.

On occasion I've found though that this isn't enough; m2eclipse thinks that all class files are up-to-date and doesn't build anything. To force m2eclipse to rebuild everything, the File / Refresh followed by a Project / Update All Maven Dependencies is pretty much guaranteed to do the trick.
