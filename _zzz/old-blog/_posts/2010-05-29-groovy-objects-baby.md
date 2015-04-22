---
author: danhaywood
comments: true
date: 2010-05-29 10:35:37+00:00
layout: post
slug: groovy-objects-baby
title: Groovy Objects, baby!
wordpress_id: 591
tags:
- apache isis
---

I was at the [SPA conference](http://spaconference.org) last week, ostensibly to do a little talk on Naked Objects, but mostly to mix and talk with some cleverer people than me to pick up some new ideas.

In a break I was asked whether Naked Objects supported [Groovy](http://groovy.codehaus.org).  To which my answer was: "well, no, but it's been on our list to look into ages, and it really oughtn't be hard if we ever got round to it".

Anyway, so I've got around to it, meaning there's now a new sister project that'll let you write your domain objects in Groovy, to run on Naked Objects.  <!-- more -->You'll find it up on SourceForge, and it's called, predictably enough, [Groovy Objects](http://groovyobjects.sourceforge.net).

Here's what the Claim (from the example [claims app]({{ site.baseurl }}/2009/09/17/naked-objects-example-claims-app-and-other-resources/)) looks like in Groovy:

    
    class Claim extends AbstractDomainObject {
    
        boolean rush
        String description
        Date date
        String status
        Claimant claimant
        Approver approver
        List claimItems = new ArrayList()
    
        String title() { status + " - " + date }
    
        void created() {
            status = "New"
            date = new Date()
        }
    
        @MemberOrder(sequence = "1.5")
        boolean getRush() { rush }
    
        @MemberOrder(sequence = "1")
        String getDescription() { description }
    
        @MemberOrder(sequence="2")
        Date getDate() { date }
    
        @Disabled
        @MemberOrder(sequence = "3")
        String getStatus() { status }
    
        @Disabled
        @MemberOrder(sequence = "4")
        Claimant getClaimant() { claimant }
    
        @Disabled
        @MemberOrder(sequence = "5")
        Approver getApprover() { approver }
    
    
        @MemberOrder(sequence = "6")
        List getClaimItems() { claimItems }
        void addToClaimItems(ClaimItem item) {
            claimItems.add(item);
        }
    
        void submit(Approver approver) {
            status = "Submitted"
            this.approver = approver
        }
        String disableSubmit() {
            status == "New" ? null : "Claim has already been submitted"
        }
        Approver default0Submit() { claimant?.approver }
    
    
        void addItem(
        @Named("Days since")
        int days,
        @Named("Amount")
        double amount,
        @Named("Description")
        String description) {
            ClaimItem claimItem = newTransientInstance(ClaimItem.class)
            def date = new Date()
            date = date.add(0, 0, days)
            claimItem.dateIncurred = date
            claimItem.description = description
            claimItem.amount = new Money(amount, "USD")
            persist(claimItem)
            addToItems(claimItem)
        }
        String disableAddItem() {
            status == "Submitted" ? "Already submitted" : null
        }
        String validateAddItem(int days, double amount, String description) {
            if (days <= 0) "Days must be positive value"
        }
        int default0AddItem() { 1 }
        List choices2AddItem() { ["meal", "taxi", "plane", "train" }
    }
    


Meanwhile, with fixtures we can take advantage of Groovy's ability to write mini-DSLs:

    
    import org.starobjects.groovy.gapplib.DomainObjectBuilder;
    
    class ClaimsFixture extends AbstractFixture {
    
        @Override
        public void install() {
            def builder = new DomainObjectBuilder(
                getContainer(), Employee.class, Claim.class)
    
            builder.employee(id: 'fred', name:"Fred Smith")
            builder.employee(id: "tom", name: "Tom Brown") { approver( refId: 'fred') }
            builder.employee(name: "Sam Jones") { approver( refId: 'fred') }
    
            builder.claim(id: 'tom:1', date: days(-16), description: "Meeting with client") {
                claimant( refId: 'tom')
                claimItem( dateIncurred: days(-16), amount: money(38.50),
                       description: "Lunch with client")
                claimItem( dateIncurred: days(-16), amount: money(16.50),
                       description: "Euston - Mayfair (return)")
            }
            builder.claim(id: 'tom:2', date: days(-18), description: "Meeting in city office") {
                claimant( refId: 'tom')
                claimItem( dateIncurred: days(-18), amount: money(18.00),
                       description: "Car parking")
                claimItem( dateIncurred: days(-18), amount: money(26.50),
                       description: "Reading - London (return)")
            }
            builder.claim(id: 'fred:1', date: days(-14), description: "Meeting at clients") {
                claimant( refId: 'fred')
                claimItem( dateIncurred: days(-14), amount: money(18.00),
                       description: "Car parking")
                claimItem( dateIncurred: days(-14), amount: money(26.50),
                       description: "Reading - London (return)")
            }
        }
    
        private Date days(int days) { new Date().add(0,0,days) }
        private Money money(double amount) { new Money(amount, "USD") }
    }
    


As I hoped, this stuff worked more-or-less out of the box: all that Groovy Objects really does is modify the Naked Objects reflector to ignore a couple of methods that the Groovy compiler adds to the classes.  But I've never programmed in earnest in Groovy, so it'd be good to get some feedback from Groovy cognescenti as to how we might evolve the programming model to be more Groovy-esque.

One obvious suggestion is to allow the Naked Objects annotations to be placed on the instance variables rather than the property accessors.  Then again, most class members are likely to have one or more of the other supporting methods (eg disableXxx()) so perhaps there's not much to gain from doing this.

Whatever; if Groovy interests you, then do try it out: there's a full [user guide](http://groovyobjects.sourceforge.net/m2-site/gmain/gdocumentation/docbkx/html/user-guide/user-guide.html)  instructions on the Groovy Objects website.  And if you have any ideas on how to take this little project further, let me know.
