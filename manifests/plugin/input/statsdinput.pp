# == Defined type: heka::plugin::input::statsdinput
#
# This defined type is for creating Heka statsdinput plugin TOML files.
# See the Heka documentation for more info on statsdinput plguins:
#
# http://hekad.readthedocs.org/en/latest/config/inputs/tcp.html
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
# @param plugin_file_template String; the ERB template to use to generate the TOML plugin file; defaults to `heka/plugins/inputs/heka_statsdinput_plugin.toml.erb`
# @param refresh_heka_service Bool; whether to refresh the Heka daemon when a config file is created or modified.
# See this page for more details on the plugin-specific options: https://hekad.readthedocs.org/en/latest/config/inputs/statsd.html
# @param address String; the IP address/port for Heka to bind to; specify as address:port; you can use variable interpolation with Facter facts: `"${::ipaddress_lo}:8125"`  
# @param stat_accum_name String; the StatAccumInput plugin instance that this StatsdInput plugin will send statsd messages to
# @param max_msg_size Int; the size of the buffer, in bytes, that's used for message reads
# @param decoder String; the default decoder to use for payloads this input takes in
# @param synchronous_decode Bool; whether to not accept new inputs until processing of the current input message has compeleted; the module default value is undef, but Heka's internal default if this is not set in the TOML file is `false` 
# @param send_decode_failures Bool; if set to `true`, if an incoming message can't be decoded, this input will still forward the message onto the message router with a `decode_failure` field set to `true` 
# @param splitter String; Which splitter to use; module defaults to undef, which causes Heka to fall back to its own default, which is `HekaFramingSplitter`
#
# === Examples
#
# ::heka::plugin::input::statsdinput { 'statsdinput1':
#   refresh_heka_service => true,
#   address => "${::ipaddress_lo}:8125"
# }
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#
# === Copyright
#
# Copyright 2015 Nicholas Chappell, unless otherwise noted.

define heka::plugin::input::statsdinput (
  #Common plugin parameters
  $plugin_dir           = '/etc/heka',
  $plugin_file_name     = "${name}.toml",
  $plugin_file_ensure   = file,
  $plugin_file_owner    = 'root',
  $plugin_file_group    = 'root',
  $plugin_file_mode     = '0644',
  $refresh_heka_service = true,
  $heka_daemon_name     = 'heka',
  #statsdinput plugin specific parameters
  $plugin_file_template = 'heka/plugins/inputs/heka_statsdinput_plugin.toml.erb',
  $address              = undef,
  $stat_accum_name      = undef,
  $max_msg_size         = undef,
  $decoder              = undef,
  $synchronous_decode   = false,
  $send_decode_failures = true,
  $splitter             = undef,

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
  validate_string($stat_accum_name)
  validate_string($decoder)
  validate_bool($synchronous_decode)
  validate_bool($send_decode_failures)
  validate_string($splitter)

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