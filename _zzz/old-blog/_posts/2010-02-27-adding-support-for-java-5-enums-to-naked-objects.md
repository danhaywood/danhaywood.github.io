---
author: danhaywood
comments: true
date: 2010-02-27 11:36:49+00:00
layout: post
slug: adding-support-for-java-5-enums-to-naked-objects
title: Adding support for Java 5 enums to Naked Objects
wordpress_id: 520
tags:
- apache isis
---

In the [previous]({{ site.baseurl }}/2010/02/24/simulating-enums-in-naked-objects/) [posts]({{ site.baseurl }}/2010/02/27/simulated-enums-supporting-choices/) we've seen how to simulate enums in Naked Objects 4.0.  But it'd be nice if Naked Objects supported enums natively.  So let's see how, half in this post and half in the one that follows.

What we're going to do here is to extend the Naked Objects programming model, which we do by writing FacetFactorys. <!-- more -->Each such factory installs one or more facets, which decorate the various elements in the NO metamodel: NakedObjectSpecification (cf java.lang.Class), NakedObjectAssociation and NakedObjectAction.  One of the easiest ways of seeing these facets is from the debug menu of the DnD viewer:

![debug-menu](http://farm5.static.flickr.com/4054/4391307731_f958baeafa.jpg)

This brings up a debug window clearly showing the facets:

![debug-window-showing-facets](http://farm3.static.flickr.com/2524/4392076218_b5e6013187.jpg)

Okay, so let's now refractor StockType (from the previous post) to be an enum:


    
    public enum StockType  {
      CD,
      BOOK
    }



At the same time, we can now get rid of the StockTypeFixture.

Time to start teaching Naked Objects about enums.  To get us started, we'll create a facet just to indicate that the type (StockType) is an enum:


    
    package org.nakedobjects.metamodel.facets;
    public interface EnumFacet extends Facet {
    }
    



This will get attached to the NakedObjectSpecification that represents the enum.  For now, it isn't much more than a marker.

Next, we need an implementation of ValueSemanticsProvider that will be able to supply the various facets (ParserFacet, DefaultsProviderFacet, EncoderDecoderFacet etc) that make up value semantics.  It will also implement the above EnumFacet.  The following code is very similar to VSPs for the built-in value types (such as int, String etc):


    
    package org.nakedobjects.metamodel.facets;
    
    import org.nakedobjects.applib.adapters.EncoderDecoder;
    import org.nakedobjects.applib.adapters.Parser;
    import org.nakedobjects.metamodel.adapter.TextEntryParseException;
    import org.nakedobjects.metamodel.config.NakedObjectConfiguration;
    import org.nakedobjects.metamodel.runtimecontext.RuntimeContext;
    import org.nakedobjects.metamodel.specloader.SpecificationLoader;
    import org.nakedobjects.metamodel.value.ValueSemanticsProviderAbstract;
    
    public class EnumValueSemanticsProvider extends ValueSemanticsProviderAbstract implements EnumFacet {
    
      private static final boolean IMMUTABLE = true;
      private static final boolean EQUAL_BY_CONTENT = true;
      private static final int TYPICAL_LENGTH = 8;
    
      private static Class type() {
        return EnumFacet.class;
    }
    
      /**
       * Required because {@link Parser} and {@link EncoderDecoder}.
       */
      public EnumValueSemanticsProvider() {
        this(null, null, null, null, null);
      }
    
      public EnumValueSemanticsProvider(
          FacetHolder holder,
          Class adaptedClass,
          NakedObjectConfiguration configuration, SpecificationLoader specificationLoader, RuntimeContext runtimeContext) {
        this(type(), holder, adaptedClass, TYPICAL_LENGTH, IMMUTABLE, EQUAL_BY_CONTENT, adaptedClass.getEnumConstants()[0], configuration, specificationLoader, runtimeContext);
      }
    
      private EnumValueSemanticsProvider(
          Class adapterFacetType,
          FacetHolder holder,
          Class adaptedClass,
          int typicalLength,
          boolean immutable,
          boolean equalByContent,
          Object defaultValue,
          NakedObjectConfiguration configuration,
          SpecificationLoader specificationLoader,
          RuntimeContext runtimeContext) {
        super(adapterFacetType, holder, adaptedClass, typicalLength, immutable,
            equalByContent, defaultValue, configuration, specificationLoader,
            runtimeContext);
      }
    
      @Override
      protected Object doParse(Object original, String entry) {
        Object[] enumConstants=getAdaptedClass().getEnumConstants();
        for (Object enumConstant : enumConstants) {
          if (enumConstant.toString().equals(entry))
            return enumConstant;
        }
        throw new TextEntryParseException("Unknown enum constant '" + entry + "'");
      }
    
      @Override
      protected String doEncode(Object object) {
        return titleString(object);
      }
    
      @Override
      protected Object doRestore(String data) {
        return doParse(null, data);
      }
    
      @Override
      protected String titleString(Object object) {
        return object.toString();
      }
    
      @Override
      public String titleStringWithMask(Object value, String usingMask) {
        return titleString(value);
      }
    
    }
    



Now for the FacetFactory that will install this facet:


    
    package org.nakedobjects.metamodel.facets;
    
    import org.nakedobjects.metamodel.value.ValueUsingValueSemanticsProviderFacetFactory;
    
    public class EnumFacetFactory extends ValueUsingValueSemanticsProviderFacetFactory {
    
      public EnumFacetFactory() {
        super(ChoicesFacet.class);
      }
    
      @Override
      public boolean process(
          Class cls, MethodRemover methodRemover,
          FacetHolder holder) {
    
        if (!cls.isEnum()) {
          return false;
        }
    
        addFacets(
          new EnumValueSemanticsProvider(
            holder, cls, getConfiguration(),
            getSpecificationLoader(), getRuntimeContext()));
        return true;
      }
    }
    



Lastly, we need to register this facet factory in nakedobjects.properties file:


    
    nakedobjects.reflector.facets.include=\
        org.nakedobjects.metamodel.facets.EnumFacetFactory
    



Put the above classes in the commandline project (under src/main/java; create if necessary) and all the NO dependencies in the classpath should resolve fine.

If you try this out, you should - courtesy of the ParserFacet - be able to enter BOOK or CD as strings for any property or parameter of type StockType; anything else will be ignored.  Moreover - because of the EncoderDecoderFacet - you should be able to run in client/server mode, and to use object stores (such as the XML Object Store) that persist using the encoding mechanism.

However, we're only half way there.  It'd be nice for Naked Objects to automatically provide a drop-down list of values for the enum.  We'll see how to do this in the [next post]({{ site.baseurl }}/2010/02/28/adding-support-for-java-5-enums-to-naked-objects-part-2/).
