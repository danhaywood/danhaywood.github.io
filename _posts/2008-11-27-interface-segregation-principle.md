---
author: danhaywood
comments: true
date: 2008-11-27 11:57:00+00:00
layout: post
slug: interface-segregation-principle
title: Interface Segregation Principle
wordpress_id: 31
tags:
- domain driven design
---

[![collander](http://farm1.static.flickr.com/215/463245164_ec0255a18c.jpg)](http://www.flickr.com/photos/karlajdee/463245164/){: .float-right}

On the [DDD newsgroup](http://tech.groups.yahoo.com/group/domaindrivendesign/) one thread started there recently asked:


_Implicit concepts are an important subject in software creation. They allow for breakthroughs in hard to model systems (for example).
Did you ever use _special_ techniques to identify them? Be it via interviews, visualizations, system metaphors, code analysis or code refactoring._


It's a good question; it's only by identifying concepts correctly that we can hope to get a rich and useful domain model.  The technique I recommended was to apply Robert Martin's interface segregation principle.

For example, in our system for administering government benefits [ed: that is, the DSFA project], we started off with two classes:

  * Customer     (ie a citizen)
  * Scheme       (ie a claim for a government benefit)


One of the first benefits implemented was for Pensions.  So we had a single relationship between `PensionScheme` and `Customer`.  The `Customer` paid in their national contributions, and when they retired they got paid a pension.  So far so easy, but no implicit concepts identified.

A subsequent benefit implemented was for Child Benefit.  Now we needed two relationships between `ChildBenefitScheme` and `Customer`.  The benefit is *because* of the child but is *paid* to their mother.  (That's how it is in Ireland).  This gave us a "source" reference (from `Scheme` to the child `Customer`) and a "beneficiary" reference (from `Scheme` to the parent `Customer`).  Still no implicit concepts, but it's getting more complex.

A benefit implemented this year has been the Widow/er's benefit, whereby a pension money is paid to a bereaved spouse based on the deceased spouse's contributions.  Now this is a little like child benefit in that it separates out two customers: the deceased spouse and the widow/er.  However, the rules are much more complex than CB.  Untangling them led us to identifying some implicit concepts that had been there from day one:

  * the `Customer` plays the role of being an `IContributionSource` with respect to `Scheme`.  The `Scheme#source` property should not be of type `Customer`, it should be of type `IContributionSource`

  * the `Customer` also plays the role of being an `IBeneficiary` with respect to `Scheme`.  The `Scheme#benefits` property should not be of type `Customer`, it should be of type `IBeneficiary`.

A good (if slightly overgeneralized) summary of this is: always ensure that your properties are named after their type (eg `Benefits#beneficiary` is of type `IBeneficiary`).  The moment there is a mismatch then that may be a clue to a missing concept.

Robert Martin's original article on this is at [http://www.objectmentor.com/resources/articles/isp.pdf](http://www.objectmentor.com/resources/articles/isp.pdf).  It's a little dated, but there are plenty other discussions on this same theme too.
