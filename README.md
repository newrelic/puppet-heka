#puppet-heka
> [github.com/nickchappell/puppet-heka](https://github.com/nickchappell/puppet-heka)
- - -

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
    * [Packages](#packages)
    * [Init scripts and Upstart/systemd files](#init-upstart-systemd-files)
    * [TOML config files](#toml-config-files)
        * [Global Heka configuration](#global-heka-configuration)
        * [TOML config files for plugins](#toml-config-files-for-plugins)
3. [Setup - The basics of getting started with heka](#setup)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Basic usage](#basic-usage)
        * [Parameter data types](#parameter-data-types)
    * [Plugins](#plugins)
        * [Inputs](#plugins-inputs)
            * [`TcpInput`](#plugins_inputs_tcpinput)
            * [`UdpInput`](#plugins_inputs_udpinput)
        * [Custom plugins](#custom-plugins)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##[Overview](id:overview)

This module installs and configures [Heka](http://hekad.readthedocs.org/en/latest/index.html), a metric/log/event router and processor.

##[Module Description](id:module-description)

This module installs Heka via the published packages and configures it by templating TOML configuration files for both Heka's global configuration and for plugins.

###[Packages](id:packages)

This module uses the RPM packages available on Heka's Github releases page:

[https://github.com/mozilla-services/heka/releases](https://github.com/mozilla-services/heka/releases)

###[Init scripts and Upstart/systemd files](id:init-upstart-systemd-files)

Because the Heka packages do not include init scripts or Upstart/systemd unit files, this module includes an Upstart file template for Red Hat/CentOS 6 and a systemd unit file for Red Hat/CentOS 7.

###[TOML config files](id:toml-config-files)

####[Global Heka configuration](id:global-heka-configuration)

The module templates `/etc/heka.toml`. Currently, it only specifies a `maxprocs` value. Other global Heka config values aren't added to the file but Heka sets these to its own defaults. See [Configuring hekad > Global configuration options](http://hekad.readthedocs.org/en/latest/config/index.html#global-configuration-options) for more info on what the 

####[TOML config files for plugins](id:toml-config-files-for-plugins)

This module has defined types and and accompanying ERB templates for a few commonly used plugins.

This module also has a more generic defined type and ERB template so you can configure any Heka plugin with the module without having to 

##[Setup](id:setup)

###[Setup Requirements](id:setup-requirements)

This module requires the following Puppet modules:

* nanlui/staging

##[Usage](id:usage)

###[Basic usage](id:basic-usage)

The following installs and configures Heka with it's default settings. The `maxprocs` in Heka's main config will be set to the value of the `processorcount` fact. All other 

```bash
class { '::heka':}
```

####[Parameter data types](id:parameter-data-types)

**Booleans**

Config values that are supposed to be booleans in a TOML config can be used as a boolean in your Puppet code:


```bash
::heka::plugin::input::tcpinput { 'tcpinput1':
...  
  refresh_heka_service => true,
...
}
```

**Strings**

Config values that are supposed to be double-quoted strings in the TOML file should have the double quotes included in the parameter in your Puppet code:

```bash
::heka::plugin::input::tcpinput { 'tcpinput1':
...
  address => ''"${::ipaddress_lo}:5565"''
...
}
```

**Integers**

Config values that are supposed to be integers in the TOML config file can be written as integers in your Puppet code:

```bash
::heka::plugin { 'dashboard3':
  type => 'DashboardOutput',
  settings => {
...
    'ticker_interval' => 6,
...
  },
}
```

**IP addresses and ports**

IP address/port combos in Heka TOML configs are entered as double-quoted strings. You can use Facter facts for IP addresses by using `${}` for variable interpolation in your Puppet code:

```bash
::heka::plugin::input::tcpinput { 'tcpinput1':
...
  address => '"${::ipaddress_lo}:5565"'
...
}
```

###[Plugins](id:plugins)

####[Inputs](id:plugins-inputs)

#####[**TcpInput**](id:plugins_inputs_tcpinput)

[Heka documentation: TcpInput](http://hekad.readthedocs.org/en/latest/config/inputs/tcp.html)

```bash
::heka::plugin::input::tcpinput { 'tcpinput1':
  refresh_heka_service => true,
  address => "${::ipaddress_lo}:5565"
}
```

#####[**UdpInput**](id:plugins_inputs_udpinput)

[Heka documentation: UdpInput](http://hekad.readthedocs.org/en/latest/config/inputs/udp.html)

```bash
::heka::plugin::input::udpinput { 'udpinput1':
  refresh_heka_service => true,
  address => "${::ipaddress_lo}:4484"
}
```

####[Custom plugins](id:custom-plugins)

**Settings**

Coming soon...

**Subsection settings**

Coming soon...

##Limitations

Only Red Hat and CentOS are supported right now.

##Development

Make PRs against the develop branch on Github: [https://github.com/nickchappell/puppet-heka/tree/develop](https://github.com/nickchappell/puppet-heka/tree/develop)