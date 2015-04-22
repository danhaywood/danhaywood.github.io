---
author: danhaywood
comments: true
date: 2013-01-20 12:28:20+00:00
layout: post
slug: apache-isis-codebase-refactored-adopting-semantic-versioning
title: Apache Isis codebase refactored, adopting semantic versioning
wordpress_id: 1078
tags:
- apache isis
- java
- semver
---

Following on from Isis' [recent graduation]({{ site.baseurl }}/2013/01/12/apache-isis-graduates-as-a-top-level-apache-project-gets-a-new-website/) as an Apache top-level project, I also blogged about how we have a new CMS-based site and also how we've [moved our code from Subversion and into Git]({{ site.baseurl }}/2013/01/16/apache-isis-sourcemoves-to-git/).  This is also part of a general theme to make Isis as easy as possible to contribute back to; all about growing the community.

Another change that we've made is that we've refactored the codebase into separately releasable components.  Isis has <!-- more -->always had a componentized architecture - broadly following the [hexagonal architecture](http://www.google.co.uk/url?sa=t&rct=j&q=hexagonal%20architecture&source=web&cd=1&cad=rja&sqi=2&ved=0CC8QFjAA&url=http%3A%2F%2Falistair.cockburn.us%2FHexagonal%2Barchitecture&ei=qFfxUIm1FeyY0QW7l4CgBA&usg=AFQjCNGkhC9Z0sbqrxb0beHAItMWuvbsXg&bvm=bv.1357700187,d.d2k) pattern - however historically released all the components at once.  That tends to make it quite a big deal to co-ordinate.

So instead, Apache Isis now consists of a [core module](http://isis.apache.org/documentation.html) that defines a number of APIs: objectstore (persistence), authentication, authorization, user profile (preferences) and also the viewer API.  Core also provides simple implementations of these components - suitable for prototyping - while other components are intended for production use.  For example, the core implementation of the object store is the in-memory objectstore, whereas the JDO objectstore component uses JDO/DataNucleus.

This componentized architecture will definitely help us release code more frequently, but the flip side to it is potentially more complexity, with both core and each of the components versioned independently.  To keep things manageable, we've decided to adopt [semantic versioning](http://semver.org/); both core and every component is versioned x.y.z.  Bumping up z means a patch to an implementation; bumping up y means a new feature that is backwardly compatible; bumping up z means a breaking change to an API.  Thus if a future JDO objectstore v1.2.3 runs against Isis Core v1.1.0, then it should also run against v1.1.1, v1.2.0, v1.9.3 ... but not necessarily Isis Core v2.0.0.

That said, we're also maintaining a [release matrix](http://isis.apache.org/release-matrix.html) so that you can check, at a glance, what the dependencies of any given component are.

The last thing to mention on this topic is archetypes.  Again, historically we've shipped an archetype that's bundled together all of the various components that make up Isis.  This has two downsides.  First, it can make Isis more daunting to a would-be user than it needs to; and second, it is harder for us to test and pull together.

So instead we've decided to put out a number of archetypes that represent typical usages/profiles of Isis; these tending also to align with a particular components maintained by any given committer.  For example, I work on the JDO objectstore, the Wicket viewer and the Restful objects viewer; since these are my "babies", there's an archetype that combines these together.  I believe that [Rob Matthews](http://www.objectconnexions.co.uk/) will also be putting together an archetype that combines off the Scimpi viewer with the NoSQL objectstore.
