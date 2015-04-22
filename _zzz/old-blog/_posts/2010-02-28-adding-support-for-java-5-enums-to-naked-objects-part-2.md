---
author: danhaywood
comments: true
date: 2010-02-28 08:24:36+00:00
layout: post
slug: adding-support-for-java-5-enums-to-naked-objects-part-2
title: Adding support for Java 5 enums to Naked Objects - part 2
wordpress_id: 526
tags:
- apache isis
---

In the [previous post]({{ site.baseurl }}/2010/02/27/adding-support-for-java-5-enums-to-naked-objects/) we saw how to write a FacetFactory so that Naked Objects treats enums as value types.  Let's now complete the story by also showing how to provide drop-down lists for any properties or action parameters of that type.
<!-- more -->
We'll start by defining a new ChoicesFacet, to represent the values of the enum.  This will be attached to the enum's NakedObjectSpecification:


    
    package org.nakedobjects.metamodel.facets;
    
    import org.nakedobjects.metamodel.adapter.NakedObject;
    
    public interface ChoicesFacet extends Facet {
    
        /**
         * Gets a set of choices for this object.
         */
        public Object[] getChoices(NakedObject adapter);
    }
    



Standard fare is to also provide an abstract adapter:


    
    package org.nakedobjects.metamodel.facets;
    
    public abstract class ChoicesFacetAbstract extends FacetAbstract implements ChoicesFacet {
    
        public static Class type() {
            return ChoicesFacet.class;
        }
    
        public ChoicesFacetAbstract(FacetHolder holder) {
            super(type(), holder, false);
        }
    }
    



And finally, let's have an implementation for enums:


    
    package org.nakedobjects.metamodel.facets;
    
    import org.nakedobjects.metamodel.adapter.NakedObject;
    
    public class ChoicesFacetEnum extends ChoicesFacetAbstract {
    
        private Object[] choices;
    
        public ChoicesFacetEnum(final FacetHolder holder, final Object[] choices) {
            super(holder);
            this.choices = choices;
        }
    
        @Override
        public Object[] getChoices(NakedObject adapter) {
            return choices;
        }
    }
    



Let's now revisit EnumFacetFactory and have it install this facet:


    
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
    
        addFacets(new EnumValueSemanticsProvider(holder, cls, getConfiguration(), getSpecificationLoader(), getRuntimeContext()));
        FacetUtil.addFacet(new ChoicesFacetEnum(holder, cls.getEnumConstants()));
        return true;
      }
    }
    



The change here is the penultimate line in process() which adds the new ChoicesFacetEnum.

To get the properties and action parameters to display these choices, we need a further FacetFactory.  This one will install a PropertyChoicesFacet and an ActionParameterChoicesFacet onto the property and action parameters respectively.  We start by defining new subclasses of these facets:


    
    package org.nakedobjects.metamodel.facets;
    
    import org.nakedobjects.metamodel.adapter.NakedObject;
    import org.nakedobjects.metamodel.facets.properties.choices.PropertyChoicesFacetAbstract;
    import org.nakedobjects.metamodel.spec.NakedObjectSpecification;
    import org.nakedobjects.metamodel.specloader.internal.peer.NakedObjectAssociationPeer;
    
    public class PropertyChoicesFacetDerivedFromChoicesFacet extends PropertyChoicesFacetAbstract {
    
        public PropertyChoicesFacetDerivedFromChoicesFacet(FacetHolder holder) {
            super(holder);
        }
    
        @Override
        public Object[] getChoices(NakedObject adapter) {
            FacetHolder facetHolder = getFacetHolder();
            NakedObjectAssociationPeer noap = (NakedObjectAssociationPeer) facetHolder;
            NakedObjectSpecification noSpec = noap.getSpecification();
            ChoicesFacet choicesFacet = noSpec.getFacet(ChoicesFacet.class);
            if (choicesFacet == null)
                return new Object[0];
            return choicesFacet.getChoices(adapter);
        }
    }
    



for properties, and:


    
    public class ActionParameterChoicesFacetDerivedFromChoicesFacet extends ActionParameterChoicesFacetAbstract {
    
        public ActionParameterChoicesFacetDerivedFromChoicesFacet(FacetHolder holder) {
            super(holder);
        }
    
        public Object[] getChoices(NakedObject adapter) {
            FacetHolder facetHolder = getFacetHolder();
            NakedObjectActionParamPeer noapp = (NakedObjectActionParamPeer) facetHolder;
            NakedObjectSpecification noSpec = noapp.getSpecification();
            ChoicesFacet choicesFacet = noSpec.getFacet(ChoicesFacet.class);
            if (choicesFacet == null)
                return new Object[0];
            return choicesFacet.getChoices(adapter);
        }
    }
    


