---
author: danhaywood
comments: true
date: 2013-07-05 11:09:20+00:00
layout: post
slug: cucumber-editors-in-eclipse
title: Cucumber editors in Eclipse
wordpress_id: 1175
tags:
- apache isis
- bdd
- cucumber
- cucumber-jvm
- dsl
- eclipse
- medit-symposium
- natural
- xtext
---

Just been experimenting with [Cucumber JVM](https://github.com/cucumber/cucumber-jvm), with a view to adding some new BDD tests into a project I'm working on. And so the obvious next step was to see if there are an integrations with [Eclipse](http://eclipse.org), my preferred IDE.

Turns out there are, helpfully summarised by some kind soul in this [public spreadsheet](https://docs.google.com/spreadsheet/ccc?key=0ArGwt1TE9pirdFE1UDd4UmI5U0RYdEdkbVVlWmxHZXc#gid=0). I tried out all the plugins listed there; for my money [Roberto Lo Giacco](https://github.com/rlogiacco)'s [plugin](https://github.com/rlogiacco/Natural) is the current winner. There's a handy [page of screenshots](https://github.com/rlogiacco/Natural/wiki/Screenshots), for example:

![Screenshot of Natural plugin](https://a248.e.akamai.net/camo.github.com/11f5cc7192046af770d64b21438e1c5ecdec4175/687474703a2f2f69313035312e70686f746f6275636b65742e636f6d2f616c62756d732f733432382f726c6f67696163636f2f68797065726c696e6b696e672e706e67)

What's also interesting is that this plugin is implemented in [XText](http://www.eclipse.org/Xtext/).  In [Apache Isis](http://isis.apache.org) we have [thought about](https://issues.apache.org/jira/browse/ISIS-369) implementing a DSL encoding Isis' programming conventions, and XText looks like a good candidate.

I'm scheduled to present (on Isis, of course) at the inaugural [Medit-Symposium conference](http://www.medit-symposium.com) in Sicily in October, and one of the [other sessions](http://www.medit-symposium.com/schedule-day-two.html) there is on XText.  Given at what Roberto has made XText do for Cucumber, I'm looking forward to learning more there!
