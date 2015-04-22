---
author: danhaywood
comments: true
date: 2010-02-23 23:48:21+00:00
layout: post
slug: simulating-enums-in-naked-objects
title: Simulating Enums in Naked Objects
wordpress_id: 506
tags:
- apache isis
---

One thing that Naked Objects 4.0 doesn't yet support is Java 5-style enums.  We think we know what we need to do to support it (I guess that will be 4.1), but for now let me offer you a way to get the same general effect.

Let's make this concrete by considering (hackneyed example, I know) a library.  Suppose that this library can loan out both Books and CDs, and that we wanted to have a StockType to enumerate these different types of stock.

First, let's start with an Enumerated interface:
<!-- more -->

    
    public interface Enumerated {
    
      public String getValue();
    
      public static final class Filter<T extends Enumerated> implements
          org.nakedobjects.applib.Filter<T> {
    
        @SuppressWarnings("unused")
        private Class<T> cls;
        private String required;
    
        public static <Q extends Enumerated> Filter<Q> create(final Class<Q> cls,
            String required) {
          return new Filter<Q>(cls, required);
        }
    
        private Filter(final Class<T> cls, String required) {
          this.cls = cls;
          this.required = required;
        }
    
        @Override
        public boolean accept(T enumerated) {
          return enumerated.getValue().equals(required);
        }
      }
    }
    



The interface simply defines a #getValue() method, which will ultimately return _BOOK_ and _CD_.  There's also a nested static class which we'll use in a moment.

Next up, an adapter implementation, EnumeratedAbstract:


    
    import org.nakedobjects.applib.AbstractDomainObject;
    import org.nakedobjects.applib.DomainObjectContainer;
    
    public abstract class EnumeratedAbstract
        extends AbstractDomainObject
        implements Enumerated {
    
      public String title() {
        return getValue();
      }
    
      private String value;
    
      public String getValue() {
        return value;
      }
    
      public void setValue(String value) {
        this.value = value;
      }
    
      protected static <T extends EnumeratedAbstract> void create(
          DomainObjectContainer container, Class<T> cls, String value) {
        T t = container.newTransientInstance(cls);
        t.setValue(value);
        container.persist(t);
      }
    
      protected static <T extends EnumeratedAbstract> T lookup(
          DomainObjectContainer doc, Class<T> cls, String value) {
        return doc.firstMatch(cls, Enumerated.Filter.create(cls, value));
      }
    }
    



The implementation of the Enumerated interface is trivial; what's most of interest are the two static methods, #create() and #lookup().  These both use the supplied DomainObjectContainer to respectively create new instances of the type, or to lookup an existing instance.  The latter method is what uses the Enumerated.Filter nested static type.  Note also that both these methods are protected, not public, so can only be called by a subclass.

Finally, then, we reach that subclass, in our case StockType:


    
    import org.nakedobjects.applib.DomainObjectContainer;
    
    public class StockType extends EnumeratedAbstract {
    
      private static final String CD = "cd";
      private static final String BOOK = "book";
    
      public static StockType Book(DomainObjectContainer container) {
        return lookup(container, StockType.class, BOOK);
      }
    
      public static StockType Cd(DomainObjectContainer container) {
        return lookup(container, StockType.class, CD);
      }
    
      public static void createAll(DomainObjectContainer container) {
        create(container, StockType.class, BOOK);
        create(container, StockType.class, CD);
      }
    
    }
    



This subclass exposes the two members, LoanType.Book() and LoanType.Cd().  Apart from the fact that each needs to have a DomainObjectContainer passed to it, these can be used as the enumerated values.  For example, some code used to create stock, eg: stockCatalog.createStock(StockType.Book(getContainer()), ...);

Note also the StockType#setUpAll() method.  This should be called from a fixture, eg StockTypeFixture:


    
    import org.nakedobjects.applib.fixtures.AbstractFixture;
    public class StockTypeFixture extends AbstractFixture {
      @Override
      public void install() {
        StockType.createAll(getContainer());
      }
    }
    
