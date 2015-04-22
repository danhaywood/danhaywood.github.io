---
author: danhaywood
comments: true
date: 2012-03-25 17:43:45+00:00
layout: post
slug: apache-isis-refactorings
title: Apache Isis refactorings
wordpress_id: 945
tags:
- apache isis
- domain driven design
---

For the last week or two I've been doing some refactoring deep in the bowels of [Apache Isis](http://incubator.apache.org/isis), working on simplifying some of the infrastructure there.

One of the major changes in the next release <!-- more -->to enable this is that we're going to ditch the client/server "remoting" support. Although this was important feature when originally implemented (the big Irish government system that runs on Naked Objects is deployed in this configuration), it adds a heck of a lot of complexity and is increasingly less important in these days of Ajax, rich web apps, REST and mobile. So... the client/server support is being removed. As a by-the-by, that will mean that the original drag-n-drop viewer will be demoted
for use either in very simple single-user systems, or just as a prototyping and design tool.

Another, more technical, reason for that dropping the client/server remoting is important is that it allows the OIDs to become immutable. In Isis every domain object is wrapped in an "adapter", which is the link into the Isis metamodel and which also keeps track of whether the object has been resolved from the object store. Each adapter is identified by an OID; in other words the OID is an object identifiers that act as keys to every object that is managed by Isis.

Now, with client/server, a lot of the complexity arose because it was necessary to track the persistence state of an object across the client and server. And this was done by having the OID as being mutable, keeping track of the previous OID (when the object was transient) and its current OID. With this requirement gone, OIDs can become immutable.

I've also taken the opportunity to simplify the OID hierarchy. In the original design of Isis, every object store implementation was responsible for defining its own OIDs. So the in-memory object store has a very simple OID, whereas the NoSQL and SQL object stores' implementations are rather more complex. Fundamentally, though, all that an OID needs to do is to identify the class of an object, and its unique identity within that type.

The Irish government system has an OID that can be converted to a string, and this has proven really useful for scenarios such as publish/subscribe. For example, CUS|1234567A identifies a customer with a unique id of 1234567A. The format of the identifier varies; for some types it is multiple components (usually corresponding to a composite primary key in a database table).

So, the simpler design that I'm working to is that a single Oid implementation has an object type ("CUS") and a (string) identifier. The object store is responsible for creating and interpreting this identifier, but the OID implementation itself is fixed. So, basically, an Oid is just a value object of two strings: CUS|1234567A. Much simpler!

Of course, I lie. In fact, we need to distinguish between the Oid of a standalone entity (in DDD jargon, the root of an aggregate), and the Oid of an aggregated entity (one that is owned by the root). The canonical example is always Order/OrderLine, but equally one could have a Customer/Name or - perhaps - Customer/Address. So, in fact root entities have a RootOid (as described above), while aggregate entities have an AggregatedOid. An AggregatedOid consists of a reference to the parent Oid, along with an identifier that is (at least) unique within the aggregate.

In Isis there is another type of object that also gets its own OID, namely the List/Set instances that manage the "internal" collections. These have an adapter because we need to support lazy loading; rather than introducing a proxy collecioon object, the adapter keeps track of whether the collection have been retrieved from the object store or not.

So, the full set of OIDs are:
- Oid as a top-level interface
- RootOid, as an implementation for aggregate roots
- AggregatedOid, as an implementation for aggregated entities
- CollectionOid, as an implementaion for List/Set instances.

To illustrate all this, consider the following classes:

[sourcecode language="java"]
public class Customer {
  private Name name;
  public Name getName() { ... }
  public void setName(Name n) { ... }

  private Address billingAddress;
  @Aggregated
  public Address getBillingAddress() { ... }
  public void setBillingAddress(Address a) { ... }

  private Order mostRecentOrder;
  public Order getMostRecentOrder() { ... }
  public void setMostRecentOrder(Order o) { ... }

  private List<Name> previousNames = Lists.newArrayList();
  public List<Name> getPreviousNames() { ... }
  public void setPreviousNames(List<Name> n) { ... }

  public List<Address> shipToAddresses = Lists.newArrayList();
  @Aggregated
  public List<Address> getShipToAddresses() { ... }
  public void setShipToAddresses(List&lt;Address> a) { ... }

  private List<Order> orders = Lists.newArrayList();
  public List<Order> getOrders() { ... }
  public void setOrders(List<Order> o) { ... }
}
[/sourcecode]



Here, the Name class is always intended to be aggregated (irrespective of context); it is thus annotated as @Aggregated:

[sourcecode language="html"]
@Aggregated
public class Name {
...
}
[/sourcecode]




The Address class, meanwhile, may be aggregated in some contexts, but not in others. Therefore the class is not aggregated:

[sourcecode language="html"]
public class Address {
...
}
[/sourcecode]



However, as you can see from the Customer's billingAddress property and shipToAddresses collections, these references are annotated with @Aggregated. Therefore, for Customer at least, Address is part of its aggregate.



Finally, we have Order:

[sourcecode language="html"]
public class Order {
...
}
[/sourcecode]



This is not annotated with @Aggregated, and its references from Customer also have no @Aggregate annoation. Each Order is therefore is its own aggregate root.




And the following object instance diagram shows what would be going on inside of Isis:

[![](http://danhaywood.files.wordpress.com/2012/03/oids.png)](http://danhaywood.files.wordpress.com/2012/03/oids.png)
