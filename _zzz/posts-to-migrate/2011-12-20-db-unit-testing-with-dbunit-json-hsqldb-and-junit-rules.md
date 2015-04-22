---
author: danhaywood
comments: true
date: 2011-12-20 18:06:53+00:00
layout: post
slug: db-unit-testing-with-dbunit-json-hsqldb-and-junit-rules
title: DB unit testing with dbUnit, JSON, HSQLDB and JUnit Rules
wordpress_id: 867
tags:
- dbunit
- java
- junit
- tdd
---

In this week's run of my TDD course, I thought it would be interesting to write a little fixture to make it easier to use [dbUnit](http://www.dbunit.org/).  My original thought was just to teach dbUnit about JSON, but it turns out that [Lieven Doclo](http://www.insaneprogramming.be/?p=105) has done that already.  So I decided to go a step further and also combine dbUnit with [JUnit Rules](http://kentbeck.github.com/junit/javadoc/latest/org/junit/rules/MethodRule.html), and provide automatic bootstrapping of an [HSQLDB](http://hsqldb.org/) in-memory object store.

<!-- more -->

The following test shows what I ended up with:

[sourcecode language="java"]
package com.danhaywood.tdd.dbunit.test;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;

import java.sql.ResultSet;
import java.sql.Statement;

import org.dbunit.Assertion;
import org.dbunit.dataset.ITable;
import org.hsqldb.jdbcDriver;
import org.junit.Rule;
import org.junit.Test;

import com.danhaywood.tdd.dbunit.DbUnitRule;
import com.danhaywood.tdd.dbunit.DbUnitRule.Ddl;
import com.danhaywood.tdd.dbunit.DbUnitRule.JsonData;

public class DbUnitRuleExample {

    @Rule
    public DbUnitRule dbUnit = new DbUnitRule(
            DbUnitRuleExample.class, jdbcDriver.class,
            "jdbc:hsqldb:file:src/test/resources/testdb", "SA", "");

@Ddl("customer.ddl")
    @JsonData("customer.json")
    @Test
    public void update_lastName() throws Exception {

        // when
        Statement statement = dbUnit.getConnection().createStatement();
        statement.executeUpdate("update customer set last_name='Bloggs' where id=2");

        // then (verify directly)
        ResultSet rs2 = dbUnit.executeQuery("select last_name from customer where id = 2");
        assertThat(rs2.next(), is(true));
        assertThat(rs2.getString("last_name"), equalTo("Bloggs"));

        // then (verify using datasets)
        ITable actualTable = dbUnit.createQueryTable("customer", "select * from customer order by id");
        ITable expectedTable = dbUnit.jsonDataSet("customer-updated.json").getTable("customer");

        Assertion.assertEquals(expectedTable, actualTable);
    }
}
[/sourcecode]

where customer.ddl is:

[sourcecode language="sql"]
drop table customer if exists;
create table customer (
	id         int         not null primary key
   ,first_name varchar(30) not null
   ,initial    varchar(1)  null
   ,last_name  varchar(30) not null
)
[/sourcecode]

and customer.json (the initial data set) is:

[sourcecode language="javascript"]
{
  "customer":
	  [
	    {
	      "id": 1,
	      "first_name": "John",
	      "initial": "K",
	      "last_name": "Smith"
	    },
	    {
	      "id": 2,
	      "first_name": "Mary",
	      "last_name": "Jones"
	    }
	  ]
}
[/sourcecode]

and customer-updated.json (the final data set) is:

[sourcecode language="javascript"]
{
  "customer":
	  [
	    {
	      "id": 1,
	      "first_name": "John",
	      "initial": "K",
	      "last_name": "Smith"
	    },
	    {
	      "id": 2,
	      "first_name": "Mary",
	      "last_name": "Bloggs"
	    }
	  ]
}
[/sourcecode]

As you've probably figured out, the @Ddl annotation optionally specifies DDL script(s) to run against the database, while the @JsonData defines a JSON-formatted dataset.

The actual implementation of the DbUnitRule class is:

