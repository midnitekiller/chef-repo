Description
===========

This cookbook defines defaults for node values such as the locations of 
common facnilities such as the Chef server, the TeamCity server, the 
Git server, etc.

Common libraries are also defined here, such as the function that returns
the appropriate Git revision IDs used for deployment to the master, 
staging, production, and feature branches.


Requirements
============

Attributes
==========

Usage
=====

Add the following line to the metadata.rb file of any cookbook used in
your Ocean infrastructure:

  depends 'ocean'

This will set common defaults and make definitions and libraries 
available for use.
