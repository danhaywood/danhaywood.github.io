---
author: danhaywood
comments: true
date: 2012-05-10 17:48:23+00:00
layout: post
slug: fail-a-maven-build-when-conflicting-or-unused-dependencies
title: Fail a Maven build when conflicting or unused dependencies
wordpress_id: 970
tags:
- how-to
- maven
---


Currently teaching my Maven course, and a couple of questions have come up about how to fail a build when a pom either has conflicting dependencies, or has (through a smidge too much copy-n-paste) even just unused dependencies.  Good questions both.




For the first of these, dependency conflicts, <!-- more --> we can use the enforcer plugin.  Add the following to your POM:

[sourcecode language="xml"]
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-enforcer-plugin</artifactId>
      <version>1.0.1</version>
      <executions>
        <execution>
          <id>validate-enforce</id>
          <configuration>
            <rules> 
               <DependencyConvergence />
            </rules>
          </configuration>
          <phase>validate</phase>
          <goals> 
            <goal>enforce</goal>
          </goals>
        </execution>
      </executions>
    </plugin>
    ... other plugins ...
  </plugins>
</build>
[/sourcecode]




This binds the enforcer:enforce goal to the validate phase, ie right at the beginning of the build of each project (or submodule, if an aggregator project).  Any conflicts for that project/submodule, and the build will break.




For the other case, unused dependencies, we can use the dependency:analyze-only goal:

[sourcecode language="xml"]
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-dependency-plugin</artifactId>
      <version>2.4</version>
      <configuration>
        <failOnWarning>true</failOnWarning>
      </configuration>
      <executions>
        <execution>
          <id>process-test-classes-dependency-analyze</id>
          <!-- needs all code to be compiled -->
          <phase>process-test-classes</phase>
          <goals>
            <goal>analyze-only</goal>
          </goals>
        </execution>
      </executions>
    </plugin>

    ... other plugins ...
  </plugins>
</build>
[/sourcecode]



There is one tiny oddity here; we want to do the analysis as soon as we can, but the plugin does require that code and test code is compiled.  The next phase on from test-compile is the process-test-classes, which runs directly before the test phase.  The execution binding above ensures that we do the dependency analysis without having to wait for unit tests to run (ie we "fail as early as we can").




If you use a corporate POM (one that every project's POM would use as its parent), then you could consider moving both of these configurations up into it.  That would then allow you to enforce these rules across all projects.
