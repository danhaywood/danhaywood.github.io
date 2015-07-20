---
author: danhaywood
comments: true
date: 2013-07-15 12:28:02+00:00
layout: post
slug: enabling-ci-for-github-projects
title: Enabling CI for github projects
wordpress_id: 1182
tags:
- agile
- ci
- github
- maven
---

I've noticed a couple of times on visiting miscellaneous github projects that there's been a little logo indicating the state of the CI build. Hmm, thought I... I guess there's some service out there that can be configured. Probably a bit of a pain to get going. Maybe one day, but not today, I thought.

But today I took a deeper look, and had a go at configuring CI using [travis-ci.org](http://travis-ci.org). And it turns out I was wrong... it's trivially easy to get going (for my Maven-based Java projects, at any rate).

Step 1: register at travis-ci.org, with your github credentials.  Travis needs them to find your repositories and to install its git commit hooks.

Step 2: per [this doc](http://about.travis-ci.org/docs/user/languages/java/), create a .travis.yml file, with the content:
`
language: java
`


Step 3: update your README.md with the link to the image.  Eg for my [java-testsupport](https://github.com/danhaywood/java-testsupport) project, the text to include was:

<pre>
    [![Build Status](https://travis-ci.org/danhaywood/java-testsupport.png?branch=master)]
    (https://travis-ci.org/danhaywood/java-testsupport)
</pre>

Step 4: Back in travis-ci.org, go to your [profile](https://travis-ci.org/profile) page and flip the switch for the github repo(s) that you've configured:

[![travis-ci-profile-page]({{site.baseurl}}/images/travis-ci-profile-page.png?w=600)]({{site.baseurl}}/images/travis-ci-profile-page.png)

Step 5: push your change, and let Travis do its thang.  After a minute or two, the home page should show the status of all your builds, with a console view for any that failed:

[![travis-ci-home-page]({{site.baseurl}}/images/travis-ci-home-page.png?w=600)]({{site.baseurl}}/images/travis-ci-home-page.png)

Step 6: over on your github page, you should be able to see the status too:

[![github-build-status]({{site.baseurl}}/images/github-build-status.png?w=600)]({{site.baseurl}}/images/github-build-status.png)


And honestly, that's all there is to it.  Ridiculously easy. 

