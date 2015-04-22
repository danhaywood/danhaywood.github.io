---
author: danhaywood
comments: true
date: 2012-11-09 18:05:11+00:00
layout: post
slug: a-domain-service-for-mail-merging-word-openxml-docx-files-with-repeating-data
title: A domain service for mail merging Word (OpenXML .docx) files ... with repeating
  data
wordpress_id: 1058
tags:
- docx
- domain driven design
- java
- openxml
---

One requirement that most business apps have is to be able to dynamically generate Word documents.  For scalar non-repeating data this is not too difficult in .docx; indeed the file format has built-in support for data binding using Custom XML Parts.  However, there is no support for repeating data, at least, not prior to Word 2013.  Which is where a little domain service that I've been working on comes into play <!-- more -->

The service works by accepting a .docx template and an XHTML input document.  The @id attribute of the input elements is matched to the tag of the smart tags in the .docx.  Repeating lists are specified in the input HTML using <ul> / <li> / <p>, and tables are specified using <table> / <tr> / <td>.  The service will clone the template list item / table rows as necessary.

For now, you can grab the code from my [github repo](https://github.com/danhaywood/docx-service) (where there's a more thorough README); in the fullness of time it'll be donated into Apache Isis codebase.
