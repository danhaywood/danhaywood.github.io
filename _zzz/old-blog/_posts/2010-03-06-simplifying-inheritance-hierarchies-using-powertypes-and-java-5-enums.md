---
author: danhaywood
comments: true
date: 2010-03-06 18:45:09+00:00
layout: post
slug: simplifying-inheritance-hierarchies-using-powertypes-and-java-5-enums
title: Simplifying inheritance hierarchies using powertypes and Java 5 enums
wordpress_id: 540
tags:
- domain driven design
---

Having seen how to teach [Naked Objects to support Java 5 enums]({{ site.baseurl }}/2010/02/28/adding-support-for-java-5-enums-to-naked-objects-part-2/) directly, let's use this new capability to avoid inheritance hierarchies in entities using powertypes.
<!-- more -->
Typically we use inheritance as a way of achieving polymorphism: different behaviours for different types.  For example, in the Library example we have CDs and Books, both different types of Stock.  One way in which these might vary is that Books might be loanable for up to 3 weeks, but CDs for only one, and each might enforce their own specific rules on the borrower.  Another variation is that Books have an ISBN, whereas for CDs we would need to use something like a [MusicBrainz Disc Id](http://wiki.musicbrainz.org/Disc_ID).

So, an inheritance-based solution to this would be a hierarchy under Stock.  The Stock superclass is:


    
    public abstract class Stock {
    
      private StockType stockType;
      public StockType getStockType() { return stockType; }
      public void setStockType(StockType stockType) { this.stockType = stockType; }
    
      /// …
    }
    



the Book subclass is:


    
    public class Book extends Stock {
    
      private String isbn;
      public String getIsbn() { return isbn; }
      public void setIsbn(String isbn) { this.isbn = isbn; }
    
      public Loan borrow(Borrower b) {
        return getLoanFactory().newLoan(this, 21);
      }
      public String disableBorrow(Borrower b) {
        return b.canBorrowBooks()?null:"borrower cannot borrow books";
      }
      /// ...
    }
    



and the CD subclass is:


    
    public class CD extends Stock {
    
      private String discId;
      public String getDiscId() { return discId; }
      public void setDiscId(String discId) { this.discId = discId; }
    
      public Loan borrow(Borrower b) {
        return getLoanFactory().newLoan(this, 7);
      }
      public String disableBorrow(Borrower b) {
        return b.canBorrowCds()?null:"borrower cannot borrow CDs";
      }
      /// …
    }
    



I've factored out the creation of Loans to a LoanFactory, partly because I don't want to focus on that detail, and partly because there's a point to I need to make about it later.

Although the above works fine, note that the variation in behaviour is based on the type of the object (a Book or CD), rather than each particular instance (of Book #1 vs Book #2).  One could argue that these responsibilities are therefore misplaced.  More pragmatically, if we are using an RDBMS then we'll need to [decide how to map onto tables](http://www.agiledata.org/essays/mappingObjects.html#MappingInheritance).

An alternative design, then, is to use powertypes.  We move the polymorphism using subtypes of the powertype and then delegate to it.  Moreover, we can simplify the inheritance hierarchy by rolling up all properties into the superclass; we then use the powertype to hide those that don't apply.

First, let's look at our new Stock class:


    
    public  class Stock { // no longer abstract
    
      private StockType stockType;
      public StockType getStockType() { return stockType; }
      public void setStockType(StockType stockType) { this.stockType = stockType; }
    
      private Isbn isbn;
      public String getIsbn() { return isbn; }
      public void setIsbn(String isbn) { this.isbn = isbn; }
      public boolean hideIsbn() { return stockType.hideIsbn(); }
    
      private String discId;
      public String getDiscId() { return discId; }
      public void setDiscId(String discId) { this.discId = discId; }
      public boolean hideDiscId() { return stockType.hideDiscId(); }
    
      public Loan borrow(Borrower b) {
        return stockType.borrow(this, b, getLoanFactory());
      }
      public String disableBorrow(Borrower b) {
        return stockType.disableBorrow(b);
      }
    
      /// ...
    }
    



There's now a new hideIsbn() and hideDiscId() supporting methods to optionally hide these properties, and all the variation in behaviour is delegated to the StockType.  On the other hand, there is no longer any Book or CD subclasses.

Okay, let's look at StockType, which is where the polymorphism has moved to.  It's implemented, as promised, as an enum:


    
    public enum StockType {
      BOOK(21) {
        public boolean hideIsbn() { return false; }
        public boolean hideDiscId() { return true; }
        public String disableBorrow(Borrower b) {
          return b.canBorrowBooks()?null:"borrower cannot borrow books";
        }
      },
      CD(7) {
        public boolean hideIsbn() { return true; }
        public boolean hideDiscId() { return false; }
        public String disableBorrow(Borrower b) {
          return b.canBorrowCds()?null:"borrower cannot borrow CDs";
        }
      };
    
      private int numDays;
      private StockType(int numDays) { this.numDays = numDays; }
    
      public abstract boolean hideIsbn();
      public abstract boolean hideDiscId();
    
      public Loan borrow(Stock s, Borrower b, LoanFactory lf) {
        return lf.newLoan(this, numDays);
      }
      public abstract String disableBorrow(Borrower b);
    
    }
    



The fact that one can, in Java, create anonymous subclasses within an enum isn't that well-known, I think, so I quite like this approach just for the novelty.  It's certainly easier to compare the variation in behaviour of different types.  It's probably easier to test; StockType is a standalone class.  Of course, you'd be right in saying that we are still using inheritance to achieve polymorphism.  But that's now an implementation detail of StockType, rather than the inheritance being spread out across the landscape with all the attendant complications for persisting the entities.

One downside to using enums is that Naked Objects cannot inject dependencies into them: hence the reason we had to pass the LoanFactory in the borrow() method.  I can't see any easy way around this; I guess that every design approach has its pros and its cons.

Finally … another advantage of powertypes is that it provides dynamic typing; the reference to the type may be mutable and so change over the object's lifetime.  But that can be the subject of another post.
