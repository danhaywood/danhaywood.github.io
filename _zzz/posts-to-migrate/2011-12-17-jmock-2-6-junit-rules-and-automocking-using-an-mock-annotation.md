---
author: danhaywood
comments: true
date: 2011-12-17 11:35:36+00:00
layout: post
slug: jmock-2-6-junit-rules-and-automocking-using-an-mock-annotation
title: JMock 2.6 - JUnit Rules and automocking using an @Mock annotation
wordpress_id: 861
tags:
- jmock
- junit
- tdd
---

I've been using [Mockito](http://mockito.googlecode.com) a lot this year at work, but I still prefer [JMock](http://jmock.org).  However, JMock could do with trimming some of its boilerplate, and I also thought it would be a good idea to use JUnit 4.7's [org.junit.rules.MethodRule](http://kentbeck.github.com/junit/javadoc/latest/org/junit/rules/MethodRule.html).

I was about to go implement something to support Mockito's [@Mock](http://mockito.googlecode.com/svn/branches/1.6/javadoc/org/mockito/Mock.html) annotation, but thought I'd browse the jmock.org website first.  It looks like Steve and Nat are ahead of me, and that JMock 2.6 will have the sort of support I need.

<!-- more -->

As I write this, they haven't released that version yet, but the actual code that's needed isn't much.   So I thought I'd copy-n-paste for your delectation:

[sourcecode language="java"]
package org.jmock.integration.junit4;

import org.jmock.auto.internal.Mockomatic;
import org.jmock.internal.AllDeclaredFields;
import org.junit.rules.MethodRule;
import org.junit.runners.model.FrameworkMethod;
import org.junit.runners.model.Statement;

import java.lang.reflect.Field;
import java.util.List;

import static org.junit.Assert.fail;

public class JUnitRuleMockery extends JUnit4Mockery implements MethodRule {
    private final Mockomatic mockomatic = new Mockomatic(this);

    @Override
    public Statement apply(final Statement base, FrameworkMethod method, final Object target) {
        return new Statement() {
            @Override
            public void evaluate() throws Throwable {
                prepare(target);
                base.evaluate();
                assertIsSatisfied();
            }

            private void prepare(final Object target) {
                List<Field> allFields = AllDeclaredFields.in(target.getClass());
                assertOnlyOneJMockContextIn(allFields);
                fillInAutoMocks(target, allFields);
            }

            private void assertOnlyOneJMockContextIn(List<Field> allFields) {
                Field contextField = null;
                for (Field field : allFields) {
                    if (JUnitRuleMockery.class.isAssignableFrom(field.getType())) {
                        if (null != contextField) {
                            fail("Test class should only have one JUnitRuleMockery field, found "
                                  + contextField.getName() + " and " + field.getName());
                        }
                        contextField = field;
                    }
                }
            }

            private void fillInAutoMocks(final Object target, List<Field> allFields) {
                mockomatic.fillIn(target, allFields);
            }
        };
    }
}
[/sourcecode]

A typical class to use this would use this as follows:

[sourcecode language="java"]
public class ATestWithSatisfiedExpectations {
    @Rule
    public final JUnitRuleMockery context = new JUnitRuleMockery();
    @Mock
    private Runnable runnable;
    @Test
    public void doesSatisfyExpectations() {
        context.checking(new Expectations()  {% raw } {{ {% endraw %}
            oneOf (runnable).run();
        }});
        runnable.run();
    }
}
[/sourcecode]

As you can see, this supports @Mock very much the same way as Mockito.  The @Mock annotation itself is simply:

[sourcecode language="java"]
package org.jmock.auto;

import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

@Retention(RUNTIME)
@Target(FIELD)
public @interface Mock {
}
[/sourcecode]

There is also an @Auto annotation which can be used to automatically instantiate States and Sequences:

[sourcecode language="java"]
package org.jmock.auto;

import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

@Retention(RUNTIME)
@Target(FIELD)
public @interface Auto {
}
[/sourcecode]

Meanwhile, there are two internal class to do some of the reflection stuff. First, Mockomatic:

[sourcecode language="java"]
package org.jmock.auto.internal;

import java.lang.reflect.Field;
import java.util.List;

import org.jmock.Mockery;
import org.jmock.Sequence;
import org.jmock.States;
import org.jmock.auto.Auto;
import org.jmock.auto.Mock;
import org.jmock.internal.AllDeclaredFields;

public class Mockomatic {
    private final Mockery mockery;

    public Mockomatic(Mockery mockery) {
        this.mockery = mockery;
    }

    public void fillIn(Object object) {
        fillIn(object, AllDeclaredFields.in(object.getClass()));
    }

    public void fillIn(Object object, final List<Field> knownFields) {
        for (Field field : knownFields) {
            if (field.isAnnotationPresent(Mock.class)) {
                autoMock(object, field);
            }
            else if (field.isAnnotationPresent(Auto.class)) {
                autoInstantiate(object, field);
            }
        }
    }

    private void autoMock(Object object, Field field) {
        setAutoField(field, object,
                     mockery.mock(field.getType(), field.getName()),
                     "auto-mock field " + field.getName());
    }

    private void autoInstantiate(Object object, Field field) {
        final Class<?> type = field.getType();
        if (type == States.class) {
            autoInstantiateStates(field, object);
        }
        else if (type == Sequence.class) {
            autoInstantiateSequence(field, object);
        }
        else {
            throw new IllegalStateException("cannot auto-instantiate field of type " + type.getName());
        }
    }

    private void autoInstantiateStates(Field field, Object object) {
        setAutoField(field, object,
                     mockery.states(field.getName()),
                     "auto-instantiate States field " + field.getName());
    }

    private void autoInstantiateSequence(Field field, Object object) {
        setAutoField(field, object,
                     mockery.sequence(field.getName()),
                     "auto-instantiate Sequence field " + field.getName());
    }

    private void setAutoField(Field field, Object object, Object value, String description) {
        try {
            field.setAccessible(true);
            field.set(object, value);
        }
        catch (IllegalAccessException e) {
            throw new IllegalStateException("cannot " + description, e);
        }
    }
}
[/sourcecode]

and second, AllDeclaredFields:

[sourcecode language="java"]</pre>
package org.jmock.auto.internal;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import static java.util.Arrays.asList;

public class AllDeclaredFields {
    public static List<Field> in(Class<?> clazz) {
        final ArrayList<Field> fields = new ArrayList<Field>();
        for (Class<?> c = clazz; c != Object.class; c = c.getSuperclass()) {
            fields.addAll(asList(c.getDeclaredFields()));
        }
        return fields;
    }
}
[/sourcecode]

The above is a great improvement; my own small extension is to add some convenience methods, and to introduce a factory method to replace the rather obscure way that JMock has for mocking classes:

[sourcecode language="java"]
package org.apache.isis.core.testsupport.jmock;

import org.jmock.Expectations;
import org.jmock.lib.legacy.ClassImposteriser;
import org.junit.runners.model.FrameworkMethod;
import org.junit.runners.model.Statement;

public class JUnitRuleMockery2 extends JUnitRuleMockery {

    public static enum Mode {
        INTERFACES_ONLY,
        INTERFACES_AND_CLASSES;
    }

    public static JUnitRuleMockery2 createFor(Mode mode) {
        JUnitRuleMockery2 jUnitRuleMockery2 = new JUnitRuleMockery2();
        if(mode == Mode.INTERFACES_AND_CLASSES) {
            jUnitRuleMockery2.setImposteriser(ClassImposteriser.INSTANCE);
        }
        return jUnitRuleMockery2;
    }

    public <T> T ignoring(final T mock) {
        checking(new Expectations() { { ignoring(mock); } });
        return mock;
    }

    public <T> T allowing(final T mock) {
        checking(new Expectations() { { allowing(mock); } });
        return mock;
    }

    public <T> T never(final T mock) {
        checking(new Expectations() { { never(mock); } });
        return mock;
    }

    public <T> T mockAndIgnoring(final Class<T> typeToMock) {
        return ignoring(mock(typeToMock));
    }

    public <T> T mockAndIgnoring(final Class<T> typeToMock, final String name) {
        return ignoring(mock(typeToMock, name));
    }

    public <T> T mockAndAllowing(final Class<T> typeToMock) {
        return allowing(mock(typeToMock));
    }

    public <T> T mockAndAllowing(final Class<T> typeToMock, final String name) {
        return allowing(mock(typeToMock, name));
    }

    public <T> T mockAndNever(final Class<T> typeToMock) {
        return never(mock(typeToMock));
    }

    public <T> T mockAndNever(final Class<T> typeToMock, final String name) {
        return never(mock(typeToMock, name));
    }
}
[/sourcecode]

This can be used as follows:

[sourcecode language="java"]
public class MyTest {

  @Rule
  public final Junit4Mockery2 context = Junit4Mockery2.createFor(Mode.INTERFACES);
  ...
}
[/sourcecode]

Comments always welcome.
