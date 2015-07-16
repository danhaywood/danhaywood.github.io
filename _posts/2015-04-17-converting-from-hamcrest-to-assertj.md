---
author: danhaywood
comments: true
date: 2015-04-17 04:53:28+00:00
layout: post
slug: converting-from-hamcrest-to-assertj
title: Converting from Hamcrest to AssertJ
wordpress_id: 1322
tags:
- apache-isis
- assertj
- hamcrest
- isisaddons
- java
- junit
- tdd
---

Don't quite know how I missed it all these years, but I only recently discovered [AssertJ](http://joel-costigliola.github.io/assertj/).  So I've started to use it in some of the [Isis Addons](http://isisaddons.org) example apps, for example the [todoapp](http://github.com/isisaddons/isis-app-todoapp).

I had a look to see if there were any scripts to convert the Hamcrest assertThat assertions into corresponding AssertJ ones, but only turned up [Joel's script](http://joel-costigliola.github.io/assertj/assertj-core-converting-junit-assertions-to-assertj.html) that works on vanilla JUnit `assertEquals(...)` assertions.  So I spent a bit of time updating it to support Hamcrest style assertions.  (I also refactored it so that it doesn't rely on `sed -i` which seems to be pretty broken on Windows).

You'll find a [copy of my updated script](https://github.com/isisaddons/isis-app-todoapp/blob/0f6ad47cf8c090527a3fcf8090a85b720d0fa514/convert-junit-assertions-to-assertj.sh)  in the todoapp's repo.  I've left in (though commented out) the original assertions for assertEquals etc; should be easy enough to add in if you want.

Please feel free to pass around!
