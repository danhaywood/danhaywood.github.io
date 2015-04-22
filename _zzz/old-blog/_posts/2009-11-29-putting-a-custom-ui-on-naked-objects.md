---
author: danhaywood
comments: true
date: 2009-11-29 16:56:03+00:00
layout: post
slug: putting-a-custom-ui-on-naked-objects
title: 'Putting a Custom UI on Naked Objects: Part 1, Bootstrapping'
wordpress_id: 425
tags:
- apache isis
---

One of the objectives for Naked Objects v4.0 was to make the framework more modular.  So although (as the [screencasts here show]({{ site.baseurl }}/tag/screencast/)) it can still be used as a full-stack framework, it's also possible to use it just for domain and persistence services.  You can then graft on your own user interface as required.

What do I mean by "domain and persistence" services?  Well:



	
  * Naked Objects will automatically instantiate any domain services (including repositories and factories), and will inject these into your domain objects.

	
  * It also makes it easy to switch from an in-memory object store while initially prototyping to a full RDBMS (or other) implementation later on.

	
  * It'll give you authentication/authorization, either in-built or integrating to your enterprise's existing mechanisms.

	
  * If you are writing client/server code (say, a JavaFX GUI), then it'll take care of all the remoting for you, marshalling and unmarshalling your domain objects across the wire.



Moreover:
<!-- more -->

	
  * Even though you are writing the user interface, there is still the Naked Objects metamodel to consult.  So you can develop your own UI components that are partly or wholly driven from this metamodel, a la [metawidget](http://metawidget.org)

	
  * You can test the business logic in your domain objects using [FitNesse](http://fitnesse.org), using Naked Objects integration through one of the [sister projects]({{ site.baseurl }}/sister-projects/starobjects-testedobjects/).



So, how to go about this?  Well, bootstrapping Naked Objects itself comes down to the following three lines:


    
    ConfigurationBuilderDefault configurationBuilder =
        new ConfigurationBuilderDefault();
    
    NakedObjectsSystemBootstrapper systemBootstrapper =
        new NakedObjectsSystemBootstrapper(configurationBuilder, getClass());
    
    NakedObjectsSystem system =
        systemBootstrapper.bootSystem(DeploymentType.SERVER_EXPLORATION);
    



The ConfigurationBuilder effectively points to the nakedobjects.properties file, while the DeploymentType determines whether in exploration, prototyping or production mode, as well as whether running client-side or server-side.   This bootstrapping sets up NakedObjectsContext, providing access to the different components.

If writing a webapp then you could put the above code into a ServletContextListener, for example.  In fact, search out NakedObjectsWebAppBootstrapper which pretty much does this already.

To interact with the domain objects themselves require a session, but a session in turn requires the user to be authenticated.  A webapp would probably use a ServletFilter to direct you to a login page if there is no AuthenticationSession available.  This would use the AuthenticationManager to create an AuthenticationSession:


    
    AuthenticationRequest authRequest = ... // eg from user & pwd fields
    AuthenticationSession authSession = NakedObjectsContext.getAuthenticationManager().authenticate(authRequest)
    



For a webapp this would probably be stuffed into a HttpSession.

Now we have a session we're set to interact with domain objects.  As already mentioned, we do this by opening a session, analogous to [the approach used with Hibernate](https://www.hibernate.org/42.html).


    
    AuthenticationSession nakedObjectsSession = ...
    NakedObjectsContext.openSession(nakedObjectsSession);
    



To close off the session at the end, use something like:

    
    NakedObjectsContext.closeSession();
    



In fact, the ServletFilter I mentioned before could do all of this.  And NakedObjectsSessionFilter is an implementation that already exists to get started.

There's more to be said (there always is).  In the [next post]({{ site.baseurl }}/2009/12/01/putting-a-custom-ui-on-naked-objects-part-2-interacting-with-pojos/) I'll show how to get hold of the repositories and services so that you can interact with the domain objects directly, and bring in transaction management.

And finally, if you're interested in seeing this working in practice, I cover this in chapter 15 of my [book](http://pragprog.com/titles/dhnako), when I show how to a custom UI using [Apache Wicket](http://wicket.apache.org).
