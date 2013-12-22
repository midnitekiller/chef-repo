These data bags contain information which belongs to one or both of the
following two categories:

* information that varies from setup to setup and 
  therefore must be tailored to your particular installation,

* information that is confidential, such as AWS secret keys and private 
  certificates and therefore must be kept from the eyes of the public.

For this reason, you should tailor the values in the data bags where necessary,
but you should take care never to commit the tailored data bags to source control,
unless you are sure your repo won't ever become public, and the credentials you've
entered won't ever be misused within your own organisation. 

If this can't be guaranteed, follow this procedure:

Upload all data bags and their contents to your Chef Server by issuing the
   following command:

 `knife data bag from file --all`

Tailor the contents by editing data bags directly on the server:

 `knife data bag edit BAGNAME BAGITEMNAME`

e.g.:

 `knife data bag edit ocean base`

When you save and close the editor window which opens, the data bag item will be
saved only on the Chef Server. The source text in the repo will remain unchanged.

To show the actual contents, developers must now use

 `knife data bag show ocean base`

as the repo source text no longer reflects your actual values.

NB: Developers must at no time upload the untailored data bags again. They
must ONLY alter them using the `knife data bag edit` commands.


Configuring your editor
=======================

(Make sure you have set EDITOR to your preferred editor in your .bash_login file. 
Also make sure the editor supports being invoked in this way:

 `export EDITOR="subl -w"`

The `-w` makes knife wait for the file to be closed before returning. (The
editor in the example above is Sublime Text 2, but TextMate has a similar switch.
Check your editor's documentation.)


Notes on the contents of the data bags
======================================

The `aws` data bag contains three sets of AWS access credentials, one for each
Chef deployment environment (master, staging, and prod). You should create
three separate AWS users using IAM (it's a good idea also to create a group for
them) and enter their AWS access credentials here.

The `base` data bag contains basic setup information for the Ocean system.
The domain name under which Ocean is to run must be specified here.

The `subnets` data bag maps each Chef environment name to AWS networking
information such as Availability Zones and their subnets and logical function.
You should study the structure of this data bag carefully. `elb`, `shared` and 
`apps` refer to the architectural function of a group of subnets; c.f. the 
table of subnets in Amazon Architectural Considerations on the wiki.

The `teamcity` data bag contains credentials for a TeamCity user you should
set up in the TeamCity web interface. Chef needs these credentials during
deployment to the master, staging and production environments in order to
determine which Git revision to deploy.

The `varnish` data bag specifies the allowed IP ranges in each environment. 
You can accept the default values for the `subnets` section. Modify 
`local_network` according to your particular network topology.

