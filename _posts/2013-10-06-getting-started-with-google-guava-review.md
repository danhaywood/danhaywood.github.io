---
author: danhaywood
comments: true
date: 2013-10-06 20:38:34+00:00
layout: post
slug: getting-started-with-google-guava-review
title: Getting Started with Google Guava - review
wordpress_id: 1205
tags:
- book-review
- guava
---

"[Getting Started with Google Guava](http://www.packtpub.com/getting-started-with-google-guava/book)" isn't a bad book to get you started with [Google Guava](https://code.google.com/p/guava-libraries/) - indeed, it'd probably be quite hard to write a bad book on Guava given just how good a library Guava is.

And the author, Bill Bejeck, has, on balance, done a pretty good job of covering the all the most important classes provided by the library, without getting too bogged down in any of them.  That's to his credit; I could easily imagine an author spending too much time on a particular personal favourite of the library.

Still, you'll need to be a reasonably competent developer to get the most out of this book.  This isn't a book that provides lengthy tutorials on functional programming for example.  But the examples that the author provides generally make sense (even if they are often rather shallow).  As a reasonably competent developer myself, I did enjoy learning about some of the nooks and crannies of Guava that I might not have discovered quite so easily.  I didn't know that Guava had a Table collection class for example, and I think that the FluentIterable class might simplify some code I've written recently.

On the other hand, I don't write that much multi-threaded code (thankfully!), and so the Concurrency chapter didn't really help me understand when I might want to use a FutureCallback vs a ListenableFuture.  And when reading the coverage of Sinks and Sources in the Files chapter, the examples didn't explain well enough why these abstractions are useful.

There were also quite a few typos in the book, including in class names.  In a similar vein, quite a lot of the indentation of code samples was also inconsistent.  The book said it'd use JUnit tests throughout to illustrate the usage; but I can tell you it didn't.  And the grammar in some of the sentences was somewhat sloppy and could have benefitted from a bit more copy-editing.  The feeling was of a book written a little too quickly.  

But overall, I'd give this book 7 out of 10.  If by reading it you end up using Guava a bit more in your day-to-day programming - and I think that you will - then it's done its job.

**Disclaimer**: I was asked to review this ebook (and received a free copy) off the back of a [blog post a while back]({{ site.baseurl }}/2013/02/02/using-google-guavas-ordering-api/) I did on Guava myself.
