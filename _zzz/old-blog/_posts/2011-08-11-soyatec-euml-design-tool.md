---
author: danhaywood
comments: true
date: 2011-08-11 07:35:19+00:00
layout: post
slug: soyatec-euml-design-tool
title: Soyatec eUML Design Tool
wordpress_id: 802
tags:
- tools
- uml
---

Once upon a time I used to be a fan of the TogetherJ UML design tool (in fact, I even [co-authored a book](http://www.amazon.co.uk/Better-Software-Faster-Coad-Carmichael/dp/0130087521) on it that sold, oh, 12 copies), and even though it isn't fashionable these days I still think there's a lot of value in UML as a way of expressing designs.

Anyway, for some of the documentation of [Apache Isis](http://incubator.apache.org/isis) I was looking around equivalent UML tools that offer similar capabilities to TogetherJ, preferably open source/free.  The one that seems to be closest is [Soyatec](www.soyatec.com), which offers both a free and a paid-for edition as plugins to Eclipse 3.7 and earlier.

What I like about this tool is that - like TogetherJ - it seems to generate the class diagrams from the Java source code, offering live updates, and uses Javadoc attributes as hints for the rendering.  However, it didn't take long to run into problems.

<!-- more -->

First off, the tool was unbearably slow when trying to work in my usual Eclipse workspace that has all the Apache Isis modules.  It would seem that the tool isn't too smart about figuring out which Java source code classes it needs to analyse for rendering, and which it can ignore.  Switching to a new workspace that just had the modules representing my domain object application seemed addressed that issue.

Next up... when I created a new class diagram and added some existing classes (from the examples/claims app which has Claimant, Claim, ClaimItem classes), the tool was clever enough to render a 1:1 association from Claim to Claimant, but couldn't figure out that a property of type List<ClaimItem> in the Claim class implied a 1:n association from Claim to ClaimItem.

I knew the tool could do this, though, and recalled that TogetherJ needed additional Javadoc attributes to render this correctly.  Scouring the Soyatec documentation didn't help, though ... it didn't seem to have any glossary of the different Javadoc attributes that were supported.  In the end I had to resort to manually adding dummy associations between the classes through the editor, in order to figure out which additional Javadoc annotations were needed.

Even then, though, I was unable to get the tool to render the association correctly; so I decided to delete the reference to Claim from the diagram and add it back in.  At this point the tool seemed to give up the ghost, and I couldn't persuade it to add the reference to Claim back into the diagram.

Conclusion: #soyatec #fail.  It's been deinstalled.

PS: I decided to wander over to Borland and download the latest [TogetherJ](http://www.borland.com/us/products/together/index.aspx) product, to see if its still usable or not.  Clicking on the "download trial" link took me to a form which I duly filled in, at which point I was notified that a sales representative would contact me shortly! In what way is that a download, may I ask?  Not impressed.
