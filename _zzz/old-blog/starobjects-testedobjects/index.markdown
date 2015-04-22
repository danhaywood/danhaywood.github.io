---
author: danhaywood
comments: false
date: 2009-09-11 08:03:57+00:00
layout: page
published: false
slug: starobjects-testedobjects
title: for FitNesse
wordpress_id: 247
---

[![](http://fitnesse.org/files/images/FitNesseLogo.gif)](http://fitnesse.org)
[Tested Objects](http://testedobjects.sourceforge.net) is a sister project that integrates [FitNesse](http://fitnesse.org) with domain applications written in Naked Objects.

You probably know about FitNesse.  It allows the agile developer (or business analyst) to write out scenarios that describe the interactions with a "system under test", from an external actors' perspective.  These scenarios can then be executed; the scenario is then annotated to indicate whether the test has succeeded or failed:

[![ClaimsAppSuite-TestResults](http://farm4.static.flickr.com/3491/3908528457_c0ecab4e95.jpg)](http://www.flickr.com/photos/danhaywood/3908528457/)

The "system under test" is often an application with a GUI on it, and the external actor is usually an end-user.  More generally though the system under test is any standalone subsystem (or bounded context in DDD parlance), and the external actor might be an person or it could be another system (such as an adapter for enterprise service bus, say).

Normally with FitNesse the developer must write fixture code that integrates the scenario test with the system under test.  We don't want the scenario test to exercise the presentation layer code, instead it exercises the code underneath, the application or domain layer.

Tested Objects' FitNesse integration for Naked Objects provides a set of fixtures that can drive the underlying domain model, in the same way that a Naked Objects viewer uses the model.  That means that the scenario tests can be described in a very natural way, but there is no need for the developer to write any of this fixture code.

Tested Objects provides a [Maven](http://maven.apache.org) archetype to get you up and running quickly, which bundles FitNesse and provides a built-in user guide.  The set of fixtures listed in the user guide are:

[![UserGuide](http://farm4.static.flickr.com/3447/3908528361_d3a05c803a.jpg)](http://www.flickr.com/photos/danhaywood/3908528361/)

So, for example, here's how we would use Tested Objects to invoke an action:

[![UsingNakedObjectsViewer.ExampleUsage](http://farm3.static.flickr.com/2662/3909310100_69200bd9ed.jpg)](http://www.flickr.com/photos/danhaywood/3909310100/)

See the [project website](http://testedobjects.sourceforge.net) for more details.
