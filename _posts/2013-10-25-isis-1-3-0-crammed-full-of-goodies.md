---
title: '[ANN] Apache Isis 1.3.0 - crammed full of goodies!'
author: danhaywood
comments: true
date: 2013-10-25 18:00:45+00:00
layout: post
slug: isis-1-3-0-crammed-full-of-goodies
wordpress_id: 1213
tags:
- announce
- apache-isis
- restful-objects
---


Over on [Apache Isis](http://isis.apache.org), we've just released a new version, 1.3.0, of the framework (core plus supporting components).

There are some major new features in this release; indeed this is probably the most significant release of Isis as a TLP.  Just to highlight some of the main features...

In core, the new features include:

* contributed collections and properties
* view model support (across both Wicket and RO viewers)
* UI layouts defined in JSON files
* better integration and BDD testing support, including Cucumber-JVM integration
* domain services for handling application and user settings service
* domain service providing various developer utilities (eg downloading metamodel)
* domain service incorporating Guava's EventBus service);
* context-specific autoComplete
* conditional choices
* new annotations: `@SortedBy`; `@CssClass`; `@PostsPropertyChangedEvent`
* helpers for writing contract unit tests and for writing comparable entities
* optimistic locking improvements

In the Wicket viewer, new features include:

* default dashboard
* more sophisticated layouts, with multiple columns
* dynamic reloading of layouts
* sortable table columns
* BlobPanel displaying images
* bookmarkable actions
* upgrade to wicket 6.11.0

In JDO objectstore, new features include:

* better integration/validation between Isis and JDO metamodels
* upgrade to DataNucleus 3.2.7
* better Google App Engine compatibility
* expose JDO `PersistenceManager` via domain service for more sophisticated use cases


The Restful Objects viewer also had several bug fixes vis-a-vis the RO spec v1.0 (thanks to our GSOC students for highlighting these).

In addition to all that, there is a new "simple" archetype, making it easier to [get started](http://isis.apache.org/getting-started/simple-archetype.html).

The full release notes etc are available on the Isis website.


