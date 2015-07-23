---
author: danhaywood
comments: true
date: 2012-02-01 23:29:59+00:00
layout: post
slug: jquerymobile-demo-app-walkthr
title: JQueryMobile demo app walk-thru
wordpress_id: 900
tags:
- apache-isis
- jquerymobile
- restful-objects
---

In the [previous post]({{ site.baseurl }}/2012/01/20/jquerymobile-on-apache-isis-rest-api/) I showed some screenshots of the simple [JQueryMobile](http://jquerymobile.com) app that is hosted by the [Apache Isis](http://incubator.apache.org/isis)' [online demo](http://mmyco.co.uk:8180/isis-onlinedemo) app, demonstrating one way of using the built-in [Restful API](http://restfulobjects.org). In this post, I want to look at the JQueryMobile code in a little more detail.

The app consists of a single html page, index.html, along with a number of supporting Javascript files.  We start by bring in the Javascript libraries, most notably JQueryMobile and JQuery:
<!-- more -->
[sourcecode language="html"]
<link rel="stylesheet" href="../jquery.mobile/jquery.mobile-1.0.min.css" />
<script src="../jquery/jquery-1.6.4.min.js"></script>
<script src="../jquery.mobile/jquery.mobile-1.0.min.js"></script>
<script src="../jquery.tmpl/jquery.tmpl-vBeta1.0.0.min.js"></script>
[/sourcecode]

You'll note that I've also brought in the JQuery.tmpl library for templating.  This has actually been discontinued by the JQuery team, but its replacement isn't yet available.  Since one templating solution is very much like another, I decided to carry on using it for this demo.

In addition to the third-party libraries, the app itself is broken up into a number of Javascript files:

[sourcecode language="html"]
<script type="text/javascript" src="namespace.js"></script>
<script type="text/javascript" src="util.js"></script>
<script type="text/javascript" src="generic.js"></script>
<script type="text/javascript" src="app.js"></script>
[/sourcecode]

The namespace.js just defines a namespace() function in order that the other stuff can be namespaced properly:

[sourcecode language="javascript"]
namespace = function(namespaceString) {
  var parts = namespaceString.split('.'),
  parent = window,
  currentPart = '';

  for(var i = 0, length = parts.length; i < length; i++) {
    currentPart = parts[i];
    parent[currentPart] = parent[currentPart] || {};
    parent = parent[currentPart];
  }
  return parent;
}
[/sourcecode]

Using this, the other script files define "util" and "generic" as aliases for a fully-qualified hierarchy:

[sourcecode language="javascript"]
var util = namespace('org.apache.isis.viewer.json.jqmobile.util');
var generic = namespace('org.apache.isis.viewer.json.jqmobile.generic');
[/sourcecode]

We'll dig into the Javascript some more in a moment, but the next thing we should look at is the index.html.  JQueryMobile works by serving a single div's at a time, and does all the animation between those div's.  In some apps those div's could be pulled down from a server dynamically; in the case of this app, though, all the div's we need are already within the index.html:

[sourcecode language="html"]
<body id="pageHolder">
  <div data-role="page" id="home"> ... </div>
  <div data-role="page" id="genericListView"> ... </div>
  <div data-role="page" id="genericDomainObjectView"> ... </div>
  <div data-role="page" id="genericObjectCollectionView"> ... </div>
</body>
[/sourcecode]


When we load the index.html initially into the browser, JQuery automatically shows the first div.  In our case this is the home div:

[sourcecode language="html"]
<div data-role="page" id="home">

  <div data-role="header">
    <h1>Home</h1>
  </div>

  <div data-role="content">
    <br/>
    <button>Todays Tasks</button>
    <ul data-role="listview" class="tasks"></ul>
  </div>

  <script class="tmpl" type="text/x-jquery-tmpl">
    <li>
      <a href="${href}">${title}</a>
    </li>
  </script>

  <script type="text/javascript">
    $("#home button").click(function(){
      $.mobile.changePage("../services/toDoItems/actions/toDosForToday/invoke", "pop")
    });
  </script>
</div>
[/sourcecode]

This renders a single button on the page.  The inline Javascript binds that to a JQueryMobile function to change page to the provided URL.  

As you can probably guess, that URL actually corresponds to the "toDosForToday"  action provided by the ToDoItems domain service.  In the normal scheme of things, if that URL served up a div, then JQueryMobile would automatically bring that div into the browser's DOM, and render it.  For our app, though, things are a little more complex, because invoking that URL will retrieve JSON.  What we need to do is to use that JSON to generate a div and then transition to it. 

The hook for doing this lives within app.js:

[sourcecode language="javascript"]
  $(document).bind("pagebeforechange", generic.submitRenderAndNavigate);
[/sourcecode]

This will cause the page transition ($.mobile.changePage) that we requested in the Javascript earlier to actually call the generic.submitRenderAndNavigate() function.  You can find this function in generic.js:

[sourcecode language="javascript"]
generic.submitRenderAndNavigate = function(e, pageChangeData) {
  if (typeof pageChangeData.toPage !== "string") {
    return;
  }

  var url = $.mobile.path.parseUrl(pageChangeData.toPage)
  var urlHref = generic.extract(url.href)
  if(!urlHref) {
    return;
  }

  generic.submitAndRender(urlHref, pageChangeData);
  e.preventDefault();
}
[/sourcecode]

The function can be called by JQueryMobile in two different ways: either the pageChangeData.toPage is a string, or it is an in-memory page object.  We intercept the former case (checking that the URL is parseable), and then delegate off to generic.submitAndRender() to do the ajax etc.  The call to e.preventDefault() suppresses JQueryMobile's usual page handling.

We're going to look at generic.submitAndRender() in a second, but for now it's worth understanding that the end result of that processing is a page object.  This is given back to JQueryMobile, which then calls back into this function.  The second time around the function just returns; because in this flow the e.preventDefault() is not called, JQueryMobile does its usual page transitions.

But, let's look to see how generic.submitAndRender() function ends up generating the page.  For a start, this is the method where the ajax call gets made:

[sourcecode language="javascript"]
generic.submitAndRender = function(urlHref, pageChangeData) {
  $.ajax({
    url : urlHref,
    dataType : 'json',
    success : function(json, str, xhr) {
      var contentType = xhr.getResponseHeader("Content-Type");
      var handler = generic.handlers[contentType];
      if(!handler) {
        alert("unable to handle response")
        return;
      }
      var pageAndOptions = handler(urlHref, pageChangeData, json, xhr)
     $.mobile.changePage(pageAndOptions.page, pageAndOptions.options);
   }
 })
}
[/sourcecode]

The example given here is only a demo, so there's no sad-case failure handling.  But assuming that the ajax call completes, the success callback looks up a 
handler function based on the returned "Content-Type".  Here's the lookup table:

[sourcecode language="javascript"]
generic.handlers = {
  "application/json;profile=\"urn:org.restfulobjects/domainobject\"": generic.handleDomainObjectRepresentation,
  "application/json;profile=\"urn:org.restfulobjects/list\"": generic.handleListRepresentation,
  "application/json;profile=\"urn:org.restfulobjects/objectcollection\"": generic.handleObjectCollectionRepresentation,
  "application/json;profile=\"urn:org.restfulobjects/actionresult\"": generic.handleActionResultRepresentation
}
[/sourcecode]

This looking up of the relevant handler is the heart of the app; using it we can handle representations of domain objects, a list, or a domain object collection, or an action result.

Since the demo app initially starts by invoking an action, let's look at the generic.handleActionResultRepresentation():

[sourcecode language="javascript"]
generic.handleActionResultRepresentation = function(urlHref, pageChangeData, json, xhr) {
  var resultType = json.resulttype
  var handler = generic.actionResultHandlers[resultType];
  if(!handler) {
    alert("unable to handle result type")
    return;
  } 
  return handler(urlHref, pageChangeData, json.result, xhr)
}
[/sourcecode]

As you can see, this also looks up a handler, this time based on the json.resultType of the returned json.result:

[sourcecode language="javascript"]
generic.actionResultHandlers = {
  "object": generic.handleDomainObjectRepresentation,
  "list": generic.handleListRepresentation
}
[/sourcecode]

Perhaps no surprise, the handler functions that the action result handler delegates to one-and-the-same as those we noted earlier.  So let's look at generic.handleListRepresentation in more detail (starting there simply because that's what the demo app does when you invoke the "todaysTasks" service action):

