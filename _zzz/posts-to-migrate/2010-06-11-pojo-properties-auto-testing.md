---
author: danhaywood
comments: true
date: 2010-06-11 12:56:18+00:00
layout: post
slug: pojo-properties-auto-testing
title: Pojo Properties Auto Testing
wordpress_id: 600
---

Doing another run of my TDD course, and one of the attendees raised an interesting question: are there any tools to automatically test pojo getters and setters?  We couldn't find any, and it sounded like a challenge worth tackling.
<!-- more -->
Now I don't want to get into the debate about whether we should even bother to test simple getters and setters; the context here is that not doing so drags down the code coverage figures, putting the development team on the back foot when trying to justifying their code quality to "management".  So if something could automatically test the simple getters and setters, that would be a big win.

So, here, for your delectation, is my pojo property auto tester. It's provided as a superclass testcase:

    
    import java.beans.BeanInfo;
    import java.beans.Introspector;
    import java.beans.PropertyDescriptor;
    import java.lang.reflect.Method;
    import java.util.HashMap;
    import java.util.Map;
    
    import org.junit.Assert;
    import org.junit.Before;
    
    public abstract class AbstractPojoTester {
    
    	private Map testValues = new HashMap();
    
    	protected void addTestValue(Class propertyType, Object testValue) {
    		testValues.put(propertyType, testValue);
    	}
    
    	@Before
    	public void setUpTestValues() throws Exception {
    		// add in further test values here.
    		addTestValue(String.class, "foo");
    		addTestValue(int.class, 123);
    		addTestValue(Integer.class, 123);
    		addTestValue(double.class, 123.0);
    		addTestValue(Double.class, 123.0);
    		addTestValue(boolean.class, true);
    		addTestValue(Boolean.class, true);
    		addTestValue(java.util.Date.class, new java.util.Date(100, 3, 4, 11, 45));
    	}
    
    	/**
    	 * Call from subclass
    	 */
    	protected void testPojo(Class pojoClass) {
    		try {
    			Object pojo = pojoClass.newInstance();
    			BeanInfo pojoInfo = Introspector.getBeanInfo(pojoClass);
    			for (PropertyDescriptor propertyDescriptor : pojoInfo
    					.getPropertyDescriptors()) {
    				testProperty(pojo, propertyDescriptor);
    			}
    		} catch (Exception e) {
    			// ignore
    		}
    	}
    
    	private void testProperty(Object pojo, PropertyDescriptor propertyDescriptor) {
    		try {
    			Class propertyType = propertyDescriptor.getPropertyType();
    			Object testValue = testValues.get(propertyType);
    			if (testValue == null) {
    				return;
    			}
    			Method writeMethod = propertyDescriptor.getWriteMethod();
    			Method readMethod = propertyDescriptor.getReadMethod();
    			if (readMethod != null && writeMethod != null) {
    				writeMethod.invoke(pojo, testValue);
    				Assert.assertEquals(readMethod.invoke(pojo), testValue);
    			}
     		} catch (Exception e) {
    			// ignore
    		}
    	}
    }
    



So, supposing you want to test this trivial pojo:

    
    public class Person {
    	private String name;
    	private int age;
    	private double salary;
    
    	public String getName() {
    		return name;
    	}
    	public void setName(String name) {
    		this.name = name;
    	}
    	public int getAge() {
    		return age;
    	}
    	public void setAge(int age) {
    		this.age = age;
    	}
    	public double getSalary() {
    		return salary;
    	}
    	public void setSalary(double salary) {
    		this.salary = salary;
    	}
    }
    



The test case for this is simply:

    
    import org.junit.Test;
    
    public class PersonTester extends AbstractPojoTester {
    	@Test
    	public void testGettersAndSetters() {
    		testPojo(Person.class);
    	}
    }
    



Feel free to enhance as required...
