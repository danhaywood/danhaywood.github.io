---
author: danhaywood
comments: true
date: 2012-07-18 11:24:10+00:00
layout: post
slug: drop-all-tables-in-an-ms-sql-server-database
title: Drop all tables in an MS SQL Server database
wordpress_id: 1021
tags:
- how-to
- sqlserver
---

Currently working on a JDO [DataNucleus](http://datanucleus.org) object store for [Apache Isis](http://incubator.apache.org/isis), as part of an app that's gonna be deployed onto MS SQL Server.

Since I'm using DataNucleus to automatically create the database schema, the build-debug cycle is:



	
  1. to run the app

	
  2. inspect the resultant schema

	
  3. drop all the tables

	
  4. change the domain object annotations/metadata


and then go round the loop again.



What with foreign-key constraints between tables, step (3) is not exactly trivial.  So it seemed like it'd be a good idea to write a little script to simplify step (3) of the above, namely to drop all the tables in my (development!) database.  Here's what I came up with... <!-- more -->
[sourcecode language="sql"]
DECLARE @table_schema varchar(100)
       ,@table_name varchar(100)
       ,@constraint_schema varchar(100)
       ,@constraint_name varchar(100)
       ,@cmd nvarchar(200)
 
 
--
-- drop all the constraints
--
DECLARE constraint_cursor CURSOR FOR
  select CONSTRAINT_SCHEMA, CONSTRAINT_NAME, TABLE_SCHEMA, TABLE_NAME
    from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   where TABLE_NAME != 'sysdiagrams'
   order by CONSTRAINT_TYPE asc -- FOREIGN KEY, then PRIMARY KEY
      
 
OPEN constraint_cursor
FETCH NEXT FROM constraint_cursor INTO @constraint_schema, @constraint_name, @table_schema, @table_name
 
WHILE @@FETCH_STATUS = 0 
BEGIN
     SELECT @cmd = 'ALTER TABLE [' + @table_schema + '].[' + @table_name + '] DROP CONSTRAINT [' + @constraint_name + ']'
     --select @cmd
     EXEC sp_executesql @cmd
 
     FETCH NEXT FROM constraint_cursor INTO @constraint_schema, @constraint_name, @table_schema, @table_name
END
 
CLOSE constraint_cursor
DEALLOCATE constraint_cursor
 
 
 
--
-- drop all the tables
--
DECLARE table_cursor CURSOR FOR
  select TABLE_SCHEMA, TABLE_NAME
    from INFORMATION_SCHEMA.TABLES
   where TABLE_NAME != 'sysdiagrams'
     and TABLE_TYPE != 'VIEW'
 
OPEN table_cursor
FETCH NEXT FROM table_cursor INTO @table_schema, @table_name
 
WHILE @@FETCH_STATUS = 0 
BEGIN
     SELECT @cmd = 'DROP TABLE [' + @table_schema + '].[' + @table_name + ']'
     --select @cmd
     EXEC sp_executesql @cmd
 
 
     FETCH NEXT FROM table_cursor INTO @table_schema, @table_name
END
 
CLOSE table_cursor 
DEALLOCATE table_cursor
[/sourcecode]


UPDATE: I've updated this to escape all schema and table names in square braces; the original script failed when it encountered a table that was a reserved word.

UPDATE: I've updated this to ignore any views (in INFORMATION_SCHEMA.TABLES)
