---
author: danhaywood
comments: true
date: 2015-04-18 06:37:42+00:00
layout: post
slug: an-adapter-to-use-hamcrest-matchers-as-assertj-conditions
title: An adapter to use Hamcrest matchers as AssertJ conditions
wordpress_id: 1324
tags:
- assertj
- hamcrest
- java
- junit
- tdd
---

Following on from [yesterday's post]({{ site.baseurl }}/2015/04/17/converting-from-hamcrest-to-assertj/) on AssertJ, here's a tiny [github repo](https://github.com/danhaywood/java-assertjext) that I put together with some utilities for AssertJ.

The first is the script mentioned yesterday, tidied up a little and renamed.

The second is a little adapter class that allows you to use Hamcrest Matchers as AssertJ Conditions.  So, if you have some really complex Hamcrest matcher stuff, you can migrate it easily:

    
```java
final String actual = "how now brown cow";
 assertThat(actual).is(matchedBy(Matchers.containsString("now brown")));
````

The adapter is provided by that "matchedBy" factory method.  But the github repo has a full README for details.
