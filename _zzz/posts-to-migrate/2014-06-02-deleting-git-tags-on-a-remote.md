---
author: danhaywood
comments: true
date: 2014-06-02 14:06:41+00:00
layout: post
slug: deleting-git-tags-on-a-remote
title: Deleting git tags on a remote
wordpress_id: 1292
tags:
- apache isis
- git
---

For some reason our [git repo](https://git-wip-us.apache.org/repos/asf?p=isis.git) for [Apache Isis](http://isis.apache.org) (mirrored on [github](http://github.com/apache/isis)) acquired a bunch of tags in the form: 




	
  * upstream/isis-1.4.0

	
  * upstream/upstream/isis-1.4.0

	
  * upstream/upstream/upstream/isis-1.4.0

	
  * upstream/upstream/upstream/upstream/isis-1.4.0



Clearly something or someone has been accidentally pushing bad tags.

To remove these tags locally, I used:

[sourcecode language="sh"]
for a in `git tag -l upstream*`; do  echo $a; git tag -d $a ; done
[/sourcecode]

To remove these tags from origin, I chose to do it in two steps.  First locate the tags to be deleted:

[sourcecode language="sh"]
git ls-remote --tags origin | awk '{print $2}' | \
                              grep ^refs/tags/ | cut -c11- | \
                              grep upstream | grep -v "\^{}" \
                              > /tmp/y
[/sourcecode]

then delete 'em:

[sourcecode language="sh"]
for a in `cat /tmp/y`; do echo $a; git push --delete origin $a ; done
[/sourcecode]

