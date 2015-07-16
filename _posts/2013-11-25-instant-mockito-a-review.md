---
author: danhaywood
comments: true
date: 2013-11-25 20:23:56+00:00
layout: post
slug: instant-mockito-a-review
title: Instant Mockito - a review
wordpress_id: 1227
tags:
- hamcrest
- java
- jmock
- mockito
- book-review
- tdd
---

[Instant Mockito](http://www.packtpub.com/how-to-create-stubs-mocks-spies-using-mockito/book) is just a little book covering [https://code.google.com/p/mockito/](https://code.google.com/p/mockito/), but that's not a bad objective in itself. Mockito, after all, is one of the most commonly used Java mocking libraries. (I happen to prefer [other mocking libraries](http://jmock.org) better, but that's another story).

The book organized around a single coherent example which - if contrived - is easy enough to grok and helps unify the content. Through that example this book does a pretty reasonable job of explaining how to use Mockito's capabilities.

As with many technical books, the layout/indentation of the code examples left something to be desired; I don't think the author was done any favours by his editor. And I did struggle a bit with little with the omission of import statements in the examples; it wasn't clear which class the static mock() method had been imported from, for example. The first mention of Matchers was also confusing; both Mockito and the widely used [Hamcrest](https://code.google.com/p/hamcrest/) library define a class of this name.

I did also find myself wondering why Mockito's @Mock annotation hadn't been used; only later was that explained. I would rather the author had shown the use of @Mock first, and then only later (as a mechanism that involves much more boilerplate), covered the use of mock().

Overall, this book doesn't cover very much more than what's covered in Mockito's own Javadoc API. So is it worth buying? Well, yes, probably... the content is solid enough, you'll read it quickly, and will end up with a pretty understanding of what Mockito is and how to use it. Which I am sure is what the author set out to do.

Disclaimer: I was asked to review this book - and provided a free eBook for my trouble - by Packt Publishing.
