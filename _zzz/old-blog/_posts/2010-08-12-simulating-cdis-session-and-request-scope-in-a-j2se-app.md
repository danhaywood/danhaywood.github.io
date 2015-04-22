---
author: danhaywood
comments: true
date: 2010-08-12 12:08:46+00:00
layout: post
slug: simulating-cdis-session-and-request-scope-in-a-j2se-app
title: Simulating CDI's Session and Request Scope in a J2SE app
wordpress_id: 648
---

We're currently considering refactoring the Naked Objects framework to use JSR-330 (dependency injection) and EE-oriented big brother, JSR-299 (CDI).  Using vanilla JSR-330 is a no-brainer, but there are also some nice features in JSR-299 that we'd like to exploit (such as events and decorators).  The snag?  The Naked Objects must also run transparently in J2SE environments.

Now JSR-299 (at least, the Weld reference implementation) can run on J2SE, but it isn't possible to use beans that are annotated as either @SessionScoped or @RequestScoped... not surprising really, because there is no HttpSession or HttpServletRequest to hook into.  On the other hand, at least in the Naked Objects framework in a J2SE context, we do have the ability to map these concepts onto its own internal lifecycle ... eg, for a client-side app, the user is always in deemed to be running in one long session.

How, then, to setup contexts for these scopes, and make them automatically active when running in J2SE?  <!-- more -->

First, let's look at the code we want to run:

    
    package org.nakedobjects.experiments.cdi;
    
    import java.util.List;
    import javax.enterprise.context.RequestScoped;
    import javax.enterprise.event.Observes;
    import org.jboss.weld.environment.se.bindings.Parameters;
    import org.jboss.weld.environment.se.events.ContainerInitialized;
    
    @RequestScoped
    public class HelloWorld {
        public static void main(String[] args) {
            // bootstrap
            org.jboss.weld.environment.se.StartMain.main(new String[]{"JSR","299"});
        }
        public void printHello(@Observes ContainerInitialized event, @Parameters List<String> args) {
            System.out.println("Hello " + args);
            System.out.flush();
        }
    }
    


Because this is a CDI bean, we need an empty META-INF/beans.xml.

The above class would print out "Hello [JSR, 299]" if annotated as @ApplicationScoped, but not with it being annotated as @RequestScoped.  What we therefore need to do is write an extension.  It's a bit hacky, but it works:


    
    package org.jboss.weld.manager; // required for visibility to BeanManagerImpl#getContexts()
    
    import java.lang.annotation.Annotation;
    
    import javax.enterprise.context.RequestScoped;
    import javax.enterprise.context.SessionScoped;
    import javax.enterprise.event.Observes;
    import javax.enterprise.inject.spi.AfterDeploymentValidation;
    import javax.enterprise.inject.spi.BeanManager;
    import javax.enterprise.inject.spi.Extension;
    
    import org.jboss.weld.context.AbstractThreadLocalMapContext;
    import org.jboss.weld.context.beanstore.HashMapBeanStore;
    
    public class WeldServletScopesSupportForSe implements Extension {
    
    	public void afterDeployment(@Observes AfterDeploymentValidation event,
    			BeanManager beanManager) {
    
    		setContextActive(beanManager, SessionScoped.class);
    		setContextActive(beanManager, RequestScoped.class);
    	}
    
    	private void setContextActive(BeanManager beanManager,
    			Class<? extends Annotation> cls) {
    		BeanManagerImpl beanManagerImpl = (BeanManagerImpl) beanManager;
    		AbstractThreadLocalMapContext context = (AbstractThreadLocalMapContext) beanManagerImpl
    				.getContexts().get(cls).get(0);
    		context.setBeanStore(new HashMapBeanStore());
    		context.setActive(true);
    	}
    }
    



Like all Weld extensions, this needs to be registered in META-INF/services, in this case in a file called javax.enterprise.inject.spi.Extension containing the fully-qualified class name.

Now, when we run the application, the session and request scopes will both be set up, and our HelloWorld bean will fire.

For developers writing apps in Naked Objects they will need to include a dependency to an additional module, if deploying a client (-t client or a server on a non-web backend (-t server with socket-level remoting, say).  For the latter, we'll need to include some smarts to figure out whether we are running in a webapp or not, and only set up the Contexts if we determine that we're not (eg can't find javax.servlet classes on the classpath.

If you want to try out the code, you can check it out using

    
    svn co https://nakedobjects.svn.sourceforge.net/svnroot/nakedobjects/framework/trunk/experiments .
