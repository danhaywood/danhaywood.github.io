---
author: danhaywood
comments: true
date: 2010-08-06 10:24:27+00:00
layout: page
slug: book-faq-and-clarifications
title: Book FAQ and Clarifications
wordpress_id: 634
---

The publishers of my [book](http://pragprog.com/titles/dhnako) (Pragmatic Bookshelf), provide a [forum](http://forums.pragprog.com/forums/106) for any questions that arising from readers.  There's also an [errata](http://www.pragprog.com/titles/dhnako/errata) page, mostly for typographical problems.

A recent suggestion on the forum was to pull together answers from the various threads so that they can be more easily located.  That seemed a good idea... so here we are!  I'll try to keep this page updated.

**Section 1.4 - Running the Claims App**

The book describes how to download the nakedobjects-4.0.0-for-maven.zip, unzip it, and then import into Eclipse (with the m2eclipse plugin).  There's a screencast of this [here](http://danhaywood.com/2009/09/17/naked-objects-example-claims-app-and-other-resources/).

Since I wrote that, it seems that m2eclipse now works slightly differently, meaning that importing the project fails because it cannot find the parent Maven project.

The fix requires editing the claims/pom.xml so that its parent is org.nakedobjects:release:


    
    
    <parent>
      <groupId>org.nakedobjects</groupId>
      <artifactId>release</artifactId>
      <version>4.0.0</version>
    </parent>
    



Then, see if Maven (without Eclipse) builds ok. For that, open up a command prompt in the claims directory, and do a ‘mvn clean install’. If that works then we’ll know that Maven is okay and the problem is with m2eclipse.

If that’s ok, then have a go at doing the import in m2eclipse; File>Import>Existing Maven Projects, browse to the claims directory and hopefully it’ll pick up the hierarchy of poms (claims as the root, with 5 children).

One thing I didn’t mention in the book that might just be relevant: the workspace directory (ie where the .metadata directory is created must not be the claims directory; its parent (the examples directory) will work, or use somewhere completely different (eg c:\workspaces\nakedobjects-claims).

**Section 2.2 - Using the Maven Archetype**

Section 2.2 describes two different ways of using the Maven Archetype, either from within m2eclipse or using the mvn command-line tool.  There's a screencast of the first approach [here](http://danhaywood.com/2009/08/29/using-the-naked-objects-4-0-maven-archetype/).

I must admit that the m2eclipse approach is somewhat fragile; when I said that the Nexus indexer can take some time, I wasn't kidding..  All things being equal, you're probably best to use the command line approach and then import the project, just like with the claims app.  I've just double checked this with a brand-new VM (running Ubuntu) and it all seems fine.  But if the command-line version still doesn't work, it might be that you're having problems getting through to the Maven central repo (where the archetype lives).  In that case, you could try adding an additional -D archetypeCatalog=http://nakedobjects.org; this will cause Maven to pick up the archetype from the Naked Objects repo instead.

But if this really doesn't work for you, then the best workaround I can give is to take the claims app (section 1.4) and hack it around a bit.  The things to pay attention to are the nakedobjects.services key and the nakedobjects.fixtures key in the config/nakedobjects.properties file.

**Section 18.2 - Securing the Application**

Among other things this section describes how to setup authorization.  It doesn't, though, mention that the application should not be run in exploration mode; rather run it in single-user (if standalone) or client mode (if client/server), ie with the flag -t single-user or -t client.

It's also important to remove (or set to false) the nakedobjects.authorization.learn flag in nakedobjects.properties; otherwise the authorization mechanism will simply write to the authorization file, not read from it.

You can read the original thread relating to this on the NO forum, [here](http://sourceforge.net/projects/nakedobjects/forums/forum/544072/topic/3787507).

**Section 18.1 - Deploying the Application (webapp deployment)**

Section 18.1 describes various ways to deploy the application; probably the most popular is likely to be as a webapp.  In which case, you use the xxx-webapp project to build the WAR file; the pom.xml for this project has all the necessary maven plugins defined to do the necessary.

All that should be necessary is to :




  * edit the src/main/webapp/WEB-INF/web.xml if necessary (the book describes what should be there)


  * copy the contents of your config/ directory up to src/main/webapp/WEB-INF


  * use mvn package to build the war (this will end up somewhere in the target directory)


