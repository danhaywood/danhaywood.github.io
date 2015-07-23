---
author: danhaywood
comments: true
date: 2013-02-02 13:58:25+00:00
layout: post
slug: using-google-guavas-ordering-api
title: Using Google Guava's Ordering API
wordpress_id: 1088
tags:
- apache-isis
- guava
- java
---

We've been playing a bit more with Google's [Guava](http://code.google.com/p/guava-libraries/) library - what a great library!  The most recent thing we used it for was to sort out the comparators for our domain objects.  Here's how.<!-- more -->

Using [Apache Isis](http://isis.apache.org)' [JDO Objectstore](http://isis.apache.org/components/objectstores/jdo/about.html), it's good practice to make your classes implement java.lang.Comparable, and use SortedSet for the collections.  You can see this in Isis' [quickstart archetype](http://isis.apache.org/getting-started/quickstart-archetype.html), where the ToDoItem has a recursive relationship to itself: 

[sourcecode language="java"]
public class ToDoItem implements Comparable<ToDoItem> {
    ...
    private SortedSet<ToDoItem> dependencies = Sets.newTreeSet();
    ...
}
[/sourcecode]

How best to implement the compareTo method, though?  Here's the original implementation:

[sourcecode language="java"]
    public int compareTo(final ToDoItem other) {
        if (isComplete() && !other.isComplete()) {
            return +1;
        }
        if (!isComplete() && other.isComplete()) {
            return -1;
        }
        if (getDueBy() == null && other.getDueBy() != null) {
            return +1;
        }
        if (getDueBy() != null && other.getDueBy() == null) {
            return -1;
        }
        if (getDueBy() == null && other.getDueBy() == null ||
            getDueBy().equals(this.getDueBy())) {
            return getDescription().compareTo(other.getDescription());
        }
        return getDueBy().compareTo(getDueBy());
    }
[/sourcecode]

Yuk!  Basically it says:
* order the not-yet-completed objects before the completed-objects
* where there's a tie, order by due date (put those without a due by date last)
* where there's a tie, order by description.

Here's how to rewrite that using Guava's Ordering class.  First, let's create some Ordering instances for the scalar types:

[sourcecode language="java"]
public final class Orderings {
    
    public static final Ordering<Boolean> BOOLEAN_NULLS_LAST = 
        Ordering.<Boolean>natural().nullsLast();
    public static final Ordering<LocalDate> LOCAL_DATE_NULLS_LAST = 
        Ordering.<LocalDate>natural().nullsLast();
    public static final Ordering<String> STRING_NULLS_LAST = 
        Ordering.<String>natural().nullsLast();

    private Orderings(){}
}
[/sourcecode]

Now we can rewrite our ToDoItem's compareTo() method in a declarative fashion:

[sourcecode language="java"]
public class ToDoItem implements Comparable {

    ...

    public int compareTo(ToDoItem o) {
        return ORDERING_BY_COMPLETE
               .compound(ORDERING_BY_DUE_BY)
               .compound(ORDERING_BY_DESCRIPTION)
               .compare(this, o);
    }

    public static Ordering<ToDoItem> ORDERING_BY_COMPLETE = new Ordering<ToDoItem>(){
        public int compare(ToDoItem p, ToDoItem q) {
            return Orderings.BOOLEAN_NULLS_LAST.compare(p.isComplete(), q.isComplete());
        }
    };

    public static Ordering<ToDoItem> ORDERING_BY_DUE_BY = new Ordering()<ToDoItem>{
        public int compare(ToDoItem p, ToDoItem q) {
            return Orderings.BOOLEAN_NULLS_LAST.compare(p.getDueBy(), q.getDueBy());
        }
    };

    public static Ordering<ToDoItem> ORDERING_BY_DESCRIPTION = new Ordering()<ToDoItem>{
        public int compare(ToDoItem p, ToDoItem q) {
            return Orderings.STRINGS_NULLS_LAST.compare(
              p.getDescription(), q.getDescription());
        }
    };
[/sourcecode]

Now, admittedly, this hardly warrants all that boilerplate for just a single method in a single class; of course not!  But what we have here now is a little algebra that we can use to combine across all the domain classes in our domain model.  Other domain classes that use a ToDoItem can order themselves using the ToDoItem's natural ordering (accessed from Ordering.natural()), or they can create new orderings using the various ToDoItem.ORDERING_BY_xxx orderings.
