---
author: danhaywood
comments: true
date: 2008-11-05 00:51:00+00:00
layout: post
slug: hibernate-3-3-1-ga-is-probably-broken-with-cglib
title: Hibernate 3.3.1.GA is (probably) broken with cglib.
wordpress_id: 29
---

Been playing around with Hibernate and upgrading - or trying to upgrade - to Hibernate [3.3.1.](http://3.3.1./) However, the Hibernate guys have decided to make javassist the default bytecode provider instead of cglib, because of a concern of possible incompatibilities of cglib's use with asm.  (Not sure their analysis is correct on this, but I'll leave that to another time).

<!-- more -->
The point of this post is that, to mitigate these possible incompatibilities, the Hibernate team have decided to repackage cglib into its their own namespace, so that net.sf.cglib becomes
org.hibernate.repackage.cglib.  This is the contents of hibernate-cglib-repack Maven module.

However, it looks like this repackaging is incorrect, which basically means that Hibernate 3.3.1 won't work with cglib. I might be wrong, but here's the bug report (my contribution is 3rd or so comment): [http://opensource.atlassian.com/projects/hibernate/browse/HHH-3504asd](http://opensource.atlassian.com/projects/hibernate/browse/HHH-3504)


UPDATE: the bug issue above has been commented on; apparently the problem has arisen because the Hibernate team used the Maven shale plugin to do the repackaging, which isn't smart enough to change package name implied in the string "[Lnet/sf/cglib/proxy/Callback".  Ok, but it's still a bug in a Hibernate module, however it was created.



[](http://opensource.atlassian.com/projects/hibernate/browse/HHH-3504)
