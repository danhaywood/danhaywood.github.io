---
author: danhaywood
comments: true
date: 2009-12-14 22:25:05+00:00
layout: post
slug: asserting-on-object-graphs-using-hamcrest-and-mvel
title: Asserting on Object Graphs using Hamcrest and MVEL
wordpress_id: 469
tags:
- tdd
---

I've been delivering my TDD course today, one topic of which is writing custom matchers in [Hamcrest](http://code.google.com/p/hamcrest/).  One topic that came up was in asserting state within large object graphs, so it struck me that a nice general purpose matcher would be one that used an expression language to navigate the graph.

For example, given a customer that has an address, which has a city, which has a name, then it'd be nice to be able to say:

`assertThat("London", navigableFrom(customer, "address.city.name"))`

where _navigableFrom()_ is the factory for the matcher.

So, without further ado, here's a set of tests for such a matcher:<!-- more -->

    
    package com.halware.matchers.mvel;
    import static com.halware.matchers.MyMatchers.navigatedFrom;
    import static org.junit.Assert.assertThat;
    import java.util.Arrays;
    import org.junit.Before;
    import org.junit.Test;
    
    public class MvelMatcherTest {
    
      private Customer customer;
      private PhoneNumber phoneNumber1;
      private PhoneNumber phoneNumber2;
      private City city;
      private Address address;
    
      @Before
      public void setUp() throws Exception {
        customer = new Customer();
        customer.setName("Joe Bloggs");
    
        address = new Address();
        address.setHouseNumber(23);
        customer.setAddress(address);
    
        city = new City();
        city.setName("London");
        address.setCity(city);
    
        phoneNumber1 = customer.addPhoneNumber("0207 123 4567");
        phoneNumber2 = customer.addPhoneNumber("0207 765 4321");
      }
    
      @Test
      public void canNavigateFromNullContext() throws Exception {
        assertThat(null, navigatedFrom(null, "anything"));
      }
    
      @Test
      public void canNavigateToValue() throws Exception {
        assertThat("Joe Bloggs", navigatedFrom(customer, "name"));
      }
    
      @Test
      public void canNavigateToNullValue() throws Exception {
        customer.setName(null);
        assertThat(null, navigatedFrom(customer, "name"));
      }
    
      @Test
      public void canNavigateToNull() throws Exception {
        assertThat(null, navigatedFrom(customer, "nonExistent"));
      }
    
      @Test
      public void canNavigateToReference() throws Exception {
        assertThat(address, navigatedFrom(customer, "address"));
      }
    
      @Test
      public void canNavigateOneHop() throws Exception {
        assertThat(23, navigatedFrom(customer, "address.houseNumber"));
      }
    
      @Test
      public void canNavigateToNullOneHop() throws Exception {
        assertThat(null, navigatedFrom(customer, "address.nonExistent"));
      }
    
      @Test
      public void canNavigateTwoHops() throws Exception {
        assertThat("London", navigatedFrom(customer, "address.city.name"));
      }
    
      @Test
      public void canNavigateToCollection() throws Exception {
        assertThat(Arrays.asList(phoneNumber1, phoneNumber2), navigatedFrom(
            customer, "phoneNumbers"));
      }
    
      @Test
      public void canEvaluateWithinCollection() throws Exception {
        assertThat(phoneNumber2, navigatedFrom(customer, "phoneNumbers[1]"));
      }
    }
    



And here's the matcher itself, implemented using [MVEL](http://mvel.codehaus.org):

    
    package com.halware.matchers;
    
    import org.hamcrest.BaseMatcher;
    import org.hamcrest.Description;
    import org.hamcrest.Matcher;
    import org.mvel2.MVEL;
    
    public final class MyMatchers {
    
      public static Matcher<Object> navigatedFrom(final Object context, final String expression) {
        return new BaseMatcher<Object>() {
    
          @Override
          public boolean matches(Object item) {
            Object eval = eval(context, expression);
            return nullSafeEquals(item, eval);
          }
    
          @Override
          public void describeTo(Description description) {
            description.appendText(
              eval(context, expression) + " (" + expression + ")");
          }
    
          private boolean nullSafeEquals(Object item, Object eval) {
            if (item == null && eval == null) {
              return true;
            }
            if (item == null || eval == null) {
              return false;
            }
            return item.equals(eval);
          }
    
          private Object eval(final Object context, final String expression) {
            try {
              return MVEL.eval(expression, context);
            } catch (Exception e) {
              return null;
            }
          }
        };
      }
    }
    
