---
author: danhaywood
comments: true
date: 2009-12-01 22:47:57+00:00
layout: post
slug: putting-a-custom-ui-on-naked-objects-part-2-interacting-with-pojos
title: 'Putting a Custom UI on Naked Objects: Part 2, Interacting with Pojos'
wordpress_id: 430
tags:
- apache isis
---

In the [previous post]({{ site.baseurl }}/2009/11/29/putting-a-custom-ui-on-naked-objects/) we saw how to bootstrap Naked Objects, and open a PersistenceSession.  In this post let's see how to actually get hold of and interact with a domain object.

First thing we usually do is to get hold of the registered services (as per nakedobjects.services key in nakedobjects.properties configuration file).  These will typically be repositories allowing us to locate existing domain objects, like Customers or Orders.  For example, in the [claims example app]({{ site.baseurl }}/2009/09/17/naked-objects-example-claims-app-and-other-resources/), we have an EmployeeRepository example:
<!-- more -->

    
    public class EmployeeRepositoryInMemory
            extends AbstractFactoryAndRepository
            implements EmployeeRepository {
    
        public String id() { return "claimants"; }
    
        public List allEmployees() {
            return allInstances(Employee.class);
        }
    
        public List findEmployees(@Named("Name") String name) {
            return allMatches(Employee.class, name);
        }
    }
    



We can get hold of the service using its id, in this case (slightly inconsistently) "claimants":


    
    NakedObject employeeRepositoryNO =
        NakedObjectsContext.getPersistenceSession().getService("claimants");
    



As we can see, every service/repository is wrapped in a NakedObject instance.  This does the following things:



	
  * wraps the underlying pojo; getObject() returns the pojo

	
  * provides access to the metamodel; getSpecification() returns an instance of NakedObjectSpecification.

	
  * provides an object identifier, or Oid; effectively a serializable URN for the domain object.  getOid() returns this Oid.  



We can therefore obtain the EmployeeRepository to find the Employees:


    
    EmployeeRepository employeeRepository =
        (EmployeeRepository)employeeRepositoryNO.getObject();
    List<Employee> employees = employeeRepository.allEmployees();
    



We can then interact with the pojos in the usual way, for example:


    
    for (Employee employee : allEmployees) {
        String name = employee.getName();
        System.out.println(name);
        employee.setName(name + "Changed");
    }
    



Try running this little app using the XML object store, so that any changes are persisted.  To configure this, just add:


    
    nakedobjects.persistor=xml
    



to the nakedobjects.properties config file.

Now, when you run successive times, you'll see the changes are indeed being persisted.

Let's take this a little further.  Although we aren't interacting with the pojos using the Naked Objects API, they are still known to Naked Objects framework, and are enlisted into its transaction management.  Since we haven't mentioned transactions anywhere in our code, each of those setName() calls is being run in a separate transaction - ie similar to ANSI unchained mode.

But we could also put all the changes into a single transaction:


    
    NakedObjectsContext.getTransactionManager().startTransaction();
    
    for (Employee employee : allEmployees) {
        String name = employee.getName();
        System.out.println(name);
        employee.setName(name + "Changed");
    }
    
    NakedObjectsContext.getTransactionManager().endTransaction();
    



Now these changes are all perfomed in a single transaction.  To confirm this, we can use the UpdateNotifier, a component that keeps track of the objects dirtied within a transaction.  Naked Objects' own generic viewers use this to determine which objects to repaint, but you can use it for whatever you need:


    
    List<NakedObject> changedObjects = updateNotifier.getChangedObjects();
    for (NakedObject nakedObject : changedObjects) {
        Object pojo = nakedObject.getObject();
        Oid oid = nakedObject.getOid();
        System.out.println("changed: " + pojo + "; oid=" + oid);
    }
    



Note that the pojos are also wrapped in NakedObject instances, just as the service/repository was earlier.

As an alternative to all this, we can interact with the domain objects through the Naked Objects API.  We'll be looking at this in the [next post]({{ site.baseurl }}/2009/12/03/putting-a-custom-ui-on-naked-objects-part-3-the-metamodel-api/).
