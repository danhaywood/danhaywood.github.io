---
author: danhaywood
comments: true
date: 2009-12-08 00:23:03+00:00
layout: post
slug: putting-a-custom-ui-on-naked-objects-part-4-business-rules
title: 'Putting a Custom UI on Naked Objects: Part 4, Business Rules'
wordpress_id: 457
tags:
- apache isis
---

In the [previous post in this series]({{ site.baseurl }}/2009/12/03/putting-a-custom-ui-on-naked-objects-part-3-the-metamodel-api/) we saw how the Naked Objects metamodel uses Facets to allow arbitrary metadata to be associated to the classes, properties, collections or actions.  We've already explored the well-defined facets that are used to capture presentation semantics and to enable interactions, but we still need to see how facets enable business rules to be captured.

As I've [previously blogged about]({{ site.baseurl }}/2009/08/19/see-it-use-it-do-it/), Naked Objects allows three different types of business rules to be implemented.  In the metamodel API there is a corresponding interface for each of these rule types, implemented by Facets:

<table >
 <tr >
  Business rule
  Description
  API
  Facet implementation examples
 </tr>
 <tr >
  
<td >Visibility
</td>
  
<td >can this user see the class member?
</td>
  
<td >HidingInteractionAdvisor
</td>
  
<td >@Hidden annotation, hideXxx() supporting methods
</td>
 </tr>
 <tr >
  
<td >Usability
</td>
  
<td >if so, can this user use (edit, modify or invoke) the class member?
</td>
  
<td >DisablingInteractionAdvisor
</td>
  
<td >@Disabled annotation, disableXxx() supporting methods
</td>
 </tr>
 <tr >
  
<td >Validity
</td>
  
<td >if so, can this user use (edit, modify or invoke) the class member?
</td>
  
<td >ValidatingInteractionAdvisor
</td>
  
<td >@RegEx annotation, validateXxx() supporting methods
</td>
 </tr>
</table>

For example, the following <!-- more --> will install a disabling facet for the disableXxx() method, and validation facets for the (lack of an) @Optional annotation and for the @RegEx annotation:


    
    private String name;
    @MemberOrder(sequence="1")
    @RegEx(validation = "[A-Z][a-z].* [A-Z][a-z].*")
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String disableName() {
        return isLocked()? "Locked": null;  // isLocked() not shown
    }
    



When we query the metamodel for visibility or usability etc, each of the facets are checked to see if they implement the appropriate advisor interface.  If they do, then they get the opportunity to veto the interaction.

It's also possible to implement additional FacetFactorys that install Facets that implement the InteractionAdvisor interface.  In an [earlier post]({{ site.baseurl }}/2009/11/12/overriding-annotations-with-a-dsl/) I showed an example of writing a FacetFactory.  It's worth noting is that there's nothing in the Naked Objects Framework that assumes that these facet implementations wrap blocks of code; they could veto the interaction based on any criteria you can think of.

Ok, supposing we want to write a custom viewer and want to honour these business rules; how do we actually query the metamodel?  Here's how:

<table >
 <tr >
  Business rule
  Member type(s)
  Description
  API
 </tr>
 <tr >
  
<td >Visibility
</td>
  
<td >property, collection, action
</td>
  
<td >can this user see the class member?
</td>
  
<td >NakedObjectMember#isVisible(AuthenticationSession, NakedObject)
</td>
 </tr>
 <tr >
  
<td >Usability
</td>
  
<td >property, collection, action
</td>
  
<td >can this user use the class member (or is it disabled/greyed out)?
</td>
  
<td >NakedObjectMember#isUsable(AuthenticationSession, NakedObject)
</td>
 </tr>
 <tr >
  
<td rowspan="5" >Validity
</td>
  
<td >property
</td>
  
<td >is the proposed value valid?
</td>
  
<td >OneToOneAssociation#isAssociationValid(NakedObject, NakedObject)
</td>
 </tr>
 <tr >
  
<td rowspan="2" >collection
</td>
  
<td >is the proposed object valid to add?
</td>
  
<td >OneToManyAssociation#isValidToAdd(NakedObject, NakedObject)
</td>
 </tr>
 <tr >
  
<td >is the proposed object valid to remove?
</td>
  
<td >OneToManyAssociation#isValidToRemove(NakedObject, NakedObject)
</td>
 </tr>
 <tr >
  
<td >action params
</td>
  
<td >is the proposed argument valid?
</td>
  
<td >NakedObjectActionParameter#isValid(NakedObject, Object)
</td>
 </tr>
 <tr >
  
<td >action
</td>
  
<td >are all the proposed arguments valid?
</td>
  
<td >NakedObjectAction#isProposedArgumentSetValid(NakedObject, NakedObject[])
</td>
 </tr>
</table>

So, given a NakedObject adapter, the viewer:




  * looks up the corresponding NakedObjectSpecification


  * for each of the specification's NakedObjectMembers:



    * check if it is visible; if not then don't render it, otherwise (for a property or collection) obtain the current value


    * check if it is usable; if not then render the value as disabled/greyed out, otherwise render in an editable field






When an property/collection is edited or action invoked, the viewer then:


  * obtain the proposed value/argument


  * for properties/collections, check the value is valid


  * for actions, check if all arguments are valid individually, then check if the arguments are valid as a set


  * if so, perform the interaction (as described in the [previous post]({{ site.baseurl }}/2009/12/03/putting-a-custom-ui-on-naked-objects-part-3-the-metamodel-api/))



That's it for now.  In the next blog post we'll look in a little more detail on how to render the class member values.
