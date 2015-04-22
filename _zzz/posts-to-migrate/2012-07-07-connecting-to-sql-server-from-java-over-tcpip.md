---
author: danhaywood
comments: true
date: 2012-07-07 08:43:47+00:00
layout: post
slug: connecting-to-sql-server-from-java-over-tcpip
title: Connecting to SQL Server from Java over TCP/IP
wordpress_id: 1002
tags:
- java
- sqlserver
---

Been a while since I did this; turns out it’s easy enough.

First, you’ll need the current JDBC driver from Microsoft, which can be found [here](http://www.microsoft.com/en-us/download/details.aspx?id=11774). Add to classpath as usual.





Set up your Java application to use the following JDBC connection settings:<!-- more -->






  * ConnectionDriverName=com.microsoft.sqlserver.jdbc.SQLServerDriver
  * ConnectionURL=jdbc:sqlserver://127.0.0.1:1433;instance=SQLEXPRESS;databaseName=jdo;
  * ConnectionUserName=jdo
  * ConnectionPassword=jdopass

In this case I’m connecting to SQLExpress instance running on my localhost.

The trickiest bit (for me) was figuring out how to persuade SQL Server to listen over TCP/IP – by default it only seems to listen over shared memory. Anyway, after a bit of trial and error, the following worked.

First, locate SQL Server Configuration Manager, and enable TCP/IP for the SQL Server instance (SQLExpress in this case).

[![image](http://danhaywood.files.wordpress.com/2012/07/image_thumb.png)](http://danhaywood.files.wordpress.com/2012/07/image.png)

Then, right-click to open up the properties for TCP/IP, and set the port for IPAll at the bottom:

[![image](http://danhaywood.files.wordpress.com/2012/07/image_thumb1.png)](http://danhaywood.files.wordpress.com/2012/07/image1.png)

  

You should then be able to connect.
