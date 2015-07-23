---
author: danhaywood
comments: true
date: 2012-01-20 19:58:57+00:00
layout: post
slug: jquerymobile-on-apache-isis-rest-api
title: JQueryMobile on the Apache Isis' REST API
wordpress_id: 888
tags:
- apache-isis
- jquerymobile
- restful-objects
---

We're currently working towards 0.2.0 of [Apache Isis](http://incubator.apache.org/isis) (incubating), and one of the most significant new areas of functionality is the REST API that it automatically provides through the json-viewer component.  As you can probably guess from the name, this viewer provides a REST interface which exposes JSON representations of the domain object models.

However, JSON representations do not a user interface make; instead the idea is that the developer will write either custom or generic UIs to consume those representations.  As an example of such an app (and by way of learning a little more Javascript) I've put together a very simple mobile app using the recently-released [JQueryMobile](http://jquerymobile.com) framework.

<!-- more -->

For now, this mobile app is part of the Apache Isis online demo, which you can download as a [WAR](https://sites.google.com/a/haywood-associates.co.uk/restfulobjects/files/onlinedemo-webapp-0.2.0-incubating-SNAPSHOT.war) or as a [self-hosted WAR](https://sites.google.com/a/haywood-associates.co.uk/restfulobjects/files/onlinedemo-webapp-0.2.0-incubating-SNAPSHOT-jetty-console.war) (run using java -jar ...).  By the time you read this it may well also be available online [here](http://mmyco.co.uk:8180/isis-onlinedemo/).

To try out the demo, the first thing you'll need to do is to register a user through the HTML viewer, and then reset the demo fixtures to create some initial data for your newly-created user.  The demo has full documentation on how to do this, so I won't repeat it here.

Once you've done that, you'll be able to browse to the home page for the mobile app (under mobile/index.html); you should see a home page showing just a single button:

[![](http://danhaywood.files.wordpress.com/2012/01/jqm-home.png?w=173)](http://danhaywood.files.wordpress.com/2012/01/jqm-home.png)

When you press that button, you'll find that your prompted for a username/password; this is the Basic Authentication that is used to secure the demo app.  Enter the username/password that you just entered.

With the username/password successfully entered, you should see a list of todo-items; these are the result of a domain service action ( ToDoItems#todaysTasks(), to be exact):

[![](http://danhaywood.files.wordpress.com/2012/01/jqm-list.png?w=173)](http://danhaywood.files.wordpress.com/2012/01/jqm-list.png)

Thereafter everything in the app is generic; in other words it is able to display any domain object that is in the model.  For example, click on a link and you'll find yourself viewing one of the ToDoItems:

[![](http://danhaywood.files.wordpress.com/2012/01/jqm-object.png?w=173)](http://danhaywood.files.wordpress.com/2012/01/jqm-object.png)

Similarly, you can look at the contents of the 'similarItems' collection:

[![](http://danhaywood.files.wordpress.com/2012/01/jqm-collection.png?w=173)](http://danhaywood.files.wordpress.com/2012/01/jqm-collection.png)

And, from there, you can navigate to other domain objects, and so on.

This little webapp consists of ~200 lines of HTML (mobile/index.html), about ~300 lines of custom Javascript (mobile/app.js, mobile/generic.js, mobile/util.js and mobile/namespace.js).  The rest of the Javascript magic is JQuery, JQueryMobile and JQuery-tmpl.

In the [next post]({{ site.baseurl }}/2012/02/01/jquerymobile-demo-app-walkthr/) I'll go through the source code and dissect it a little; in the meantime though you're welcome to reverse-engineer it yourself.

As ever, comments welcome.
