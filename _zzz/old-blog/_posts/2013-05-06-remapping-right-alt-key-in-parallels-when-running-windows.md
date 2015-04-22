---
author: danhaywood
comments: true
date: 2013-05-06 11:50:32+00:00
layout: post
slug: remapping-right-alt-key-in-parallels-when-running-windows
title: Remapping right-alt key in Parallels when running Windows
wordpress_id: 1162
tags:
- mac
---

I bought a MacBook Pro a few years back.  I didn't really like it... I miss keyboard accelerators (not shortcuts) that the Unix and Windows UI have.  Also, I do a lot of work with clients that use Windows, so I kinda need access to it.  So my Mac went into the cupboard, unloved.

Then the Windows laptop I was using died... its SSD blew up and seemingly took the motherboard with it.  Whatever, it didn't work and I wasn't going to fix it.

So I got that MacBook back out of the cupboard, installed an SSD and some more RAM, and set about running Windows in a VM instead<!-- more -->.  With a little bit of playing with [KeyRemap4MacBook](http://pqrs.org/macosx/keyremap4macbook/) (thanks, Jeroen, for that tip) I was able to switch over the Mac options and cmd keys so that in Windows the keys are where my fingers want them to be.  So, I have to say, this time around I'm enjoying using my Mac.

But I still had one issue: to alt-tab within windows I found I needed to use the right alt key, not the left one.  I've got used to doing this, but it's kinda annoying to have to have both hands on the keyboard for this common task.

However, a bit of googling has found the [answer](http://forum.parallels.com/showthread.php?259063-make-right-alt-key-like-left-alt&p=639986&viewfull=1#post639986); which I repeat here.  I am indebted to JasonXP, whoever he may be:

With the aforementioned KeyRemap4MacBook installed:



	
  * Clicked on the new icon in the top menu 


	
  * Clicked on "Open KeyRemap4MacBook Preferences"


	
  * Clicked on the "Misc and Uninstall" tab


	
  * Clicked on the "private.xml" button 


	
  * Right clicked on "private.xml" in Finder and chose "Open With" TextEdit


	
  * Added this XML


[sourcecode]
<?xml version="1.0"?>
<root>
<item>
<name>Modifier To Option_R</name>
<appendix>Option_R to Option_L</appendix>
<identifier>remap.keytokey_modifier_JG</identifier>
<autogen>--KeyToKey-- KeyCode::OPTION_R, KeyCode::OPTION_L</autogen>
</item>
</root>
[/sourcecode]
	
  * Saved the file


	
  * Clicked on "Open KeyRemap4MacBook Preferences"


	
  * Went to the "Change Key" tab


	
  * Clicked on "ReloadXML" button


	
  * And selected the new entry 'Modifier To Option_R' at the top





