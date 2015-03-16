# == Defined type: heka::plugin::input::stataccuminput
#
# This defined type is for creating Heka StatAccumInput plugin TOML files.
# See the Heka documentation for more info on StatAccumInput plguins:
#
# https://hekad.readthedocs.org/en/latest/config/inputs/stataccum.html
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
# @param plugin_file_template String; the ERB template to use to generate the TOML plugin file; defaults to `heka/plugins/inputs/heka_stataccuminput_plugin.toml.erb`
# @param refresh_heka_service Bool; whether to refresh the Heka daemon when a config file is created or modified.
# See this page for more details on the plugin-specific options: https://hekad.readthedocs.org/en/latest/config/inputs/stataccum.html
# @param emit_in_payload [Bool]
# @param emit_in_fields [Bool]
# @param percent_threshold [Int]
# @param ticket_interval [Int]
# @param message_type [String] 
# @param legacy_namespaces [Bool]
# @param global_prefix [String]
# @param counter_prefix [String]
# @param timer_prefix [String]
# @param gauge_prefix [String]
# @param statsd_prefix [String]
# @param delete_idle_stats [Bool]
#
# === Examples
#
# ::heka::plugin::input::stataccuminput { 'stataccuminput1':
#   refresh_heka_service => true,
#   ticker_interval => 1,
#   emit_in_fields => true,
# }
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#

define heka::plugin::input::stataccuminput (
  #Common plugin parameters
  $plugin_dir           = '/etc/heka',
  $plugin_file_name     = "${name}.toml",
  $plugin_file_ensure   = file,
  $plugin_file_owner    = 'root',
  $plugin_file_group    = 'root',
  $plugin_file_mode     = '0644',
  $refresh_heka_service = true,
  $heka_daemon_name     = 'heka',
  #stataccuminput plugin specific parameters
  $plugin_file_template = 'heka/plugins/inputs/heka_stataccuminput_plugin.toml.erb',
  $emit_in_payload      = true,
  $emit_in_fields       = false,
  $percent_threshold    = undef,
  $ticker_interval      = undef,
  $message_type         = undef,
  $legacy_namespaces    = false,
  $global_prefix        = undef,
  $counter_prefix       = undef,
  $timer_prefix         = undef,
  $gauge_prefix         = undef,
  $statsd_prefix        = undef,
  $delete_idle_stats    = false,
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
  
  if $emit_in_payload {
    validate_bool($emit_in_payload)
  }
  
  if $emit_in_fields {
    validate_bool($emit_in_fields)
  }
  
  if $percent_threshold {
    validate_integer($percent_threshold)
  }
  
  if $ticker_interval {
    validate_integer($ticker_interval)
  }
  
  if $message_type {
    validate_string($message_type)
  }
  
  if $legacy_namespaces {
    validate_bool($legacy_namespaces)
  }
  
  if $global_prefix {
    validate_string($global_prefix)
  }
  
  if $counter_prefix {
    validate_string($counter_prefix)
  }
  
  if $timer_prefix {
    validate_string($timer_prefix)
  }
  
  if $gauge_prefix {
    validate_string($gauge_prefix)
  }
  
  if $statsd_prefix {
    validate_string($statsd_prefix)
  }
  
  if $delete_idle_stats {
    validate_bool($delete_idle_stats)
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