# == Defined type: heka::plugin::input::tcpinput
#
# This defined type is for creating custom Heka TOML plugin files.
#
# === Parameters
#
# @param plugin_dir String; the directory the TOML plugin file will be created in; defaults to `/etc/heka`.
# @param plugin_file_name String; the name of the TOML plugin file; defaults to `$name.toml`.
# @param plugin_file_ensure String' the type of file resource to create; defaults to `file`.
# @param plugin_file_owner String; the owner of the TOML plugin file; defaults to `root`.
# @param plugin_file_group String; the group of the TOML plugin file; defaults to `root`.
# @param plugin_file_mode String; the mode of the TOML plugin file; defaults to `0644`.
# @param plugin_file_template String; the ERB template to use to generate the TOML plugin file; defaults to `heka/plugins/heka_plugin.toml.erb`
# @param refresh_heka_service Bool; whether to refresh the Heka daemon when a config file is created or modified.
# @param type String; the type of Heka plugin this TOML file will be an instance of.
# @param settings Hash; a hash of settings that gets passed to the ERB template, which iterates over the hash to create the TOML INI settings.
#
# === Examples
#
# ::heka::plugin { 'tcpinput4':
#   toml_settings => {
#     'type'        => { setting => 'type', value   => '"TcpInput"', },
#     'address'     => { setting => 'address', value   => '"127.0.0.1:5568"', },
#     'parser_type' => { setting => 'parser_type', value   => '"token"', },
#   }
# }
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#
# === Copyright
#
# Copyright 2015 Nicholas Chappell, unless otherwise noted.

define heka::plugin (
  #Common plugin parameters
  $plugin_dir           = '/etc/heka',
  $plugin_file_name     = "${name}.toml",
  $plugin_file_ensure   = file,
  $plugin_file_owner    = 'root',
  $plugin_file_group    = 'root',
  $plugin_file_mode     = '0644',
  $plugin_file_template = 'heka/plugins/heka_plugin.toml.erb',
  $refresh_heka_service = true,
  $heka_daemon_name     = 'heka',
  $type                 = undef,
  $settings             = {}

) {

  include heka::params

  #Do some validation of the parameters:
  validate_string($plugin_dir)
  validate_string($plugin_file_name)
  validate_string($plugin_file_template)
  validate_string($heka_daemon_name)
  validate_string($type)
  validate_hash($settings)

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