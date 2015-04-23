---
author: danhaywood
comments: true
date: 2010-04-08 22:22:47+00:00
layout: post
slug: enums-and-pluggable-strategies
title: Enums and Pluggable Strategies
wordpress_id: 552
tags:
- apache isis
---

Last time round we simplified an entity inheritance hierarchy, moving the polymorphism into anonymous subclasses of a Java 5 enum.  Which is great, but if there's a lot of business logic that's been factored out in this way, it can make the enum itself somewhat unmanageable.  Moreover, we can't easily extend or modify its behaviour without opening up the enum class, modifying it and recompiling.

To get round these problems we can further refactor our solution by pushing the polymorphic behaviour into a strategy class, and have the enum look up that strategy somehow in order to delegate to it.
<!-- more -->
Let's see this in code.  As a reminder, our StockType (enumerating CDs and BOOKs in our library) looks like:


    
    public enum StockType {
      BOOK(...) {
       ...
        public String disableBorrow(Borrower b) {
          return b.canBorrowBooks()?null:"borrower cannot borrow books";
        }
      },
      CD(...) {
        ...
        public String disableBorrow(Borrower b) {
          return b.canBorrowCds()?null:"borrower cannot borrow CDs";
        }
      };
    
      public abstract String disableBorrow(Borrower b);
    }
    



Right now the disableBorrow(Borrower b) is a one-liner, so doesn't really warrant the treatment that follows.  But let's go ahead and do so anyway, if only so that you might apply the technique on your own code of sufficient complexity to benefit.

First, we introduce an interface to represent the responsibility:


    
    public interface DisableBorrowStrategy {
      boolean isFor(StockType st);
      String disableBorrow(Borrower b);
    }
    



Now, let's write two implementations; here's the one for Books:

    
    public class DisableBorrowStrategyForBook implements DisableBorrowStrategy {
      public boolean isFor(StockType st) { return st == StockType.BOOK; }
      public String disableBorrow(Borrower b) {
        return b.canBorrowBooks()?null:"borrower cannot borrow books";
      }
    }
    


And now for the CD:

    
    public class DisableBorrowStrategyForCd implements DisableBorrowStrategy {
      public boolean isFor(StockType st) { return st == StockType.CD; }
      public String disableBorrow(Borrower b) {
        return b.canBorrowCds()?null:"borrower cannot borrow CDs";
      }
    }
    


Each strategy implementation indicates which StockType it is intended to service; more on this in a mo'.  Meanwhile, the body of the enum's disableBorrow() method now lives in each of the strategies.  To repeat: obviously in your own code the body of these methods would be much larger!

Finally, the enum delegates to the strategy.  To do so it has to get hold of that strategy; one approach is to use JDK's [ServiceLoader](http://java.sun.com/javase/6/docs/api/java/util/ServiceLoader.html):


    
    public enum StockType {
    	BOOK(...) {
               ...
    	},
    	CD(...) {
               ...
    	};
    
    	private static ServiceLoader<DisableBorrowStrategy> serviceLoader = ServiceLoader.load(DisableBorrowStrategy.class);
            ...
    
    	public String disableBorrow(Borrower b) {
    		return strategy().disableBorrow(b);
    	}
    
    	private DisableBorrowStrategy strategy() {
    		for (DisableBorrowStrategy strategy : serviceLoader) {
    			if (strategy.isFor(this)) {
    				return strategy;
    			}
    		}
    		throw new IllegalStateException("could not find strategy");
    	}
    }
    


Because the lookup of the strategy is the same for both BOOK and CD, the method implementation no longer needs to be in anonymous subclasses.  And of course, if we widened the strategy interface to cover all of the responsibilities of the enum, then we'd ultimately be able to get rid of the anonymous subclasses completely.

Let's just recap what we've done over these last few blogs:




  * We started with Stock as an entity superclass, with polymorphism provided by theBook and Cd as entity subclasses


  * We introduced StockType as an enum that allow us to have just a Stock, and obtained the polymorphism through the anonymous subclasses of the enum's members


  * Then, in this post we have (or could have) collapsed StockType back down to a simple enum, and moved the polymorphism into different implementations of a new strategy, looked up using a JDK 6 ServiceLoader.  New or altered implementations could be provided just by dropping in a JAR onto the classpath.