[sourcecode language="javascript"]
generic.handleListRepresentation = function(urlHref, pageChangeData, json, xhr) {

  var page = $("#genericListView");
  var header = page.children(":jqmData(role=header)");
  var content = page.children(":jqmData(role=content)");

  var items = generic.itemLinks(json.value)

  header.find("h1").html("Objects");

  var div = page.find("ul");
  var templateDiv = page.find(".tmpl");

  util.applyTemplateDiv(items, div, templateDiv);

  page.page();
  content.find( ":jqmData(role=listview)" ).listview("refresh");
  page.trigger("create");

  return generic.pageAndOptions(page, "genericListView", urlHref)
}
[/sourcecode]

The function uses a helper function generic.itemLinks to build a list of link objects.  Then, we identify the template script $("#genericListView .tmpl"), and pass both to the util.applyTemplateDiv helper function.  This in turn calls the jQuery.tmpl library to do the heavy lifting.  

Here's the HTML div that it works against:

[sourcecode language="html"]
<div data-role="page" id="genericListView">

  <div data-role="header">
    <a data-icon="back" data-rel="back">Back</a>
    <h1>List</h1>
  </div>

  <div data-role="content">
    <br/>
    <ul data-filter="true" data-role="listview"></ul>
  </div>

  <script class="tmpl" type="text/x-jquery-tmpl">
    <li>
      <a href="${href}">${title}</a>
    </li>
  </script>
