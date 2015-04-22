---
author: danhaywood
comments: true
date: 2010-02-27 09:07:59+00:00
layout: post
slug: simulated-enums-supporting-choices
title: Simulated Enums - supporting choices
wordpress_id: 517
tags:
- apache isis
---

In my [last post]({{ site.baseurl }}/2010/02/24/simulating-enums-in-naked-objects/) I showed how to simulate enums, and then Giorgio [asked]({{ site.baseurl }}/2010/02/24/simulating-enums-in-naked-objects/comment-page-1/#comment-582) in the comments as to how this fits in with the choices() method, used to provide a drop-down list of values.

To start with, let's add an all() method to StockType:
<!-- more -->

    
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
    
      public static List all(DomainObjectContainer container) {
        return Arrays.asList(Book(container), Cd(container));
      }
    
      public static void createAll(DomainObjectContainer container) {
        create(container, StockType.class, BOOK);
        create(container, StockType.class, CD);
      }
    
    }
    



Then, in the StockType domain object we just add the choices() method, for example:


    
        //  {% raw } {{ {% endraw %} StockType
        private StockType stockType;
        @Disabled
        @MemberOrder(sequence = "2")
        public StockType getStockType() {
          return stockType;
        }
    
        public void setStockType(final StockType stockType) {
          this.stockType = stockType;
        }
        public List choicesStockType() {
            return StockType.all(getContainer());
        }
        // }}
    



Short and sweet.  In the next post I'll show how we can teach Naked Objects to support Java 5 enums natively (a feature that we'll be adding formally in Naked Objects 4.1).
