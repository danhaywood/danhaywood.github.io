---
author: danhaywood
comments: true
date: 2010-01-09 14:01:25+00:00
layout: post
slug: installing-maven-on-mac-os-x
title: Installing Maven on Mac OS X
wordpress_id: 481
---

Although I'm reasonably proficient with UNIX and I love its design, for most of my professional life I've used Windows; its environment I'm comfortable with, I know the keystrokes, I can be pretty productive etc etc.

But it seems that all the cool kids doing developers use Macs, <!-- more --> and I must admit the idea of being able to get to a proper UNIX shell (rather than cygwin) along with a set of apps that "just work" has been eating away at me.  So just before Xmas I took the plunge and bought a MacBook Pro, and used Xmas to copy over all my files and stuff from my old XP laptop.

So, now I'm busy rebuilding my dev environment, and one of the things that includes is installing [Maven](http://maven.apache.org), one of the prerequisites for Naked Objects.  After a bit of googling around I hit upon [MacPorts](http://macports.org), "an easy to use system for compiling, installing, and managing open source software".  Installing MacPorts itself is dead simple, just download its DMG and then run the PKG.  From there Maven can be installed using:


    
    $ sudo port install maven2



This will download Maven, install it and setup the UNIX environment variables etc.  It doesn't take a minute to run:


[![Screen shot 2010-01-09 at 13.34.22](http://farm5.static.flickr.com/4031/4258668603_c7de316fc5.jpg)](http://www.flickr.com/photos/danhaywood/4258668603/)


Now back to learning a few more of them Mac OS keystrokes!
