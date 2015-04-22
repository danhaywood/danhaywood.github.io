---
author: danhaywood
comments: true
date: 2010-05-09 08:37:07+00:00
layout: page
published: false
slug: viewer-stories
title: Viewer Stories
wordpress_id: 578
---

On the [Project Ideas](http://danhaywood.com/resources/project-ideas/) page I've listed a number of suggestions for extending the Naked Objects framework. Some of the larger projects are around building a generic viewer OOUI in various technologies (Android, JavaFX, GWT, etc).

To help understand what it takes to develop such a viewer, here's a list of user stories / features. I've ordered them in the probable order of implementation.

0001 Set up dev env
0002 Representation of application (menu) services/repositories

0003 Display no-arg actions for domain services

0004 Invoke no-arg application service action returning a domain object

0005 Render domain entity title
0006 Render domain entity icon

0007 Render domain entity properties
- read-only
- treat all properties as strings

0008 Handle additional basic property types
- integer, string, date, boolean

0009 Handle references properties
- eg Customer Address

0010 Navigate to object referenced within a property

0011 Render domain entity collections
- read-only

0012 Navigate to object referenced within a collection

0013 Render no-arg actions of entity

0014 Invoke a no-arg action of an entity returning a single object
0015 Invoke a no-arg service action returning a (standalone) collection
0016 Invoke a no-arg action returning a scalar
0017 Invoke a no-arg action returning void

0018 Navigate to object referenced within a standalone action

[0019-0025] technology specific stories, eg handling reorientation of a tablet.

0026 Invoke application service action taking simple datatypes
- strings, int, date, boolean

0027 Invoke entity action taking simple datatypes
- strings, int, date, boolean

0028 Invoke application service action taking reference to other object
- with choices drop-down
0029 Invoke application service action taking reference to other object
- with autocomplete drop-down

0030 Validate action arguments
0031 Choices for action arguments
0032 Defaults for action arguments

0033 Editable entity properties taking simple datatypes
- “save-as-you-go”, single properties
- strings, int, date, boolean

0034 Choices for entity properties

0035 Editable entity properties with references to other objects

0036 Validate entity properties
0037 Disable entity properties

0038 Updating multiple properties of an entity
- in single request

0039 User authentication

0040 Error handling of optimistic locking failure
0041 Error handling of stale reference to deleted object
0042 Error handling of error thrown by application

0043 Extensibility: register new renderers for properties
0044 Extensibility: register new renderers for properties and action params
0045 Extensibility: register new renderers for standalone collections
0046 Extensibility: register new renderers for parented collections
0047 Extensibility: register new renderers for entities