</div>
[/sourcecode]

The href's of the link objects are formulated such that, when followed, they will again trigger the generic.submitRenderAndNavigate() function.  In this way, we are able to walk between (the representations of) connected domain objects.

Once the content has been generated, we call a bunch of JQueryMobile functions (page.page() and so on) to tell the framework to "enhance" the generated page.   And once that has been done, we call the generic.pageAndOptions() function to create the in-memory page.  We'll drill into that helper shortly.

Let's now have a look at the biggest of the handlers, the generic.handleDomainObjectRepresentation:

[sourcecode language="javascript"]
generic.handleDomainObjectRepresentation = function(urlHref, pageChangeData, json, xhr) {

  var page = $("#genericDomainObjectView");
  var header = page.children(":jqmData(role=header)");
  var content = page.children(":jqmData(role=content)");

  header.find("h1").html(json.title);

  // value properties
  var valueProperties = json.members.filter(function(item) {
    return item.memberType === "property" && !item.value.href;
  });

  valueProperties = $.map( valueProperties, function(value, i) {
    var dataType = generic.dataTypeFor(value)
    return {
      "id": value.id,
      "value": value.value,
      "dataTypeIsString": dataType === "string",
      "dataTypeIsBoolean": dataType === "boolean"
    }
  });

  var valuePropertiesDiv = page.children(":jqmData(role=content)").find(".valueProperties");
  var valuePropertiesTemplateDiv = page.children(".valueProperties-tmpl");
  util.applyTemplateDiv(valueProperties, valuePropertiesDiv, valuePropertiesTemplateDiv);

  // reference properties
  var referenceProperties = json.members.filter(function(item) {
    return item.memberType === "property" && item.value.href;
  });

  var referencePropertiesList = page.children(":jqmData(role=content)").find(".referenceProperties");
  var referencePropertiesTemplateDiv = page.children(".referenceProperties-tmpl");
  util.applyTemplateDiv(referenceProperties, referencePropertiesList, referencePropertiesTemplateDiv);

  var collections = json.members.filter(function(item) {
    return item.memberType === "collection";
  }).map(function(value, i) {
    var href = util.grepLink(value.links, "details").href
    return {
      "hrefUrlEncoded" : util.urlencode(value.links[0].href),
      "id" : value.id,
      "href" : value.links[0].href
    }
  });

  // collections
  var collectionsList = page.children(":jqmData(role=content)").find(".collections");
  var collectionsTemplateDiv = page.children(".collections-tmpl");
  util.applyTemplateDiv(collections, collectionsList, collectionsTemplateDiv);

  page.page();
  content.find( ":jqmData(role=listview)" ).listview("refresh");
  page.trigger("create");

  return generic.pageAndOptions(page, "genericDomainObjectView", urlHref)
}
[/sourcecode]

Although this handler is longer, it's doing much the same thing as the list handler.  Specifically, it processes the JSON into three lists, one for value properties, one for references properties, and one for collections.  For each, it uses the util.applyTemplateDiv function again in order to render against the corresponding templates, $("#genericDomainObjectView .valueProperties-tmpl") and so forth.

The corresponding div in the HTML is:

[sourcecode language="html"]
<div data-role="page" id="genericDomainObjectView">

  <div data-role="header">
    <a data-icon="back" data-rel="back">Back</a>
    <h1>Object</h1>
  </div>

  <div data-role="content">
    <div class="valueProperties"></div>
    <br/>
    <p>References</p>
    <ul data-role="listview" data-inset="true" class="referenceProperties"></ul>
    <br/>
    <p>Collections</p>
    <ul data-role="listview" data-inset="true" class="collections"></ul>
  </div>

  <script class="valueProperties-tmpl" type="text/x-jquery-tmpl">
  {{if dataTypeIsString}}
    <label for="${id}">${id}:</label>
    <input type="text" name="${id}" id="${id}" value="${value}" placeholder="${id}" class="required"/>
  {{/if}}
  {{if dataTypeIsBoolean}}
    <div data-role="fieldcontain">
      <fieldset data-role="controlgroup">
        <legend>${id}?</legend>
        <input type="checkbox" name="${id}" id="${id}" value="${value}" class="required"/>
        <label for="${id}">${id}</label>
      </fieldset>
    </div>
  {{/if}}
  </script>

  <script class="referenceProperties-tmpl" type="text/x-jquery-tmpl">
    <li>
      <a data-transition="slide" href="${value.href}">
        <p>${id}</p>
        <p><b>${value.title}</b></p>
      </a>
    </li>
  </script>

  <script class="collections-tmpl" type="text/x-jquery-tmpl">
    <li>
      <a data-transition="slideup" href="${href}">${id}</a>
    </li>
  </script>
