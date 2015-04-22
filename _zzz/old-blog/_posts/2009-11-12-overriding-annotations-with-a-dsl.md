---
author: danhaywood
comments: true
date: 2009-11-12 08:15:43+00:00
layout: post
slug: overriding-annotations-with-a-dsl
title: Overriding Annotations with a DSL
wordpress_id: 414
tags:
- apache isis
---

In the [previous post]({{ site.baseurl }}/2009/11/11/annotations-vs-xml/) I discussed the usage of annotations in domain models, and characterized them as either capturing domain semantics intrinsic to the domain, or semantics pertaining to adjacent layers (eg persistence, or presentation).

I also mentioned though that if you really dislike annotations, it's quite possible to redefine the Naked Objects programming model so it picks up the information from elsewhere, such as a tiny DSL.  So let's see how.
<!-- more -->
The way that Naked Objects builds up its metamodel is using an API called _FacetFactory_.  Taken together as a set, these effectively define the programming model.  Taken together, these define the programming model, as seen in the [ProgrammingModelFacetsJava5](http://nakedobjects.svn.sourceforge.net/viewvc/nakedobjects//framework/trunk/core/metamodel/src/main/java/org/nakedobjects/metamodel/specloader/progmodelfacets/) class.  This implements the _ProgrammingModelFacets_ interface.

One way of specifying a different programming model is to provide a complete new implementation of _ProgrammingModelFacets_, and then declare it in _nakedobjects.properties_ using:


    
    nakedobjects.reflector.facets=\
      com.mycompany.nakedobjects.progmodel.MyCompanyProgrammingModelFacets
    



However, more likely you may just want to adjust the original _ProgrammingModelFacetsJava5_ model, by excluding selected facets, and/or including new facets.  So you could remove support for the _@Mask_ annotation for example using:


    
    nakedobjects.reflector.facets.exclude=\
      org.nakedobjects.metamodel.facets.propparam.validate.mask.MaskAnnotationFacetFactory
    



Let's take this further by replacing the use of @MemberOrder (which defines the order of properties and collections in the UI) with a config file.  I've chose this as an example because it is conceivably a case where the member order could conceivably vary across different deployments (eg if rolled out to different customers).

Here's the idea; we'll provide a config file that specifies the order for a class.  So, for Employee, with two properties 'name' and 'approver', we would have Employee.memberorder, containing:


    
    name=1
    approver=2
    



This will put the name first, the approver second.  This file lives on the classpath.

Okay; first we need to implement the _FacetFactory_ API.

First we'll define the _MemberOrderFacetFileBased_ facet itself.  This is the object that gets instantiated and attached to the properties and collections in the metamodel.  It doesn't need to do much more than remember the sequence (analogous to @MemberOrder(sequence='...') attribute.  Since there's already an adapter, we can just subclass it:


    
    package org.starobjects.misc.facets;
    
    import org.nakedobjects.metamodel.facets.FacetHolder;
    import org.nakedobjects.metamodel.facets.ordering.memberorder.MemberOrderFacetAbstract;
    
    public class MemberOrderFacetFileBased extends MemberOrderFacetAbstract {
    
      public MemberOrderFacetFileBased(
          String sequence,
          FacetHolder holder) {
        this("", sequence, holder);
      }
    
      public MemberOrderFacetFileBased(
          String name, String sequence,
          FacetHolder holder) {
        super(name, sequence, holder);
      }
    }
    



Then, the more substantial work of the _FacetFactory_ itself:


    
    package com.mycompany.nakedobjects.programmingmodel;
    
    import java.io.Closeable;
    import java.io.IOException;
    import java.io.InputStream;
    import java.lang.reflect.Method;
    import java.util.HashMap;
    import java.util.Map;
    import java.util.Properties;
    
    import org.nakedobjects.applib.Identifier;
    import org.nakedobjects.metamodel.facets.FacetFactoryAbstract;
    import org.nakedobjects.metamodel.facets.FacetHolder;
    import org.nakedobjects.metamodel.facets.FacetUtil;
    import org.nakedobjects.metamodel.facets.MethodRemover;
    import org.nakedobjects.metamodel.spec.feature.NakedObjectFeatureType;
    import org.nakedobjects.metamodel.spec.identifier.Identified;
    
    public class MemberOrderFacetFactoryFileBased extends FacetFactoryAbstract {
    
      private Map, Properties> propertiesByClass = new HashMap, Properties>();
    
      public MemberOrderFacetFactoryFileBased() {
        super(NakedObjectFeatureType.PROPERTIES_COLLECTIONS_AND_ACTIONS);
      }
    
      @Override
      public boolean process(
          Class cls, Method method, MethodRemover methodRemover,
          FacetHolder facetHolder) {
    
        if (!(facetHolder instanceof Identified)) {
          return false;
        }
        Identified identified = (Identified) facetHolder;
    
        Identifier identifier = identified.getIdentifier();
        if (identifier == null) {
          return false;
        }
        String name = identifier.getMemberName();
        if (name == null) {
          return false;
        }
    
        Properties properties = retrievePropertiesFor(cls);
        if (properties == null) {
          return false;
        }
    
        String sequence = (String) properties.get(name);
        if (sequence == null) {
          return false;
        }
        return FacetUtil.addFacet(new MemberOrderFacetFileBased(sequence, facetHolder));
      }
    
      private Properties retrievePropertiesFor(Class cls) {
        Properties properties = propertiesByClass.get(cls);
        if (properties == null) {
          InputStream resource = cls.getResourceAsStream(cls.getSimpleName() + ".memberorder");
          if (resource == null) {
            return null;
          }
          properties = new Properties();
          try {
            properties.load(resource);
          } catch (IOException e) {
            return null;
          } finally {
            closeSafely(resource);
          }
          propertiesByClass.put(cls, properties);
        }
        return properties;
      }
    
      private static void closeSafely(Closeable closeable) {
        try {
          closeable.close();
        } catch (IOException e) {
          // ignore
        }
      }
    }
    



The entry point here is the _public boolean process(Class cls, Method method, MethodRemover methodRemover, FacetHolder facetHolder)_ method.  This is called for every method in every domain class, with the relevant _FacetHolder_ (that is, the class member in the metamodel) passed in also so that a facet can be added if appropriate.  The _FacetFactory_ looks for the config file; if found then it processes it and uses it to create a _MemberOrderFacetFileBased_ with the sequence number taken from the file.

All we need do now is to include this facet factory in our configuration:


    
    nakedobjects.reflector.facets.include=\
        org.starobjects.misc.facets.MemberOrderFacetFactoryFileBased
    nakedobjects.reflector.facets.exclude=\
        org.nakedobjects.metamodel.facets.ordering.memberorder.MemberOrderAnnotationFacetFactory
    



This also excludes the _MemberOrderAnnotationFacetFactory_, though in fact any explicitly facet factory take precedence over the default factories, so this isn't strictly necessary.
