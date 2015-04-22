---
author: danhaywood
comments: true
date: 2009-09-11 11:55:39+00:00
layout: page
published: false
slug: starobjects-restfulobject
title: for REST
wordpress_id: 265
---

[![arabic-trenduk-deckchair-330x220](http://farm1.static.flickr.com/66/216247046_5ee336d3d6.jpg)](http://www.flickr.com/photos/nik-in-parispodcast/216247046/)

RESTful Objects is a sister project for Naked Objects that automatically exposes your domain objects as [RESTful](http://en.wikipedia.org/wiki/Representational_State_Transfer) resources.



Using the standard HTTP verbs (GET, POST, PUT and DELETE) a client application can interact with your domain objects.  The domain objects are represented as XHTML resources, with a CSS microlanguage to define semantics.




RESTful Objects provides the following mappings:
<table border="1" >
<tbody >
<tr >
HTTP Method
Object
Property
Collection
Action
</tr>
<tr >

<td >GET
</td>

<td >current state of properties
</td>

<td >-
</td>

<td >retrieve contents of collection
</td>

<td >-
</td>
</tr>
<tr >

<td >PUT
</td>

<td >persist object
</td>

<td >sets property
</td>

<td >adds object to collection
</td>

<td >-
</td>
</tr>
<tr >

<td >DELETE
</td>

<td >delete persisted object
</td>

<td >clears property
</td>

<td >removes object from collection
</td>

<td >-
</td>
</tr>
<tr >

<td >POST
</td>

<td >-
</td>

<td >-
</td>

<td >-
</td>

<td >invoke
</td>
</tr>
</tbody></table>

Under the cover RESTful Objects is implemented using JAX-RS API, with JBoss' [RESTEasy](http://jboss.org/resteasy) as the underlying implementation.  The JAX-RS annotations are defined in the RESTful objects applib which specifies the precisely the URLs for client-side programs to submit.  (See below for details).  You'll need to use a bit of trial and error to figure out the parsing of the XHTML, though because it _is_ you can browse directly using Firefox.  Here's a screenshot from the [book](http://pragprog.com/titles/dhnako):

[![RestfulObjectsServesUpXhtmlPages](http://farm3.static.flickr.com/2588/3908781949_105aeda8f2.jpg)](http://www.flickr.com/photos/danhaywood/3908781949/)




See the [project website](http://restfulobjects.sourceforge.net) for more details.



* * *




### **RESTful Objects Mappings**





The RESTful Objects applib uses JAX-RS annotations to specify the URLs for client-side programs to submit.  They are:



#### **/resources**


The other top-level resources (ie, those listed below)

    
    package org.starobjects.restful.applib.resources;
    
    import javax.ws.rs.GET;
    import javax.ws.rs.Produces;
    
    public interface HomePageResource {
    
        @GET
        @Produces( {"application/xhtml+xml", "text/html"} )
        public String resources();
    
    }
    




#### **/services**





Resources providing access to the available repositories or registered domain services (in nakedobjects.properties).

    
    package org.starobjects.restful.applib.resources;
    
    import javax.ws.rs.GET;
    import javax.ws.rs.Path;
    import javax.ws.rs.Produces;
    
    public interface ServicesResource {
    
        @GET
        @Produces( {"application/xhtml+xml", "text/html"} )
        @Path("/")
        public String services();
    
    }
    





#### **/object**





Resources to interact with a domain object or a repository.  These are the ones used most often.

    
    package org.starobjects.restful.applib.resources;
    
    import java.io.InputStream;
    
    import javax.ws.rs.DELETE;
    import javax.ws.rs.GET;
    import javax.ws.rs.POST;
    import javax.ws.rs.PUT;
    import javax.ws.rs.Path;
    import javax.ws.rs.PathParam;
    import javax.ws.rs.Produces;
    import javax.ws.rs.QueryParam;
    
    public interface ObjectResource {
    
        @GET
        @Path("/{oid}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public String object(
                @PathParam("oid") final String oidStr);
    
        @PUT
        @Path("/{oid}/property/{propertyId}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public String modifyProperty(
                @PathParam("oid") final String oidStr,
                @PathParam("propertyId") final String propertyId,
                @QueryParam("proposedValue") final String proposedValue);
    
        @DELETE
        @Path("/{oid}/property/{propertyId}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public String clearProperty(
                @PathParam("oid") final String oidStr,
                @PathParam("propertyId") final String propertyId);
    
        @GET
        @Path("/{oid}/collection/{collectionId}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public String accessCollection(
                @PathParam("oid") final String oidStr,
                @PathParam("collectionId") final String collectionId);
    
        @PUT
        @Path("/{oid}/collection/{collectionId}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public String addToCollection(
                @PathParam("oid") final String oidStr,
                @PathParam("collectionId") final String collectionId,
                @QueryParam("proposedValue") final String proposedValueOidStr);
    
        @DELETE
        @Path("/{oid}/collection/{collectionId}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public String removeFromCollection(
                @PathParam("oid") final String oidStr,
                @PathParam("collectionId") final String collectionId,
                @QueryParam("proposedValue") final String proposedValueOidStr);
    
        @POST
        @Path("/{oid}/action/{actionId}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public String invokeAction(
                @PathParam("oid") final String oidStr,
                @PathParam("actionId") final String actionId,
                final InputStream body);
    
    }
    





#### **/specs**





Resources representing the Naked Objects meta-model

    
    package org.starobjects.restful.applib.resources;
    
    import javax.ws.rs.GET;
    import javax.ws.rs.Path;
    import javax.ws.rs.PathParam;
    import javax.ws.rs.Produces;
    
    public interface SpecsResource {
    
        @GET
        @Path("/")
        @Produces( { "application/xhtml+xml", "text/html" })
        public abstract String specs();
    
        @GET
        @Path("/{specFullName}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public abstract String spec(
        		@PathParam("specFullName") final String specFullName);
    
        @GET
        @Path("/{specFullName}/facet/{facetType}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public abstract String specFacet(
        		@PathParam("specFullName") final String specFullName,
        		@PathParam("facetType") final String facetTypeName);
    
        @GET
        @Path("/{specFullName}/property/{propertyName}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public abstract String specProperty(
        		@PathParam("specFullName") final String specFullName,
        		@PathParam("propertyName") final String propertyName);
    
        @GET
        @Path("/{specFullName}/collection/{collectionName}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public abstract String specCollection(
        		@PathParam("specFullName") final String specFullName,
        		@PathParam("collectionName") final String collectionName);
    
        @GET
        @Path("/{specFullName}/action/{actionId}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public abstract String specAction(
        		@PathParam("specFullName") final String specFullName,
        		@PathParam("actionId") final String actionId);
    
        @GET
        @Path("/{specFullName}/property/{propertyName}/facet/{facetType}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public abstract String specPropertyFacet(
        		@PathParam("specFullName") final String specFullName,
        		@PathParam("propertyName") final String propertyName,
        		@PathParam("facetType") final String facetTypeName);
    
        @GET
        @Path("/{specFullName}/collection/{collectionName}/facet/{facetType}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public abstract String specCollectionFacet(
        		@PathParam("specFullName") final String specFullName,
        		@PathParam("collectionName") final String collectionName,
        		@PathParam("facetType") final String facetTypeName);
    
        @GET
        @Path("/{specFullName}/action/{actionId}/facet/{facetType}")
        @Produces( { "application/xhtml+xml", "text/html" })
        public abstract String specActionFacet(
        		@PathParam("specFullName") final String specFullName,
        		@PathParam("actionId") final String actionId,
        		@PathParam("facetType") final String facetTypeName);
    
    }




### **/user **


Resources representing the current user.

    
    package org.starobjects.restful.applib.resources;
    
    import javax.ws.rs.GET;
    import javax.ws.rs.Produces;
    
    public interface UserResource {
    
        @GET
        @Produces( { "application/xhtml+xml", "text/html" })
        public String user();
    
    }
