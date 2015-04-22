---
author: danhaywood
comments: true
date: 2009-12-03 00:15:02+00:00
layout: post
slug: putting-a-custom-ui-on-naked-objects-part-3-the-metamodel-api
title: 'Putting a Custom UI on Naked Objects: Part 3, The MetaModel API'
wordpress_id: 436
tags:
- apache isis
---

In [part one]({{ site.baseurl }}/2009/11/29/putting-a-custom-ui-on-naked-objects/) of this series we saw how to bootstrap Naked Objects, and in [part two]({{ site.baseurl }}/2009/12/01/putting-a-custom-ui-on-naked-objects-part-2-interacting-with-pojos/) we saw how we can interact directly with domain objects as pojos (with Naked Objects taking care of persistence and transaction management).  But we can also interact with domain objects through their NakedObject wrapper/adapter.  Although more indirect, it is also more powerful.  So let's see how.

Recall that NakedObject does three things main things: it wraps the pojo (getObject()), it provides access to the metamodel through the corresponding NakedObjectSpecification (getSpecification()), and it provides access to the object's Oid (getOid()).

If NakedObject is analogous to java.lang.Object, then NakedObjectSpecification is analogous to java.lang.Class, describing the class members (properties, collections and actions) of each NakedObject.  It provides:
<!-- more -->




  * getAssociationList() - each instance will be a OneToOneAssociation (ie a property) or a OneToManyAssociation (ie a collection)


  * getObjectActionList(NakedObjectActionType.USER) - each instance will be a NakedObjectAction


  * from NakedObjectAction in turn you can also use getParameters() - which returns a set of NakedObjectActionParameters.



If you explore these main interfaces - NakedObjectSpecification, OneToOneAssociation, OneToManyAssociation, NakedObjectAction and NakedObjectActionParameter - then you'll see that they all implement FacetHolder, which means they all implement the getFacets() and getFacet(Class) methods; an example of the [Extension Object](http://www.ccs.neu.edu/research/demeter/adaptive-patterns/visitor-usage/papers/plop96/extension-objects-gamma.ps) pattern.  Facets are key to understanding the Naked Objects metamodel.

So, a facet is a piece of information held about a class or its class members, and allowing us to interact with a domain object of that type.  These facets break into three categories.

First, there are a set of well-defined facets, understood by all Naked Objects generic OOUIs, that are primarily for presentation purposes.  For example, to obtain the (possibly localized) name of a class or class member, we use:


    
    NamedFacet specName = someNoSpec.getFacet(NamedFacet.class);
    



Second, there are facets that allow the interaction to be performed.  These are also well defined and understood by Naked Objects viewers.  The full list of interactions and their corresponding facets are:

<table >
 <tr >
  Member type
  Interaction
  Facet
  Prog model
 </tr>
 <tr >
  
<td >Property
</td>
  
<td >getter/accessor
</td>
  
<td >PropertyAccessorFacet
</td>
  
<td >getXxx()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >choices
</td>
  
<td >PropertyChoicesFacet
</td>
  
<td >choicesXxx()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >default
</td>
  
<td >PropertyDefaultFacet
</td>
  
<td >defaultXxx()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >validate
</td>
  
<td >PropertyValidateFacet
</td>
  
<td >validateXxx()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >setter/mutator
</td>
  
<td >PropertySetterFacet
</td>
  
<td >setXxx()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >clear
</td>
  
<td >PropertyClearFacet
</td>
  
<td >clearXxx()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >initialization
</td>
  
<td >PropertyInitializationFacet
</td>
  
<td >setXxx()
</td>
 </tr>
 <tr >
  
<td >Collection
</td>
  
<td >getter/accessor
</td>
  
<td >PropertyAccessorFacet
</td>
  
<td >getYyy()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >add to
</td>
  
<td >CollectionAddToFacet
</td>
  
<td >addToYyy()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >remove from
</td>
  
<td >CollectionRemoveFromFacet
</td>
  
<td >removeFromYyy()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >clear
</td>
  
<td >CollectionClearFacet
</td>
  
