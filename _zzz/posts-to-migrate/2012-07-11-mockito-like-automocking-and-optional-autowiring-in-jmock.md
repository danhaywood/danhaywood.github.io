---
author: danhaywood
comments: true
date: 2012-07-11 07:02:21+00:00
layout: post
slug: mockito-like-automocking-and-optional-autowiring-in-jmock
title: Mockito-like automocking and optional autowiring in JMock
wordpress_id: 1010
tags:
- java
- jmock
- junit
- tdd
---

I'm running my little TDD course again, and (as usual) it's given rise to another small idea to make unit testing easier: provide Mockito-like automocking (using a @Mock annotation), and in addition perform autowiring of all mocks into the class under test.<!-- more -->

Now, to be honest, the difficult bit, automocking, is already in the JMock codebase, but as of this writing it's still not been released (come on guys!).  So I've just taken that code and tweaked it to also support this idea of autowiring.

Here's what it looks like in code:
[sourcecode language="java"]
public class JUnitRuleMockery2Test_autoWiring {

    @Rule
    public JUnitRuleMockery2 context = 
        JUnitRuleMockery2.createFor(Mode.INTERFACES_AND_CLASSES);

    @Mock
    private Collaborator collaborator;

    @ClassUnderTest
    private Collaborating collaborating;

    @Before
    public void setUp() throws Exception {
        collaborating = (Collaborating) context.getClassUnderTest();
    }
    
    @Test
    public void checkAutoWiring() {
        assertThat(collaborating, is(not(nullValue())));
        assertThat(collaborating.collaborator, is(not(nullValue())));
    }
}
[/sourcecode]

Where to get this code?  Well, since I've now blogged about a [couple]({{ site.baseurl }}/2010/11/04/contract-test-for-value-types/) of [utilities]({{ site.baseurl }}/2011/12/20/db-unit-testing-with-dbunit-json-hsqldb-and-junit-rules/), I thought I'd upload them to this new [github project](https://github.com/danhaywood/java-testsupport).  There's the stuff from those posts and this one, as well as a couple of other goodies.  Just pull it down and build with Maven.

As ever, feedback welcome!
