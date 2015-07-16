---
title: '[ANN] Apache Isis version 1.6.0 Released'
slug: ann-apache-isis-version-1-6-0-released
author: danhaywood
comments: true
date: 2014-07-28 17:50:34+00:00
excerpt: Apache Isis 1.6.0 has been released, including new and improved event bus
  stuff to decouple business logic within the apps, and a new companion www.isisaddons.org
  for housing third-party modules.
layout: post
wordpress_id: 1299
tags:
- announce
- apache-isis
- guava
- isisaddons
- java
---

We just pushed out 1.6.0 of Apache Isis, which now consists of:

* Apache Isis Core version 1.6.0
* Wicket Viewer 1.6.0
* TodoApp Archetype 1.6.0
* SimpleApp Archetype 1.6.0

If you compare this announcement to that of [1.5.0]({{ site.baseurl }}/2014/06/07/ann-apache-isis-version-1-5-0-and-related-components-released/), you'll see that we're releasing a lot fewer components.  But that's because:

* Isis Core now incorporates the JDO Objectstore, Restful Objects Viewer and Shiro Security (all previously released as separate components).
* TodoApp Archetype was previously the 'Quickstart (Wicket/Restful/JDO) archetype'
* SimpleApp Archetype was previously the 'Simple (Wicket/Restful/JDO) archetype'

Full release notes are available on the Isis website, but there are some significant new features and reorganization worth calling out.

* Extend (custom) `EventBus` vetoing logic so that can also encompass hide, disable, validate (ISIS-831)
* `@DomainService` annotation to automatically discover and register domains (ISIS-493)
* Wicket viewer: Add edit capability to view objects (ISIS-781)
* Wicket viewer: Wizard-like form for Wicket viewer (ISIS-800, ISIS-810)
* Move jdo, shiro and restful into core (ISIS-832)
* Breaking out applib and JDO services into modules (ISIS-833)

The new EventBus stuff substantially helps decouple business logic in apps, while the @DomainService annotation reduces a lot of boring configuration.  But it's the last two bullet points I want to talk a bit more about.

**[www.isisaddons.org](http://www.isisaddons.org/)**

To expand on what these last two bullet points mean, as of 1.6.0 Isis now has a companion website, [www.isisaddons.org](http://www.isisaddons.org/).  Similar to the way in which Apache Wicket has an additional "wicketstuff" website [9], the intention is for this site to house various third-party extensions to Isis, such that they can either be used "out-of-the-box", or be forked and extended as need be.

Currently Isis add-ons fall into two categories:

* modules... these provide business functionality to be incorporated directly into your domain object model, usually as domain services, occasionally with supporting entities.  Examples include mail merge, spreadsheets, tags/labels.

* wicket extensions ... these extend the capability of the Wicket viewer, eg maps, calendars, charts.

In the future we expect to add in "metamodel" category for customizations to Isis' metamodel, eg an extension to leverage various Java 8 reflection features which we don't want to roll into Isis core just yet.

The intention is for all modules in [www.isisaddons.org](http://www.isisaddons.org/) to follow a standard format, and include full unit and integration testing.  Thus, if you want to fork and extend any given module, then there is a solid base to start from.  Over time we hope that the "modules" in particular will provide a useful catalog to help bootstrap Isis development, and provide a way for the community to contribute back their own functionality as modules.

We are also considering moving some of Isis' own modules (ie those recently factored out, such as for auditing, command, publishing etc) into [www.isisaddons.org](http://www.isisaddons.org/).  Doing so will reduce the size of Isis itself while making it possible for these components to be more easily extended/adapted by the user community as need be.  We will certainly take a *copy* of these modules in the first instance.

OK, that's it.  Go check it out...