[sourcecode language="java"]
package com.danhaywood.tdd.dbunit;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.nio.charset.Charset;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.dbunit.IDatabaseTester;
import org.dbunit.JdbcDatabaseTester;
import org.dbunit.database.IDatabaseConnection;
import org.dbunit.dataset.DataSetException;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.ITable;
import org.junit.rules.MethodRule;
import org.junit.runners.model.FrameworkMethod;
import org.junit.runners.model.Statement;

import com.google.common.io.Resources;

public class DbUnitRule implements MethodRule {

    @Retention(RetentionPolicy.RUNTIME)
    @Target({ ElementType.METHOD })
    public static @interface Ddl {
        String[] value();
    }

    @Retention(RetentionPolicy.RUNTIME)
    @Target({ ElementType.METHOD })
    public static @interface JsonData {
        String value();
    }

    private final Class<?> resourceBase;

    private IDatabaseTester databaseTester;
    private IDatabaseConnection dbUnitConnection;

    private Connection connection;
    private java.sql.Statement statement;

    public DbUnitRule(Class<?> resourceBase, Class<?> driver, String url, String user, String password) {
        this.resourceBase = resourceBase;
        try {
            databaseTester = new JdbcDatabaseTester(driver.getName(), url, user, password);
            dbUnitConnection = databaseTester.getConnection();
            connection = dbUnitConnection.getConnection();
            statement = connection.createStatement();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Statement apply(final Statement base, final FrameworkMethod method, final Object target) {

        return new Statement() {

            @Override
            public void evaluate() throws Throwable {

                try {
                    Ddl ddl = method.getAnnotation(Ddl.class);
                    if (ddl != null) {
                        String[] values = ddl.value();
                        for (String value : values) {
                            executeUpdate(Resources.toString(
                                resourceBase.getResource(value), Charset.defaultCharset()));
                        }
                    }

                    JsonData data = method.getAnnotation(JsonData.class);
                    if (data != null) {
                        IDataSet ds = new JSONDataSet(resourceBase.getResourceAsStream(data.value()));
                        databaseTester.setDataSet(ds);
                    }

                    databaseTester.onSetup();

                    base.evaluate();
                } finally {
                    databaseTester.onTearDown();
                }
            }
        };
    }

    public java.sql.Connection getConnection() {
        return connection;
    }

    public void executeUpdate(String sql) throws SQLException {
        statement.executeUpdate(sql);
    }

    public ResultSet executeQuery(String sql) throws SQLException {
        return statement.executeQuery(sql);
    }

    public IDataSet jsonDataSet(String datasetResource) {
        return new JSONDataSet(resourceBase.getResourceAsStream(datasetResource));
    }

    public ITable createQueryTable(String string, String string2) throws DataSetException, SQLException {
        return dbUnitConnection.createQueryTable(string, string2);
    }
}
[/sourcecode]

This uses Lieven Doclo's JSONDataSet (copied here for your convenience):

[sourcecode language="java"]
import org.codehaus.jackson.map.ObjectMapper;
import org.dbunit.dataset.*;
import org.dbunit.dataset.datatype.DataType;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;

/**
 * DBUnit DataSet format for JSON based datasets. It is similar to the flat XML layout,
 * but has some improvements (columns are calculated by parsing the entire dataset, not just
 * the first row). It uses Jackson, a fast JSON processor.
 * <br/><br/>
 * The format looks like this:
 * <br/>
 * <pre>
 * {
 *    "&lt;table_name&gt;": [
 *        {
 *             "&lt;column&gt;":&lt;value&gt;,
 *             ...
 *        },
 *        ...
 *    ],
 *    ...
 * }
 * </pre>
 * <br/>
 * I.e.:
 * <br/>
 * <pre>
 * {
 *    "test_table": [
 *        {
 *             "id":1,
 *             "code":"JSON dataset",
 *        },
 *        {
 *             "id":2,
 *             "code":"Another row",
 *        }
 *    ],
 *    "another_table": [
 *        {
 *             "id":1,
 *             "description":"Foo",
 *        },
 *        {
 *             "id":2,
 *             "description":"Bar",
 *        }
 *    ],
 *    ...
 * }
 * </pre>
 *
 * @author Lieven DOCLO
 */
public class JSONDataSet extends AbstractDataSet {
    // The parser for the dataset JSON file
    private JSONITableParser tableParser = new JSONITableParser();

    // The tables after parsing
    private List<ITable> tables;

    /**
     * Creates a JSON dataset based on a file
     * @param file A JSON dataset file
     */
    public JSONDataSet(File file) {
        tables = tableParser.getTables(file);
    }

    /**
     * Creates a JSON dataset based on an inputstream
     * @param is An inputstream pointing to a JSON dataset
     */
    public JSONDataSet(InputStream is) {
        tables = tableParser.getTables(is);
    }

    @Override
    protected ITableIterator createIterator(boolean reverse) throws DataSetException {
        return new DefaultTableIterator(tables.toArray(new ITable[tables.size()]));
    }

    private class JSONITableParser {

        private ObjectMapper mapper = new ObjectMapper();

        /**
         * Parses a JSON dataset file and returns the list of DBUnit tables contained in
         * that file
         * @param jsonFile A JSON dataset file
         * @return A list of DBUnit tables
         */
        public List<ITable> getTables(File jsonFile) {
            try {
                return getTables(new FileInputStream(jsonFile));
            } catch (IOException e) {
                throw new RuntimeException(e.getMessage(), e);
            }
        }

        /**
         * Parses a JSON dataset input stream and returns the list of DBUnit tables contained in
         * that input stream
         * @param jsonStream A JSON dataset input stream
         * @return A list of DBUnit tables
         */
        @SuppressWarnings("unchecked")
        public List<ITable> getTables(InputStream jsonStream) {
            List<ITable> tables = new ArrayList<ITable>();
            try {
                // get the base object tree from the JSON stream
                Map<String, Object> dataset = mapper.readValue(jsonStream, Map.class);
                // iterate over the tables in the object tree
                for (Map.Entry<String, Object> entry : dataset.entrySet()) {
                    // get the rows for the table
                    List<Map<String, Object>> rows = (List<Map<String, Object>>) entry.getValue();
                    ITableMetaData meta = getMetaData(entry.getKey(), rows);
                    // create a table based on the metadata
                    DefaultTable table = new DefaultTable(meta);
                    int rowIndex = 0;
                    // iterate through the rows and fill the table
                    for (Map<String, Object> row : rows) {
                        fillRow(table, row, rowIndex++);
                    }
                    // add the table to the list of DBUnit tables
                    tables.add(table);
                }

            } catch (IOException e) {
                throw new RuntimeException(e.getMessage(), e);
            }
            return tables;
        }

        /**
         * Gets the table meta data based on the rows for a table
         * @param tableName The name of the table
         * @param rows The rows of the table
         * @return The table metadata for the table
         */
        private ITableMetaData getMetaData(String tableName, List<Map<String, Object>> rows) {
            Set<String> columns = new LinkedHashSet<String>();
            // iterate through the dataset and add the column names to a set
            for (Map<String, Object> row : rows) {
                for (Map.Entry<String, Object> column : row.entrySet()) {
                    columns.add(column.getKey());
                }
            }
            List<Column> list = new ArrayList<Column>(columns.size());
            // create a list of DBUnit columns based on the column name set
            for (String s : columns) {
                list.add(new Column(s, DataType.UNKNOWN));
            }
            return new DefaultTableMetaData(tableName, list.toArray(new Column[list.size()]));
        }

        /**
         * Fill a table row
         * @param table The table to be filled
         * @param row A map containing the column values
         * @param rowIndex The index of the row to te filled
         */
        private void fillRow(DefaultTable table, Map<String, Object> row, int rowIndex) {
            try {
                table.addRow();
                // set the column values for the current row
                for (Map.Entry<String, Object> column : row.entrySet()) {
                    table.setValue(rowIndex, column.getKey(), column.getValue());

                }
            } catch (Exception e) {
                throw new RuntimeException(e.getMessage(), e);
            }
        }
    }
}
[/sourcecode]

The libraries I used for this (ie are dependencies) are:



	
  * hsqldb 2.2.6

	
  * dbunit 2.4.8

	
  * jackson 1.9.3

	
  * slf4j-api-1.6.4, slf4j-nop-1.6.4

	
  * google-guava 10.0.1

	
  * junit 4.8


As ever, comments welcome.