</div>
[/sourcecode]

The template for value properties is, admittedly, a little ugly: it uses the {{if}} template in order to bring in either a checkbox or a textbox widget dependent on the value's type.  A more fully-featured application would probably generalize this to use subtemplates (and might even be extensible) to allow richer value types such as images or maps to be rendered accordingly.

The last of our handlers, generic.handleObjectCollectionRepresentation, is very similar to the generic.handleListRepresentation:

[sourcecode language="javascript"]
generic.handleObjectCollectionRepresentation = function(urlHref, pageChangeData, json, xhr) {
  var page = $("#genericObjectCollectionView");
  var header = page.children(":jqmData(role=header)");
  var content = page.children(":jqmData(role=content)");

  var items = generic.itemLinks(json.value)

  var parentTitle = util.grepLink(json.links, "up").title

  var collectionId = json.id;
  header.find("h1").html(collectionId + " for " + parentTitle);

  var div = page.find("ul");
  var templateDiv = page.find(".tmpl");
  util.applyTemplateDiv(items, div, templateDiv);

  page.page();
  content.find( ":jqmData(role=listview)" ).listview("refresh");
  page.trigger("create");

  return generic.pageAndOptions(page, "genericObjectCollectionView", urlHref, "slideup")
}
[/sourcecode]

It's corresponding div in the HTML is: 

[sourcecode language="html"]
<div data-role="page" id="genericObjectCollectionView">

  <div data-role="header">
    <a data-icon="back" data-rel="back">Back</a>
    <h1>Collection</h1>
  </div>

  <div data-role="content">
    <br/>
    <ul data-filter="true" data-role="listview"></ul>
  </div>

  <script class="tmpl" type="text/x-jquery-tmpl">
    <li>
      <a href="${href}">${title}</a>
    </li>
  </script>
</div>
[/sourcecode]


There's just a couple more functions I want to go through.  The first is generic.pageAndOptions(); this is the function, if you recall, that creates and hands back the in-memory page option:

[sourcecode language="javascript"]
generic.pageAndOptions = function(page, view, dataUrl, transition) {
  var pageAndOptions = {
    "page": page,
    "options": {
      "dataUrl": "#" + view + "?dataUrl=" + util.urlencode(dataUrl),
      "allowSamePageTransition": true,
      "transition": transition
    }
  }
  return pageAndOptions
}
[/sourcecode]

This little function returns a tuple consisting of the newly created page, along with an options object that has a dataUrl.  This options.dataUrl property that is important, because it is what appears in the browser's address bar.  

As you can see, I've designed it to include both the view name (as an anchor), along with a ?dataUrl query param.  Why so?  Well, it allows the page to be bookmarked, so that the user can come back to any domain object rather than starting from home.  The little bit of processing to do this is in app.js:

[sourcecode language="javascript"]
// if user manually refreshes page for domain object, then re-retrieve
var locationHref = location.href;
if(locationHref.indexOf("genericDomainObjectView") != -1) {
  var urlHref = generic.extract(locationHref);
  generic.submitAndRender(urlHref, "pop");
} else {
  $.mobile.changePage($("#home"))
}
[/sourcecode]

Here we try to extract the dataUrl from the locationHref, in other words the dataUrl query param.  If successful, we call generic.submitAndRender(), as described above.  Or, if the dataUrl cannot be interpreted, then we just revert back to the home page.


I hope the above run-thru has been useful.  Bear in mind that this is far from production quality, and there could be bugs in it (in fact, I'm pretty sure that there are...).  And there are, of course, plenty of things that this demo doesn't yet support - invoking actions, for one.  

In the future we expect that there'll be a fully fledged generic REST client.  In the meantime, though, hopefully this is a good demonstrator for the potential of the [Rest API](http://restfulobjects.org) that ships with Isis.

PS: If you're interested in the source code, you can either just save the files from the online demo (index.html, app.js, generic.js, util.js, namespace.js), or you can browse to the [Isis subversion repository](http://svn.apache.org/repos/asf/incubator/isis/trunk/examples/onlinedemo/webapp/src/main/webapp/mobile/).

