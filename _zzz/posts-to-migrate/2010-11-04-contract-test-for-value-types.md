---
author: danhaywood
comments: true
date: 2010-11-04 16:54:25+00:00
layout: post
slug: contract-test-for-value-types
title: Contract test for value types
wordpress_id: 680
tags:
- tdd
---

In my 2-day TDD course a couple of the things we go into are value types and of contract tests. It occurred to me recently (while writing a new value type within [Apache Isis](http://incubator.apache.org/isis)) that I really should have a contract test for any value type. That would allow me to easily check that the value type's equals() method was an [equivalence relation](http://en.wikipedia.org/wiki/Equivalence_relation) (ie symmetric, transitive, reflexive) and that its hashCode() is consistent with equals().

What I came up with is the ValueTypeContractTestAbstract<T> class. This is how you would use it to test that java.lang.String#equals() meets the equivalence relation:

<!-- more -->
[sourcecode language="java"]
public class ValueTypeContractTestAbstract_StringTest 
    extends ValueTypeContractTestAbstract<String> {

    @Override
    protected List<String> getObjectsWithSameValue() {
        return Arrays.asList(new String("1"), new String("1"));
    }

    @Override
    protected List<String> getObjectsWithDifferentValue() {
        return Arrays.asList(new String("1  "), new String("  1"), new String("2"));
    }
}
[/sourcecode]
Similarly, the tests for java.math.BigDecimals looks like:
[sourcecode language="java"]
public class ValueTypeContractTestAbstract_BigIntegerTest 
        extends ValueTypeContractTestAbstract<BigInteger> {

    @Override
    protected List<BigInteger> getObjectsWithSameValue() {
        return Arrays.asList(new BigInteger("1"), new BigInteger("1"));
    }

    @Override
    protected List<BigInteger> getObjectsWithDifferentValue() {
        return Arrays.asList(new BigInteger("2"));
    }
}
[/sourcecode]

And what of the contract test itself? Here, for you to copy-n-paste is the class:
[sourcecode language="java"]
package org.apache.isis.testsupport;

import static org.hamcrest.Matchers.*;
import static org.junit.Assert.assertThat;
import static org.junit.matchers.JUnitMatchers.*;

import java.util.Arrays;
import java.util.List;

import org.junit.Before;
import org.junit.Test;

/**
 * Contract test for value types ({@link #equals(Object)} and {@link #hashCode()}).
 */
public abstract class ValueTypeContractTestAbstract<T> {

	@Before
	public void setUp() throws Exception {
		assertSizeAtLeast(getObjectsWithSameValue(), 2);
		assertSizeAtLeast(getObjectsWithDifferentValue(), 1);
	}

	private void assertSizeAtLeast(List objects, int i) {
		assertThat(objects, is(notNullValue()));
		assertThat(objects.size(), is(greaterThan(i-1)));
	}

	@Test
	public void notEqualToNull() throws Exception {
		for(T o1: getObjectsWithSameValue()) {
			assertThat(o1.equals(null), is(false));
		}
		for(T o1: getObjectsWithDifferentValue()) {
			assertThat(o1.equals(null), is(false));
		}
	}

	@Test
	public void reflexiveAndSymmetric() throws Exception {
		for(T o1: getObjectsWithSameValue()) {
			for(T o2: getObjectsWithSameValue()) {
				assertThat(o1.equals(o2), is(true));
				assertThat(o2.equals(o1), is(true));
				assertThat(o1.hashCode(), is(equalTo(o2.hashCode())));
			}
		}
	}

	@Test
	public void notEqual() throws Exception {
		for(T o1: getObjectsWithSameValue()) {
			for(T o2: getObjectsWithDifferentValue()) {
				assertThat(o1.equals(o2), is(false));
				assertThat(o2.equals(o1), is(false));
			}
		}
	}

	@Test
	public void transitiveWhenEqual() throws Exception {
		for(T o1: getObjectsWithSameValue()) {
			for(T o2: getObjectsWithSameValue()) {
				for(Object o3: getObjectsWithSameValue()) {
					assertThat(o1.equals(o2), is(true));
					assertThat(o2.equals(o3), is(true));
					assertThat(o1.equals(o3), is(true));
				}
			}
		}
	}

	protected abstract List<T> getObjectsWithSameValue();
	protected abstract List<T> getObjectsWithDifferentValue();
}
[/sourcecode]

