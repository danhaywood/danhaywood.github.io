---
title: '[ANN] Apache Isis version 1.5.0 and related components Released'
slug: ann-apache-isis-version-1-5-0-and-related-components-released
author: danhaywood
comments: true
date: 2014-06-07 18:21:32+00:00
layout: post
wordpress_id: 1297
tags:
- announce
- apache-isis
- java
- jrebel
- maven
- restful-objects
- apache-shiro
---

The Isis team is pleased to announce the release of:

- Apache Isis Core version 1.5.0
- Wicket Viewer 1.5.0
- Restful Objects Viewer 2.3.0
- JDO Object Store 1.5.0
- Shiro Security 1.5.0
- Simple Archetype 1.5.0
- Quickstart Archetype 1.5.0

New features and improvements in this release include:

- Additional `EventBus` service events, ability to programmatically trigger events, vetoing subscribers (ISIS-550, ISIS-786)
- Integration testing improvements, most notably the new FixtureScript API and auto-injection of services into integration tests (ISIS-776, ISIS-782, ISIS-783)
- Better handling of multiple realms in Shiro security (ISIS-746)
- Better default column sizes for applib services (command, auditing, pubsub) (ISIS-744, ISIS-750)
- Precommit phase to flush pending updates for applib services (ISIS-769)
- Preparatory work for move to Java 7 (ISIS-569, ISIS-770, ISIS-772)
- Improved support for [JRebel](http://zeroturnaround.com/software/jrebel/) in Maven and various IDEs (ISIS-756)

Notable bug fixes include:

- Fixed blob/clob mapping in JDO Objectstore (ISIS-714)
- Fixed handling of mandatory boolean parameters in Wicket viewer (ISIS-431)
- RO not threadsafe when buiding metamodel (ISIS-777)

Full release notes are available on the Isis website.

