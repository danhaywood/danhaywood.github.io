---
author: danhaywood
comments: true
date: 2010-03-23 00:12:20+00:00
layout: post
slug: more-on-enums-and-powertypes
title: More on enums and powertypes
wordpress_id: 544
tags:
- domain driven design
---

My [last blog post]({{ site.baseurl }}/2010/03/06/simplifying-inheritance-hierarchies-using-powertypes-and-java-5-enums/), about pushing behaviour onto enum subclasses, got quite a few votes on dzone.  Interestingly, about a third voted the post down, not up - though no-one left any comment to explain why they thought it was a bad idea.

So, here's another example of using this technique, but from a somewhat different source.  I was recently writing some code that needed some fairly standard collections manipulation, but rather than write it myself I thought I'd check out the [google-collections](http://code.google.com/p/google-collections/) API (now at v1.0).  I remembered reading that this library has support for caching along with soft or weak references, and browsing into the source code I came across MapMaker#Strength: <!-- more -->


    
      private enum Strength {
        WEAK {
          @Override boolean equal(Object a, Object b) {
            return a == b;
          }
          @Override int hash(Object o) {
            return System.identityHashCode(o);
          }
          @Override <K, V> ValueReference<K, V> referenceValue(
              ReferenceEntry<K, V> entry, V value) {
            return new WeakValueReference<K, V>(value, entry);
          }
          @Override <K, V> ReferenceEntry<K, V> newEntry(
              Internals<K, V, ReferenceEntry<K, V>> internals, K key,
              int hash, ReferenceEntry<K, V> next) {
            return (next == null)
                ? new WeakEntry<K, V>(internals, key, hash)
                : new LinkedWeakEntry<K, V>(internals, key, hash, next);
          }
          @Override <K, V> ReferenceEntry<K, V> copyEntry(
              K key, ReferenceEntry<K, V> original,
              ReferenceEntry<K, V> newNext) {
            WeakEntry<K, V> from = (WeakEntry<K, V>) original;
            return (newNext == null)
                ? new WeakEntry<K, V>(from.internals, key, from.hash)
                : new LinkedWeakEntry<K, V>(
                    from.internals, key, from.hash, newNext);
          }
        },
    
        SOFT {
          // ... same sort of thing here ...
        },
    
        STRONG {
                // ... same sort of thing here ...
        };
        /**
         * Determines if two keys or values are equal according to this
         * strength strategy.
         */
        abstract boolean equal(Object a, Object b);
    
        /**
         * Hashes a key according to this strategy.
         */
        abstract int hash(Object o);
    
        // ... and so on ...
      }
    



As you can see, it's the same general idea.  Rather than have subclasses of Map to deal with strong references, or soft references, or weak references, the authors instead pushed this responsibilities onto an enum with anonymous subclasses.  And given that this code was written by a couple of Google's finest (Kevin Bourrillion and ["Crazy" Bob Lee](http://crazybob.org/)), I reckon I'm in good company.




But if you still aren't convinced, here's another reason to move this sort of functionality into powertypes: what happens if the behaviour of the object varies across 2 (or more) dimensions?  In my original example we had Stock having StockType, but what if they also had a ReserveType (i.e. the mechanism by which they could be reserved by our library user) of RESERVABLE and NON_RESERVABLE?  If we didn't have these powertypes then our inheritance hierarchy of Stock would grow into ReservableCdStock, NonReservableCdStock, ReservableBookStock, NonReservableBookStock, one for each combination.  I suppose all I'm doing here is reiterating the old advice "prefer composition to inheritance"; the powertype is just a usage of the strategy pattern.




Still, one reason though why some might have voted the technique down in the previous post is that the subclasses can get rather large; all that functionality is inlined into a single rather large class file.  In the next post we'll see a way to get around this.
