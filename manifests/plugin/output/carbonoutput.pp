# == Defined type: heka::plugin::output::carbonoutput
#
# This defined type is for creating Heka CarbonOutput plugin TOML files.
# See the Heka documentation for more info on CarbonOutput plguins:
#
# https://hekad.readthedocs.org/en/latest/config/outputs/carbon.html
#
# Parameters that have `undef` as their default value will not get written to the TOML file
# and Heka to fall back to its own internal defaults.
#
# === Parameters
#
# @param plugin_dir String; the directory the TOML plugin file will be created in; defaults to `/etc/heka`.
# @param plugin_file_name String; the name of the TOML plugin file; defaults to `$name.toml`.
# @param plugin_file_ensure String' the type of file resource to create; defaults to `file`.
# @param plugin_file_owner String; the owner of the TOML plugin file; defaults to `root`.
# @param plugin_file_group String; the group of the TOML plugin file; defaults to `root`.
# @param plugin_file_mode String; the mode of the TOML plugin file; defaults to `0644`.
# @param plugin_file_template String; the ERB template to use to generate the TOML plugin file; defaults to `heka/plugins/inputs/heka_CarbonOutput_plugin.toml.erb`
# @param refresh_heka_service Bool; whether to refresh the Heka daemon when a config file is created or modified.
# See this page for more details on the plugin-specific options: http://hekad.readthedocs.org/en/latest/config/inputs/tcp.html
# @param address [String] the IP address/port for Heka to send Carbon-format data to; specify as address:port; you can use variable interpolation with Facter facts: `"${::ipaddress_lo}:5565"`  
# @param message_matcher [String] the types of Heka messages the plugin instance should receive from the message router
# @param protocol [String] whether to use TCP or UDP; defaults to `tcp`
# @param tcp_keep_alive [Bool] whether to keep TCP connections open and reuse them, defaults to false
#
# === Examples
#
# ::heka::plugin::output::carbonoutput { 'carbonoutput1':
#   address => 'graphiteserver.local:2003',
#   message_matcher => "Type == 'heka.statmetric'",
#   protocol => 'udp',
# }
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#
# === Copyright
#
# Copyright 2015 Nicholas Chappell, unless otherwise noted.

define heka::plugin::output::carbonoutput (
  #Common plugin parameters
  $plugin_dir           = '/etc/heka',
  $plugin_file_name     = "${name}.toml",
  $plugin_file_ensure   = file,
  $plugin_file_owner    = 'root',
  $plugin_file_group    = 'root',
  $plugin_file_mode     = '0644',
  $refresh_heka_service = true,
  $heka_daemon_name     = 'heka',
  #CarbonOutput plugin specific parameters
  $plugin_file_template = 'heka/plugins/outputs/heka_carbonoutput_plugin.toml.erb',
  $address              = undef,
  $message_matcher      = "Type == 'heka.statmetric'",
  $protocol             = 'tcp',
  $tcp_keep_alive       = false,

) {

  include heka::params

  #Do some validation of the parameters:
  validate_string($plugin_dir)
  validate_string($plugin_file_name)
  validate_string($plugin_file_owner)
  validate_string($plugin_file_group)  
  validate_string($plugin_file_mode)
  validate_string($plugin_file_template)
  validate_bool($refresh_heka_service)
  validate_string($address)
  
  if $message_matcher {
    validate_string($message_matcher)
  }
  
  if $tcp_keep_alive {
    validate_bool($tcp_keep_alive)
  }

 #If the refresh_heka_service parameter is set to true...
  if $refresh_heka_service == true {
    file { "${plugin_dir}/${plugin_file_name}":
      ensure  => $plugin_file_ensure,
      owner   => $plugin_file_owner,
      group   => $plugin_file_group,
      mode    => $plugin_file_mode,
      content => template($plugin_file_template),
      #...notify the Heka daemon so it can restart and pick up changes made to this config file...
      notify  => Service[$heka_daemon_name],
    }
  }
  #...otherwise, use the same file resource but without a notify => parameter: 
  else {
    file { "${plugin_dir}/${plugin_file_name}":
      ensure  => $plugin_file_ensure,
      owner   => $plugin_file_owner,
      group   => $plugin_file_group,
      mode    => $plugin_file_mode,
      content => template($plugin_file_template),
    }
  }

}