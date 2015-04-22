---
author: danhaywood
comments: true
date: 2010-04-23 14:12:24+00:00
layout: page
published: false
slug: project-ideas
title: Project Ideas
wordpress_id: 560
---

moved to wiki, see https://cwiki.apache.org/confluence/display/ISIS/ProjectIdeasForStudents.

If you are a IT/CompSci student looking for an interesting project for your thesis, why not consider one of the following?  I'd be very glad to help you (and your supervisor) with any points arising.  For each project, I've also commented as to whether I think it's a small or large project.

_I've written up each of the projects so that it can be read standalone from the other projects, easily cut-n-pasted from this page into your project preamble._

**Project 1: Maven plugin
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

Apache Isis applications are built using Maven, the most commonly used open source build tool.  Maven itself is a highly extensible build platform.  This project is to develop a plugin for Maven that will validate the Isis metamodel.  This allows semantic contradictions in the metamodel (such as saying a property is both visible and not visible at the same time) during the build phase, allowing such errors to be rapidly fixed.

_This is a small project; of interest to those who understand how important good configuration management and build management is.  Would need a fairly technical person who is able to pick through Maven open source code to figure out how to write plugins.  An Isis ticket for this has already been raised, so it might get done anyway (see [ISIS-284](https://issues.apache.org/jira/browse/ISIS-284)).
_

**Project 2: Polyglot Domain Models
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

Apache Isis works its magic by building a metamodel; the viewers then interrogate this metamodel in order to render the domain objects.  This metamodel captures semantics intrinsic to the domain (such as whether a property or action is enabled or not) along with some semantics about the UI layer.

Internally, the Apache Isis "metamodel builder" is extensible, and could be used to support any JVM-based language. There is already basic support for [Groovy](http://groovy.codehaus.org/).

This project is to extend Isis to allow enterprise applications to be developed in some other language, such as [Scala](http://www.scala-lang.org/), [JRuby](http://jruby.org/) or [Kotlin](http://kotlin.jetbrains.org/).  All of these have the power of Java, but incorporate constructs from various functional languages.  The end result will be the ability to develop and deploy enterprise applications written in one of these other languages, running either as a rich client app or on the web.

_This is actually a pretty small project.  The work involved is amounts to writing a bunch of FacetFactorys, and there is already the Groovy support to work from.  It might appeal to those who want to learn another JVM language.
_

**Project 3: A Domain-specific language for Isis
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

Apache Isis works its magic by building a metamodel; the viewers then interrogate this metamodel in order to render the domain objects.  This metamodel captures semantics intrinsic to the domain (such as whether a property or action is enabled or not) along with some semantics about the UI layer.

Isis currently relies on naming conventions to build up its metamodel, for example: a property firstName, accessed by the getFirstName() method, can be made read-only if the disableFirstName() method returns a non-null string.  Although not too onerous to maintain, it is possible to orphan these supporting methods if a property or other class member is renamed.

This project therefore is to develop a domain-specific language (DSL) for Isis that obviates such issues.

_This is a medium-sized project.  Some discussion of this has occurred on the Isis mailing list, see [this thread](http://markmail.org/thread/f6sw6tsmhynugrru) and in particular [this post](http://markmail.org/message/d3tz72fdwad5ccw4).  The thread also has some ideas on implementation tools to use.
_

**Project 4: Mashup Views
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

One of the limitations of Isis out-of-the-box though is that this OO UI is just that, generic.  If collection of Appointment objects will just be shown as a list, rather than, say, as a Calendar.  Similarly, a collection of CompanyAddresses will also be shown as a list, rather than, say, rendered on a Google Map.

This project will extend Isis wicket viewer to allow it to support various so-called "mash-up" views, including the Calendar and Google Map views above.  Graphs (pie charts, line charts etc) are another obvious example.

_This is a small project (though could be as large as you wish).  Adding support for Calendar view has been done already for a non open source project._

**Project 5: JavaFX viewer
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

Isis has an extensible architecture making it straight-forward to add new viewers (on the front-end) and persistence stores (on the back-end).  Out-of-the-box Isis ships with a several web viewers as well as an AWT client for exploration.  There are however a number of new and interesting UI technologies, one of which is JavaFX.  This promises a much richer set of animations and capabilities.

This project is to develop a new viewer for Isis using JavaFX.  Ideally, this should use the Restful API.
_
This is a large project, but could be of interest to anyone who likes developing sexy-looking UIs in fancy technologies.  It has in fact been tackled once already, but ran against a forerunner of the current Restful API_

**Project 6: Rich webapp viewer
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

Isis has an extensible architecture making it straightforward to add new viewers (on the front-end) and persistence stores (on the back-end).  Out-of-the-box Isis ships with a several web viewers.  These are all quite traditional page-oriented webapps, with only small bits of Ajax.  

The modern web experience however is much richer than HTML-based viewers, being characterized by apps such as Gmail.  This project therefore is to develop a new web viewer for Isis using a library such as [Vaadin](http://vaadin.com/), [ExtJS](http://www.sencha.com/products/extjs), [Kendo UI](http://www.kendoui.com/) or perhaps Google's [GWT](https://developers.google.com/web-toolkit/).

_This is a large project.  For Vaadin or GWT, my Wicket viewer would be a good starting point to work from.  For ExtJS and KendoUI, these would probably end up using the Restful API.  An option here is to use the [Spiro](http://nuget.org/packages/RestfulObjects.Spiro/0.10.0-beta) library.
_

**Project 7: Multi-touch (Android) viewer
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

Isis has an extensible architecture making it straightforward to add new viewers (on the front-end) and persistence stores (on the back-end).  Out-of-the-box Isis ships with a several web viewers.  Notable by its omission though is any support for mobile devices.

Google's Android platform supports Java apps; it also supports multi-touch interactions, opening up the possibility of interesting new ways of manipulating domain objects directly.

This project is to develop a generic viewer for Isis to be deployed onto Android-based mobile devices.  It could be a native Android app, or it could use a web framework such as [Sencha Touch](http://www.sencha.com/products/touch) or [Kendo UI](http://www.kendoui.com/).

_This is a large project, but definitely do-able.  In fact, there was a PDA-based student project done with an early version of Naked objects, see [http://opensource.erve.vtt.fi/pdaovm/pda-ovm/index.html](http://opensource.erve.vtt.fi/pdaovm/pda-ovm/index.html).  For a Sencha/KendoUI solution, the work involved would be almost identical to developing a rich webapp, accessing through the the Restful API, eg via the [Spiro](http://nuget.org/packages/RestfulObjects.Spiro/0.10.0-beta) library.
_

**Project 8: NoSQL/Cloud-based Persistence Stores
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

Isis has an extensible architecture making it straightforward to add new viewers on the front-end, but also to define new persistence stores for the back.  Out-of-the-box Isis supports a variety of object stores; one of these is DataNucleus.  Although typically used with an RDBMS', it can also connect to non-relational ('NoSQL') persistence stores.

This project, then, is to demonstrate the use of Isis against a NoSQL object store.

_This is a very small project; most of the work is likely to be in configuring DataNucleus.  It might be interesting to configure against the Cloud datastores however._

**Project 9: IDE Support for Domain Models
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

Isis works its magic by building a metamodel of the Java code, where the Java code is POJO-based, along with a number of "convention over configuration" extensions.  For example, Isis detects that a Customer has a firstName property by the presence of a getFirstName() / setFirstName() pair.  But it also notices methods such as disableFirstName(), hideFirstName() and other supporting methods, that are used to capture imperative business rules.  Collectively this set of conventions is called the "Isis programming model".

This project is to provide IDE tooling to support the Isis programming model, for example so that a rename refactor of a property (getFirstName(), setFirstName()) will also update the supporting methods (disableFirstName(), validateFirstName() etc).

_This is a small-to-medium-sized project.  I've just listed one example, but it could go much further.  For example, a view could be provided showing all properties/collections in a list.  Moving these up and down would adjust the @MemberOrder annotation.  Or, a view could be used to allow annotations to be applied using checkboxes.  I have in fact done some work on this for Eclipse 3.3, but the project was mothballed while I wrote my book.  That project (source code [here](https://github.com/danhaywood/apache-isis-ide)) could be resurrected, or start afresh.   Alternatively, they might want to write plugins for NetBeans or IntelliJ are also options since both freely available._

**Project 10: IDE UML Tooling for Domain Models
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

Isis works its magic by building a metamodel of the Java code, where the Java code is POJO-based, along with a number of "convention over configuration" extensions.  Generally speaking a domain model implemented in Isis is very clean.

Still, a picture tells a thousand words, and a UML class diagram can be a powerful way of understanding the entities involved in a domain model.  This project is therefore to provide a plugin for an IDE to render a Isis domain model as a UML class diagram.  Initially the project will focus on generating a read-only view; if time then this will be enhanced to be read/write (ie to modify the code through the diagram).

_This is a large-ish project.  Of course, there are commercial tools out there (such as [Omondo](http://www.omondo.com/), [AgileJ](http://www.agilej.com/) and [TogetherJ]()) that do this.  But it'd be nice to be able to pick up and render the Isis-specific conventions (eg render hidden properties differently from disabled properties).  The project could be descoped by having it simply take an existing UML tool and extend it.  And/or, the project could be combined with the previous one, to provide general-purpose IDE tooling.
_

**Project 11: Story Recorder
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

The fact that the UI is taken care of automatically makes it very easy to put together enterprise applications, focusing only on the bit that matters: the domain model.  In fact, it becomes possible to pair-program directly with a non-technical domain expert, the domain expert identifying the business rules and the developer implementing them directly.

However, this isn't enough for enterprise apps; we also need a set of tests that define the behaviour of the system independently from the code.  These become the documentation for the system, and provide a safety net for regression testing.  The question is: how to write these tests?

Because Isis generates the OO UI at runtime, it is in full control of the interactions made from the UI to the domain model.  This opens up the possibility of a "record button" that captures those interactions, and then dumps them out for various purposes, eg to code generate a JUnit test, or a FitNesse test, or to capture a defect for replay.  It could also, possibly, be used to create a macro-definition device.

_This is a small-to-medium sized project.  It would fit in with Isis' ability to run Concordion tests (through the BDD viewer).
_

**Project 12: Story Writer
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

The fact that the UI is taken care of automatically makes it very easy to put together enterprise applications, focusing only on the bit that matters: the domain model.  In fact, it becomes possible to pair-program directly with a non-technical domain expert, the domain expert identifying the business rules and the developer implementing them directly.

However, this isn't enough for enterprise apps; we also need a set of tests that define the behaviour of the system independently from the code.  These become the documentation for the system, and provide a safety net for regression testing.  The question is: how to write these tests?

Isis works its magic by building a metamodel; the viewers then interrogate this metamodel in order to render the domain objects.  Isis has an extensible architecture making it straightforward to add new viewers on the front-end, which opens up the possibility of a viewer that's designed to make test writing easy.

This viewer would present the test author with a simplified view of domain objects, and make it easy for the author to make assertions about the state of those objects or on the post-conditions following an interaction.  It could also, possibly, launch one of the regular viewers to allow the user to inspect the current state of the system.

Once the test is written, the viewer would allow the test script to be dumped into an external format, eg so it can be converted into a JUnit or FitNesse test.

_This is a relatively large project.  There's obviously some overlap with the other two testing projects.
_

**Project 13: iTunes Clone
**
Apache Isis is a full-stack, open source Java framework for building enterprise apps.  The twist is that you do this just by writing the domain objects that sit in the domain model; Isis takes care of the UI and persistence layers for you, creating a generic OO UI at runtime as a webapp.  Alternatively, it can generate a Restful API, in line with the [Restful Objects spec](http://restfulobjects.org)

Because of its focus on the domain model, Isis is a natural bed-fellow with domain-driven design.  DDD defines a set of patterns that describe how to architect enterprise-apps, with a correct separation of concerns.  Part of this is the use of domain services that allow the core business parts of a domain to be separated from technical concerns.

Now we all like to listen to our MP3s, so how about implementing an iTunes clone following DDD principles?  There are some nice entities to model (Artist, Album, Genre etc), but there are also some technical concerns that need solving (how to actually play the MP3, how to purchase new tunes off the web).  So this project is to implement iTunes from the ground-up, using Isis, and following strict DDD principles.

_This is small-to-medium sized project.   could also be extended by bring in some of the composite views of other projects (eg a coverflow viewer).  If this application doesn't appeal, then perhaps a Twitter-clone, or Facebook-clone, or any other of those hip and trendy websites?_

