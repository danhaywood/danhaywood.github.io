---
author: danhaywood
comments: true
date: 2012-05-30 05:43:43+00:00
layout: post
slug: registering-entity-types-with-openjpa-programmatically
title: Registering entity types with OpenJPA programmatically
wordpress_id: 979
tags:
- apache isis
- openjpa
---

I've just started work on [an OpenJPA objectstore](https://issues.apache.org/jira/browse/ISIS-48) for [Isis](incubator.apache.org/isis).  In the normal scheme of things, one would register the entity types within the persistence.xml file.  However, Isis is a framework that builds its own metamodel, and can figure out for itself which classes constitute entities.   I therefore didn't want to have to force the developer to [repeat themselves](http://en.wikipedia.org/wiki/Don't_repeat_yourself), so the puzzle became how to register the entity types programmatically within the Isis code.<!-- more -->




It turns out to be pretty simple, if a little ugly.  OpenJPA allows implementations of certain key components to be defined programmatically; these are specified in a properties map that is then passed through to javax.persistence.Persistence.createEntityManager(null, props).  But it also supports a syntax that can be used to initialize those components through setter injection.




In my case the component of interest is the openjpa.MetaDataFactory.  At one point I thought I'd be writing my own implementation; but it turns out that the standard implementation does what I need, because it allows the types to be injected through its setTypes(List<String>) mutator.  The list of strings is passed into that property as a ;-delimited list.




So, here's what I've ended up with:

[sourcecode language="java"]
final Map<String, String> props = Maps.newHashMap();

final String typeList = entityTypeList();
props.put("openjpa.MetaDataFactory",
  "org.apache.openjpa.persistence.jdbc.PersistenceMappingFactory(types=" + typeList + ")");

// ... then add in regular properties such as 
// openjpa.ConnectionURL, openjpa.ConnectionDriverName etc...
            
entityManagerFactory = Persistence.createEntityManagerFactory(null, props);
[/sourcecode]

where entityTypeList() in my case looks something like:

[sourcecode language="java"]
private String entityTypeList() {
    final StringBuilder buf = new StringBuilder();
    // loop thru Isis' metamodel looking for types that have been annotated using @Entity
    final Collection<ObjectSpecification> allSpecifications = 
        getSpecificationLoader().allSpecifications();
    for(ObjectSpecification objSpec: allSpecifications) {
        if(objSpec.containsFacet(JpaEntityFacet.class)) {
            final String fqcn = objSpec.getFullIdentifier();
            buf.append(fqcn).append(";");
        }
    }
    final String typeList = buf.toString();
    return typeList;
}
[/sourcecode]




Comments welcome, as ever.
