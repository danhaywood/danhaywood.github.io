---
author: danhaywood
comments: true
date: 2010-07-20 06:58:24+00:00
layout: post
slug: sp__crudparams
title: sp__crudparams for CRUD-style stored procs in Sybase ASE
wordpress_id: 627
---

Slight diversion from the norm...

Suppose you want to write a CRUD-style sproc, for Sybase ASE.  If we were writing for Oracle, we could just use its %ROWTYPE syntax.  But Sybase doesn't have anything equivalent.  Instead, we'll need to have a set of params matching the columns of a table.

The following stored proc, sp__crudparams, will generate an SQL fragment that you can then copy and paste into your editor.  Here's how it works for the pubs2..titles table:


    
    exec sp__crudparams titles
    go
    --------------------------------------------------
     @pub_id char(4) = NULL
    ,@type char(12) = NULL
    ,@title varchar(80) = NULL
    ,@notes varchar(200) = NULL
    ,@total_sales int  = NULL
    ,@price money  = NULL
    ,@advance money  = NULL
    ,@pubdate datetime  = NULL
    ,@contract bit  = NULL
    ,@title_id tid  = NULL     -- varchar
    



And here's the stored proc itself: <!-- more -->

    
    use sybsystemprocs
    go
    if exists (select 1 from sysobjects where name = 'sp__crudparams') begin
        drop procedure sp__crudparams
    end
    go
    create procedure sp__crudparams (
     @tablename varchar(30) = null
    )
    as
    if @tablename is null begin
    	raiserror 20000 "Usage: sp__crudparams table_name"
    	return -100
    end
    
    declare @len1 int, @len2 int, @len3 int, @len4 int, @len5 int, @sysstat2 int
    
    	select num = identity(3)
    	      ,Column_name = isnull(c.name, 'NULL')
    	      ,Col_order = colid
    	      ,Type = isnull(convert(char(30), x.xtname),
    				isnull(convert(char(30),
    					get_xtypename(c.xtype, c.xdbid)),
    				t.name))
    	      ,Default_name = object_name(c.cdefault)
    	      ,Rule_name = object_name(c.domain)
    	      ,Length = c.length
    	      ,Prec = c.prec
    	      ,Scale = c.scale
    	      ,Nulls = convert(bit, (c.status & 8))
    	      ,Access_Rule_name = object_name(c.accessrule)
    	      ,rtype = t.type, utype = t.usertype, xtype = c.xtype
    	      ,Ident = convert(bit, (c.status & 0x80))
    	      ,Object_storage =
    			case when (c.xstatus is null) then NULL
                                 when (c.xstatus & 1) = 1 then "off row"
                                 else                          "in row " end
              ,c.type
              ,c.usertype
              ,Storage_type = convert(varchar(30), ' ')
    	into #helptype
    	from syscolumns c, systypes t, sysxtypes x
    		where c.id = object_id(@tablename)
    			and c.usertype *= t.usertype
    			and c.xtype *= x.xtid
    
        update #helptype
           set Storage_type = st.name
    		from #helptype s, systypes st
    	  where s.type = st.type
    	    and st.name not in ("timestamp", "sysname", "nchar", "nvarchar")
    		and st.usertype 30 characters to 30,
    	** and print them with a trailing "+" character.
    	*/
    	update #helptype
    		set Type = substring(Type, 1, 29) + "+"
    		where xtype is not null
    		      and substring(Type, 29, 1) != " "
    
    	/* Handle National Characters */
    	update #helptype
    		set Length = Length / @@ncharsize
    		where (rtype = 47 and utype = 24)
    		   or (rtype = 39 and utype = 25)
    
    	/* Handle unichar/univarchar */
    	update #helptype
    		set Length = Length / @@unicharsize
    		where rtype in (select type from systypes
    			where name in ('unichar', 'univarchar'))
    
    	select @len1 = max(datalength(Column_name)),
    	       @len2 = max(datalength(Type)),
    	       @len3 = max(datalength(Default_name)),
    	       @len4 = max(datalength(Rule_name))
    	from #helptype
    
    	select convert(varchar(80),
    		   (case when num > 1 then ',' else ' ' end)
               + '@' + Column_name
    	       + ' ' + Type
    	       + (case when usertype = 100 then '     -- ' + Storage_type else ' ' end)
    	       )
    	  from #helptype
    	 order by num asc
    
    	drop table #helptype
    go
    grant execute on sp__crudparams to public
    go
    
