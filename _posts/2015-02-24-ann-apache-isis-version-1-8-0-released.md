---
author: danhaywood
comments: true
date: 2015-02-24 08:45:20+00:00
layout: post
slug: ann-apache-isis-version-1-8-0-released
title: '[ANN] Apache Isis version 1.8.0 released'
wordpress_id: 1314
tags:
- announce
- apache-isis
- bootstrap
- i18n
- isisaddons
- neo4j
---

We just pushed another release of Apache Isis, and it's a big one! New features in this release include:

- a new theme-able look-n-feel for the Wicket viewer, using [Twitter Bootstrap](http://www.getbootstrap.com/) and [font awesome](http://fortawesome.github.io/Font-Awesome/icons/) icons
- a new simplified set of annotations (`@Property`, `@DomainObject`, `@CollectionLayout` etc) to make features more discoverable; see [cheat-sheet](http://isis.apache.org/intro/resources/cheat-sheet.html)
- support to enable multi-tenancy (in particular in conjunction with Isis addons [security module](https://github.com/isisaddons/isis-module-security))
- new [i18n support](http://isis.apache.org/config/i18n-support.html) using gettext .po files, honouring user locale
- [sign-up/self-registration](http://isis.apache.org/reference/services/user-registration-service.html) support (so that end-users can create own user accounts)
- `EmailService` for [sending HTML emails](http://isis.apache.org/reference/services/email-service.html), optionally with attachments [7]
- ability to validate individual parameters imperatively
- config property to flag use of deprecated annotations/method prefixes
- Maven plugin to validate domain object model with respect to Isis programming conventions
- improved support for Neo4J
- experimental support for more [flexibility of generating Restful Objects representations](http://isis.apache.org/components/viewers/restfulobjects/suppressing-elements-of-the-representations.html)

Full release notes are available on the [Isis website](http://isis.apache.org/core/release-notes/isis-1.8.0.html).

As of 1.8.0 we're continuing to trim down and simplify.  To that end, the Wicket Viewer is bundled in with Core, while the ToDoApp archetype is no longer provided.  In its place the [example todoapp](https://github.com/isisaddons/isis-app-todoapp) is available from Isis addons (not ASF) to fork and adapt.

Also, I should point out that this release finally drops support for JDK 1.6, standardizes on JDK 1.7
