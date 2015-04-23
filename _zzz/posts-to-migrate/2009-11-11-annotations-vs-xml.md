---
author: danhaywood
comments: true
date: 2009-11-11 07:56:10+00:00
layout: post
slug: annotations-vs-xml
title: Annotations vs XML
wordpress_id: 406
tags:
- apache isis
---

For me, the best innovation on the Java platform (and .NET too) in recent years has the introduction of annotations/attributes.  But not everyone thinks so, even now.

Here's a comment made to me in an offlist exchange from the [DDD yahoo group](http://tech.groups.yahoo.com/group/domaindrivendesign/):



<blockquote>"One thing I can tell you is that I despise attributes / annotations.  I think it is because it very tightly couples one to whatever is providing those attributes."</blockquote>



So, since I'm a fan of annotations, I think I should defend them.  I think it's worth identifying two categories:
<!-- more -->



	
  * the first category allows us to specify semantics that are *intrinsic to the domain* in a declarative vs imperative way.  So annotating a property as @Email or an argument as @NotNull is informing the runtime about the values that property or argument can hold.  In a sense this is an extension of type-safety: if I declare an int variable then the runtime ensures that the variable only ever holds integral numbers.

	
  * the second category allow us to specify semantics about adjacent layers.  for example JPA annotations do this for persistence semantics.  If the information isn't in annotations then it must be somewhere else, eg Hibernate .hbm.xml config file, which often leads into refactoring problems.



For me, the decider as to whether some semantics go into the code or into some config file is based on whether I would want to vary the information on a deployment-by-deployment basis.  If they won't, then compile the semantics into the domain using annotations.  If they could, then put the semantics outside of the code where they can be more easily modified, eg XML. Even then, one can arrange matters so that annotations are used as the default, with XML (or other config file) used to override those annotations if need be.

Naked Objects of course makes heavy use of annotations, about 50:50 between the two categories (see end of this post for details).  As of Naked Objects 4.0 these all reside in org.nakedobjects.applib, but that's only because there aren't, yet, any Java standards to define them.  However, we are starting to get them: eg [JSR-303](https://www.hibernate.org/412.html) for validation (eg @Email) and [JSR-305](http://code.google.com/p/jsr-305/) for software defect detection (eg @NotNull).  As these standards become commonplace we'll most likely deprecate Naked Objects' own annotations and adopt the standards instead.

All the above said, if you still really dislike annotations (or would rather you define your own instead of those in the applib) then, actually, it's quite easy to do.  I'll show you how in the [next post]({{ site.baseurl }}/2009/11/12/overriding-annotations-with-a-dsl/).




* * *


Naked Objects annotations representing domain semantics:



	
  * @Aggregated 

	
  * @Bounded 

	
  * @Defaulted 

	
  * @Disabled 

	
  * @EqualByContent 

	
  * @Facets 

	
  * @Immutable

	
  * @Mask 

	
  * @MaxLength 

	
  * @MustSatisfy 

	
  * @NotPersistable 

	
  * @NotPersisted 

	
  * @Optional 

	
  * @RegEx 

	
  * @TypeOf 

	
  * @TypicalLength 

	
  * @Value 



Naked Objects annotations that inform adjacent layers (presentation, application, persistence):

	
  * @ActionOrder

	
  * @Debug 

	
  * @DescribedAs 

	
  * @Encodeable 

	
  * @Executed 

	
  * @Exploration 

	
  * @FieldOrder 

	
  * @Hidden 

	
  * @Ignore 

	
  * @MemberOrder

	
  * @MultiLine 

	
  * @Named 

	
  * @Parseable

	
  * @Plural


