---
author: danhaywood
comments: true
date: 2014-03-14 19:07:33+00:00
layout: post
slug: isis-1-4-0-released
title: Isis 1.4.0 released
wordpress_id: 1236
tags:
- announce
- isis
- restful
- wicket
---

After 4 months development, we've just released [Apache Isis](http://isis.apache.org) 1.4.0, and supporting components.

This is a pretty cool release, because it's the one that [Estatio](http://github.com/estatio/estatio) (the first major application to run on Isis) has been deployed against.

Some of the features in this release include:

- further support in `layout.json` files for additional facets and UI hints
- better reporting of metamodel validation errors (including a new page in Wicket viewer)
- improved support for bulk update
- `@javax.enterprise.context.RequestScoped` for request-scoped services
- `QueryResultsCache` request-scoped domain service (for performance tuning)
- new `MementoService` to support view models
- new request-scoped `@Bulk.InteractionontextService` for standardized co-ordination between bulk action invocations
- `Scratchpad` request-scoped domain service (for adhoc coordination between actions, eg bulk action invocations)
- `Command`, `CommandContext`, `BackgroundCommandService`, for profiling and background task support
- improvements to JDO implementations of auditing and publishing services, to integrate closely with the new command/backgroundCommand services
- improved support for running arbitrary Isis jobs via a scheduler
- supporting methods (`disableXxx`, `validateXxx`) for contributed actions/associations now supported
- services autowired prior to `@PostConstruct`, and Isis session present for service initialization
- JRebel support (JRebel plugin itself is third-party, see Isis website for details)

In the Wicket viewer, major changes/improvements include:

- show action dialogs in a modal dialog, rather than new page
- limit number of bookmarks, make less easier to accidentally trip, show/hide with keyboard shortcut
- improved IE9 support, bundle CSS files
- simplify URLs in Wicket viewer
- actions returning URL open new browser window
- UI sorting/ordering hints, pop-up to copy to clipboard
- breadcrumb drop-down to easily revisit previous page
- upper/lower case now switchable
- standalone tables now rendered according to runtime type, not compile-time type
- better tooltips over icon/titles

Full release notes are available on the Isis website.

