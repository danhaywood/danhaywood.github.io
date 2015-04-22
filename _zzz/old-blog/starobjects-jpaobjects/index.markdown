---
author: danhaywood
comments: false
date: 2009-09-11 10:20:00+00:00
layout: page
published: false
slug: starobjects-jpaobjects
title: for JPA/Hibernate
wordpress_id: 252
---

[![](https://www.hibernate.org/tpl/hibernate3/img/hibernate_icon.gif)](http://hibernate.org)

JPA Objects is a sister project for Naked Objects that provides an object store implementation allowing your domain objects to be persisted in a relational database.  You annotate your domain objects using JPA annotations and let the object store do the rest!

Okay, so it's never quite as easy as that, but JPA Objects does its best to simplify the integration task.  It uses [Hibernate](http://hibernate.org) as the underlying JPA implementation, and supports a number of the Hibernate-specific annotations for any

JPA Objects provides the following features:



	
  * all the standard mappings of entities and relationships using JPA annotations

	
  * mapping of values using Hibernate's UserType and CompositeUserType classes

	
  * mapping of interface relationships using Hibernate's @Any and @ManyToAny annotations

	
  * a Maven archetype

	
  * repository support, through @NamedQuery

	
  * a command line tool to build the schema (really, just a wrapper around Hibernate's own hbm2dddl tool)

	
  * a command line tool to populate the database (reusing Naked Object fixture objects that you probably created during prototyping)


The main constraint to be aware of that JPA Objects requires on your domain classes is that they:

	
  * provide (or inherit) an @Id property;

	
  * is annotated with the JPA @DiscriminatorValue (even if not part of an inheritance hierarchy).


This are required to allow the integration with Naked Objects' own handling of object identity.

See the [project website](http://jpaobjects.sourceforge.net) for more details.
