#MCollective Facter Fact Source

##Overview

The facter plugin enables mcollective to use facter as a source for facts about your system.

Note: This method suffers from some issues due to how slow Facter can be in some cases, you should use [Facter via YAML](http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/FactsFacterYAML) instead.

##Installation

* Follow the [basic plugin install guide](http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/InstalingPlugins)

##Configuration

The following options can be set in server.cfg

* plugin.facter.facterlib - where to find custom facts. Defaults to /var/lib/puppet/lib/facter:/var/lib/puppet/facts

Sample configuration:

```
factsource = facter
plugin.facter.facterlib = /var/lib/puppet/lib/otherfacts
fact_cache_time = 200
```

##Usage

You should now be able to use all your facter facts in discovery and fact reporting.

```
% mco rpc rpcutil get_fact fact=osfamily
Discovering hosts using the mc method for 2 second(s) .... 2

 * [ ============================================================> ] 2 / 2

node1.your.com

    Fact: osfamily
   Value: Debian

node2.your.com

    Fact: osfamily
   Value: RedHat


Summary of Value:

   RedHat = 1
   Debian = 1


Finished processing 2 / 2 hosts in 3105.79 ms
```

```
% mco rpc rpcutil ping -F osfamily=RedHat
Discovering hosts using the mc method for 2 second(s) .... 1

 * [ ============================================================> ] 1 / 1


node2.your.com
   Timestamp: 1360696771



Finished processing 1 / 1 hosts in 46.86 ms
```

```
% mco inventory node1.your.com
Inventory for node1.your.com:

   ...
   ...

   Facts:
      architecture => x86_64
      augeasversion => 0.9.0
      boardmanufacturer => Intel Corporation
      boardproductname => 440BX Desktop Reference Platform
      boardserialnumber => None
      ...
      ...
```
