---
author: danhaywood
comments: true
date: 2014-08-22 10:35:26+00:00
layout: post
slug: how-to-restore-a-postgresql-backup
title: How to restore a PostgreSQL backup
wordpress_id: 1303
tags:
- postgres
---

There would seem to be several ways, but if the backup file was created by pg_dump and is actually a series of DDL and INSERT statements (look in vi), then use:

[sourcecode language="java"]
psql -U postgres -d dbname < dbname.backup
[/sourcecode]

'Nuff said!


