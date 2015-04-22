---
author: danhaywood
comments: true
date: 2009-12-04 13:32:58+00:00
layout: post
slug: easymock-junit-rules-and-hamcrest
title: EasyMock, JUnit @Rules and Hamcrest
wordpress_id: 447
tags:
- tdd
---

Taking a break from my series on [putting a custom UI on Naked Objects]({{ site.baseurl }}/2009/12/03/putting-a-custom-ui-on-naked-objects-part-3-the-metamodel-api/), in a week or two I'll be running my TDD training course.  The client this time wants [EasyMock](http://easymock.org) instead of [JMock](http://jmock.org) (which is what I normally teach), so I've spent an hour trying to figure out how to get the automatic verification (that JMock's own JUnit runner gives) along with easily using [Hamcrest](http://hamcrest.org) matchers in expectations.  I also wanted a way to easily switch between mocking concrete classes or just interfaces.

Anyway, here's what I've cooked up.  Given an object to test:


    
    package com.mycompany;
    import com.mycompany.TeaMaker.MilkAmount;
    import com.mycompany.TeaMaker.SugarAmount;
    
    public class TeaDrinker {
    	private TeaMaker teaMaker;
    	public void setTeaMaker(TeaMaker teaMaker) {
    		this.teaMaker = teaMaker;
    	}
    
    	public void drinkTea() {
    		teaMaker.makeTea(SugarAmount.ONE_SPOON, MilkAmount.JUST_A_DASH);
    	}
    }
    



and a collaborator (that we want to mock out):
<!-- more -->


    
    package com.mycompany;
    
    public interface TeaMaker {
    	enum SugarAmount {
    		NONE,
    		ONE_SPOON,
    		TWO_SPOONS,
    		LOTS,
    	}
    	enum MilkAmount {
    		NONE,
    		JUST_A_DASH,
    		PLENTY,
    	}
    	Tea makeTea(SugarAmount sugarAmount, MilkAmount milkAmount);
    }
    



then we can write the following test:


    
    package com.mycompany;
    
    import static com.halware.easymock.junit.integration.EasyMocks.with;
    import static org.easymock.EasyMock.expect;
    import static org.hamcrest.Matchers.equalTo;
    
    import org.junit.Rule;
    import org.junit.Test;
    
    import com.halware.easymock.junit.integration.EasyMocks;
    import com.mycompany.TeaMaker.MilkAmount;
    import com.mycompany.TeaMaker.SugarAmount;
    
    public class GivenTeaDrinkerIsThirsty {
    
    	@Rule
    	public EasyMocks mocks = EasyMocks.createMockFactory();
    
    	@Test
    	public void whenDrinksTeaThenAsksTeaMakerToMakeItFirst() throws Exception {
    		TeaMaker mockTeaMaker = mocks.niceMock(TeaMaker.class);
    		Tea mockTea = mocks.mock(Tea.class);
    		TeaDrinker teaDrinker = new TeaDrinker();
    		teaDrinker.setTeaMaker(mockTeaMaker);
    
    		expect(
    			mockTeaMaker.makeTea(
    					with(equalTo(SugarAmount.ONE_SPOON)),
    					with(equalTo(MilkAmount.JUST_A_DASH))))
    			.andReturn(mockTea);
    
    		mocks.replay();
    
    		teaDrinker.drinkTea();
    	}
    }
    



This uses a new class, EasyMocks, that acts as a mock factory along with being a JUnit rule.  Here's its code:


    
    package com.halware.easymock.junit.integration;
    
    import java.util.HashMap;
    import java.util.Map;
    
    import org.hamcrest.Matcher;
    import org.hamcrest.integration.EasyMock2Adapter;
    import org.junit.rules.MethodRule;
    import org.junit.runners.model.FrameworkMethod;
    import org.junit.runners.model.Statement;
    
    /**
     * A factory for mocks, approximately equivalent to
     * JMock's mockery (with a dash of JMock's Expectations class too).
     *
     * <p>
     * Also implements JUnit's MethodRule interface, so can automatically
     * verify all created mocks.
     */
    public class EasyMocks implements MethodRule {
    
    	/**
    	 * Factory to create mocks for interfaces only.
    	 */
    	public static EasyMocks createMockFactory() {
    		return new EasyMocks(MockFactory.INTERFACES_ONLY);
    	}
    
    	/**
    	 * Factory to create mocks for either interfaces or concrete classes.
    	 */
    	public static EasyMocks createMockFactoryForConcrete() {
    		return new EasyMocks(MockFactory.INTERFACES_AND_CLASSES);
    	}
    
    
        ////////////////////////////////////////////////
    
    	/**
    	 * Adapter to allow Hamcrest matchers to be used in expectations.
    	 */
        public static <T> T with(Matcher<T> matcher) {
            EasyMock2Adapter.adapt(matcher);
            return null;
        }
    
        public static boolean with(Matcher<Boolean> matcher) {
        	EasyMock2Adapter.adapt(matcher);
            return false;
        }
    
        public static byte with(Matcher<Byte> matcher) {
        	EasyMock2Adapter.adapt(matcher);
            return 0;
        }
    
        public static short with(Matcher<Short> matcher) {
        	EasyMock2Adapter.adapt(matcher);
            return 0;
        }
    
        public static int with(Matcher<Integer> matcher) {
        	EasyMock2Adapter.adapt(matcher);
            return 0;
        }
    
        public static long with(Matcher<Long> matcher) {
        	EasyMock2Adapter.adapt(matcher);
            return 0;
        }
    
        public static float with(Matcher<Float> matcher) {
        	EasyMock2Adapter.adapt(matcher);
            return 0.0f;
        }
    
        public static double with(Matcher<Double> matcher) {
        	EasyMock2Adapter.adapt(matcher);
            return 0.0;
        }
    
        ////////////////////////////////////////////////
    
    	public <T> T mock(Class<T> cls) {
    		return mock(null, cls);
    	}
    	public <T> T niceMock(Class<T> cls) {
    		return niceMock(null, cls);
    	}
    	public <T> T strictMock(Class<T> cls) {
    		return strictMock(null, cls);
    	}
    
    	@SuppressWarnings("unchecked")
    	public synchronized <T> T mock(String name, Class<T> cls) {
    		ClassAndName classAndName = new ClassAndName(name, cls);
    		Object mock = mocks.get(classAndName);
    		if (mock == null) {
    			mock = mockFactory.createMock(name, cls);
    			mocks.put(classAndName, mock);
    		}
    		return (T) mock;
    	}
    	@SuppressWarnings("unchecked")
    	public synchronized <T> T niceMock(String name, Class<T> cls) {
    		ClassAndName classAndName = new ClassAndName(name, cls);
    		Object mock = mocks.get(classAndName);
    		if (mock == null) {
    			mock = mockFactory.createNiceMock(name, cls);
    			mocks.put(classAndName, mock);
    		}
    		return (T) mock;
    	}
    	@SuppressWarnings("unchecked")
    	public synchronized <T> T strictMock(String name, Class<T> cls) {
    		ClassAndName classAndName = new ClassAndName(name, cls);
    		Object mock = mocks.get(classAndName);
    		if (mock == null) {
    			mock = mockFactory.createStrictMock(name, cls);
    			mocks.put(classAndName, mock);
    		}
    		return (T) mock;
    	}
    
    	public void replay() {
    		for (Object mock : mocks.values()) {
    			mockFactory.replay(mock);
    		}
    	}
    
    	private void verifyMocks() {
    		for (Object mock : mocks.values()) {
    			mockFactory.verify(mock);
    		}
    	}
    
    
        ////////////////////////////////////////////////
    
    	/**
    	 * JUnit's MethodRule implementation, automatically verifying any mocks.
    	 */
    	@Override
    	public Statement apply(final Statement base, final FrameworkMethod method, final Object target) {
    		return new Statement() {
    			@Override
    			public void evaluate() throws Throwable {
    				base.evaluate();
    				verifyMocks();
    				mocks.clear();
    			}
    		};
    	}
    
    
        ////////////////////////////////////////////////
    
    	private EasyMocks(MockFactory mockFactory) {
    		this.mockFactory = mockFactory;
    	}
    
    	private Map<ClassAndName, Object> mocks = new HashMap<ClassAndName, Object>();
    	private MockFactory mockFactory;
    	private enum MockFactory {
    		INTERFACES_ONLY {
    			@Override
    			public <T> T createMock(Class<T> cls) {
    				return org.easymock.EasyMock.createMock(cls);
    			}
    			@Override
    			public <T> T createMock(String name, Class<T> cls) {
    				return org.easymock.EasyMock.createMock(name, cls);
    			}
    			@Override
    			public <T> T createNiceMock(Class<T> cls) {
    				return org.easymock.EasyMock.createNiceMock(cls);
    			}
    			@Override
    			public <T> T createNiceMock(String name, Class<T> cls) {
    				return org.easymock.EasyMock.createNiceMock(name, cls);
    			}
    			@Override
    			public <T> T createStrictMock(Class<T> cls) {
    				return org.easymock.EasyMock.createStrictMock(cls);
    			}
    			@Override
    			public <T> T createStrictMock(String name, Class<T> cls) {
    				return org.easymock.EasyMock.createStrictMock(name, cls);
    			}
    			@Override
    			public void replay(Object mock) {
    				org.easymock.EasyMock.replay(mock);
    			}
    			@Override
    			public void verify(Object mock) {
    				org.easymock.EasyMock.verify(mock);
    			}
    		},
    		INTERFACES_AND_CLASSES {
    			@Override
    			public <T> T createMock(Class<T> cls) {
    				return org.easymock.classextension.EasyMock.createMock(cls);
    			}
    			@Override
    			public <T> T createMock(String name, Class<T> cls) {
    				return org.easymock.classextension.EasyMock.createMock(name, cls);
    			}
    			@Override
    			public <T> T createNiceMock(Class<T> cls) {
    				return org.easymock.classextension.EasyMock.createNiceMock(cls);
    			}
    			@Override
    			public <T> T createNiceMock(String name, Class<T> cls) {
    				return org.easymock.classextension.EasyMock.createNiceMock(name, cls);
    			}
    			@Override
    			public <T> T createStrictMock(Class<T> cls) {
    				return org.easymock.classextension.EasyMock.createStrictMock(cls);
    			}
    			@Override
    			public <T> T createStrictMock(String name, Class<T> cls) {
    				return org.easymock.classextension.EasyMock.createStrictMock(name, cls);
    			}
    			@Override
    			public void replay(Object mock) {
    				org.easymock.classextension.EasyMock.replay(mock);
    			}
    			@Override
    			public void verify(Object mock) {
    				org.easymock.classextension.EasyMock.verify(mock);
    			}
    		};
    		abstract <T> T createMock(Class<T> cls);
    		abstract <T> T createNiceMock(Class<T> cls);
    		abstract <T> T createStrictMock(Class<T> cls);
    
    		abstract <T> T createMock(String name, Class<T> cls);
    		abstract <T> T createNiceMock(String name, Class<T> cls);
    		abstract <T> T createStrictMock(String name, Class<T> cls);
    
    		abstract void verify(Object mock);
    		abstract void replay(Object mock);
    	}
    
    	private static class ClassAndName {
    		private Class<?> cls;
    		private String name;
    
    		public ClassAndName(String name, Class cls) {
    			this.name = name;
    			this.cls = cls;
    		}
    
    		@Override
    		public int hashCode() {
    			final int prime = 31;
    			int result = 1;
    			result = prime * result + ((cls == null) ? 0 : cls.hashCode());
    			result = prime * result + ((name == null) ? 0 : name.hashCode());
    			return result;
    		}
    		@Override
    		public boolean equals(Object obj) {
    			if (this == obj)
    				return true;
    			if (obj == null)
    				return false;
    			if (getClass() != obj.getClass())
    				return false;
    			ClassAndName other = (ClassAndName) obj;
    			if (cls == null) {
    				if (other.cls != null)
    					return false;
    			} else if (cls != other.cls)
    				return false;
    			if (name == null) {
    				if (other.name != null)
    					return false;
    			} else if (!name.equals(other.name))
    				return false;
    			return true;
    		}
    	}
    }
    



I wrote this against hamcrest v1.1, junit v4.7, easymock v2.5.1 & easymock class extensions v2.4.  I'm not exactly sure which of these projects it should be contributed to.  But at any rate, feel free to copy-and-paste and adapt/fix as needed.