<td >clearYyy()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >validate add to
</td>
  
<td >CollectionValidateAddToFacet
</td>
  
<td >validateAddToYyy()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >validate remove from
</td>
  
<td >CollectionValidateRemoveFromFacet
</td>
  
<td >validateAddToYyy()
</td>
 </tr>
 <tr >
  
<td >action
</td>
  
<td >invocation
</td>
  
<td >ActionInvocationFacet
</td>
  
<td >zzz(arg0, arg1, ...)
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >choices (all params)
</td>
  
<td >ActionChoicesFacet
</td>
  
<td >choicesZzz()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >choices (param N)
</td>
  
<td >ActionParameterChoicesFacet
</td>
  
<td >choicesNZzz()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >default (all params)
</td>
  
<td >ActionDefaultFacet
</td>
  
<td >defaultZzz()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >default (param N)
</td>
  
<td >ActionParameterDefaultFacet
</td>
  
<td >defaultNZzz()
</td>
 </tr>
 <tr >
  
<td >
</td>
  
<td >validate
</td>
  
<td >ActionValidationFacet
</td>
  
<td >validateZzz(arg0, arg1, ...)
</td>
 </tr>
</table>

Third, there are the facets that enforce business rules.  To keep this post of manageable size we'll come back to these later.


For now though, let's see how to use this metamodel API.  Recall that in the [claims example app]({{ site.baseurl }}/2009/09/17/naked-objects-example-claims-app-and-other-resources/) we have an EmployeeRepository that defines an allEmployees action.  Here's how we call that action:


    
    NakedObjectSpecification employeeRepositorySpec =
        employeeRepositoryNO.getSpecification();
    NakedObjectAction allEmployeesAction =
        employeeRepositorySpec.getObjectAction(NakedObjectActionType.USER, "allEmployees()");
    ActionInvocationFacet actionInvocationFacet =
        allEmployeesAction.getFacet(ActionInvocationFacet.class);
    NakedObject resultNO = actionInvocationFacet.invoke(employeeRepositoryNO, new NakedObject[]{});
    



The result of the action is a collection, wrapped in resultNO.  However, we can discover this dynamically by checking for the existence of a CollectionFacet, through which we can then list all elements in that collection:


    
    NakedObjectSpecification resultSpec = resultNO.getSpecification();
    CollectionFacet collectionFacet = resultSpec.getFacet(CollectionFacet.class);
    if (collectionFacet != null) { // should be true
        Collection<NakedObject> adapterList =
            collectionFacet.collection(resultNO);
        for (NakedObject adapter : adapterList) {
            OneToOneAssociation nameAssoc =
                (OneToOneAssociation) adapter.getSpecification().getAssociation("name");
            PropertyAccessorFacet propertyAccessorFacet =
                nameAssoc.getFacet(PropertyAccessorFacet.class);
            Object name = propertyAccessorFacet.getProperty(adapter);
            System.out.println(name);
        }
    }
    



In this code there are two hard-coded assumptions about the domain model: that EmployeeRepository has an action called allEmployees(), and the resultant domain objects have a property called "name".  In fact, we could get rid of this second assumption, either by iterating through every property, or (simpler) just by printing out each object's title using the TitleFacet:


    
    for (NakedObject adapter : adapterList) {
        TitleFacet titleFacet =
            adapter.getSpecification().getFacet(TitleFacet.class);
        String title = titleFacet.title(adapter);
        System.out.println(title);
    }
    



Although (obviously) the metamodel API is a lot more verbose than simply using the domain objects, it is also (as I hope you are eralizing) a lot more powerful.  The ability to iterate over results and render them in a standard, generic fashion is the root of the Naked Objects viewers.  You could equally use the same technique sprinkled into your own custom UI, to take care of the 80~90% of cases where a simple UI is all that's required.

That's it for now.  In the [next]({{ site.baseurl }}/2009/12/08/putting-a-custom-ui-on-naked-objects-part-4-business-rules/), we'll continue exploring the power of the metamodel API and see how that third category of facets can be used to enforcing various types of business rules.
