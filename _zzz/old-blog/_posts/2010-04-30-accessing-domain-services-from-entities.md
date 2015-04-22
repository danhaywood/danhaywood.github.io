---
author: danhaywood
comments: true
date: 2010-04-30 22:47:38+00:00
layout: post
slug: accessing-domain-services-from-entities
title: Accessing Domain Services from Entities
wordpress_id: 573
tags:
- apache isis
---

A topic that comes around now and again on the [DDD newsgroup](http://tech.groups.yahoo.com/group/domaindrivendesign/) is how to provide access to a domain service (or a repository) to an entity.  This service might be very generic, e.g. a NotificationService so that the entity can raise a domain event.  Or, it might be quite specific, e.g. an EmailService so that an entity (e.g. Communication) can physically send itself out as an email.
So, let's look at four different techniques by which the entity can gain access to the service.  I'll use the email example throughout.
<!-- more -->


### Double Dispatch


First, what's common to all of the techniques is the use of double dispatch in the design of the services' API.  That is, the entity (Communication) calls the service (EmailService), passing a reference to itself.  The service would then call back to fetch out the information required:

    
    public interface EmailService {
        void send(Emailable emailable);
        ...
    }
    


In the API above I've introduced an interface to decouple the domain service from any entities that might call it, so the entity will either need to implement this interface or provide an adapter.   In the sections below, you'll see that Communication implements Emailable.
Ok, let's move onto the first of the options to provide the service to the entity.


### Pass the service in as an argument


Our first option is to pass the service in as an argument to the method that needs it:

    
    public class Communication implements Emailable {
        public void sendAsEmail(EmailService emailService) {
            emailService.send(this);
       }
        ...
    }
    


This design works well enough when the entity is called by the application layer; the application layer can easily access all the domain services, and so can pass in the appropriate service.  If the entity is called by another entity then it's more problematic, because the calling entity will in turn need to be passed in that entity, and transitively all the way back to the original call from the application layer.
So I'm not keen on this design, because it in effect exposes implementation details to the caller (that a Communication requires an EmailService in order to be sent as email).  And pragmatically, it makes for fragile code (if an entity several layers down in the call stack now needs a service, then that impacts all of its callers).


### Singleton


Typically services are singletons, scoped either at request, session or application level.  So another option is to let the entity obtain the service as a singleton:

    
    public class Communication implements Emailable {
        public void sendAsEmail() {
            EmailService emailService = EmailService.getInstance();
            emailService.send(this);
       }
        ...
    }
    


From an implementation standpoint that getInstance method is either returning the service implemented as a classic Singleton pattern (application scope), or may be picking up from a thread local (for request scope or session scope).
Compared to the previous design, we are now hiding the fact that the Communication requires an EmailService, so that's an improvement.  However, this design is difficult to test, because there is no place where we can substitute in a mock service for testing (in Michael Feathers' terminology, there is no seam).  Time to move onto our next design.


### Service Locator


An evolution from singleton is a service locator.  Here, we hold a registry of services, and have the entity lookup the service from this locator.  The locator itself is typically a singleton.

    
    public class Communication implements Emailable {
        public void sendAsEmail() {
            EmailService emailService = ServiceLocator.getInstance().lookup(EmailService.class);
            emailService.send(this);
       }
        ...
    }
    


This is a definite improvement on the singleton design, because in the test environment we can register mock services with the service locator, rather than the real ones.  There are a couple of ways to do this in Java, one of which would be to use a JNDI InitialContext, another being the java.util.ServiceLookup class that I mentioned in my previous post.
Still, it's not ideal, because the service locator introduces an piece of infrastructure to our entity that I'd rather do without.  Which takes us to…


### Dependency Injection


Dependency injection frameworks such as Spring and Guice offer an alternative means to wire up objects.  Each object declares its dependencies through the constructor or setters, and then the runtime automatically instantiates the objects and wires them together.  These frameworks were originally sold on the desire to remove infrastructural elements such as service locator from the runtime; Java 7 will see this stuff standardised as part of the JDK.
Typically these frameworks are used to wire up components that are application, session or request level scoped, but where the components are singletons with respect to their scope.  But it is possible (as for example [Chris Richardson shows](http://chris-richardson.blog-city.com/migrating_to_spring_2_part_3__injecting_dependencies_into_en.htm)) to inject into entities too:

    
    public class Communication implements Emailable {
        public void sendAsEmail() {
            emailService.send(this);
       }
        private EmailService emailService;
        public void setEmailService(EmailService emailService) {
            this.emailService = emailService;
        }
        ...
    }
    


This design doesn't introduce any spurious infrastructure of a locator, and doesn't expose to the callers that the entity requires a service to do its work (sendAsEmail takes no arguments).  And, clearly, testing the entity with a mock service is trivial: the test just injects a mock service prior to interacting with the entity.
Dependency injection is the approach that is taken by Naked Objects. What's nice about Naked Objects' design is that no configuration is required; all services are automatically injected into the entity.  Compare this to traditional DI frameworks where (as Chris Richardson's blog post shows) some configuration is required.
Still, DI is not without some downsides: it requires an extra four bytes storage per service per instantiated entity, along with the cost of injecting the service when the object is instantiated/re-hydrated, whether or not the object actually uses that service.  In Naked Objects, it also requires that new objects are instantiated using DomainObjectContainer#newTransientInstance(Class) method (to provide an opportunity for Naked Objects to do the DI).


### Singleton / Service Locator revisited


Before we wrap up, let's just revisit the singleton / service locator designs.  My criticism of singleton was the lack of a seam: the entity chooses its collaborator so there is no opportunity to provide an alternative.  Service locator introduces a seam in a roundabout way (the entity's call to the locator) but only at the expense of a more complex infrastructure.
There is another way to introduce a seam, though, that works whether you prefer singleton and/or service locator.  It's really easy too: just use the extract method refactoring.  Here's how for a singleton:

    
    public class Communication implements Emailable {
        public void sendAsEmail() {
            getEmailService().send(this);
        }
        protected EmailService getEmailService() {
            EmailService emailService = EmailService.getInstance();
        }
        ...
    }
    


Why does this help?  Well, notice that the new getEmailService has protected visibility.  This means that we can selectively override the method in the test:

    
    public class CommunicationTest {
        private EmailService mockEmailService;
        ....
        @Test
        public void canSendEmail() {
            Communication communication = new Communication() {
                protected EmailService getEmailService() { return mockEmailService; }
            };
            // rest of test here
        }
    }
    


The seam is the polymorphic call from the communication _to itself_.


### Conclusion


So there you have it: a range of techniques to provide a domain service to an entity.  My preference is to use dependency injection; that's why when we were developing Naked Objects we made it support DI automatically as it does.  But if you're worried about performance (I should say, if you know that the performance hit of this injection is significant) then you can still go with singleton or service locator; just don't forget to introduce a seam for your unit testing.