for action parameters.  The implementation of these two facets is similar: they delegate to the ChoicesFacet of their corresponding type if it exists.

Finally, we need the new FacetFactory to install these facets:


    
    package org.nakedobjects.metamodel.facets;
    
    import java.lang.reflect.Method;
    
    import org.nakedobjects.metamodel.spec.feature.NakedObjectFeatureType;
    
    public class PropertyAndParameterChoicesFacetDerivedFromChoicesFacetFacetFactory extends
        FacetFactoryAbstract {
    
        public PropertyAndParameterChoicesFacetDerivedFromChoicesFacetFacetFactory() {
            super(NakedObjectFeatureType.PROPERTIES_AND_PARAMETERS);
        }
    
        @Override
        public boolean process(Class cls, Method method,
                MethodRemover methodRemover, FacetHolder holder) {
    
            Class returnType = method.getReturnType();
    
            if (!returnType.isEnum()) {
                return false;
            }
    
            FacetUtil.addFacet(new PropertyChoicesFacetDerivedFromChoicesFacet(holder));
            return true;
        }
    
        @Override
        public boolean processParams(Method method, int paramNum, FacetHolder holder) {
            Class paramType = method.getParameterTypes()[paramNum];
    
            if (!paramType.isEnum()) {
                return false;
            }
    
            FacetUtil.addFacet(new ActionParameterChoicesFacetDerivedFromChoicesFacet(holder));
            return true;
        }
    }
    



Last but not least, we need to register this new FacetFactory alongside the one described in the previous post:


    
    nakedobjects.reflector.facets.include=\
        org.nakedobjects.metamodel.facets.EnumFacetFactory,\
        org.nakedobjects.metamodel.facets.PropertyAndParameterChoicesFacetDerivedFromChoicesFacetFacetFactory
    



All that remains is to see what this looks like.  Here in full is the Stock entity, where Stock has a StockType:


    
    package com.mycompany.myapp.dom;
    
    import org.nakedobjects.applib.AbstractDomainObject;
    import org.nakedobjects.applib.annotation.Disabled;
    import org.nakedobjects.applib.annotation.MemberOrder;
    import org.nakedobjects.applib.annotation.Optional;
    
    public class Stock extends AbstractDomainObject implements Loanable {
    
        public String title() {
            return getName();
        }
    
        //  {% raw } {{ {% endraw %} Name
        private String name;
        @MemberOrder(sequence = "1")
        public String getName() {
          return name;
        }
        public void setName(final String name) {
          this.name = name;
        }
        // }}
    
        //  {% raw } {{ {% endraw %} Quantity
        private int quantity;
        @MemberOrder(sequence = "2")
        public int getQuantity() {
          return quantity;
        }
    
        public void setQuantity(final int quantity) {
          this.quantity = quantity;
        }
        // }}
    
        //  {% raw } {{ {% endraw %} StockType
        private StockType stockType;
    
        @Optional
        @MemberOrder(sequence = "2")
        public StockType getStockType() {
          return stockType;
        }
    
        public void setStockType(final StockType stockType) {
          this.stockType = stockType;
        }
        // }}
    }
    



… and a  StockRepository:


    
    package com.mycompany.myapp.dom;
    
    import java.util.List;
    
    import org.nakedobjects.applib.AbstractFactoryAndRepository;
    import org.nakedobjects.applib.annotation.MemberOrder;
    
    public class StockRepository extends AbstractFactoryAndRepository {
    
      //  {% raw } {{ {% endraw %} all
      @MemberOrder(sequence = "1")
      public List all() {
        return allInstances(Stock.class);
      }
      // }}
    
      //  {% raw } {{ {% endraw %} create
      @MemberOrder(sequence = "2")
      public Stock create(StockType stockType) {
        Stock stock = newTransientInstance(Stock.class);
        stock.setStockType(stockType);
        return stock;
      }
      // }}
    }
    



If we bring up the dialog for the repository's create() action, we'll see there is a drop-down list box:

![action-param-enum-dropdown](http://farm5.static.flickr.com/4005/4392076884_ab8b0bb9f9.jpg)

and similarly, there's a drop-down for the StockRepository:

![property-enum-dropdown](http://farm3.static.flickr.com/2756/4391308137_428e0dbd8f.jpg)

We'll be merging the above into facets within Naked Objects 4.1, but if you can't wait until that is released, by all means copy and paste and add to your own projects in the meantime.  Enjoy!
