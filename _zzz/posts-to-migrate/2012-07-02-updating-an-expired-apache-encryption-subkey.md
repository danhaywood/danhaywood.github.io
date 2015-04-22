---
author: danhaywood
comments: true
date: 2012-07-02 11:21:52+00:00
layout: post
slug: updating-an-expired-apache-encryption-subkey
title: Updating an expired Apache encryption key
wordpress_id: 995
tags:
- asf
- how-to
---

I work as a committer on Apache Isis.  On setting up a new PC, I realised that I've forgotten my ASF committer password.  I popped over to [id.apache.org](http://id.apache.org), but found that the "reset password" button didn't work, failing with an "Encryption failed" error.




This post is mostly a "note to self" on how I fixed that.<!-- more -->



	
  * I hopped over to #asfinfra on webchat.freenode.net, was told that my public key had expired

    * (thanks, danielsh)

	
  * verified that by browsing to pgp.mit.edu:

	
    * [http://pgp.mit.edu:11371/pks/lookup?search=dan+haywood&op=index](http://pgp.mit.edu:11371/pks/lookup?search=dan+haywood&op=index)

	
    * and then [http://pgp.mit.edu:11371/pks/lookup?op=vindex&search=0x76D7491A77AD2E23](http://pgp.mit.edu:11371/pks/lookup?op=vindex&search=0x76D7491A77AD2E23)

	
    * in fact, it's the subkey used for encryption that's expired





So, to recreate a new subkey:

	
  * ensure that ~/.gnupg (or c:\users\xxx\appdata\roaming\gnupg) is up-to-date

	
    * (reinstate from secure backup if required)




	
  * gpg --edit-key 77AD2E23     # this being the id of my main non-expiring key

	
  * addkey                                           # then enter passphrase for expiring key

	
  * select RSA(6)                              # ie, encrypt only

	
  * 4096 bits

	
  * 1y                                                     # ie, 1 year expiry


Then upload:

	
  * gpg --keyserver pgp.mit.edu --send-key 77AD2E23

	
  * confirm uploaded by browsing to pgp.mit.edu

	
    * [http://pgp.mit.edu:11371/pks/lookup?op=vindex&search=0x76D7491A77AD2E23](http://pgp.mit.edu:11371/pks/lookup?op=vindex&search=0x76D7491A77AD2E23)








It takes 1 day for this to be sync'ed with ASF.
