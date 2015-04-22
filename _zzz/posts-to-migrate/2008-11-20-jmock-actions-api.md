---
author: danhaywood
comments: true
date: 2008-11-20 14:01:00+00:00
layout: post
slug: jmock-actions-api
title: JMock Actions API
wordpress_id: 30
tags:
- tdd
---

I use JMock as my preferred mocking library.  Most of the time the expectations I write are pretty simple, indicating that a mock should return this value, or should throw this exception.  For example:


    
    
    mockery.checking(new Expectations() {% raw } {{ {% endraw %}
     allowing(mockConfiguration).getString(
         "nakedobjects.persistor.adapter-factory",
         PojoAdapterFactory.class.getName());
     will(returnValue(PojoAdapterFactory.class.getName()));
    }});
    



However, I recently needed wrote a little API whereby Injectable components will inject themselves into any objects that declare itself to be aware of that component.  For example, we have a SpecificationLoader:

<!-- more -->

    
    
    public class SpecificationLoaderImpl
        extends SpecificationLoader
        implements Injectable {
      public void injectInto(Object candidate) {
        if (SpecificationLoaderAware.class.isAssignableFrom(
            candidate.getClass())) {
          SpecificationLoaderAware cast = SpecificationLoaderAware.class.cast(candidate);
          cast.setSpecificationLoader(this);
        }
      }
    }
    



Elsewhere I then have code such as:


    
    
    specificationLoader.injectInto(someObject);
    



and don't have to worry whether someObject is aware of SpecificationLoader or not.

But, what if I have a mock SpecificationLoader?  How do I tell it to behave correctly if we call its injectInto() method?  In fact, how can I do this for any Injectable component?  This is what I came up with:


    
    
    public final class InjectIntoJMockAction
      implements Action {
      public void describeTo(Description description) {
        description.appendText("inject self");
      }
      // x.injectInto(y) ---> y.setXxx(x)
      public Object invoke(Invocation invocation) throws Throwable {
        Object injectable = invocation.getInvokedObject();
        Object toInjectInto = invocation.getParameter(0);
        Method[] methods = toInjectInto.getClass().getMethods();
        for(Method method: methods) {
          if (!method.getName().startsWith("set")) {
            continue;
          }
          if (method.getParameterTypes().length != 1) {
            continue;
          }
          Class methodParameterType =
            method.getParameterTypes()[0];
          if (methodParameterType.isAssignableFrom(
                injectable.getClass())) {
            method.invoke(toInjectInto, injectable);
            break;
          }
        }
        return null;
      }
      public static InjectIntoJMockAction injectSelf() {
        return new InjectIntoJMockAction();
      }
    }
    



This code searches for a setter that takes a single argument the type of the mock in question, and if found then invokes it.  And this is what the expectation on the mock looks like:


    
    
    import static yada.yada.InjectIntoJMockAction.injectInto;
    ...
    context.checking(new Expectations() {% raw } {{ {% endraw %}
     allowing(any(Injectable.class)).method("injectInto").with(any(Object.class));
     will(injectSelf());
    }}
    



Seems to work well for me, and a nice example I think of one of the lesser known corners of the power of JMock.  The only thing that would be nice is if the:


    
    
    allowing(any(Injectable.class))
    



returned an reference of type Injectable.  As it is, the use of method("injectInto") is a little fragile if I were to refactor the name.
